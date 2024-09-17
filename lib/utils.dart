import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:stripes_backend_helper/QuestionModel/question.dart';

import 'package:stripes_backend_helper/QuestionModel/response.dart' as repo;
import 'package:stripes_backend_helper/RepositoryBase/QuestionBase/question_repo_base.dart';
import 'package:stripes_backend_helper/RepositoryBase/SubBase/sub_user.dart'
    as local;
import 'package:stripes_backend_helper/RepositoryBase/TestBase/BlueDye/blue_dye_impl.dart'
    as test;

import 'package:stripes_backend_helper/RepositoryBase/TestBase/BlueDye/blue_dye_response.dart';
import 'package:stripes_backend_helper/RepositoryBase/TestBase/BlueDye/bm_test_log.dart';
import 'package:stripes_sandbox_aws/models/BlueDyeResponse.dart';
import 'package:stripes_sandbox_aws/models/BlueDyeResponseLog.dart';
import 'package:stripes_sandbox_aws/models/BlueDyeTest.dart';
import 'package:stripes_sandbox_aws/models/BlueDyeTestLog.dart';
import 'package:stripes_sandbox_aws/models/DetailResponse.dart';
import 'package:stripes_sandbox_aws/models/Response.dart';

import 'package:stripes_sandbox_aws/models/SubUser.dart';

BlueDyeResp blueDyeFromQuery(
    BlueDyeResponse blueDye, QuestionRepo questionRepo) {
  final List<BlueDyeResponseLog> logs = blueDye.logs ?? [];
  final BlueDyeResponseLog firstBlue = logs.firstWhere((val) => val.isBlue,
      orElse: () => BlueDyeResponseLog(isBlue: false));
  final BlueDyeResponseLog lastBlue = logs.lastWhere((val) => val.isBlue,
      orElse: () => BlueDyeResponseLog(isBlue: false));
  final int numBlue = logs.where((element) => element.isBlue).toList().length;
  final int numBrown = logs.length - numBlue;

  final List<BMTestLog> bmTestLogs = [];
  for (BlueDyeResponseLog log in logs) {
    if (log.response == null) continue;
    bmTestLogs.add(BMTestLog(
        id: log.id,
        response: detailFromQuery(log.response!, questionRepo),
        isBlue: log.isBlue));
  }
  return BlueDyeResp(
      id: blueDye.id,
      group: blueDye.group,
      startEating: blueDye.stamp.getDateTimeInUtc().toLocal(),
      eatingDuration: Duration(milliseconds: blueDye.finishedEating),
      normalBowelMovements: numBrown,
      blueBowelMovements: numBlue,
      firstBlue: firstBlue.response?.stamp.getDateTimeInUtc().toLocal() ??
          DateTime.now(),
      lastBlue: lastBlue.response?.stamp.getDateTimeInUtc().toLocal() ??
          DateTime.now(),
      logs: bmTestLogs,
      amountConsumed: test.parseAmountConsumed(blueDye.amountConsumed) ??
          test.AmountConsumed.undetermined);
}

SubUser fromLocal(local.SubUser user) => SubUser(
    id: user.uid,
    name: user.name,
    gender: user.gender,
    birthYear: user.birthYear,
    isControl: user.isControl);

local.SubUser toLocal(SubUser user) => local.SubUser(
    id: user.id,
    name: user.name ?? "",
    gender: user.gender ?? "",
    birthYear: user.birthYear ?? 0,
    isControl: user.isControl);

repo.Response responseFromQuery(Response response, QuestionRepo questionRepo) {
  final Question question = questionRepo.questions.fromBank(response.qid);
  final int responseStamp =
      response.stamp.getDateTimeInUtc().millisecondsSinceEpoch;
  if (response.textResponse != null) {
    return repo.OpenResponse(
      id: response.id,
      group: response.group,
      question: question as FreeResponse,
      stamp: responseStamp,
      response: response.textResponse!,
    );
  } else if (response.all_selected != null) {
    return repo.AllResponse(
        id: response.id,
        group: response.group,
        question: question as AllThatApply,
        stamp: responseStamp,
        responses: response.all_selected!);
  } else if (response.selected != null) {
    return repo.MultiResponse(
        id: response.id,
        group: response.group,
        question: question as MultipleChoice,
        stamp: responseStamp,
        index: response.selected!);
  } else if (response.numeric != null) {
    return repo.NumericResponse(
        id: response.id,
        group: response.group,
        question: question as Numeric,
        stamp: responseStamp,
        response: response.numeric!);
  }
  return repo.Selected(
      question: question as Check,
      stamp: responseStamp,
      group: response.group,
      id: response.id);
}

Response responseToQuery(repo.Response response, String subUserId) {
  final TemporalDateTime awsDate =
      TemporalDateTime(DateTime.fromMillisecondsSinceEpoch(response.stamp));

  if (response is repo.OpenResponse) {
    return Response(
        stamp: awsDate,
        type: response.type,
        qid: response.question.id,
        textResponse: response.response,
        id: response.id,
        subUserId: subUserId);
  }
  if (response is repo.AllResponse) {
    return Response(
        id: response.id,
        stamp: awsDate,
        type: response.type,
        qid: response.question.id,
        all_selected: response.responses,
        subUserId: subUserId);
  }
  if (response is repo.NumericResponse) {
    return Response(
        id: response.id,
        stamp: awsDate,
        type: response.type,
        qid: response.question.id,
        numeric: response.response.toInt(),
        subUserId: subUserId);
  }
  if (response is repo.MultiResponse) {
    return Response(
        id: response.id,
        stamp: awsDate,
        type: response.type,
        qid: response.question.id,
        selected: response.index,
        subUserId: subUserId);
  }
  return Response(
      id: response.id,
      stamp: awsDate,
      type: response.type,
      qid: response.question.id,
      subUserId: subUserId);
}

DetailResponse detailToQuery(repo.DetailResponse detailResponse, SubUser user) {
  final DetailResponse noChildren = DetailResponse(
    id: detailResponse.id,
    group: detailResponse.group,
    stamp: TemporalDateTime(
        DateTime.fromMillisecondsSinceEpoch(detailResponse.stamp)),
    type: detailResponse.type,
    description: detailResponse.description,
    subUserId: user.id,
  );
  final List<Response> children = detailResponse.responses
      .map((response) => responseToQuery(response, user.id)
          .copyWith(detailResponseID: detailResponse.id))
      .toList();
  return noChildren.copyWith(responses: children);
}

repo.DetailResponse detailFromQuery(
    DetailResponse response, QuestionRepo questionRepo) {
  return repo.DetailResponse(
      id: response.id,
      group: response.group,
      description: response.description ?? "",
      responses: response.responses
              ?.map((val) => responseFromQuery(val, questionRepo))
              .toList() ??
          [],
      stamp: response.stamp.getDateTimeInUtc().millisecondsSinceEpoch,
      detailType: response.type ?? "");
}

BlueDyeTest localTestToQuery(test.BlueDyeState test, local.SubUser subUser) {
  final BlueDyeTest blueDyeTest = BlueDyeTest(
    id: test.id,
    stamp: TemporalDateTime(test.startTime ?? DateTime.now()),
    finishedEating: test.finishedEating?.inMilliseconds,
    finishedEatingDate: test.finishedEatingTime != null
        ? TemporalDateTime(test.finishedEatingTime!)
        : null,
    pauseTime:
        test.pauseTime != null ? TemporalDateTime(test.pauseTime!) : null,
    startTime:
        test.timerStart != null ? TemporalDateTime(test.timerStart!) : null,
    amountConsumed: test.amountConsumed?.toString(),
    subUser: fromLocal(subUser),
  );
  final List<BlueDyeTestLog> testLogs = test.logs.map((log) {
    final DetailResponse logRes =
        detailToQuery(log.response, fromLocal(subUser));
    return BlueDyeTestLog(
        id: log.id,
        isBlue: log.isBlue,
        response: logRes,
        detailResponseID: logRes.id,
        blueDyeTest: blueDyeTest);
  }).toList();
  return blueDyeTest.copyWith(logs: testLogs);
}

test.BlueDyeState queryToLocalTest(
    BlueDyeTest blueDyeTest, QuestionRepo questionRepo) {
  final List<BlueDyeTestLog> logs = blueDyeTest.logs ?? [];
  final List<BMTestLog> bmTestLogs = [];
  for (BlueDyeTestLog log in logs) {
    if (log.response == null) continue;
    bmTestLogs.add(BMTestLog(
        id: log.id,
        response: detailFromQuery(log.response!, questionRepo),
        isBlue: log.isBlue));
  }

  return test.BlueDyeState(
      id: blueDyeTest.id,
      startTime: blueDyeTest.stamp.getDateTimeInUtc().toLocal(),
      finishedEating: blueDyeTest.finishedEating != null
          ? Duration(milliseconds: blueDyeTest.finishedEating!)
          : null,
      finishedEatingTime: blueDyeTest.finishedEatingDate?.getDateTimeInUtc(),
      pauseTime: blueDyeTest.pauseTime?.getDateTimeInUtc(),
      timerStart: blueDyeTest.startTime?.getDateTimeInUtc(),
      amountConsumed: test.parseAmountConsumed(blueDyeTest.amountConsumed),
      logs: bmTestLogs);
}
