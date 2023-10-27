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


/** This is an auto generated class representing the SubUser type in your schema. */
class SubUser extends amplify_core.Model {
  static const classType = const _SubUserModelType();
  final String id;
  final String? _name;
  final String? _gender;
  final int? _birthYear;
  final bool? _isControl;
  final String? _blueDyeTestID;
  final BlueDyeTest? _blueDyeTest;
  final List<Response>? _responses;
  final List<DetailResponse>? _detailResponses;
  final List<BlueDyeResponse>? _blueDyeResponses;
  final amplify_core.TemporalDateTime? _createdAt;
  final amplify_core.TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;
  
  @Deprecated('[getId] is being deprecated in favor of custom primary key feature. Use getter [modelIdentifier] to get model identifier.')
  @override
  String getId() => id;
  
  SubUserModelIdentifier get modelIdentifier {
      return SubUserModelIdentifier(
        id: id
      );
  }
  
  String get name {
    try {
      return _name!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  String get gender {
    try {
      return _gender!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  int get birthYear {
    try {
      return _birthYear!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  bool get isControl {
    try {
      return _isControl!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  String? get blueDyeTestID {
    return _blueDyeTestID;
  }
  
  BlueDyeTest? get blueDyeTest {
    return _blueDyeTest;
  }
  
  List<Response>? get responses {
    return _responses;
  }
  
  List<DetailResponse>? get detailResponses {
    return _detailResponses;
  }
  
  List<BlueDyeResponse>? get blueDyeResponses {
    return _blueDyeResponses;
  }
  
  amplify_core.TemporalDateTime? get createdAt {
    return _createdAt;
  }
  
  amplify_core.TemporalDateTime? get updatedAt {
    return _updatedAt;
  }
  
  const SubUser._internal({required this.id, required name, required gender, required birthYear, required isControl, blueDyeTestID, blueDyeTest, responses, detailResponses, blueDyeResponses, createdAt, updatedAt}): _name = name, _gender = gender, _birthYear = birthYear, _isControl = isControl, _blueDyeTestID = blueDyeTestID, _blueDyeTest = blueDyeTest, _responses = responses, _detailResponses = detailResponses, _blueDyeResponses = blueDyeResponses, _createdAt = createdAt, _updatedAt = updatedAt;
  
  factory SubUser({String? id, required String name, required String gender, required int birthYear, required bool isControl, String? blueDyeTestID, BlueDyeTest? blueDyeTest, List<Response>? responses, List<DetailResponse>? detailResponses, List<BlueDyeResponse>? blueDyeResponses}) {
    return SubUser._internal(
      id: id == null ? amplify_core.UUID.getUUID() : id,
      name: name,
      gender: gender,
      birthYear: birthYear,
      isControl: isControl,
      blueDyeTestID: blueDyeTestID,
      blueDyeTest: blueDyeTest,
      responses: responses != null ? List<Response>.unmodifiable(responses) : responses,
      detailResponses: detailResponses != null ? List<DetailResponse>.unmodifiable(detailResponses) : detailResponses,
      blueDyeResponses: blueDyeResponses != null ? List<BlueDyeResponse>.unmodifiable(blueDyeResponses) : blueDyeResponses);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SubUser &&
      id == other.id &&
      _name == other._name &&
      _gender == other._gender &&
      _birthYear == other._birthYear &&
      _isControl == other._isControl &&
      _blueDyeTestID == other._blueDyeTestID &&
      _blueDyeTest == other._blueDyeTest &&
      DeepCollectionEquality().equals(_responses, other._responses) &&
      DeepCollectionEquality().equals(_detailResponses, other._detailResponses) &&
      DeepCollectionEquality().equals(_blueDyeResponses, other._blueDyeResponses);
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("SubUser {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("name=" + "$_name" + ", ");
    buffer.write("gender=" + "$_gender" + ", ");
    buffer.write("birthYear=" + (_birthYear != null ? _birthYear!.toString() : "null") + ", ");
    buffer.write("isControl=" + (_isControl != null ? _isControl!.toString() : "null") + ", ");
    buffer.write("blueDyeTestID=" + "$_blueDyeTestID" + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  SubUser copyWith({String? name, String? gender, int? birthYear, bool? isControl, String? blueDyeTestID, BlueDyeTest? blueDyeTest, List<Response>? responses, List<DetailResponse>? detailResponses, List<BlueDyeResponse>? blueDyeResponses}) {
    return SubUser._internal(
      id: id,
      name: name ?? this.name,
      gender: gender ?? this.gender,
      birthYear: birthYear ?? this.birthYear,
      isControl: isControl ?? this.isControl,
      blueDyeTestID: blueDyeTestID ?? this.blueDyeTestID,
      blueDyeTest: blueDyeTest ?? this.blueDyeTest,
      responses: responses ?? this.responses,
      detailResponses: detailResponses ?? this.detailResponses,
      blueDyeResponses: blueDyeResponses ?? this.blueDyeResponses);
  }
  
  SubUser copyWithModelFieldValues({
    ModelFieldValue<String>? name,
    ModelFieldValue<String>? gender,
    ModelFieldValue<int>? birthYear,
    ModelFieldValue<bool>? isControl,
    ModelFieldValue<String?>? blueDyeTestID,
    ModelFieldValue<BlueDyeTest?>? blueDyeTest,
    ModelFieldValue<List<Response>?>? responses,
    ModelFieldValue<List<DetailResponse>?>? detailResponses,
    ModelFieldValue<List<BlueDyeResponse>?>? blueDyeResponses
  }) {
    return SubUser._internal(
      id: id,
      name: name == null ? this.name : name.value,
      gender: gender == null ? this.gender : gender.value,
      birthYear: birthYear == null ? this.birthYear : birthYear.value,
      isControl: isControl == null ? this.isControl : isControl.value,
      blueDyeTestID: blueDyeTestID == null ? this.blueDyeTestID : blueDyeTestID.value,
      blueDyeTest: blueDyeTest == null ? this.blueDyeTest : blueDyeTest.value,
      responses: responses == null ? this.responses : responses.value,
      detailResponses: detailResponses == null ? this.detailResponses : detailResponses.value,
      blueDyeResponses: blueDyeResponses == null ? this.blueDyeResponses : blueDyeResponses.value
    );
  }
  
  SubUser.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _name = json['name'],
      _gender = json['gender'],
      _birthYear = (json['birthYear'] as num?)?.toInt(),
      _isControl = json['isControl'],
      _blueDyeTestID = json['blueDyeTestID'],
      _blueDyeTest = json['blueDyeTest']?['serializedData'] != null
        ? BlueDyeTest.fromJson(new Map<String, dynamic>.from(json['blueDyeTest']['serializedData']))
        : null,
      _responses = json['responses'] is List
        ? (json['responses'] as List)
          .where((e) => e?['serializedData'] != null)
          .map((e) => Response.fromJson(new Map<String, dynamic>.from(e['serializedData'])))
          .toList()
        : null,
      _detailResponses = json['detailResponses'] is List
        ? (json['detailResponses'] as List)
          .where((e) => e?['serializedData'] != null)
          .map((e) => DetailResponse.fromJson(new Map<String, dynamic>.from(e['serializedData'])))
          .toList()
        : null,
      _blueDyeResponses = json['blueDyeResponses'] is List
        ? (json['blueDyeResponses'] as List)
          .where((e) => e?['serializedData'] != null)
          .map((e) => BlueDyeResponse.fromJson(new Map<String, dynamic>.from(e['serializedData'])))
          .toList()
        : null,
      _createdAt = json['createdAt'] != null ? amplify_core.TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? amplify_core.TemporalDateTime.fromString(json['updatedAt']) : null;
  
  Map<String, dynamic> toJson() => {
    'id': id, 'name': _name, 'gender': _gender, 'birthYear': _birthYear, 'isControl': _isControl, 'blueDyeTestID': _blueDyeTestID, 'blueDyeTest': _blueDyeTest?.toJson(), 'responses': _responses?.map((Response? e) => e?.toJson()).toList(), 'detailResponses': _detailResponses?.map((DetailResponse? e) => e?.toJson()).toList(), 'blueDyeResponses': _blueDyeResponses?.map((BlueDyeResponse? e) => e?.toJson()).toList(), 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format()
  };
  
  Map<String, Object?> toMap() => {
    'id': id,
    'name': _name,
    'gender': _gender,
    'birthYear': _birthYear,
    'isControl': _isControl,
    'blueDyeTestID': _blueDyeTestID,
    'blueDyeTest': _blueDyeTest,
    'responses': _responses,
    'detailResponses': _detailResponses,
    'blueDyeResponses': _blueDyeResponses,
    'createdAt': _createdAt,
    'updatedAt': _updatedAt
  };

  static final amplify_core.QueryModelIdentifier<SubUserModelIdentifier> MODEL_IDENTIFIER = amplify_core.QueryModelIdentifier<SubUserModelIdentifier>();
  static final ID = amplify_core.QueryField(fieldName: "id");
  static final NAME = amplify_core.QueryField(fieldName: "name");
  static final GENDER = amplify_core.QueryField(fieldName: "gender");
  static final BIRTHYEAR = amplify_core.QueryField(fieldName: "birthYear");
  static final ISCONTROL = amplify_core.QueryField(fieldName: "isControl");
  static final BLUEDYETESTID = amplify_core.QueryField(fieldName: "blueDyeTestID");
  static final BLUEDYETEST = amplify_core.QueryField(
    fieldName: "blueDyeTest",
    fieldType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.model, ofModelName: 'BlueDyeTest'));
  static final RESPONSES = amplify_core.QueryField(
    fieldName: "responses",
    fieldType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.model, ofModelName: 'Response'));
  static final DETAILRESPONSES = amplify_core.QueryField(
    fieldName: "detailResponses",
    fieldType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.model, ofModelName: 'DetailResponse'));
  static final BLUEDYERESPONSES = amplify_core.QueryField(
    fieldName: "blueDyeResponses",
    fieldType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.model, ofModelName: 'BlueDyeResponse'));
  static var schema = amplify_core.Model.defineSchema(define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "SubUser";
    modelSchemaDefinition.pluralName = "SubUsers";
    
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
      key: SubUser.NAME,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: SubUser.GENDER,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: SubUser.BIRTHYEAR,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.int)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: SubUser.ISCONTROL,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.bool)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: SubUser.BLUEDYETESTID,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.hasOne(
      key: SubUser.BLUEDYETEST,
      isRequired: false,
      ofModelName: 'BlueDyeTest',
      associatedKey: BlueDyeTest.SUBUSER
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.hasMany(
      key: SubUser.RESPONSES,
      isRequired: false,
      ofModelName: 'Response',
      associatedKey: Response.SUBUSERID
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.hasMany(
      key: SubUser.DETAILRESPONSES,
      isRequired: false,
      ofModelName: 'DetailResponse',
      associatedKey: DetailResponse.SUBUSERID
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.hasMany(
      key: SubUser.BLUEDYERESPONSES,
      isRequired: false,
      ofModelName: 'BlueDyeResponse',
      associatedKey: BlueDyeResponse.SUBUSERID
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

class _SubUserModelType extends amplify_core.ModelType<SubUser> {
  const _SubUserModelType();
  
  @override
  SubUser fromJson(Map<String, dynamic> jsonData) {
    return SubUser.fromJson(jsonData);
  }
  
  @override
  String modelName() {
    return 'SubUser';
  }
}

/**
 * This is an auto generated class representing the model identifier
 * of [SubUser] in your schema.
 */
class SubUserModelIdentifier implements amplify_core.ModelIdentifier<SubUser> {
  final String id;

  /** Create an instance of SubUserModelIdentifier using [id] the primary key. */
  const SubUserModelIdentifier({
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
  String toString() => 'SubUserModelIdentifier(id: $id)';
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    
    return other is SubUserModelIdentifier &&
      id == other.id;
  }
  
  @override
  int get hashCode =>
    id.hashCode;
}