import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart' as webDb;
import 'package:sqflite/sqflite.dart';
import 'package:stripes_backend_helper/RepositoryBase/TestBase/BlueDye/blue_dye_response.dart';
import 'package:stripes_backend_helper/date_format.dart';

import 'package:stripes_sandbox_aws/models/BlueDyeResponse.dart';
import 'package:stripes_sandbox_aws/models/BlueDyeResponseLog.dart';
import 'package:stripes_sandbox_aws/models/BlueDyeTest.dart';
import 'package:stripes_sandbox_aws/models/BlueDyeTestLog.dart';
import 'package:stripes_sandbox_aws/models/DetailResponse.dart';
import 'package:stripes_sandbox_aws/models/Response.dart';

import 'dart:core';

// ignore: depend_on_referenced_packages
import 'package:path/path.dart';

import 'package:stripes_sandbox_aws/models/SubUser.dart';

const dbName = 'stripes_local_store.db';

//tables + schemas
const String subUserTable = 'SUBUSER';

const subUserSchema = {
  id: 'TEXT PRIMARY KEY',
  name: 'TEXT',
  gender: 'TEXT',
  birthYear: 'INTEGER',
  isControl: 'INTEGER',
  blueDyeTestID: 'TEXT'
};

const String responseTable = 'RESPONSES';

const responseSchema = {
  id: 'TEXT PRIMARY KEY',
  stamp: 'TEXT',
  type: 'TEXT',
  qid: 'TEXT',
  textResponse: 'TEXT',
  selected: 'INTEGER',
  numeric: 'INTEGER',
  all_selected: 'BLOB',
  subUserId: 'TEXT',
  detailResponseID: 'TEXT'
};

const String detailTable = 'DETAILRESPONSES';

const detailSchema = {
  id: 'TEXT PRIMARY KEY',
  stamp: 'TEXT',
  type: 'TEXT',
  description: 'TEXT',
  subUserId: 'TEXT'
};

const String blueDyeTestTable = 'BLUEDYETEST';

const blueDyeTestSchema = {
  id: 'TEXT PRIMARY KEY',
  stamp: 'TEXT',
  finishedEating: 'INTEGER',
  finishedEatingDate: 'TEXT',
  pauseTime: 'TEXT',
  startTime: 'TEXT',
  amountConsumed: 'TEXT',
  subUserId: 'TEXT'
};

const String blueDyeResponseTable = 'BLUEDYERESPONSE';

const blueDyeResponseSchema = {
  id: 'TEXT PRIMARY KEY',
  stamp: 'TEXT',
  finishedEating: 'INTEGER',
  finishedEatingDate: 'TEXT',
  amountConsumed: 'TEXT',
  subUserId: 'TEXT'
};

const String blueDyeTestLogTable = 'BLUEDYETESTLOG';

const blueDyeTestLogSchema = {
  id: 'TEXT PRIMARY KEY',
  isBlue: 'INTEGER',
  blueDyeTestID: 'TEXT',
  detailResponseID: 'TEXT',
};

const String blueDyeResponseLogTable = 'BLUEDYERESPONSELOG';

const blueDyeResponseLogSchema = {
  id: 'TEXT PRIMARY KEY',
  isBlue: 'INTEGER',
  blueDyeResponseID: 'TEXT',
  detailResponseID: 'TEXT'
};

//fieldNames

const id = 'id';
const stamp = 'stamp';
const type = 'type';
const subUserId = 'subUserId';

const qid = 'qid';
const textResponse = 'textResponse';
const selected = 'selected';
const numeric = 'numeric';
const all_selected = 'all_selected';
const detailResponseID = 'detailResponseID';

const name = 'name';
const gender = 'gender';
const birthYear = 'birthYear';
const isControl = 'isControl';
const blueDyeTestID = 'blueDyeTestID';

const description = 'description';

const finishedEating = 'finishedEating';
const finishedEatingDate = 'finishedEatingDate';
const amountConsumed = 'amountConsumed';
const pauseTime = 'pauseTime';
const startTime = 'startTime';

const isBlue = 'isBlue';

const blueDyeResponseID = 'blueDyeResponseID';

const accessKey = '';

class LocalDB {
  static final _instance = LocalDB._internal();

  late Database _db;

  late Future ready;

  final FlutterSecureStorage storage = const FlutterSecureStorage();

  LocalDB._internal() {
    ready = init();
  }

  factory LocalDB() => _instance;

  init() async {
    if (kIsWeb) {
      _db = await webDb.databaseFactoryFfiWeb.openDatabase(
        dbName, /*password: await storage.read(key: accessKey), singleInstance: true*/
      );
    } else {
      final String basePath = await getDatabasesPath();

      _db = await openDatabase(join(basePath, dbName), singleInstance: true);
    }
    _initTables();
  }

  _initTables() async {
    await _createTable(subUserTable, subUserSchema);
    await _createTable(responseTable, responseSchema);
    await _createTable(detailTable, detailSchema);
    await _createTable(blueDyeTestTable, blueDyeTestSchema);
    await _createTable(blueDyeResponseTable, blueDyeResponseSchema);
    await _createTable(blueDyeTestLogTable, blueDyeTestLogSchema);
    await _createTable(blueDyeResponseLogTable, blueDyeResponseLogSchema);
  }

  Future<void> _createTable(
      String tableName, Map<String, String> fields) async {
    final List<String> fieldStrings = [];
    fields.forEach((key, value) {
      fieldStrings.add('$key $value');
    });

    final String tableCreate =
        'CREATE TABLE IF NOT EXISTS $tableName (${fieldStrings.join(',')})';

    return await _db.execute(tableCreate);
  }

  Future<bool> addSubUser(SubUser subUser) async {
    final Map<String, dynamic> values = subUser.toJson();
    values[isControl] = boolToInt(subUser.isControl);
    final retId =
        await _db.insert(subUserTable, matchKeys(values, subUserSchema.keys));
    return retId != 0;
  }

  Future<bool> deleteSubUser(String subId) async {
    final retId =
        await _db.delete(subUserTable, where: '$id = ?', whereArgs: [subId]);
    return retId != 0;
  }

  Future<bool> updateSubUser(SubUser subUser) async {
    final Map<String, dynamic> values = subUser.toJson();
    values[isControl] = boolToInt(subUser.isControl);
    final retId = await _db.update(
        subUserTable, matchKeys(values, subUserSchema.keys),
        where: '$id = ?', whereArgs: [subUser.id]);
    return retId != 0;
  }

  Future<List<SubUser>> getSubUsers() async {
    final List<SubUser> subUsers = [];
    final List<Map<String, Object?>> values = await _db.query(subUserTable);
    for (final value in values) {
      final int control = value[isControl] is int ? value[isControl] as int : 0;
      final SubUser newSub =
          SubUser.fromJson({...value, isControl: intToBool(control)});
      subUsers.add(newSub);
    }
    return subUsers;
  }

  Future<bool> addDetailResponse(DetailResponse detail) async {
    final List<Response> children = detail.responses ?? [];
    try {
      int totalAdditions = 0;
      await _db.transaction((txn) async {
        Map<String, dynamic> detailJson =
            matchKeys(detail.toJson(), detailSchema.keys);

        totalAdditions += await txn.insert(detailTable, detailJson);
        for (final child in children) {
          Map<String, dynamic> toInsert =
              matchKeys(child.toJson(), responseSchema.keys);
          totalAdditions += await txn.insert(responseTable, toInsert);
        }
      });
      return totalAdditions > 0;
    } catch (e) {
      return false;
    }
  }

  Future<bool> removeDetailResponse(DetailResponse detail) async {
    try {
      int totalDeletions = 0;
      await _db.transaction((txn) async {
        totalDeletions += await txn
            .delete(detailTable, where: '$id = ?', whereArgs: [detail.id]);
        totalDeletions += await txn.delete(responseTable,
            where: '$detailResponseID = ?', whereArgs: [detail.id]);
      });
      return totalDeletions > 0;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateDetailResponse(DetailResponse detail) async {
    final List<Response> children = detail.responses ?? [];
    try {
      int alterations = 0;
      int deletions = 0;
      await _db.transaction((txn) async {
        final Map<String, dynamic> detailJson =
            matchKeys(detail.toJson(), detailSchema.keys);
        alterations += await txn.update(detailTable, detailJson,
            where: '$id = ?', whereArgs: [detail.id]);
        deletions = await txn.delete(responseTable,
            where: '$detailResponseID = ?', whereArgs: [detail.id]);
        for (final child in children) {
          final Map<String, dynamic> responseJson =
              matchKeys(child.toJson(), responseSchema.keys);
          alterations += await txn.insert(responseTable, responseJson);
        }
      });
      return alterations > 0 || deletions > 0;
    } catch (e) {
      return false;
    }
  }

  Future<List<DetailResponse>> getDetailResponses(String subId,
      {TemporalDateTime? earliest, TemporalDateTime? last}) async {
    List<DetailResponse> responses = [];
    final String whereBounts = whereFromBounds(earliest: earliest, last: last);
    final List<Map<String, Object?>> values = await _db.query(detailTable,
        where: whereBounts.isEmpty
            ? '$subUserId = ?'
            : '$whereBounts AND $subUserId = ?',
        whereArgs: whereArgsFromBounds(earliest: earliest, last: last)
          ..add(subId));
    final batch = _db.batch();

    for (final value in values) {
      final DetailResponse toAdd = DetailResponse.fromJson(value);
      batch.query(responseTable,
          where: '$detailResponseID = ?', whereArgs: [toAdd.id]);
      responses.add(toAdd);
    }
    final List<Object?> childrenBlob = await batch.commit();

    List<Response> parseObject(Object? val) {
      if (val is! List) return [];
      return val
          .map((e) => Response.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    }

    for (int i = 0; i < responses.length; i++) {
      final DetailResponse currentDetail = responses[i];
      final List<Response> childResponses = parseObject(childrenBlob[i]);
      responses[i] = currentDetail.copyWith(responses: childResponses);
    }
    return responses;
  }

  Future<bool> addResponse(Response response) async {
    final int added = await _db.insert(
        responseTable, matchKeys(response.toJson(), responseSchema.keys));
    return added > 0;
  }

  Future<bool> removeResponse(String responseId) async {
    final int removed = await _db
        .delete(responseTable, where: '$id = ?', whereArgs: [responseId]);
    return removed > 0;
  }

  Future<bool> updateResponse(Response response) async {
    final int updated = await _db.update(
        responseTable, matchKeys(response.toJson(), responseSchema.keys),
        where: '$id = ?', whereArgs: [response.id]);
    return updated > 0;
  }

  Future<List<Response>> getResponses(String subId,
      {TemporalDateTime? earliest, TemporalDateTime? last}) async {
    final List<Response> resps = [];
    final String whereBounts = whereFromBounds(earliest: earliest, last: last);
    const String addedConditions =
        '$subUserId = ? AND $detailResponseID IS NULL';
    List<Map<String, Object?>> responseBlobs = await _db.query(responseTable,
        where: whereBounts.isEmpty
            ? addedConditions
            : '$whereBounts AND $addedConditions',
        whereArgs: whereArgsFromBounds(earliest: earliest, last: last)
          ..add(subId));
    for (final blob in responseBlobs) {
      resps.add(Response.fromJson(blob));
    }
    return resps;
  }

  Future<bool> addBlueDyeResponse(BlueDyeResponse blueDyeResponse) async {
    final List<BlueDyeResponseLog> logs = blueDyeResponse.logs ?? [];

    int count = 0;
    await _db.transaction((txn) async {
      count += await txn.insert(blueDyeResponseTable,
          matchKeys(blueDyeResponse.toJson(), blueDyeResponseSchema.keys));
      for (final log in logs) {
        final logPacket = log.toJson();
        final bool blue = logPacket[isBlue] ?? false;
        logPacket[isBlue] = boolToInt(blue);
        count += await txn.insert(blueDyeResponseLogTable,
            matchKeys(logPacket, blueDyeResponseLogSchema.keys));
      }
    });
    return count > 0;
  }

  Future<bool> removeBlueDyeResponse(String blueDyeResponseId) async {
    int count = 0;
    await _db.transaction((txn) async {
      count += await txn.delete(blueDyeResponseTable,
          where: '$id = ?', whereArgs: [blueDyeResponseId]);
      count += await txn.delete(blueDyeResponseLogTable,
          where: '$blueDyeResponseID = ?', whereArgs: [blueDyeResponseId]);
    });

    return count > 0;
  }

  Future<bool> updateBlueDyeResponse(BlueDyeResponse blueDyeResponse) async {
    final List<BlueDyeResponseLog> logs = blueDyeResponse.logs ?? [];
    int count = 0;
    await _db.transaction((txn) async {
      count += await txn.update(blueDyeResponseTable,
          matchKeys(blueDyeResponse.toJson(), blueDyeResponseSchema.keys),
          where: '$id = ?', whereArgs: [blueDyeResponse.id]);
      await txn.delete(blueDyeResponseLogTable,
          where: '$blueDyeResponseID = ?', whereArgs: [blueDyeResponse.id]);
      for (final log in logs) {
        final logPacket = log.toJson();
        final bool blue = logPacket[isBlue] ?? false;
        logPacket[isBlue] = boolToInt(blue);
        count += await txn.insert(blueDyeResponseLogTable,
            matchKeys(logPacket, blueDyeResponseLogSchema.keys));
      }
    });

    return count > 0;
  }

  Future<List<BlueDyeResponse>> getBlueDyeResponses(String subId,
      {TemporalDateTime? earliest, TemporalDateTime? last}) async {
    final List<BlueDyeResponse> blueDyeResponses = [];
    final String whereBounts = whereFromBounds(earliest: earliest, last: last);
    final List<Map<String, Object?>> responsesBlob = await _db.query(
        blueDyeResponseTable,
        where: whereBounts.isEmpty
            ? '$subUserId = ?'
            : '$whereBounts AND $subUserId = ?',
        whereArgs: whereArgsFromBounds(earliest: earliest, last: last)
          ..add(subId));
    for (final responseBlob in responsesBlob) {
      final BlueDyeResponse res = BlueDyeResponse.fromJson(responseBlob);
      final List<BlueDyeResponseLog> logs = [];
      final List<Map<String, Object?>> logBlobs = await _db.query(
          blueDyeResponseLogTable,
          where: '$blueDyeResponseID = ?',
          whereArgs: [res.id]);
      for (final logBlob in logBlobs) {
        final int blue = logBlob[isBlue] is int ? logBlob[isBlue] as int : 0;
        final BlueDyeResponseLog log =
            BlueDyeResponseLog.fromJson({...logBlob, isBlue: intToBool(blue)});
        final detailBlob = await _db.query(detailTable,
            where: '$id = ?', whereArgs: [log.detailResponseID]);
        DetailResponse? attachedDetail = detailBlob.firstOrNull != null
            ? DetailResponse.fromJson(detailBlob.firstOrNull!)
            : null;
        if (attachedDetail != null) {
          final List<Map<String, Object?>> childResponsesBlob = await _db.query(
              responseTable,
              where: '$detailResponseID = ?',
              whereArgs: [attachedDetail.id]);
          final List<Response> childResponses =
              childResponsesBlob.map((res) => Response.fromJson(res)).toList();
          attachedDetail = attachedDetail.copyWith(responses: childResponses);
        }
        logs.add(log.copyWith(response: attachedDetail));
      }
      blueDyeResponses.add(res.copyWith(logs: logs));
    }
    return blueDyeResponses;
  }

  Map<String, dynamic> testBlob(BlueDyeTest test, String subId) {
    return {...test.toJson(), subUserId: subId};
  }

  Future<bool> setBlueDyeTest(BlueDyeTest? test, String subId) async {
    if (test == null) {
      int count = 0;
      List<Map<String, Object?>> testsBlob = await _db
          .query(blueDyeTestTable, where: '$subUserId = ?', whereArgs: [subId]);
      if (testsBlob.isEmpty) return true;
      final Object? firstTest = testsBlob[0][id];

      final String testId = firstTest is String ? firstTest : "";
      await _db.transaction((txn) async {
        count += await txn.delete(blueDyeTestTable,
            where: '$subUserId = ?', whereArgs: [subId]);
        count += await txn.delete(blueDyeTestLogTable,
            where: '$blueDyeTestID = ?', whereArgs: [testId]);
      });
      return count > 0;
    }
    final List<Map<String, Object?>> results = await _db
        .query(blueDyeTestTable, where: '$subUserId = ?', whereArgs: [subId]);
    if (results.isNotEmpty) {
      if (results[0][id] == test.id) return _updateBlueDyeTest(test, subId);
      await _db.delete(blueDyeTestTable,
          where: '$subUserId = ?', whereArgs: [subId]);
      return setBlueDyeTest(test, subId);
    }
    int count = 0;
    final List<BlueDyeTestLog> logs = test.logs ?? [];
    await _db.transaction((txn) async {
      count += await txn.insert(blueDyeTestTable,
          matchKeys(testBlob(test, subId), blueDyeTestSchema.keys));
      for (final log in logs) {
        final logBlob = log.toJson()..putIfAbsent(blueDyeTestID, () => test.id);
        logBlob[isBlue] = boolToInt(logBlob[isBlue]);
        count += await txn.insert(
            blueDyeTestLogTable, matchKeys(logBlob, blueDyeTestLogSchema.keys));
      }
    });
    return count > 0;
  }

  Future<bool> _updateBlueDyeTest(BlueDyeTest test, String subId) async {
    int count = 0;
    final List<BlueDyeTestLog> logs = test.logs ?? [];
    await _db.transaction((txn) async {
      count += await txn.update(blueDyeTestTable,
          matchKeys(testBlob(test, subId)..remove(id), blueDyeTestSchema.keys));
      await txn.delete(blueDyeTestLogTable,
          where: '$blueDyeTestID = ?', whereArgs: [test.id]);
      for (final log in logs) {
        final logBlob = log.toJson()..putIfAbsent(blueDyeTestID, () => test.id);
        logBlob[isBlue] = boolToInt(logBlob[isBlue]);
        count += await txn.insert(
            blueDyeTestLogTable, matchKeys(logBlob, blueDyeTestLogSchema.keys));
      }
    });
    return count > 0;
  }

  Future<BlueDyeTest?> getBlueDyeTest(SubUser subUser) async {
    final List<Map<String, Object?>> tests = await _db.query(blueDyeTestTable,
        where: '$subUserId = ?', whereArgs: [subUser.id]);
    if (tests.isEmpty) return null;
    final BlueDyeTest test = BlueDyeTest.fromJson(tests[0]);
    final List<Map<String, Object?>> logBlobs = await _db.query(
        blueDyeTestLogTable,
        where: '$blueDyeTestID = ?',
        whereArgs: [test.id]);
    final List<BlueDyeTestLog> logs = [];
    for (final logBlob in logBlobs) {
      final int blue = logBlob[isBlue] is int ? logBlob[isBlue] as int : 0;
      final BlueDyeTestLog log =
          BlueDyeTestLog.fromJson({...logBlob, isBlue: intToBool(blue)});
      final List<Map<String, Object?>> detailBlobs = await _db.query(
          detailTable,
          where: '$id = ?',
          whereArgs: [log.detailResponseID]);
      final DetailResponse? detailResponse = detailBlobs.isNotEmpty
          ? DetailResponse.fromJson(detailBlobs[0])
          : null;
      final List<Map<String, Object?>> responsesBlob = await _db.query(
          responseTable,
          where: '$detailResponseID = ?',
          whereArgs: [detailResponse?.id]);
      final List<Response> responses =
          responsesBlob.map((res) => Response.fromJson(res)).toList();
      logs.add(log.copyWith(
          response: detailResponse?.copyWith(responses: responses)));
    }

    return test.copyWith(logs: logs, subUser: subUser);
  }
}

Map<String, dynamic> matchKeys(
    Map<String, dynamic> toEnter, Iterable<String> schemaKeys) {
  return toEnter..removeWhere((key, value) => !schemaKeys.contains(key));
}

String whereFromBounds({TemporalDateTime? earliest, TemporalDateTime? last}) {
  if (earliest == null && last == null) return '';
  if (earliest == null) return '$stamp <= ?';
  if (last == null) return '$stamp >= ?';
  return '$stamp <= ? AND $stamp >= ?';
}

List<String> whereArgsFromBounds(
    {TemporalDateTime? earliest, TemporalDateTime? last}) {
  return [earliest?.format(), last?.format()].whereType<String>().toList();
}

bool intToBool(int val) => val == 1;

int boolToInt(bool val) => val ? 1 : 0;
