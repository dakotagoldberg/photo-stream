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
import 'package:amplify_core/amplify_core.dart';
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';

/** This is an auto generated class representing the Post type in your schema. */
@immutable
class Post extends Model {
  static const classType = const _PostModelType();
  final String id;
  final String? _title;
  final String? _description;
  final String? _image;
  final String? _userID;
  final List<UserLikes>? _Likes;
  final TemporalDateTime? _createdAt;
  final TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;

  @override
  String getId() {
    return id;
  }

  String get title {
    try {
      return _title!;
    } catch (e) {
      throw new AmplifyCodeGenModelException(
          AmplifyExceptionMessages
              .codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion: AmplifyExceptionMessages
              .codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString());
    }
  }

  String? get description {
    return _description;
  }

  String get image {
    try {
      return _image!;
    } catch (e) {
      throw new AmplifyCodeGenModelException(
          AmplifyExceptionMessages
              .codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion: AmplifyExceptionMessages
              .codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString());
    }
  }

  String get userID {
    try {
      return _userID!;
    } catch (e) {
      throw new AmplifyCodeGenModelException(
          AmplifyExceptionMessages
              .codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion: AmplifyExceptionMessages
              .codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString());
    }
  }

  List<UserLikes>? get Likes {
    return _Likes;
  }

  TemporalDateTime? get createdAt {
    return _createdAt;
  }

  TemporalDateTime? get updatedAt {
    return _updatedAt;
  }

  const Post._internal(
      {required this.id,
      required title,
      description,
      required image,
      required userID,
      Likes,
      createdAt,
      updatedAt})
      : _title = title,
        _description = description,
        _image = image,
        _userID = userID,
        _Likes = Likes,
        _createdAt = createdAt,
        _updatedAt = updatedAt;

  factory Post(
      {String? id,
      required String title,
      String? description,
      required String image,
      required String userID,
      List<UserLikes>? Likes}) {
    return Post._internal(
        id: id == null ? UUID.getUUID() : id,
        title: title,
        description: description,
        image: image,
        userID: userID,
        Likes: Likes != null ? List<UserLikes>.unmodifiable(Likes) : Likes);
  }

  bool equals(Object other) {
    return this == other;
  }

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Post &&
        id == other.id &&
        _title == other._title &&
        _description == other._description &&
        _image == other._image &&
        _userID == other._userID &&
        DeepCollectionEquality().equals(_Likes, other._Likes);
  }

  @override
  int get hashCode => toString().hashCode;

  @override
  String toString() {
    var buffer = new StringBuffer();

    buffer.write("Post {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("title=" + "$_title" + ", ");
    buffer.write("description=" + "$_description" + ", ");
    buffer.write("image=" + "$_image" + ", ");
    buffer.write("userID=" + "$_userID" + ", ");
    buffer.write("createdAt=" +
        (_createdAt != null ? _createdAt!.format() : "null") +
        ", ");
    buffer.write(
        "updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");

    return buffer.toString();
  }

  Post copyWith(
      {String? id,
      String? title,
      String? description,
      String? image,
      String? userID,
      List<UserLikes>? Likes}) {
    return Post._internal(
        id: id ?? this.id,
        title: title ?? this.title,
        description: description ?? this.description,
        image: image ?? this.image,
        userID: userID ?? this.userID,
        Likes: Likes ?? this.Likes);
  }

  Post.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        _title = json['title'],
        _description = json['description'],
        _image = json['image'],
        _userID = json['userID'],
        _Likes = json['Likes'] is List
            ? (json['Likes'] as List)
                .where((e) => e?['serializedData'] != null)
                .map((e) => UserLikes.fromJson(
                    new Map<String, dynamic>.from(e['serializedData'])))
                .toList()
            : null,
        _createdAt = json['createdAt'] != null
            ? TemporalDateTime.fromString(json['createdAt'])
            : null,
        _updatedAt = json['updatedAt'] != null
            ? TemporalDateTime.fromString(json['updatedAt'])
            : null;

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': _title,
        'description': _description,
        'image': _image,
        'userID': _userID,
        'Likes': _Likes?.map((UserLikes? e) => e?.toJson()).toList(),
        'createdAt': _createdAt?.format(),
        'updatedAt': _updatedAt?.format()
      };

  static final QueryField ID = QueryField(fieldName: "post.id");
  static final QueryField TITLE = QueryField(fieldName: "title");
  static final QueryField DESCRIPTION = QueryField(fieldName: "description");
  static final QueryField IMAGE = QueryField(fieldName: "image");
  static final QueryField USERID = QueryField(fieldName: "userID");
  static final QueryField LIKES = QueryField(
      fieldName: "Likes",
      fieldType: ModelFieldType(ModelFieldTypeEnum.model,
          ofModelName: (UserLikes).toString()));
  static var schema =
      Model.defineSchema(define: (ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "Post";
    modelSchemaDefinition.pluralName = "Posts";

    modelSchemaDefinition.authRules = [
      AuthRule(
          authStrategy: AuthStrategy.OWNER,
          ownerField: "owner",
          identityClaim: "cognito:username",
          provider: AuthRuleProvider.USERPOOLS,
          operations: [
            ModelOperation.CREATE,
            ModelOperation.UPDATE,
            ModelOperation.DELETE,
            ModelOperation.READ
          ]),
      AuthRule(
          authStrategy: AuthStrategy.PRIVATE,
          operations: [ModelOperation.READ, ModelOperation.UPDATE]),
      AuthRule(
          authStrategy: AuthStrategy.PUBLIC,
          provider: AuthRuleProvider.IAM,
          operations: [ModelOperation.READ])
    ];

    modelSchemaDefinition.addField(ModelFieldDefinition.id());

    modelSchemaDefinition.addField(ModelFieldDefinition.field(
        key: Post.TITLE,
        isRequired: true,
        ofType: ModelFieldType(ModelFieldTypeEnum.string)));

    modelSchemaDefinition.addField(ModelFieldDefinition.field(
        key: Post.DESCRIPTION,
        isRequired: false,
        ofType: ModelFieldType(ModelFieldTypeEnum.string)));

    modelSchemaDefinition.addField(ModelFieldDefinition.field(
        key: Post.IMAGE,
        isRequired: true,
        ofType: ModelFieldType(ModelFieldTypeEnum.string)));

    modelSchemaDefinition.addField(ModelFieldDefinition.field(
        key: Post.USERID,
        isRequired: true,
        ofType: ModelFieldType(ModelFieldTypeEnum.string)));

    modelSchemaDefinition.addField(ModelFieldDefinition.hasMany(
        key: Post.LIKES,
        isRequired: false,
        ofModelName: (UserLikes).toString(),
        associatedKey: UserLikes.POST));

    modelSchemaDefinition.addField(ModelFieldDefinition.nonQueryField(
        fieldName: 'createdAt',
        isRequired: false,
        isReadOnly: true,
        ofType: ModelFieldType(ModelFieldTypeEnum.dateTime)));

    modelSchemaDefinition.addField(ModelFieldDefinition.nonQueryField(
        fieldName: 'updatedAt',
        isRequired: false,
        isReadOnly: true,
        ofType: ModelFieldType(ModelFieldTypeEnum.dateTime)));
  });
}

class _PostModelType extends ModelType<Post> {
  const _PostModelType();

  @override
  Post fromJson(Map<String, dynamic> jsonData) {
    return Post.fromJson(jsonData);
  }
}
