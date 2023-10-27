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


/** This is an auto generated class representing the Response type in your schema. */
class Response extends amplify_core.Model {
  static const classType = const _ResponseModelType();
  final String id;
  final amplify_core.TemporalDateTime? _stamp;
  final String? _type;
  final String? _qid;
  final String? _textResponse;
  final int? _selected;
  final int? _numeric;
  final List<int>? _all_selected;
  final String? _subUserId;
  final DetailResponse? _detailResponse;
  final amplify_core.TemporalDateTime? _createdAt;
  final amplify_core.TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;
  
  @Deprecated('[getId] is being deprecated in favor of custom primary key feature. Use getter [modelIdentifier] to get model identifier.')
  @override
  String getId() => id;
  
  ResponseModelIdentifier get modelIdentifier {
      return ResponseModelIdentifier(
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
  
  String get type {
    try {
      return _type!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  String get qid {
    try {
      return _qid!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  String? get textResponse {
    return _textResponse;
  }
  
  int? get selected {
    return _selected;
  }
  
  int? get numeric {
    return _numeric;
  }
  
  List<int>? get all_selected {
    return _all_selected;
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
  
  DetailResponse? get detailResponse {
    return _detailResponse;
  }
  
  amplify_core.TemporalDateTime? get createdAt {
    return _createdAt;
  }
  
  amplify_core.TemporalDateTime? get updatedAt {
    return _updatedAt;
  }
  
  const Response._internal({required this.id, required stamp, required type, required qid, textResponse, selected, numeric, all_selected, required subUserId, detailResponse, createdAt, updatedAt}): _stamp = stamp, _type = type, _qid = qid, _textResponse = textResponse, _selected = selected, _numeric = numeric, _all_selected = all_selected, _subUserId = subUserId, _detailResponse = detailResponse, _createdAt = createdAt, _updatedAt = updatedAt;
  
  factory Response({String? id, required amplify_core.TemporalDateTime stamp, required String type, required String qid, String? textResponse, int? selected, int? numeric, List<int>? all_selected, required String subUserId, DetailResponse? detailResponse}) {
    return Response._internal(
      id: id == null ? amplify_core.UUID.getUUID() : id,
      stamp: stamp,
      type: type,
      qid: qid,
      textResponse: textResponse,
      selected: selected,
      numeric: numeric,
      all_selected: all_selected != null ? List<int>.unmodifiable(all_selected) : all_selected,
      subUserId: subUserId,
      detailResponse: detailResponse);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Response &&
      id == other.id &&
      _stamp == other._stamp &&
      _type == other._type &&
      _qid == other._qid &&
      _textResponse == other._textResponse &&
      _selected == other._selected &&
      _numeric == other._numeric &&
      DeepCollectionEquality().equals(_all_selected, other._all_selected) &&
      _subUserId == other._subUserId &&
      _detailResponse == other._detailResponse;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("Response {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("stamp=" + (_stamp != null ? _stamp!.format() : "null") + ", ");
    buffer.write("type=" + "$_type" + ", ");
    buffer.write("qid=" + "$_qid" + ", ");
    buffer.write("textResponse=" + "$_textResponse" + ", ");
    buffer.write("selected=" + (_selected != null ? _selected!.toString() : "null") + ", ");
    buffer.write("numeric=" + (_numeric != null ? _numeric!.toString() : "null") + ", ");
    buffer.write("all_selected=" + (_all_selected != null ? _all_selected!.toString() : "null") + ", ");
    buffer.write("subUserId=" + "$_subUserId" + ", ");
    buffer.write("detailResponse=" + (_detailResponse != null ? _detailResponse!.toString() : "null") + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  Response copyWith({amplify_core.TemporalDateTime? stamp, String? type, String? qid, String? textResponse, int? selected, int? numeric, List<int>? all_selected, String? subUserId, DetailResponse? detailResponse}) {
    return Response._internal(
      id: id,
      stamp: stamp ?? this.stamp,
      type: type ?? this.type,
      qid: qid ?? this.qid,
      textResponse: textResponse ?? this.textResponse,
      selected: selected ?? this.selected,
      numeric: numeric ?? this.numeric,
      all_selected: all_selected ?? this.all_selected,
      subUserId: subUserId ?? this.subUserId,
      detailResponse: detailResponse ?? this.detailResponse);
  }
  
  Response copyWithModelFieldValues({
    ModelFieldValue<amplify_core.TemporalDateTime>? stamp,
    ModelFieldValue<String>? type,
    ModelFieldValue<String>? qid,
    ModelFieldValue<String?>? textResponse,
    ModelFieldValue<int?>? selected,
    ModelFieldValue<int?>? numeric,
    ModelFieldValue<List<int>>? all_selected,
    ModelFieldValue<String>? subUserId,
    ModelFieldValue<DetailResponse?>? detailResponse
  }) {
    return Response._internal(
      id: id,
      stamp: stamp == null ? this.stamp : stamp.value,
      type: type == null ? this.type : type.value,
      qid: qid == null ? this.qid : qid.value,
      textResponse: textResponse == null ? this.textResponse : textResponse.value,
      selected: selected == null ? this.selected : selected.value,
      numeric: numeric == null ? this.numeric : numeric.value,
      all_selected: all_selected == null ? this.all_selected : all_selected.value,
      subUserId: subUserId == null ? this.subUserId : subUserId.value,
      detailResponse: detailResponse == null ? this.detailResponse : detailResponse.value
    );
  }
  
  Response.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _stamp = json['stamp'] != null ? amplify_core.TemporalDateTime.fromString(json['stamp']) : null,
      _type = json['type'],
      _qid = json['qid'],
      _textResponse = json['textResponse'],
      _selected = (json['selected'] as num?)?.toInt(),
      _numeric = (json['numeric'] as num?)?.toInt(),
      _all_selected = (json['all_selected'] as List?)?.map((e) => (e as num).toInt()).toList(),
      _subUserId = json['subUserId'],
      _detailResponse = json['detailResponse']?['serializedData'] != null
        ? DetailResponse.fromJson(new Map<String, dynamic>.from(json['detailResponse']['serializedData']))
        : null,
      _createdAt = json['createdAt'] != null ? amplify_core.TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? amplify_core.TemporalDateTime.fromString(json['updatedAt']) : null;
  
  Map<String, dynamic> toJson() => {
    'id': id, 'stamp': _stamp?.format(), 'type': _type, 'qid': _qid, 'textResponse': _textResponse, 'selected': _selected, 'numeric': _numeric, 'all_selected': _all_selected, 'subUserId': _subUserId, 'detailResponse': _detailResponse?.toJson(), 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format()
  };
  
  Map<String, Object?> toMap() => {
    'id': id,
    'stamp': _stamp,
    'type': _type,
    'qid': _qid,
    'textResponse': _textResponse,
    'selected': _selected,
    'numeric': _numeric,
    'all_selected': _all_selected,
    'subUserId': _subUserId,
    'detailResponse': _detailResponse,
    'createdAt': _createdAt,
    'updatedAt': _updatedAt
  };

  static final amplify_core.QueryModelIdentifier<ResponseModelIdentifier> MODEL_IDENTIFIER = amplify_core.QueryModelIdentifier<ResponseModelIdentifier>();
  static final ID = amplify_core.QueryField(fieldName: "id");
  static final STAMP = amplify_core.QueryField(fieldName: "stamp");
  static final TYPE = amplify_core.QueryField(fieldName: "type");
  static final QID = amplify_core.QueryField(fieldName: "qid");
  static final TEXTRESPONSE = amplify_core.QueryField(fieldName: "textResponse");
  static final SELECTED = amplify_core.QueryField(fieldName: "selected");
  static final NUMERIC = amplify_core.QueryField(fieldName: "numeric");
  static final ALL_SELECTED = amplify_core.QueryField(fieldName: "all_selected");
  static final SUBUSERID = amplify_core.QueryField(fieldName: "subUserId");
  static final DETAILRESPONSE = amplify_core.QueryField(
    fieldName: "detailResponse",
    fieldType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.model, ofModelName: 'DetailResponse'));
  static var schema = amplify_core.Model.defineSchema(define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "Response";
    modelSchemaDefinition.pluralName = "Responses";
    
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
      amplify_core.ModelIndex(fields: const ["subUserId", "stamp"], name: "responsesBySub")
    ];
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.id());
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Response.STAMP,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.dateTime)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Response.TYPE,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Response.QID,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Response.TEXTRESPONSE,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Response.SELECTED,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.int)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Response.NUMERIC,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.int)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Response.ALL_SELECTED,
      isRequired: false,
      isArray: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.collection, ofModelName: amplify_core.ModelFieldTypeEnum.int.name)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Response.SUBUSERID,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.belongsTo(
      key: Response.DETAILRESPONSE,
      isRequired: false,
      targetNames: ['detailResponseID'],
      ofModelName: 'DetailResponse'
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

class _ResponseModelType extends amplify_core.ModelType<Response> {
  const _ResponseModelType();
  
  @override
  Response fromJson(Map<String, dynamic> jsonData) {
    return Response.fromJson(jsonData);
  }
  
  @override
  String modelName() {
    return 'Response';
  }
}

/**
 * This is an auto generated class representing the model identifier
 * of [Response] in your schema.
 */
class ResponseModelIdentifier implements amplify_core.ModelIdentifier<Response> {
  final String id;

  /** Create an instance of ResponseModelIdentifier using [id] the primary key. */
  const ResponseModelIdentifier({
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
  String toString() => 'ResponseModelIdentifier(id: $id)';
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    
    return other is ResponseModelIdentifier &&
      id == other.id;
  }
  
  @override
  int get hashCode =>
    id.hashCode;
}