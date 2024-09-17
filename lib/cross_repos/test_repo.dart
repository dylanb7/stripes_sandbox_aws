import 'dart:async';

import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/subjects.dart';
import 'package:stripes_backend_helper/TestingReposImpl/test_question_repo.dart';

import 'package:stripes_backend_helper/stripes_backend_helper.dart';
import 'package:stripes_sandbox_aws/combined_repos.dart/combined_stamp_repo.dart';
import 'package:stripes_sandbox_aws/cross_repos/stamp_repo.dart';
import 'package:stripes_sandbox_aws/models/BlueDyeResponse.dart';
import 'package:stripes_sandbox_aws/models/BlueDyeResponseLog.dart';
import 'package:stripes_sandbox_aws/models/BlueDyeTestLog.dart';
import 'package:stripes_sandbox_aws/utils.dart';
import 'package:stripes_ui/UI/Record/TestScreen/blue_dye_test_screen.dart';
import 'package:stripes_ui/l10n/app_localizations.dart';

import '../../models/BlueDyeTest.dart';

class BlueTest extends Test<BlueDyeState> {
  BlueDyeTest? current;

  final BehaviorSubject<BlueDyeState> _controller = BehaviorSubject();

  BlueTest({
    required super.stampRepo,
    required super.authUser,
    required super.subUser,
    required super.questionRepo,
  }) : super(listensTo: {Symptoms.BM}, testName: 'Blue Dye Test') {
    fetchCurrentTest();
  }

  String? group() =>
      authUser.attributes[const CognitoUserAttributeKey.custom("group").key];

  Future<void> fetchCurrentTest() async {
    const fetchTest = "listBlueDyeTests";
    const gqlDocument = '''query FetchTest(\$id: ID!) {
      $fetchTest(filter: {subUserId: { eq: \$id} }) {  
        items {
          id
          stamp
          group
          finishedEating
          finishedEatingDate
          amountConsumed
          pauseTime
          startTime
          logs {
            items {
              id
              group
              isBlue
              response {
                id
                stamp
                group
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
        : BlueDyeState.empty());
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
  BehaviorSubject<BlueDyeState> get state => _controller;

  @override
  Future<void> setTestState(BlueDyeState state) async {
    final String? groupName = group();
    final BlueDyeTest value =
        localTestToQuery(state, subUser).copyWith(group: groupName);
    final List<BlueDyeTestLog> logs =
        value.logs?.map((log) => log.copyWith(group: groupName)).toList() ?? [];
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
        final GraphQLRequest<BlueDyeTest> create =
            ModelMutations.create(value.copyWith(group: groupName));
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
        final BlueDyeTestLog toCreate =
            log.copyWith(blueDyeTest: result.data, group: groupName);
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

    final String? groupName = group();
    final BlueDyeResponse res = BlueDyeResponse(
      stamp: current!.stamp,
      finishedEating: current!.finishedEating!,
      logs: current!.logs!
          .map((log) => BlueDyeResponseLog(
              isBlue: log.isBlue,
              detailResponseID: log.response?.id,
              response: log.response,
              group: groupName))
          .toList(),
      group: groupName,
      subUserId: subUser.uid,
    );
    try {
      await ((stampRepo as CombinedStampRepo).remote as RemoteStamps)
          .addRawBlueDye(res);
      await cancel();
    } catch (e) {
      safePrint(e);
    }
  }

  @override
  Widget? displayState(BuildContext context) {
    return const BlueDyeTestScreen();
  }

  @override
  String getName(BuildContext context) {
    return AppLocalizations.of(context)!.blueDyeHeader;
  }

  @override
  Future<void> onDelete(Response<Question> stamp, String type) async {
    if (stamp is! DetailResponse) return;
    final BlueDyeState current = state.value;
    final bool? isBlue = _isBlueFromDetail(stamp);
    if (isBlue == null) return;
    final List<BMTestLog> logs = current.logs;
    logs.removeWhere((element) => element.response == stamp);
    if (logs == current.logs) return;
    await setTestState(current.copyWith(logs: logs));
  }

  @override
  Future<void> onEdit(Response<Question> stamp, String type) async {
    if (stamp is! DetailResponse) return;
    final BlueDyeState current = state.value;
    final bool? isBlue = _isBlueFromDetail(stamp);
    if (isBlue == null) return;
    final int index =
        current.logs.indexWhere((element) => element.stamp == stamp.stamp);
    if (index < 0) return;
    final List<BMTestLog> newLogs = current.logs;
    newLogs[index] = BMTestLog(response: stamp, isBlue: isBlue);
    await setTestState(current.copyWith(logs: newLogs));
  }

  @override
  Future<void> onSubmit(Response<Question> stamp, String type) async {
    if (stamp is! DetailResponse) return;
    final bool? blue = _isBlueFromDetail(stamp);
    if (blue == null) return;
    final BlueDyeState current = state.value;
    await setTestState(current.copyWith(
        logs: [...current.logs, BMTestLog(response: stamp, isBlue: blue)]));
  }

  BlueDyeTestStage get testStage => state.hasValue
      ? stageFromTestState(state.value)
      : BlueDyeTestStage.initial;

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
    final BlueDyeTestStage current = testStage;
    if (current == BlueDyeTestStage.initial ||
        current == BlueDyeTestStage.started) {
      return null;
    }
    return Text(
      AppLocalizations.of(context)!.testInProgressNotif,
      style: Theme.of(context)
          .textTheme
          .bodyMedium
          ?.copyWith(color: Theme.of(context).colorScheme.secondary),
    );
  }

  @override
  List<Question> recordAdditions(BuildContext context, String type) {
    final BlueDyeTestStage current = testStage;
    return [
      if (current == BlueDyeTestStage.logs ||
          current == BlueDyeTestStage.logsSubmit)
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
