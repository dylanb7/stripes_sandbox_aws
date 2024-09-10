/*
* Copyright 2021 Amazon.com, Inc. or its affiliates. All Rights Reserved.
*
* Licensed under the Apache License, Version 2.0 (the "License").
* You may not use this file except in compliance with the License.
* A copy of the License is located at
*
*  http://aws.amazon.com/apache2.0
*
* or in the "license" file accompanying this file. This file is distributed
* on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either
* express or implied. See the License for the specific language governing
* permissions and limitations under the License.
*/

// NOTE: This file is generated and may not follow lint rules defined in your app
// Generated files can be excluded from analysis in analysis_options.yaml
// For more info, see: https://dart.dev/guides/language/analysis-options#excluding-code-from-analysis

// ignore_for_file: public_member_api_docs, annotate_overrides, dead_code, dead_codepublic_member_api_docs, depend_on_referenced_packages, file_names, library_private_types_in_public_api, no_leading_underscores_for_library_prefixes, no_leading_underscores_for_local_identifiers, non_constant_identifier_names, null_check_on_nullable_type_parameter, override_on_non_overriding_member, prefer_adjacent_string_concatenation, prefer_const_constructors, prefer_if_null_operators, prefer_interpolation_to_compose_strings, slash_for_doc_comments, sort_child_properties_last, unnecessary_const, unnecessary_constructor_name, unnecessary_late, unnecessary_new, unnecessary_null_aware_assignments, unnecessary_nullable_for_final_variable_declarations, unnecessary_string_interpolations, use_build_context_synchronously

import 'ModelProvider.dart';
import 'package:amplify_core/amplify_core.dart' as amplify_core;
import 'package:collection/collection.dart';


/** This is an auto generated class representing the BlueDyeTest type in your schema. */
class BlueDyeTest extends amplify_core.Model {
  static const classType = const _BlueDyeTestModelType();
  final String id;
  final String? _group;
  final amplify_core.TemporalDateTime? _stamp;
  final String? _amountConsumed;
  final int? _finishedEating;
  final amplify_core.TemporalDateTime? _pauseTime;
  final amplify_core.TemporalDateTime? _startTime;
  final amplify_core.TemporalDateTime? _finishedEatingDate;
  final List<BlueDyeTestLog>? _logs;
  final SubUser? _subUser;
  final amplify_core.TemporalDateTime? _createdAt;
  final amplify_core.TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;
  
  @Deprecated('[getId] is being deprecated in favor of custom primary key feature. Use getter [modelIdentifier] to get model identifier.')
  @override
  String getId() => id;
  
  BlueDyeTestModelIdentifier get modelIdentifier {
      return BlueDyeTestModelIdentifier(
        id: id
      );
  }
  
  String? get group {
    return _group;
  }
  
  amplify_core.TemporalDateTime get stamp {
    try {
      return _stamp!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  String? get amountConsumed {
    return _amountConsumed;
  }
  
  int? get finishedEating {
    return _finishedEating;
  }
  
  amplify_core.TemporalDateTime? get pauseTime {
    return _pauseTime;
  }
  
  amplify_core.TemporalDateTime? get startTime {
    return _startTime;
  }
  
  amplify_core.TemporalDateTime? get finishedEatingDate {
    return _finishedEatingDate;
  }
  
  List<BlueDyeTestLog>? get logs {
    return _logs;
  }
  
  SubUser get subUser {
    try {
      return _subUser!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  amplify_core.TemporalDateTime? get createdAt {
    return _createdAt;
  }
  
  amplify_core.TemporalDateTime? get updatedAt {
    return _updatedAt;
  }
  
  const BlueDyeTest._internal({required this.id, group, required stamp, amountConsumed, finishedEating, pauseTime, startTime, finishedEatingDate, logs, required subUser, createdAt, updatedAt}): _group = group, _stamp = stamp, _amountConsumed = amountConsumed, _finishedEating = finishedEating, _pauseTime = pauseTime, _startTime = startTime, _finishedEatingDate = finishedEatingDate, _logs = logs, _subUser = subUser, _createdAt = createdAt, _updatedAt = updatedAt;
  
  factory BlueDyeTest({String? id, String? group, required amplify_core.TemporalDateTime stamp, String? amountConsumed, int? finishedEating, amplify_core.TemporalDateTime? pauseTime, amplify_core.TemporalDateTime? startTime, amplify_core.TemporalDateTime? finishedEatingDate, List<BlueDyeTestLog>? logs, required SubUser subUser}) {
    return BlueDyeTest._internal(
      id: id == null ? amplify_core.UUID.getUUID() : id,
      group: group,
      stamp: stamp,
      amountConsumed: amountConsumed,
      finishedEating: finishedEating,
      pauseTime: pauseTime,
      startTime: startTime,
      finishedEatingDate: finishedEatingDate,
      logs: logs != null ? List<BlueDyeTestLog>.unmodifiable(logs) : logs,
      subUser: subUser);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is BlueDyeTest &&
      id == other.id &&
      _group == other._group &&
      _stamp == other._stamp &&
      _amountConsumed == other._amountConsumed &&
      _finishedEating == other._finishedEating &&
      _pauseTime == other._pauseTime &&
      _startTime == other._startTime &&
      _finishedEatingDate == other._finishedEatingDate &&
      DeepCollectionEquality().equals(_logs, other._logs) &&
      _subUser == other._subUser;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("BlueDyeTest {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("group=" + "$_group" + ", ");
    buffer.write("stamp=" + (_stamp != null ? _stamp!.format() : "null") + ", ");
    buffer.write("amountConsumed=" + "$_amountConsumed" + ", ");
    buffer.write("finishedEating=" + (_finishedEating != null ? _finishedEating!.toString() : "null") + ", ");
    buffer.write("pauseTime=" + (_pauseTime != null ? _pauseTime!.format() : "null") + ", ");
    buffer.write("startTime=" + (_startTime != null ? _startTime!.format() : "null") + ", ");
    buffer.write("finishedEatingDate=" + (_finishedEatingDate != null ? _finishedEatingDate!.format() : "null") + ", ");
    buffer.write("subUser=" + (_subUser != null ? _subUser!.toString() : "null") + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  BlueDyeTest copyWith({String? group, amplify_core.TemporalDateTime? stamp, String? amountConsumed, int? finishedEating, amplify_core.TemporalDateTime? pauseTime, amplify_core.TemporalDateTime? startTime, amplify_core.TemporalDateTime? finishedEatingDate, List<BlueDyeTestLog>? logs, SubUser? subUser}) {
    return BlueDyeTest._internal(
      id: id,
      group: group ?? this.group,
      stamp: stamp ?? this.stamp,
      amountConsumed: amountConsumed ?? this.amountConsumed,
      finishedEating: finishedEating ?? this.finishedEating,
      pauseTime: pauseTime ?? this.pauseTime,
      startTime: startTime ?? this.startTime,
      finishedEatingDate: finishedEatingDate ?? this.finishedEatingDate,
      logs: logs ?? this.logs,
      subUser: subUser ?? this.subUser);
  }
  
  BlueDyeTest copyWithModelFieldValues({
    ModelFieldValue<String?>? group,
    ModelFieldValue<amplify_core.TemporalDateTime>? stamp,
    ModelFieldValue<String?>? amountConsumed,
    ModelFieldValue<int?>? finishedEating,
    ModelFieldValue<amplify_core.TemporalDateTime?>? pauseTime,
    ModelFieldValue<amplify_core.TemporalDateTime?>? startTime,
    ModelFieldValue<amplify_core.TemporalDateTime?>? finishedEatingDate,
    ModelFieldValue<List<BlueDyeTestLog>?>? logs,
    ModelFieldValue<SubUser>? subUser
  }) {
    return BlueDyeTest._internal(
      id: id,
      group: group == null ? this.group : group.value,
      stamp: stamp == null ? this.stamp : stamp.value,
      amountConsumed: amountConsumed == null ? this.amountConsumed : amountConsumed.value,
      finishedEating: finishedEating == null ? this.finishedEating : finishedEating.value,
      pauseTime: pauseTime == null ? this.pauseTime : pauseTime.value,
      startTime: startTime == null ? this.startTime : startTime.value,
      finishedEatingDate: finishedEatingDate == null ? this.finishedEatingDate : finishedEatingDate.value,
      logs: logs == null ? this.logs : logs.value,
      subUser: subUser == null ? this.subUser : subUser.value
    );
  }
  
  BlueDyeTest.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _group = json['group'],
      _stamp = json['stamp'] != null ? amplify_core.TemporalDateTime.fromString(json['stamp']) : null,
      _amountConsumed = json['amountConsumed'],
      _finishedEating = (json['finishedEating'] as num?)?.toInt(),
      _pauseTime = json['pauseTime'] != null ? amplify_core.TemporalDateTime.fromString(json['pauseTime']) : null,
      _startTime = json['startTime'] != null ? amplify_core.TemporalDateTime.fromString(json['startTime']) : null,
      _finishedEatingDate = json['finishedEatingDate'] != null ? amplify_core.TemporalDateTime.fromString(json['finishedEatingDate']) : null,
      _logs = json['logs']  is Map
        ? (json['logs']['items'] is List
          ? (json['logs']['items'] as List)
              .where((e) => e != null)
              .map((e) => BlueDyeTestLog.fromJson(new Map<String, dynamic>.from(e)))
              .toList()
          : null)
        : (json['logs'] is List
          ? (json['logs'] as List)
              .where((e) => e?['serializedData'] != null)
              .map((e) => BlueDyeTestLog.fromJson(new Map<String, dynamic>.from(e?['serializedData'])))
              .toList()
          : null),
      _subUser = json['subUser'] != null
        ? json['subUser']['serializedData'] != null
          ? SubUser.fromJson(new Map<String, dynamic>.from(json['subUser']['serializedData']))
          : SubUser.fromJson(new Map<String, dynamic>.from(json['subUser']))
        : null,
      _createdAt = json['createdAt'] != null ? amplify_core.TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? amplify_core.TemporalDateTime.fromString(json['updatedAt']) : null;
  
  Map<String, dynamic> toJson() => {
    'id': id, 'group': _group, 'stamp': _stamp?.format(), 'amountConsumed': _amountConsumed, 'finishedEating': _finishedEating, 'pauseTime': _pauseTime?.format(), 'startTime': _startTime?.format(), 'finishedEatingDate': _finishedEatingDate?.format(), 'logs': _logs?.map((BlueDyeTestLog? e) => e?.toJson()).toList(), 'subUser': _subUser?.toJson(), 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format()
  };
  
  Map<String, Object?> toMap() => {
    'id': id,
    'group': _group,
    'stamp': _stamp,
    'amountConsumed': _amountConsumed,
    'finishedEating': _finishedEating,
    'pauseTime': _pauseTime,
    'startTime': _startTime,
    'finishedEatingDate': _finishedEatingDate,
    'logs': _logs,
    'subUser': _subUser,
    'createdAt': _createdAt,
    'updatedAt': _updatedAt
  };

  static final amplify_core.QueryModelIdentifier<BlueDyeTestModelIdentifier> MODEL_IDENTIFIER = amplify_core.QueryModelIdentifier<BlueDyeTestModelIdentifier>();
  static final ID = amplify_core.QueryField(fieldName: "id");
  static final GROUP = amplify_core.QueryField(fieldName: "group");
  static final STAMP = amplify_core.QueryField(fieldName: "stamp");
  static final AMOUNTCONSUMED = amplify_core.QueryField(fieldName: "amountConsumed");
  static final FINISHEDEATING = amplify_core.QueryField(fieldName: "finishedEating");
  static final PAUSETIME = amplify_core.QueryField(fieldName: "pauseTime");
  static final STARTTIME = amplify_core.QueryField(fieldName: "startTime");
  static final FINISHEDEATINGDATE = amplify_core.QueryField(fieldName: "finishedEatingDate");
  static final LOGS = amplify_core.QueryField(
    fieldName: "logs",
    fieldType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.model, ofModelName: 'BlueDyeTestLog'));
  static final SUBUSER = amplify_core.QueryField(
    fieldName: "subUser",
    fieldType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.model, ofModelName: 'SubUser'));
  static var schema = amplify_core.Model.defineSchema(define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "BlueDyeTest";
    modelSchemaDefinition.pluralName = "BlueDyeTests";
    
    modelSchemaDefinition.authRules = [
      amplify_core.AuthRule(
        authStrategy: amplify_core.AuthStrategy.OWNER,
        ownerField: "owner",
        identityClaim: "cognito:username",
        provider: amplify_core.AuthRuleProvider.USERPOOLS,
        operations: const [
          amplify_core.ModelOperation.CREATE,
          amplify_core.ModelOperation.UPDATE,
          amplify_core.ModelOperation.DELETE,
          amplify_core.ModelOperation.READ
        ]),
      amplify_core.AuthRule(
        authStrategy: amplify_core.AuthStrategy.GROUPS,
        groupClaim: "cognito:groups",
        groupsField: "groups",
        provider: amplify_core.AuthRuleProvider.USERPOOLS,
        operations: const [
          amplify_core.ModelOperation.READ
        ])
    ];
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.id());
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: BlueDyeTest.GROUP,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: BlueDyeTest.STAMP,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.dateTime)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: BlueDyeTest.AMOUNTCONSUMED,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: BlueDyeTest.FINISHEDEATING,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.int)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: BlueDyeTest.PAUSETIME,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.dateTime)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: BlueDyeTest.STARTTIME,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.dateTime)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: BlueDyeTest.FINISHEDEATINGDATE,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.dateTime)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.hasMany(
      key: BlueDyeTest.LOGS,
      isRequired: false,
      ofModelName: 'BlueDyeTestLog',
      associatedKey: BlueDyeTestLog.BLUEDYETEST
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.belongsTo(
      key: BlueDyeTest.SUBUSER,
      isRequired: true,
      targetNames: ['subUserId'],
      ofModelName: 'SubUser'
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.nonQueryField(
      fieldName: 'createdAt',
      isRequired: false,
      isReadOnly: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.dateTime)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.nonQueryField(
      fieldName: 'updatedAt',
      isRequired: false,
      isReadOnly: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.dateTime)
    ));
  });
}

class _BlueDyeTestModelType extends amplify_core.ModelType<BlueDyeTest> {
  const _BlueDyeTestModelType();
  
  @override
  BlueDyeTest fromJson(Map<String, dynamic> jsonData) {
    return BlueDyeTest.fromJson(jsonData);
  }
  
  @override
  String modelName() {
    return 'BlueDyeTest';
  }
}

/**
 * This is an auto generated class representing the model identifier
 * of [BlueDyeTest] in your schema.
 */
class BlueDyeTestModelIdentifier implements amplify_core.ModelIdentifier<BlueDyeTest> {
  final String id;

  /** Create an instance of BlueDyeTestModelIdentifier using [id] the primary key. */
  const BlueDyeTestModelIdentifier({
    required this.id});
  
  @override
  Map<String, dynamic> serializeAsMap() => (<String, dynamic>{
    'id': id
  });
  
  @override
  List<Map<String, dynamic>> serializeAsList() => serializeAsMap()
    .entries
    .map((entry) => (<String, dynamic>{ entry.key: entry.value }))
    .toList();
  
  @override
  String serializeAsString() => serializeAsMap().values.join('#');
  
  @override
  String toString() => 'BlueDyeTestModelIdentifier(id: $id)';
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    
    return other is BlueDyeTestModelIdentifier &&
      id == other.id;
  }
  
  @override
  int get hashCode =>
    id.hashCode;
}