import 'package:copy_with/copy_with.dart';
import 'package:json_annotation/json_annotation.dart';

part 'entities.g.dart';

@JsonSerializable()
class ArticleTagEntity {
  int id;
  String label;
  String url;

  ArticleTagEntity({
    required this.id,
    required this.label,
    required this.url,
  });

  factory ArticleTagEntity.fromJson(Map<String, dynamic> json) =>
      _$ArticleTagEntityFromJson(json);

  Map<String, dynamic> toJson() => _$ArticleTagEntityToJson(this);
}

@JsonSerializable()
class LikeEntity {
  factory LikeEntity.fromJson(Map<String, dynamic> json) =>
      _$LikeEntityFromJson(json);

  LikeEntity();

  Map<String, dynamic> toJson() => _$LikeEntityToJson(this);
}

@CopyWith()
@JsonSerializable(explicitToJson: true)
class ArticleEntity {
  final int id;
  final String title;
  final String body;
  final String slug;
  @JsonKey(name: 'likes_count')
  final int likesCount;
  @JsonKey(name: 'views_count')
  final int viewsCount;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;
  final int like;

  @JsonKey(name: 'article_tags')
  final List<ArticleTagEntity>? articleTags;

  ArticleEntity({
    required this.id,
    required this.title,
    required this.body,
    required this.slug,
    required this.likesCount,
    required this.viewsCount,
    required this.createdAt,
    required this.updatedAt,
    this.articleTags,
    required this.like,
  });

  factory ArticleEntity.fromJson(Map<String, dynamic> json) =>
      _$ArticleEntityFromJson(json);

  Map<String, dynamic> toJson() => _$ArticleEntityToJson(this);
}

@JsonSerializable()
class CommentEntity {
  int id;
  String subject;
  String body;
  @JsonKey(name: 'article_id')
  int articleId;

  CommentEntity({
    required this.id,
    required this.subject,
    required this.body,
    required this.articleId,
  });

  factory CommentEntity.fromJson(Map<String, dynamic> json) =>
      _$CommentEntityFromJson(json);

  Map<String, dynamic> toJson() => _$CommentEntityToJson(this);
}

@JsonSerializable()
class LaravelErrorBag {
  final String message;
  final Map<String, List<String>>? errors;

  LaravelErrorBag({required this.message, required this.errors});

  static String? getError(String name, LaravelErrorBag? errorBag) {
    if (errorBag == null || errorBag.errors == null) return null;
    if (!(errorBag.errors?.containsKey(name) ?? false)) return null;
    if (errorBag.errors?[name]?.isEmpty ?? true) return null;

    return errorBag.errors?[name]?.first;
  }

  factory LaravelErrorBag.fromJson(Map<String, dynamic> json) =>
      _$LaravelErrorBagFromJson(json);
}
