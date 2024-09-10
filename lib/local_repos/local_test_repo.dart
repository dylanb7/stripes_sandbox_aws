import 'dart:async';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/subjects.dart';
import 'package:stripes_backend_helper/TestingReposImpl/test_question_repo.dart';
import 'package:stripes_backend_helper/stripes_backend_helper.dart';
import 'package:stripes_sandbox_aws/local_repos/local_db.dart';
import 'package:stripes_sandbox_aws/local_repos/local_stamp_repo.dart';
import 'package:stripes_sandbox_aws/models/BlueDyeResponse.dart';
import 'package:stripes_sandbox_aws/models/BlueDyeResponseLog.dart';
import 'package:stripes_sandbox_aws/utils.dart';
import 'package:stripes_ui/UI/Record/TestScreen/blue_dye_test_screen.dart';
import 'package:stripes_ui/l10n/app_localizations.dart';

import '../../models/BlueDyeTest.dart';

class LocalBlueTest extends Test<BlueDyeState> {
  BlueDyeTest? current;

  final BehaviorSubject<BlueDyeState> _controller = BehaviorSubject();

  final LocalDB db = LocalDB();

  LocalBlueTest({
    required super.stampRepo,
    required super.authUser,
    required super.subUser,
    required super.questionRepo,
  }) : super(listensTo: {Symptoms.BM}, testName: 'Blue Dye Test') {
    fetchCurrentTest();
  }

  Future<void> fetchCurrentTest() async {
    await db.ready;
    final BlueDyeTest? test = await db.getBlueDyeTest(fromLocal(subUser));
    _emit(test);
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
    await db.setBlueDyeTest(null, subUser.uid);
    _emit(null);
  }

  @override
  BehaviorSubject<BlueDyeState> get state => _controller;

  @override
  setTestState(BlueDyeState state) async {
    print(state);
    final BlueDyeTest value = localTestToQuery(state, subUser);
    final bool added = await db.setBlueDyeTest(value, subUser.uid);
    if (added) _emit(value);
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
      await (stampRepo as LocalStamps).addRawBlueDye(res);
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
