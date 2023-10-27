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


/** This is an auto generated class representing the BlueDyeResponseLog type in your schema. */
class BlueDyeResponseLog extends amplify_core.Model {
  static const classType = const _BlueDyeResponseLogModelType();
  final String id;
  final bool? _isBlue;
  final BlueDyeResponse? _blueDyeResponse;
  final String? _detailResponseID;
  final DetailResponse? _response;
  final amplify_core.TemporalDateTime? _createdAt;
  final amplify_core.TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;
  
  @Deprecated('[getId] is being deprecated in favor of custom primary key feature. Use getter [modelIdentifier] to get model identifier.')
  @override
  String getId() => id;
  
  BlueDyeResponseLogModelIdentifier get modelIdentifier {
      return BlueDyeResponseLogModelIdentifier(
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
  
  BlueDyeResponse? get blueDyeResponse {
    return _blueDyeResponse;
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
  
  const BlueDyeResponseLog._internal({required this.id, required isBlue, blueDyeResponse, detailResponseID, response, createdAt, updatedAt}): _isBlue = isBlue, _blueDyeResponse = blueDyeResponse, _detailResponseID = detailResponseID, _response = response, _createdAt = createdAt, _updatedAt = updatedAt;
  
  factory BlueDyeResponseLog({String? id, required bool isBlue, BlueDyeResponse? blueDyeResponse, String? detailResponseID, DetailResponse? response}) {
    return BlueDyeResponseLog._internal(
      id: id == null ? amplify_core.UUID.getUUID() : id,
      isBlue: isBlue,
      blueDyeResponse: blueDyeResponse,
      detailResponseID: detailResponseID,
      response: response);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is BlueDyeResponseLog &&
      id == other.id &&
      _isBlue == other._isBlue &&
      _blueDyeResponse == other._blueDyeResponse &&
      _detailResponseID == other._detailResponseID &&
      _response == other._response;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("BlueDyeResponseLog {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("isBlue=" + (_isBlue != null ? _isBlue!.toString() : "null") + ", ");
    buffer.write("blueDyeResponse=" + (_blueDyeResponse != null ? _blueDyeResponse!.toString() : "null") + ", ");
    buffer.write("detailResponseID=" + "$_detailResponseID" + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  BlueDyeResponseLog copyWith({bool? isBlue, BlueDyeResponse? blueDyeResponse, String? detailResponseID, DetailResponse? response}) {
    return BlueDyeResponseLog._internal(
      id: id,
      isBlue: isBlue ?? this.isBlue,
      blueDyeResponse: blueDyeResponse ?? this.blueDyeResponse,
      detailResponseID: detailResponseID ?? this.detailResponseID,
      response: response ?? this.response);
  }
  
  BlueDyeResponseLog copyWithModelFieldValues({
    ModelFieldValue<bool>? isBlue,
    ModelFieldValue<BlueDyeResponse?>? blueDyeResponse,
    ModelFieldValue<String?>? detailResponseID,
    ModelFieldValue<DetailResponse?>? response
  }) {
    return BlueDyeResponseLog._internal(
      id: id,
      isBlue: isBlue == null ? this.isBlue : isBlue.value,
      blueDyeResponse: blueDyeResponse == null ? this.blueDyeResponse : blueDyeResponse.value,
      detailResponseID: detailResponseID == null ? this.detailResponseID : detailResponseID.value,
      response: response == null ? this.response : response.value
    );
  }
  
  BlueDyeResponseLog.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _isBlue = json['isBlue'],
      _blueDyeResponse = json['blueDyeResponse']?['serializedData'] != null
        ? BlueDyeResponse.fromJson(new Map<String, dynamic>.from(json['blueDyeResponse']['serializedData']))
        : null,
      _detailResponseID = json['detailResponseID'],
      _response = json['response']?['serializedData'] != null
        ? DetailResponse.fromJson(new Map<String, dynamic>.from(json['response']['serializedData']))
        : null,
      _createdAt = json['createdAt'] != null ? amplify_core.TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? amplify_core.TemporalDateTime.fromString(json['updatedAt']) : null;
  
  Map<String, dynamic> toJson() => {
    'id': id, 'isBlue': _isBlue, 'blueDyeResponse': _blueDyeResponse?.toJson(), 'detailResponseID': _detailResponseID, 'response': _response?.toJson(), 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format()
  };
  
  Map<String, Object?> toMap() => {
    'id': id,
    'isBlue': _isBlue,
    'blueDyeResponse': _blueDyeResponse,
    'detailResponseID': _detailResponseID,
    'response': _response,
    'createdAt': _createdAt,
    'updatedAt': _updatedAt
  };

  static final amplify_core.QueryModelIdentifier<BlueDyeResponseLogModelIdentifier> MODEL_IDENTIFIER = amplify_core.QueryModelIdentifier<BlueDyeResponseLogModelIdentifier>();
  static final ID = amplify_core.QueryField(fieldName: "id");
  static final ISBLUE = amplify_core.QueryField(fieldName: "isBlue");
  static final BLUEDYERESPONSE = amplify_core.QueryField(
    fieldName: "blueDyeResponse",
    fieldType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.model, ofModelName: 'BlueDyeResponse'));
  static final DETAILRESPONSEID = amplify_core.QueryField(fieldName: "detailResponseID");
  static final RESPONSE = amplify_core.QueryField(
    fieldName: "response",
    fieldType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.model, ofModelName: 'DetailResponse'));
  static var schema = amplify_core.Model.defineSchema(define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "BlueDyeResponseLog";
    modelSchemaDefinition.pluralName = "BlueDyeResponseLogs";
    
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
      key: BlueDyeResponseLog.ISBLUE,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.bool)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.belongsTo(
      key: BlueDyeResponseLog.BLUEDYERESPONSE,
      isRequired: false,
      targetNames: ['blueDyeResponseID'],
      ofModelName: 'BlueDyeResponse'
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: BlueDyeResponseLog.DETAILRESPONSEID,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.hasOne(
      key: BlueDyeResponseLog.RESPONSE,
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

class _BlueDyeResponseLogModelType extends amplify_core.ModelType<BlueDyeResponseLog> {
  const _BlueDyeResponseLogModelType();
  
  @override
  BlueDyeResponseLog fromJson(Map<String, dynamic> jsonData) {
    return BlueDyeResponseLog.fromJson(jsonData);
  }
  
  @override
  String modelName() {
    return 'BlueDyeResponseLog';
  }
}

/**
 * This is an auto generated class representing the model identifier
 * of [BlueDyeResponseLog] in your schema.
 */
class BlueDyeResponseLogModelIdentifier implements amplify_core.ModelIdentifier<BlueDyeResponseLog> {
  final String id;

  /** Create an instance of BlueDyeResponseLogModelIdentifier using [id] the primary key. */
  const BlueDyeResponseLogModelIdentifier({
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
  String toString() => 'BlueDyeResponseLogModelIdentifier(id: $id)';
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    
    return other is BlueDyeResponseLogModelIdentifier &&
      id == other.id;
  }
  
  @override
  int get hashCode =>
    id.hashCode;
}