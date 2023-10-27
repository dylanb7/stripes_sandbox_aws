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

// ignore_for_file: public_member_api_docs, annotate_overrides, dead_code, dead_codepublic_member_api_docs, depend_on_referenced_packages, file_names, library_private_types_in_public_api, no_leading_underscores_for_library_prefixes, no_leading_underscores_for_local_identifiers, non_constant_identifier_names, null_check_on_nullable_type_parameter, prefer_adjacent_string_concatenation, prefer_const_constructors, prefer_if_null_operators, prefer_interpolation_to_compose_strings, slash_for_doc_comments, sort_child_properties_last, unnecessary_const, unnecessary_constructor_name, unnecessary_late, unnecessary_new, unnecessary_null_aware_assignments, unnecessary_nullable_for_final_variable_declarations, unnecessary_string_interpolations, use_build_context_synchronously

import 'ModelProvider.dart';
import 'package:amplify_core/amplify_core.dart' as amplify_core;
import 'package:collection/collection.dart';


/** This is an auto generated class representing the BlueDyeResponse type in your schema. */
class BlueDyeResponse extends amplify_core.Model {
  static const classType = const _BlueDyeResponseModelType();
  final String id;
  final amplify_core.TemporalDateTime? _stamp;
  final int? _finishedEating;
  final List<BlueDyeResponseLog>? _logs;
  final String? _subUserId;
  final amplify_core.TemporalDateTime? _createdAt;
  final amplify_core.TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;
  
  @Deprecated('[getId] is being deprecated in favor of custom primary key feature. Use getter [modelIdentifier] to get model identifier.')
  @override
  String getId() => id;
  
  BlueDyeResponseModelIdentifier get modelIdentifier {
      return BlueDyeResponseModelIdentifier(
        id: id
      );
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
  
  int get finishedEating {
    try {
      return _finishedEating!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  List<BlueDyeResponseLog>? get logs {
    return _logs;
  }
  
  String get subUserId {
    try {
      return _subUserId!;
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
  
  const BlueDyeResponse._internal({required this.id, required stamp, required finishedEating, logs, required subUserId, createdAt, updatedAt}): _stamp = stamp, _finishedEating = finishedEating, _logs = logs, _subUserId = subUserId, _createdAt = createdAt, _updatedAt = updatedAt;
  
  factory BlueDyeResponse({String? id, required amplify_core.TemporalDateTime stamp, required int finishedEating, List<BlueDyeResponseLog>? logs, required String subUserId}) {
    return BlueDyeResponse._internal(
      id: id == null ? amplify_core.UUID.getUUID() : id,
      stamp: stamp,
      finishedEating: finishedEating,
      logs: logs != null ? List<BlueDyeResponseLog>.unmodifiable(logs) : logs,
      subUserId: subUserId);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is BlueDyeResponse &&
      id == other.id &&
      _stamp == other._stamp &&
      _finishedEating == other._finishedEating &&
      DeepCollectionEquality().equals(_logs, other._logs) &&
      _subUserId == other._subUserId;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("BlueDyeResponse {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("stamp=" + (_stamp != null ? _stamp!.format() : "null") + ", ");
    buffer.write("finishedEating=" + (_finishedEating != null ? _finishedEating!.toString() : "null") + ", ");
    buffer.write("subUserId=" + "$_subUserId" + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  BlueDyeResponse copyWith({amplify_core.TemporalDateTime? stamp, int? finishedEating, List<BlueDyeResponseLog>? logs, String? subUserId}) {
    return BlueDyeResponse._internal(
      id: id,
      stamp: stamp ?? this.stamp,
      finishedEating: finishedEating ?? this.finishedEating,
      logs: logs ?? this.logs,
      subUserId: subUserId ?? this.subUserId);
  }
  
  BlueDyeResponse copyWithModelFieldValues({
    ModelFieldValue<amplify_core.TemporalDateTime>? stamp,
    ModelFieldValue<int>? finishedEating,
    ModelFieldValue<List<BlueDyeResponseLog>?>? logs,
    ModelFieldValue<String>? subUserId
  }) {
    return BlueDyeResponse._internal(
      id: id,
      stamp: stamp == null ? this.stamp : stamp.value,
      finishedEating: finishedEating == null ? this.finishedEating : finishedEating.value,
      logs: logs == null ? this.logs : logs.value,
      subUserId: subUserId == null ? this.subUserId : subUserId.value
    );
  }
  
  BlueDyeResponse.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _stamp = json['stamp'] != null ? amplify_core.TemporalDateTime.fromString(json['stamp']) : null,
      _finishedEating = (json['finishedEating'] as num?)?.toInt(),
      _logs = json['logs'] is List
        ? (json['logs'] as List)
          .where((e) => e?['serializedData'] != null)
          .map((e) => BlueDyeResponseLog.fromJson(new Map<String, dynamic>.from(e['serializedData'])))
          .toList()
        : null,
      _subUserId = json['subUserId'],
      _createdAt = json['createdAt'] != null ? amplify_core.TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? amplify_core.TemporalDateTime.fromString(json['updatedAt']) : null;
  
  Map<String, dynamic> toJson() => {
    'id': id, 'stamp': _stamp?.format(), 'finishedEating': _finishedEating, 'logs': _logs?.map((BlueDyeResponseLog? e) => e?.toJson()).toList(), 'subUserId': _subUserId, 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format()
  };
  
  Map<String, Object?> toMap() => {
    'id': id,
    'stamp': _stamp,
    'finishedEating': _finishedEating,
    'logs': _logs,
    'subUserId': _subUserId,
    'createdAt': _createdAt,
    'updatedAt': _updatedAt
  };

  static final amplify_core.QueryModelIdentifier<BlueDyeResponseModelIdentifier> MODEL_IDENTIFIER = amplify_core.QueryModelIdentifier<BlueDyeResponseModelIdentifier>();
  static final ID = amplify_core.QueryField(fieldName: "id");
  static final STAMP = amplify_core.QueryField(fieldName: "stamp");
  static final FINISHEDEATING = amplify_core.QueryField(fieldName: "finishedEating");
  static final LOGS = amplify_core.QueryField(
    fieldName: "logs",
    fieldType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.model, ofModelName: 'BlueDyeResponseLog'));
  static final SUBUSERID = amplify_core.QueryField(fieldName: "subUserId");
  static var schema = amplify_core.Model.defineSchema(define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "BlueDyeResponse";
    modelSchemaDefinition.pluralName = "BlueDyeResponses";
    
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
        groups: [ "Admin" ],
        provider: amplify_core.AuthRuleProvider.USERPOOLS,
        operations: const [
          amplify_core.ModelOperation.READ
        ])
    ];
    
    modelSchemaDefinition.indexes = [
      amplify_core.ModelIndex(fields: const ["subUserId", "stamp"], name: "blueResponseBySub")
    ];
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.id());
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: BlueDyeResponse.STAMP,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.dateTime)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: BlueDyeResponse.FINISHEDEATING,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.int)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.hasMany(
      key: BlueDyeResponse.LOGS,
      isRequired: false,
      ofModelName: 'BlueDyeResponseLog',
      associatedKey: BlueDyeResponseLog.BLUEDYERESPONSE
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: BlueDyeResponse.SUBUSERID,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
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

class _BlueDyeResponseModelType extends amplify_core.ModelType<BlueDyeResponse> {
  const _BlueDyeResponseModelType();
  
  @override
  BlueDyeResponse fromJson(Map<String, dynamic> jsonData) {
    return BlueDyeResponse.fromJson(jsonData);
  }
  
  @override
  String modelName() {
    return 'BlueDyeResponse';
  }
}

/**
 * This is an auto generated class representing the model identifier
 * of [BlueDyeResponse] in your schema.
 */
class BlueDyeResponseModelIdentifier implements amplify_core.ModelIdentifier<BlueDyeResponse> {
  final String id;

  /** Create an instance of BlueDyeResponseModelIdentifier using [id] the primary key. */
  const BlueDyeResponseModelIdentifier({
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
  String toString() => 'BlueDyeResponseModelIdentifier(id: $id)';
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    
    return other is BlueDyeResponseModelIdentifier &&
      id == other.id;
  }
  
  @override
  int get hashCode =>
    id.hashCode;
}