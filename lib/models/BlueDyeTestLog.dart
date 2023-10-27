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


/** This is an auto generated class representing the BlueDyeTestLog type in your schema. */
class BlueDyeTestLog extends amplify_core.Model {
  static const classType = const _BlueDyeTestLogModelType();
  final String id;
  final bool? _isBlue;
  final BlueDyeTest? _blueDyeTest;
  final String? _detailResponseID;
  final DetailResponse? _response;
  final amplify_core.TemporalDateTime? _createdAt;
  final amplify_core.TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;
  
  @Deprecated('[getId] is being deprecated in favor of custom primary key feature. Use getter [modelIdentifier] to get model identifier.')
  @override
  String getId() => id;
  
  BlueDyeTestLogModelIdentifier get modelIdentifier {
      return BlueDyeTestLogModelIdentifier(
        id: id
      );
  }
  
  bool get isBlue {
    try {
      return _isBlue!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  BlueDyeTest? get blueDyeTest {
    return _blueDyeTest;
  }
  
  String? get detailResponseID {
    return _detailResponseID;
  }
  
  DetailResponse? get response {
    return _response;
  }
  
  amplify_core.TemporalDateTime? get createdAt {
    return _createdAt;
  }
  
  amplify_core.TemporalDateTime? get updatedAt {
    return _updatedAt;
  }
  
  const BlueDyeTestLog._internal({required this.id, required isBlue, blueDyeTest, detailResponseID, response, createdAt, updatedAt}): _isBlue = isBlue, _blueDyeTest = blueDyeTest, _detailResponseID = detailResponseID, _response = response, _createdAt = createdAt, _updatedAt = updatedAt;
  
  factory BlueDyeTestLog({String? id, required bool isBlue, BlueDyeTest? blueDyeTest, String? detailResponseID, DetailResponse? response}) {
    return BlueDyeTestLog._internal(
      id: id == null ? amplify_core.UUID.getUUID() : id,
      isBlue: isBlue,
      blueDyeTest: blueDyeTest,
      detailResponseID: detailResponseID,
      response: response);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is BlueDyeTestLog &&
      id == other.id &&
      _isBlue == other._isBlue &&
      _blueDyeTest == other._blueDyeTest &&
      _detailResponseID == other._detailResponseID &&
      _response == other._response;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("BlueDyeTestLog {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("isBlue=" + (_isBlue != null ? _isBlue!.toString() : "null") + ", ");
    buffer.write("blueDyeTest=" + (_blueDyeTest != null ? _blueDyeTest!.toString() : "null") + ", ");
    buffer.write("detailResponseID=" + "$_detailResponseID" + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  BlueDyeTestLog copyWith({bool? isBlue, BlueDyeTest? blueDyeTest, String? detailResponseID, DetailResponse? response}) {
    return BlueDyeTestLog._internal(
      id: id,
      isBlue: isBlue ?? this.isBlue,
      blueDyeTest: blueDyeTest ?? this.blueDyeTest,
      detailResponseID: detailResponseID ?? this.detailResponseID,
      response: response ?? this.response);
  }
  
  BlueDyeTestLog copyWithModelFieldValues({
    ModelFieldValue<bool>? isBlue,
    ModelFieldValue<BlueDyeTest?>? blueDyeTest,
    ModelFieldValue<String?>? detailResponseID,
    ModelFieldValue<DetailResponse?>? response
  }) {
    return BlueDyeTestLog._internal(
      id: id,
      isBlue: isBlue == null ? this.isBlue : isBlue.value,
      blueDyeTest: blueDyeTest == null ? this.blueDyeTest : blueDyeTest.value,
      detailResponseID: detailResponseID == null ? this.detailResponseID : detailResponseID.value,
      response: response == null ? this.response : response.value
    );
  }
  
  BlueDyeTestLog.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _isBlue = json['isBlue'],
      _blueDyeTest = json['blueDyeTest']?['serializedData'] != null
        ? BlueDyeTest.fromJson(new Map<String, dynamic>.from(json['blueDyeTest']['serializedData']))
        : null,
      _detailResponseID = json['detailResponseID'],
      _response = json['response']?['serializedData'] != null
        ? DetailResponse.fromJson(new Map<String, dynamic>.from(json['response']['serializedData']))
        : null,
      _createdAt = json['createdAt'] != null ? amplify_core.TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? amplify_core.TemporalDateTime.fromString(json['updatedAt']) : null;
  
  Map<String, dynamic> toJson() => {
    'id': id, 'isBlue': _isBlue, 'blueDyeTest': _blueDyeTest?.toJson(), 'detailResponseID': _detailResponseID, 'response': _response?.toJson(), 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format()
  };
  
  Map<String, Object?> toMap() => {
    'id': id,
    'isBlue': _isBlue,
    'blueDyeTest': _blueDyeTest,
    'detailResponseID': _detailResponseID,
    'response': _response,
    'createdAt': _createdAt,
    'updatedAt': _updatedAt
  };

  static final amplify_core.QueryModelIdentifier<BlueDyeTestLogModelIdentifier> MODEL_IDENTIFIER = amplify_core.QueryModelIdentifier<BlueDyeTestLogModelIdentifier>();
  static final ID = amplify_core.QueryField(fieldName: "id");
  static final ISBLUE = amplify_core.QueryField(fieldName: "isBlue");
  static final BLUEDYETEST = amplify_core.QueryField(
    fieldName: "blueDyeTest",
    fieldType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.model, ofModelName: 'BlueDyeTest'));
  static final DETAILRESPONSEID = amplify_core.QueryField(fieldName: "detailResponseID");
  static final RESPONSE = amplify_core.QueryField(
    fieldName: "response",
    fieldType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.model, ofModelName: 'DetailResponse'));
  static var schema = amplify_core.Model.defineSchema(define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "BlueDyeTestLog";
    modelSchemaDefinition.pluralName = "BlueDyeTestLogs";
    
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
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.id());
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: BlueDyeTestLog.ISBLUE,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.bool)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.belongsTo(
      key: BlueDyeTestLog.BLUEDYETEST,
      isRequired: false,
      targetNames: ['blueDyeTestID'],
      ofModelName: 'BlueDyeTest'
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: BlueDyeTestLog.DETAILRESPONSEID,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.hasOne(
      key: BlueDyeTestLog.RESPONSE,
      isRequired: false,
      ofModelName: 'DetailResponse',
      associatedKey: DetailResponse.ID
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

class _BlueDyeTestLogModelType extends amplify_core.ModelType<BlueDyeTestLog> {
  const _BlueDyeTestLogModelType();
  
  @override
  BlueDyeTestLog fromJson(Map<String, dynamic> jsonData) {
    return BlueDyeTestLog.fromJson(jsonData);
  }
  
  @override
  String modelName() {
    return 'BlueDyeTestLog';
  }
}

/**
 * This is an auto generated class representing the model identifier
 * of [BlueDyeTestLog] in your schema.
 */
class BlueDyeTestLogModelIdentifier implements amplify_core.ModelIdentifier<BlueDyeTestLog> {
  final String id;

  /** Create an instance of BlueDyeTestLogModelIdentifier using [id] the primary key. */
  const BlueDyeTestLogModelIdentifier({
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
  String toString() => 'BlueDyeTestLogModelIdentifier(id: $id)';
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    
    return other is BlueDyeTestLogModelIdentifier &&
      id == other.id;
  }
  
  @override
  int get hashCode =>
    id.hashCode;
}