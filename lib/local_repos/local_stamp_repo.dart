import 'dart:async';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:rxdart/subjects.dart';

import 'package:stripes_backend_helper/QuestionModel/response.dart' as repo;
import 'package:stripes_backend_helper/RepositoryBase/StampBase/base_stamp_repo.dart';
import 'package:stripes_backend_helper/RepositoryBase/StampBase/stamp.dart';
import 'package:stripes_backend_helper/RepositoryBase/TestBase/BlueDye/blue_dye_response.dart';
import 'package:stripes_sandbox_aws/local_repos/local_db.dart';
import 'package:stripes_sandbox_aws/models/BlueDyeResponse.dart';
import 'package:stripes_sandbox_aws/models/DetailResponse.dart';
import 'package:stripes_sandbox_aws/models/Response.dart';
import 'package:stripes_sandbox_aws/utils.dart';

class LocalStamps extends StampRepo<repo.Response> {
  List<DetailResponse> details = [];
  List<Response> responses = [];
  List<BlueDyeResponse> blueDyeResponses = [];

  final LocalDB db = LocalDB();

  final BehaviorSubject<List<repo.Response>> _controller = BehaviorSubject();

  LocalStamps(
      {required super.authUser,
      required super.currentUser,
      required super.questionRepo,
      DateTime? earliestFetched}) {
    earliest = earliestFetched;
    fetchStamps();
  }

  _emit() {
    final List<repo.DetailResponse> localDetails =
        details.map((detail) => detailFromQuery(detail, questionRepo)).toList();
    final List<repo.Response> localResponses = responses
        .map((response) => responseFromQuery(response, questionRepo))
        .toList();
    final List<BlueDyeResp> blueDye = blueDyeResponses
        .map((blue) => blueDyeFromQuery(blue, questionRepo))
        .toList();
    final List<repo.Response> newStamps = [
      ...localDetails,
      ...localResponses,
      ...blueDye
    ];
    newStamps.sort((a, b) => b.stamp.compareTo(a.stamp));
    _controller.add(newStamps);
  }

  fetchStamps({bool includePrevious = false}) async {
    await db.ready;
    final TemporalDateTime earliestTime = earliest != null
        ? TemporalDateTime(earliest!)
        : TemporalDateTime(DateTime(0));

    responses = await db.getResponses(currentUser.uid, earliest: earliestTime);
    blueDyeResponses =
        await db.getBlueDyeResponses(currentUser.uid, earliest: earliestTime);
    details =
        await db.getDetailResponses(currentUser.uid, earliest: earliestTime);

    _emit();
  }

  Future<void> addRawBlueDye(BlueDyeResponse response) async {
    if (response.logs == null) return;
    final bool added = await db.addBlueDyeResponse(response);
    if (added) {
      blueDyeResponses.add(response);
      _emit();
    }
  }

  @override
  addStamp(Stamp stamp) async {
    if (stamp is repo.DetailResponse) {
      final DetailResponse toCreate =
          detailToQuery(stamp, fromLocal(currentUser));
      final bool created = await db.addDetailResponse(toCreate);
      if (created) {
        details.add(toCreate);
        _emit();
      }
    } else if (stamp is BlueDyeResp) {
      final BlueDyeResponse res =
          blueDyeToQuery(stamp, currentUser, questionRepo);
      final bool created = await db.addBlueDyeResponse(res);
      if (created) {
        blueDyeResponses.add(res);
      }
    } else if (stamp is repo.Response) {
      final Response toCreate = responseToQuery(stamp, currentUser.uid);
      final bool created = await db.addResponse(toCreate);
      if (created) {
        responses.add(toCreate);
        _emit();
      }
    }
  }

  @override
  removeStamp(Stamp stamp) async {
    if (stamp.id == null) return;
    if (stamp is repo.DetailResponse) {
      final DetailResponse toDelete =
          detailToQuery(stamp, fromLocal(currentUser));
      final bool deleted = await db.removeDetailResponse(toDelete);
      if (deleted) {
        details.removeWhere(
          (element) => element.id == stamp.id!,
        );
        _emit();
      }
    } else if (stamp is BlueDyeResp) {
      if (stamp.id == null) return;
      final bool deleted = await db.removeBlueDyeResponse(stamp.id!);
      if (deleted) {
        blueDyeResponses.removeWhere(
          (element) => element.id == stamp.id!,
        );
        _emit();
      }
    } else if (stamp is repo.Response) {
      if (stamp.id == null) return;
      final bool deleted = await db.removeResponse(stamp.id!);
      if (deleted) {
        responses.removeWhere(
          (element) => element.id == stamp.id!,
        );
        _emit();
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
      final bool updated = await db.updateDetailResponse(toUpdate);
      if (updated) {
        final int addIndex =
            details.indexWhere((element) => element.id == toUpdate.id);
        if (addIndex != -1) {
          details[addIndex] = toUpdate;
          _emit();
        }
      }
    } else if (stamp is repo.Response) {
      final Response toUpdate = responseToQuery(stamp, currentUser.uid);
      final bool updated = await db.updateResponse(toUpdate);
      if (updated) {
        final int addIndex =
            responses.indexWhere((element) => element.id == toUpdate.id);
        if (addIndex != -1) {
          responses[addIndex] = toUpdate;
          _emit();
        }
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
