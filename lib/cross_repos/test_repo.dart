import 'dart:async';

import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_flutter/amplify_flutter.dart';

import 'package:stripes_backend_helper/RepositoryBase/TestBase/BlueDye/blue_dye_impl.dart'
    as repo;
import 'package:stripes_backend_helper/RepositoryBase/TestBase/base_test_repo.dart';
import 'package:stripes_sandbox_aws/cross_repos/stamp_repo.dart';
import 'package:stripes_sandbox_aws/models/BlueDyeResponse.dart';
import 'package:stripes_sandbox_aws/models/BlueDyeResponseLog.dart';
import 'package:stripes_sandbox_aws/models/BlueDyeTestLog.dart';
import 'package:stripes_sandbox_aws/models/DetailResponse.dart';
import 'package:stripes_sandbox_aws/utils.dart';

import '../../models/BlueDyeTest.dart';
import 'query_utils.dart';

class Test extends TestRepo<repo.BlueDyeTest> {
  BlueDyeTest? current;

  final StreamController<repo.BlueDyeTest?> _controller = StreamController();

  Test(
      {required super.stampRepo,
      required super.authUser,
      required super.subUser,
      required super.questionRepo}) {
    fetchCurrentTest();
  }

  Future<void> fetchCurrentTest() async {
    try {
      GraphQLRequest<PaginatedResult<BlueDyeTest>> request = ModelQueries.list(
          BlueDyeTest.classType,
          where: BlueDyeTest.SUBUSER.eq(subUser.uid));

      GraphQLResponse<PaginatedResult<BlueDyeTest>> res =
          await Amplify.API.query(request: request).response;

      final BlueDyeTest? rawTest = res.data?.items.first;

      final BlueDyeTest? withLogs = await _addLogs(rawTest);

      _emit(withLogs);
    } catch (e) {
      safePrint(e);
    }
  }

  Future<BlueDyeTest?> _addLogs(BlueDyeTest? raw) async {
    if (raw == null || raw.logs != null) return raw;
    final GraphQLRequest<PaginatedResult<BlueDyeTestLog>> logsRequest =
        ModelQueries.list(BlueDyeTestLog.classType,
            where: BlueDyeTestLog.BLUEDYETEST.eq(raw.id));
    final GraphQLResponse<PaginatedResult<BlueDyeTestLog>> res =
        await Amplify.API.query(request: logsRequest).response;
    final List<BlueDyeTestLog> logs =
        res.data?.items.whereType<BlueDyeTestLog>().toList() ?? [];
    final List<BlueDyeTestLog> withResp = [];
    for (BlueDyeTestLog log in logs) {
      final BlueDyeTestLog? cleanedLog = await _clean(log);
      if (cleanedLog == null) continue;
      withResp.add(cleanedLog);
    }
    return raw.copyWith(logs: withResp);
  }

  Future<BlueDyeTestLog?> _clean(BlueDyeTestLog log) async {
    if (log.response != null) {
      final DetailResponse? cleaned = await ensureDetailChildren(log.response);
      if (cleaned == null) return null;
      final BlueDyeTestLog withResponse = log.copyWith(response: cleaned);
      return withResponse;
    }
    final GraphQLRequest<PaginatedResult<DetailResponse>> logResponse =
        ModelQueries.list(DetailResponse.classType,
            where: DetailResponse.ID.eq(log.detailResponseID));
    final DetailResponse? res =
        (await Amplify.API.query(request: logResponse).response)
            .data
            ?.items
            .first;
    final DetailResponse? cleanedDetail = await ensureDetailChildren(res);
    if (cleanedDetail == null) return null;
    final BlueDyeTestLog withResponse = log.copyWith(response: cleanedDetail);
    return withResponse;
  }

  _emit(BlueDyeTest? test) {
    current = test;
    _controller.add(test != null ? queryToLocalTest(test, questionRepo) : null);
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
  Stream<repo.BlueDyeTest?> get obj => _controller.stream;

  @override
  setValue(repo.BlueDyeTest obj) async {
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
}
