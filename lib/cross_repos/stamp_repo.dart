import 'dart:async';
import 'dart:convert';

import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:rxdart/subjects.dart';

import 'package:stripes_backend_helper/QuestionModel/response.dart' as repo;
import 'package:stripes_backend_helper/RepositoryBase/StampBase/base_stamp_repo.dart';
import 'package:stripes_backend_helper/RepositoryBase/StampBase/stamp.dart';
import 'package:stripes_backend_helper/RepositoryBase/TestBase/BlueDye/blue_dye_response.dart';
import 'package:stripes_backend_helper/date_format.dart';

import 'package:stripes_sandbox_aws/models/BlueDyeResponse.dart';
import 'package:stripes_sandbox_aws/models/BlueDyeResponseLog.dart';
import 'package:stripes_sandbox_aws/models/DetailResponse.dart';
import 'package:stripes_sandbox_aws/models/Response.dart';
import 'package:stripes_sandbox_aws/utils.dart';

class Stamps extends StampRepo<repo.Response> {
  List<DetailResponse> details = [];
  List<Response> responses = [];
  List<BlueDyeResponse> blueDyeResponses = [];

  final BehaviorSubject<List<repo.Response>> _controller = BehaviorSubject();

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

  fetchStamps({bool includePrevious = false}) async {
    final TemporalDateTime earliestTime = earliest != null
        ? TemporalDateTime(earliest!)
        : TemporalDateTime(DateTime(0));

    const fetchResponses = "listResponses";
    const fetchDetails = "listDetailResponses";
    const fetchBlueResponses = "listBlueDyeResponses";

    const gqlDocument = '''query FetchStamps(\$subId: ID!) {
      $fetchResponses(
        filter: { 
          subUserId: { 
            eq: \$subId 
          }, 
          detailResponseID: {
            attributeExists: false
          },
        }) {
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
      $fetchDetails(
        filter: { 
          subUserId: { 
            eq: \$subId 
          },
          
        }) {
        items {
          id
          stamp
          type
          description
          subUserId
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
      $fetchBlueResponses(
        filter: { 
          subUserId: { 
            eq: \$subId 
          }, 
        }) {
        items {
          id
          stamp
          finishedEating
          subUserId
          logs {
            items {
              id
              isBlue
              response {
                id
                stamp
                type
                description
                subUserId
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
    }''';

    final int? earliestResponseTime =
        _controller.hasValue && _controller.value.isNotEmpty
            ? _controller.value.last.stamp
            : null;
    final TemporalDateTime? previous =
        includePrevious && earliestResponseTime != null
            ? TemporalDateTime(dateFromStamp(earliestResponseTime))
            : null;
    GraphQLRequest stampsRequest = GraphQLRequest(
      document: gqlDocument,
      variables: {
        "subId": currentUser.uid,
        "earliest": earliestTime.format(),
        "previousEarliest": previous?.format()
      },
    );

/*
    ModelQueries.get(
        SubUser.classType, SubUserModelIdentifier(id: currentUser.uid));

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
                */

    List<DetailResponse> parseDetail(Map<String, dynamic> detailResponsesBlob) {
      if (!detailResponsesBlob.containsKey("items")) return [];
      List<dynamic> items = detailResponsesBlob["items"];
      final List<DetailResponse> ret = [];
      for (final item in items) {
        DetailResponse res = DetailResponse.fromJson(item);
        if (item.containsKey("responses")) {
          PaginatedResult<Response> children =
              const PaginatedModelType(Response.classType)
                  .fromJson(item["responses"]);
          res = res.copyWith(
              responses: children.items.whereType<Response>().toList());
        }
        ret.add(res);
      }

      return ret;
    }

    List<BlueDyeResponse> parseBlue(Map<String, dynamic> blueResponsesBlob) {
      if (!blueResponsesBlob.containsKey("items")) return [];
      List<dynamic> items = blueResponsesBlob["items"];
      final List<BlueDyeResponse> ret = [];
      for (final item in items) {
        BlueDyeResponse res = BlueDyeResponse.fromJson(item);
        if (item.containsKey("logs")) {
          List<dynamic> logsBlob = item["logs"]["items"];
          final List<BlueDyeResponseLog> blueLogs = [];

          for (final log in logsBlob) {
            final Map<String, dynamic> logMap =
                (log as Map).cast<String, dynamic>();
            BlueDyeResponseLog resToAdd = BlueDyeResponseLog.fromJson(logMap);
            if (logMap.containsKey("response")) {
              final Map<String, dynamic> detailMap =
                  (logMap["response"] as Map).cast<String, dynamic>();
              final List<Response> responsesToAdd = [];

              if (detailMap.containsKey("responses")) {
                for (final resBlob in detailMap["responses"]["items"] as List) {
                  final Map<String, dynamic> resMap =
                      (resBlob as Map).cast<String, dynamic>();

                  responsesToAdd.add(Response.fromJson(resMap));
                }
              }
              final DetailResponse logDetail =
                  DetailResponse.fromJson(detailMap)
                      .copyWith(responses: responsesToAdd);

              resToAdd = resToAdd.copyWith(response: logDetail);
            }

            blueLogs.add(resToAdd);
          }
          res = res.copyWith(logs: blueLogs);
        }
        ret.add(res);
      }

      return ret;
    }

    try {
      final GraphQLResponse response =
          await Amplify.API.query(request: stampsRequest).response;
      if (response.data == null) return;
      final jsonData =
          (json.decode(response.data) as Map).cast<String, Object?>();

      final responsesBlob =
          (jsonData[fetchResponses] as Map).cast<String, dynamic>();
      final PaginatedResult<Response> rawResponses =
          const PaginatedModelType(Response.classType).fromJson(responsesBlob);

      final detailResponsesBlob =
          (jsonData[fetchDetails] as Map).cast<String, dynamic>();

      final List<DetailResponse> newDetails = parseDetail(detailResponsesBlob);

      final blueResponsesBlob =
          (jsonData[fetchBlueResponses] as Map).cast<String, dynamic>();

      final List<BlueDyeResponse> newBlueDye = parseBlue(blueResponsesBlob);

      final List<Response> newResponses =
          rawResponses.items.whereType<Response>().toList();

      if (includePrevious) {
        responses = [...responses, ...newResponses];
        details = [...details, ...newDetails];
        blueDyeResponses = [...blueDyeResponses, ...newBlueDye];
      } else {
        responses = newResponses;
        details = newDetails;
        blueDyeResponses = newBlueDye;
      }

      _emit();

      /*final GraphQLResponse<PaginatedResult<DetailResponse>> detailResult =
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
      _emit();*/
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
        final GraphQLResponse<DetailResponse> parentResponse =
            await Amplify.API.mutate(request: request).response;
        for (Response response in toCreate.responses!) {
          final Response childCreate =
              response.copyWith(detailResponseID: parentResponse.data?.id);
          final GraphQLRequest<Response> createChild =
              ModelMutations.create(childCreate);
          await Amplify.API.mutate(request: createChild).response;
        }
        if (parentResponse.data != null) {
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
      throw UnimplementedError();
    }

    if (stamp is repo.DetailResponse) {
      final DetailResponse toUpdate =
          detailToQuery(stamp, fromLocal(currentUser));
      final GraphQLRequest<DetailResponse> existsRequest = ModelQueries.get(
          DetailResponse.classType,
          DetailResponseModelIdentifier(id: toUpdate.id));
      try {
        final GraphQLResponse<DetailResponse> exists =
            await Amplify.API.query(request: existsRequest).response;
        if (exists.data == null) return;
        final DetailResponse updateComparison =
            toUpdate.copyWith(responses: []);
        if (exists.data != updateComparison) {
          final GraphQLRequest<DetailResponse> updateRequest =
              ModelMutations.update(toUpdate);
          final GraphQLResponse<DetailResponse> updateResponse =
              await Amplify.API.mutate(request: updateRequest).response;
          if (updateResponse.data == null) {
            return;
          }
        }
        final int index =
            details.indexWhere((element) => element.id == exists.data!.id);
        final List<Response> currentChildren =
            index == -1 ? [] : details[index].responses ?? [];
        for (Response res in currentChildren) {
          final GraphQLRequest<Response> deleteRequest =
              ModelMutations.delete(res);
          await Amplify.API.mutate(request: deleteRequest).response;
        }
        final List<Response> created = [];
        for (Response childCreate in toUpdate.responses ?? []) {
          final Response childToCreate =
              childCreate.copyWith(detailResponseID: toUpdate.id);
          final GraphQLRequest<Response> createRequest =
              ModelMutations.create(childToCreate);
          final GraphQLResponse<Response> createResponse =
              await Amplify.API.mutate(request: createRequest).response;
          if (createResponse.data != null) {
            created.add(createResponse.data!);
          }
        }
        final DetailResponse toAdd = toUpdate.copyWith(responses: created);
        final int addIndex =
            details.indexWhere((element) => element.id == toAdd.id);
        if (addIndex != -1) {
          details[addIndex] = toAdd;
          _emit();
        }
      } catch (e) {
        safePrint(e);
      }
    } else if (stamp is repo.Response) {
      final Response toUpdate = responseToQuery(stamp, currentUser.uid);
      final GraphQLRequest<Response> updateRequest =
          ModelMutations.update(toUpdate);
      try {
        final GraphQLResponse<Response> update =
            await Amplify.API.mutate(request: updateRequest).response;
        if (update.data != null) {
          responses.add(update.data!);
          _emit();
        }
      } catch (e) {
        safePrint(e);
      }
    }
  }

  @override
  set earliestDate(DateTime dateTime) {
    earliest = dateTime;
    fetchStamps();
  }

  @override
  Stream<List<repo.Response>> get stamps => _controller.stream;
}
