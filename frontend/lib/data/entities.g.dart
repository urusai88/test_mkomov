// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'entities.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ArticleTagEntity _$ArticleTagEntityFromJson(Map<String, dynamic> json) {
  return ArticleTagEntity(
    id: json['id'] as int,
    label: json['label'] as String,
    url: json['url'] as String,
  );
}

Map<String, dynamic> _$ArticleTagEntityToJson(ArticleTagEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'label': instance.label,
      'url': instance.url,
    };

LikeEntity _$LikeEntityFromJson(Map<String, dynamic> json) {
  return LikeEntity();
}

Map<String, dynamic> _$LikeEntityToJson(LikeEntity instance) =>
    <String, dynamic>{};

ArticleEntity _$ArticleEntityFromJson(Map<String, dynamic> json) {
  return ArticleEntity(
    id: json['id'] as int,
    title: json['title'] as String,
    body: json['body'] as String,
    slug: json['slug'] as String,
    likesCount: json['likes_count'] as int,
    viewsCount: json['views_count'] as int,
    createdAt: DateTime.parse(json['created_at'] as String),
    updatedAt: DateTime.parse(json['updated_at'] as String),
    articleTags: (json['article_tags'] as List<dynamic>?)
        ?.map((e) => ArticleTagEntity.fromJson(e as Map<String, dynamic>))
        .toList(),
    like: json['like'] as int,
  );
}

Map<String, dynamic> _$ArticleEntityToJson(ArticleEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'body': instance.body,
      'slug': instance.slug,
      'likes_count': instance.likesCount,
      'views_count': instance.viewsCount,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
      'like': instance.like,
      'article_tags': instance.articleTags?.map((e) => e.toJson()).toList(),
    };

CommentEntity _$CommentEntityFromJson(Map<String, dynamic> json) {
  return CommentEntity(
    id: json['id'] as int,
    subject: json['subject'] as String,
    body: json['body'] as String,
    articleId: json['article_id'] as int,
  );
}

Map<String, dynamic> _$CommentEntityToJson(CommentEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'subject': instance.subject,
      'body': instance.body,
      'article_id': instance.articleId,
    };

LaravelErrorBag _$LaravelErrorBagFromJson(Map<String, dynamic> json) {
  return LaravelErrorBag(
    message: json['message'] as String,
    errors: (json['errors'] as Map<String, dynamic>?)?.map(
      (k, e) =>
          MapEntry(k, (e as List<dynamic>).map((e) => e as String).toList()),
    ),
  );
}

Map<String, dynamic> _$LaravelErrorBagToJson(LaravelErrorBag instance) =>
    <String, dynamic>{
      'message': instance.message,
      'errors': instance.errors,
    };
