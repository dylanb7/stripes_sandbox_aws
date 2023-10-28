import 'dart:async';

import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_flutter/amplify_flutter.dart';

import 'package:stripes_backend_helper/RepositoryBase/StampBase/base_stamp_repo.dart';
import 'package:stripes_backend_helper/RepositoryBase/StampBase/stamp.dart';

import 'package:stripes_backend_helper/RepositoryBase/TestBase/BlueDye/blue_dye_response.dart';

import 'package:stripes_backend_helper/QuestionModel/response.dart' as repo;
import 'package:stripes_sandbox_aws/cross_repos/query_utils.dart';
import 'package:stripes_sandbox_aws/models/BlueDyeResponse.dart';
import 'package:stripes_sandbox_aws/models/BlueDyeResponseLog.dart';
import 'package:stripes_sandbox_aws/models/DetailResponse.dart';
import 'package:stripes_sandbox_aws/models/Response.dart';
import 'package:stripes_sandbox_aws/utils.dart';

class Stamps extends StampRepo<repo.Response> {
  List<DetailResponse> details = [];
  List<Response> responses = [];
  List<BlueDyeResponse> blueDyeResponses = [];

  final StreamController<List<repo.Response>> _controller = StreamController();

  Stamps(
      {required super.authUser,
      required super.currentUser,
      required super.questionRepo}) {
    _controller.add([]);
    fetchStamps();
  }

  _emit() {
    final List<repo.DetailResponse> localDetails =
        details.map((detail) => detailFromQuery(detail, questionRepo)).toList();
    final List<repo.Response> localResponses = responses
        .map((response) => responseFromQuery(response, questionRepo))
        .toList();
    final List<BlueDyeResp> blueDye =
        blueDyeResponses.map((blue) => blueDyeFromQuery(blue)).toList();
    final List<repo.Response> newStamps = [
      ...localDetails,
      ...localResponses,
      ...blueDye
    ];
    newStamps.sort((a, b) => b.stamp.compareTo(a.stamp));
    _controller.add(newStamps);
  }

  fetchStamps() async {
    final int earlist = earliest?.millisecondsSinceEpoch ?? 0;
    final GraphQLRequest<PaginatedResult<DetailResponse>> detailQuery =
        ModelQueries.list(DetailResponse.classType,
            where: DetailResponse.STAMP
                .ge(earlist)
                .and(DetailResponse.SUBUSERID.eq(currentUser.uid)));

    final GraphQLRequest<PaginatedResult<Response>> responseQuery =
        ModelQueries.list(Response.classType,
            where: Response.STAMP.ge(earlist).and(Response.DETAILRESPONSE
                .eq(null)
                .and(Response.SUBUSERID.eq(currentUser.uid))));

    final GraphQLRequest<PaginatedResult<BlueDyeResponse>> blueQuery =
        ModelQueries.list(BlueDyeResponse.classType,
            where: BlueDyeResponse.STAMP
                .ge(earlist)
                .and(BlueDyeResponse.SUBUSERID.eq(currentUser.uid)));

    try {
      final GraphQLResponse<PaginatedResult<DetailResponse>> detailResult =
          await Amplify.API.query(request: detailQuery).response;
      if (detailResult.data != null) {
        final List<DetailResponse?> cleaned = [];
        for (DetailResponse? response in detailResult.data!.items) {
          cleaned.add(await ensureDetailChildren(response));
        }
        details = cleaned.whereType<DetailResponse>().toList();
      }

      final GraphQLResponse<PaginatedResult<Response>> responseResult =
          await Amplify.API.query(request: responseQuery).response;
      if (responseResult.data != null) {
        final List<Response?> rawResponses = responseResult.data!.items;
        responses = rawResponses.whereType<Response>().toList();
      }

      final GraphQLResponse<PaginatedResult<BlueDyeResponse>> blueDyeResult =
          await Amplify.API.query(request: blueQuery).response;
      if (blueDyeResult.data != null) {
        final List<BlueDyeResponse> rawData =
            blueDyeResult.data!.items.whereType<BlueDyeResponse>().toList();
        final List<BlueDyeResponse> cleaned = [];
        for (BlueDyeResponse blueDyeResponse in rawData) {
          List<BlueDyeResponseLog>? logs = blueDyeResponse.logs;
          if (logs == null) {
            final GraphQLRequest<PaginatedResult<BlueDyeResponseLog>> blueLogs =
                ModelQueries.list(BlueDyeResponseLog.classType,
                    where: BlueDyeResponseLog.BLUEDYERESPONSE
                        .eq(blueDyeResponse.id));
            GraphQLResponse<PaginatedResult<BlueDyeResponseLog>> res =
                await Amplify.API.query(request: blueLogs).response;
            if (res.data == null) continue;
            logs = res.data!.items.whereType<BlueDyeResponseLog>().toList();
          }

          final List<BlueDyeResponseLog> withDetail = [];
          for (BlueDyeResponseLog log in logs) {
            final DetailResponse? logResponse =
                await ensureDetailChildren(log.response);
            if (logResponse != null) {
              final BlueDyeResponseLog toAdd = log.copyWith(
                  response: logResponse, detailResponseID: logResponse.id);
              withDetail.add(toAdd);
            }
          }
          final BlueDyeResponse toAdd =
              blueDyeResponse.copyWith(logs: withDetail);
          cleaned.add(toAdd);
        }

        blueDyeResponses = cleaned;
      }
      _emit();
    } catch (e) {
      safePrint(e);
    }
  }

  Future<void> addRawBlueDye(BlueDyeResponse response) async {
    if (response.logs == null) return;
    final List<BlueDyeResponseLog> responseLogs = response.logs!;

    final GraphQLRequest<BlueDyeResponse> createParentRequest =
        ModelMutations.create(response);

    try {
      final GraphQLResponse<BlueDyeResponse> parentReponse =
          await Amplify.API.mutate(request: createParentRequest).response;
      if (parentReponse.hasErrors) return;
      for (BlueDyeResponseLog log in responseLogs) {
        final BlueDyeResponseLog toCreate =
            log.copyWith(blueDyeResponse: parentReponse.data);
        final GraphQLRequest createLog = ModelMutations.create(toCreate);
        await Amplify.API.mutate(request: createLog).response;
      }
      blueDyeResponses.add(response);
      _emit();
    } catch (e) {
      safePrint(e);
    }
  }

  @override
  addStamp(Stamp stamp) async {
    if (stamp is repo.DetailResponse) {
      try {
        final DetailResponse toCreate =
            detailToQuery(stamp, fromLocal(currentUser));
        final GraphQLRequest<DetailResponse> request =
            ModelMutations.create(toCreate);
        final GraphQLResponse<DetailResponse> response =
            await Amplify.API.mutate(request: request).response;
        for (Response response in toCreate.responses!) {
          final Response childCreate =
              response.copyWith(detailResponse: toCreate);
          final GraphQLRequest<Response> createChild =
              ModelMutations.create(childCreate);
          await Amplify.API.mutate(request: createChild).response;
        }
        if (response.data != null) {
          details.add(toCreate);
          _emit();
        }
      } catch (e) {
        safePrint(e);
      }
    } else if (stamp is BlueDyeResp) {
      throw UnimplementedError();
    } else if (stamp is repo.Response) {
      try {
        final GraphQLRequest<Response> request =
            ModelMutations.create(responseToQuery(stamp, currentUser.uid));
        final GraphQLResponse<Response> response =
            await Amplify.API.mutate(request: request).response;
        Response? res = response.data;
        if (res != null) {
          responses.add(res);
          _emit();
        }
      } catch (e) {
        safePrint(e);
      }
    }
  }

  @override
  removeStamp(Stamp stamp) async {
    if (stamp.id == null) return;
    if (stamp is repo.DetailResponse) {
      try {
        final GraphQLRequest<DetailResponse> request =
            ModelMutations.deleteById(DetailResponse.classType,
                DetailResponseModelIdentifier(id: stamp.id!));
        final GraphQLResponse<DetailResponse> response =
            await Amplify.API.mutate(request: request).response;
        if (response.data != null) {
          details.removeWhere(
            (element) => element.id == stamp.id!,
          );
          _emit();
        }
      } catch (e) {
        safePrint(e);
      }
    } else if (stamp is BlueDyeResp) {
      try {
        final GraphQLRequest<BlueDyeResponse> request =
            ModelMutations.deleteById(BlueDyeResponse.classType,
                BlueDyeResponseModelIdentifier(id: stamp.id!));
        final GraphQLResponse<BlueDyeResponse> response =
            await Amplify.API.mutate(request: request).response;
        if (response.data != null) {
          blueDyeResponses.removeWhere(
            (element) => element.id == stamp.id!,
          );
          _emit();
        }
      } catch (e) {
        safePrint(e);
      }
    } else if (stamp is repo.Response) {
      try {
        final GraphQLRequest<Response> request = ModelMutations.deleteById(
            Response.classType, ResponseModelIdentifier(id: stamp.id!));
        final GraphQLResponse<Response> response =
            await Amplify.API.mutate(request: request).response;
        if (response.data != null) {
          responses.removeWhere(
            (element) => element.id == stamp.id!,
          );
          _emit();
        }
      } catch (e) {
        safePrint(e);
      }
    }
  }

  @override
  updateStamp(Stamp stamp) async {
    if (stamp is BlueDyeResp) {
      return;
    }
    await removeStamp(stamp);
    await addStamp(stamp);
    if (stamp is repo.DetailResponse) {
      details.add(detailToQuery(stamp, fromLocal(currentUser)));
    } else if (stamp is repo.Response) {
      responses.add(responseToQuery(stamp, currentUser.uid));
    }
    _emit();
  }

  @override
  set earliestDate(DateTime dateTime) {
    earliest = dateTime;
    fetchStamps();
  }

  @override
  Stream<List<repo.Response>> get stamps => _controller.stream;
}
