import 'dart:async';

import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/subjects.dart';
import 'package:stripes_backend_helper/TestingReposImpl/test_question_repo.dart';

import 'package:stripes_backend_helper/stripes_backend_helper.dart';
import 'package:stripes_sandbox_aws/cross_repos/stamp_repo.dart';
import 'package:stripes_sandbox_aws/models/BlueDyeResponse.dart';
import 'package:stripes_sandbox_aws/models/BlueDyeResponseLog.dart';
import 'package:stripes_sandbox_aws/models/BlueDyeTestLog.dart';
import 'package:stripes_sandbox_aws/utils.dart';
import 'package:stripes_ui/UI/Record/TestScreen/test_screen.dart';
import 'package:stripes_ui/Util/text_styles.dart';
import 'package:stripes_ui/l10n/app_localizations.dart';

import '../../models/BlueDyeTest.dart';

class BlueTest extends Test<BlueDyeObj> {
  BlueDyeTest? current;

  final BehaviorSubject<BlueDyeObj> _controller = BehaviorSubject();

  BlueTest({
    required super.stampRepo,
    required super.authUser,
    required super.subUser,
    required super.questionRepo,
  }) : super(listensTo: {Symptoms.BM}) {
    fetchCurrentTest();
  }

  Future<void> fetchCurrentTest() async {
    const fetchTest = "listBlueDyeTests";
    const gqlDocument = '''query FetchTest(\$id: ID!) {
      $fetchTest(filter: {subUserId: { eq: \$id} }) {  
        items {
          id
          stamp
          finishedEating
          logs {
            items {
              id
              isBlue
              response {
                id
                stamp
                type
                description
                responses {
                  items {
                    id
                    stamp
                    type
                    qid
                    textResponse
                    selected
                    numeric
                    all_selected
                  }
                }
              }
            }
          }
          
        }
      }
    }
    ''';
    GraphQLRequest<PaginatedResult<BlueDyeTest>> testRequest = GraphQLRequest(
      document: gqlDocument,
      modelType: const PaginatedModelType(BlueDyeTest.classType),
      variables: {"id": subUser.uid},
      decodePath: fetchTest,
    );
    try {
      final GraphQLResponse<PaginatedResult<BlueDyeTest>> response =
          await Amplify.API.query(request: testRequest).response;
      if (response.data == null) return _emit(null);
      _emit(response.data?.items.isEmpty ?? true
          ? null
          : response.data?.items.first);

      /*GraphQLRequest<PaginatedResult<BlueDyeTest>> request = ModelQueries.list(
          BlueDyeTest.classType,
          where: BlueDyeTest.SUBUSER.eq(subUser.uid));

      GraphQLResponse<PaginatedResult<BlueDyeTest>> res =
          await Amplify.API.query(request: request).response;

      final BlueDyeTest? rawTest = res.data?.items.first;

      final BlueDyeTest? withLogs = await _addLogs(rawTest);*/

      //_emit(result.data);
    } catch (e) {
      safePrint(e);
    }
  }

  _emit(BlueDyeTest? test) {
    current = test;
    _controller.add(test != null
        ? queryToLocalTest(test, questionRepo)
        : BlueDyeObj.empty());
  }

  @override
  cancel() async {
    if (current == null) return;
    final GraphQLRequest<BlueDyeTest> delete = ModelMutations.deleteById(
        BlueDyeTest.classType, BlueDyeTestModelIdentifier(id: current!.id));
    try {
      GraphQLResponse<BlueDyeTest> res =
          await Amplify.API.mutate(request: delete).response;
      if (!res.hasErrors) {
        _emit(null);
      }
    } catch (e) {
      safePrint(e);
    }
  }

  @override
  BehaviorSubject<BlueDyeObj> get obj => _controller;

  @override
  setValue(BlueDyeObj obj) async {
    final BlueDyeTest value = localTestToQuery(obj, subUser);
    final List<BlueDyeTestLog> logs = value.logs!;
    final GraphQLRequest<PaginatedResult<BlueDyeTest>> query =
        ModelQueries.list(BlueDyeTest.classType,
            where: BlueDyeTest.SUBUSER.eq(subUser.uid));
    try {
      final GraphQLResponse<PaginatedResult<BlueDyeTest>> tests =
          await Amplify.API.query(request: query).response;
      final bool exists = tests.data?.items.isNotEmpty ?? false;
      GraphQLResponse<BlueDyeTest>? result;
      if (exists) {
        final GraphQLRequest<BlueDyeTest> update = ModelMutations.update(value);
        result = await Amplify.API.mutate(request: update).response;
        if (result.data == null) {
          safePrint(result.errors);
          return;
        }
      } else {
        final GraphQLRequest<BlueDyeTest> create = ModelMutations.create(value);
        result = await Amplify.API.mutate(request: create).response;
        if (result.data == null) {
          safePrint(result.errors);
          return;
        }
      }
      final List<BlueDyeTestLog> currentLogs = current?.logs ?? [];
      for (BlueDyeTestLog log in currentLogs) {
        final GraphQLRequest<BlueDyeTestLog> delete =
            ModelMutations.delete(log);
        await Amplify.API.mutate(request: delete).response;
      }
      List<BlueDyeTestLog> created = [];
      for (BlueDyeTestLog log in logs) {
        final BlueDyeTestLog toCreate = log.copyWith(blueDyeTest: result.data);
        final GraphQLRequest<BlueDyeTestLog> create =
            ModelMutations.create(toCreate);
        final GraphQLResponse<BlueDyeTestLog> createdLog =
            await Amplify.API.mutate(request: create).response;
        if (createdLog.data != null) {
          created.add(createdLog.data!.copyWith(
              isBlue: toCreate.isBlue,
              blueDyeTest: toCreate.blueDyeTest,
              detailResponseID: toCreate.response?.id,
              response: toCreate.response));
        }
      }
      final BlueDyeTest? toEmit = result.data?.copyWith(logs: created);
      _emit(toEmit);
    } catch (e) {
      safePrint(e);
    }
  }

  @override
  submit(DateTime submitTime) async {
    if (current == null ||
        current?.logs == null ||
        current?.finishedEating == null) return;
    final int lastBlue =
        current!.logs!.lastIndexWhere((element) => element.isBlue);

    if (lastBlue == -1) return;
    final BlueDyeResponse res = BlueDyeResponse(
      stamp: current!.stamp,
      finishedEating: current!.finishedEating!,
      logs: current!.logs!
          .map((log) => BlueDyeResponseLog(
                isBlue: log.isBlue,
                detailResponseID: log.response?.id,
                response: log.response,
              ))
          .toList(),
      subUserId: subUser.uid,
    );
    try {
      await (stampRepo as Stamps).addRawBlueDye(res);
      await cancel();
    } catch (e) {
      safePrint(e);
    }
  }

  @override
  Widget? displayState(BuildContext context) {
    return BlueDyeTestScreen<BlueTest>();
  }

  @override
  String getName(BuildContext context) {
    return AppLocalizations.of(context)!.blueDyeHeader;
  }

  @override
  Future<void> onDelete(Response<Question> stamp, String type) async {
    if (stamp is! DetailResponse) return;
    final BlueDyeObj current = obj.value;
    final bool? isBlue = _isBlueFromDetail(stamp);
    if (isBlue == null) return;
    final List<BMTestLog> logs = current.logs;
    logs.removeWhere((element) => element.response == stamp);
    if (logs == current.logs) return;
    await setValue(current.copyWith(logs: logs));
  }

  @override
  Future<void> onEdit(Response<Question> stamp, String type) async {
    if (stamp is! DetailResponse) return;
    final BlueDyeObj current = obj.value;
    final bool? isBlue = _isBlueFromDetail(stamp);
    if (isBlue == null) return;
    final int index =
        current.logs.indexWhere((element) => element.stamp == stamp.stamp);
    if (index < 0) return;
    final List<BMTestLog> newLogs = current.logs;
    newLogs[index] = BMTestLog(response: stamp, isBlue: isBlue);
    await setValue(current.copyWith(logs: newLogs));
  }

  @override
  Future<void> onSubmit(Response<Question> stamp, String type) async {
    if (stamp is! DetailResponse) return;
    final bool? blue = _isBlueFromDetail(stamp);
    if (blue == null) return;
    final BlueDyeObj current = obj.value;
    await setValue(current.copyWith(
        logs: [...current.logs, BMTestLog(response: stamp, isBlue: blue)]));
  }

  TestState get state =>
      obj.hasValue ? stateFromTestOBJ(obj.value) : TestState.initial;

  bool? _isBlueFromDetail(DetailResponse res) {
    List<Response> blueRes = res.responses
        .where((val) => val.question.id == blueQuestionId)
        .toList();
    if (blueRes.isEmpty) return null;
    final MultiResponse multi = blueRes.first as MultiResponse;
    return multi.index == 0;
  }

  @override
  Widget? pathAdditions(BuildContext context, String type) {
    final TestState current = state;
    if (current == TestState.initial || current == TestState.started) {
      return null;
    }
    return Text(
      AppLocalizations.of(context)!.testInProgressNotif,
      style: lightBackgroundStyle.copyWith(
          color: Theme.of(context).colorScheme.secondary),
    );
  }

  @override
  List<Question> recordAdditions(BuildContext context, String type) {
    final TestState current = state;
    return [
      if (current == TestState.logs || current == TestState.logsSubmit)
        MultipleChoice(
            id: blueQuestionId,
            isRequired: true,
            prompt: AppLocalizations.of(context)!.submitBlueQuestion,
            type: type,
            choices: [
              AppLocalizations.of(context)!.blueQuestionYes,
              AppLocalizations.of(context)!.blueQuestionNo
            ])
    ];
  }
}

const blueQuestionId = "BlueDyeQuestion";
