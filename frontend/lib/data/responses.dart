import 'package:frontend/data/entities.dart';
import 'package:json_annotation/json_annotation.dart';

part 'responses.g.dart';

@JsonSerializable(explicitToJson: true)
class ArticlesListResponse {
  List<ArticleEntity> data;
  @JsonKey(name: 'current_page')
  int currentPage;
  @JsonKey(name: 'last_page')
  int lastPage;
  @JsonKey(name: 'first_page_url')
  String firstPageUrl;
  @JsonKey(name: 'next_page_url')
  String? nextPageUrl;
  @JsonKey(name: 'prev_page_url')
  String? prevPageUrl;
  int from;
  int to;
  int total;
  @JsonKey(name: 'per_page')
  int perPage;

  ArticlesListResponse({
    required this.currentPage,
    required this.lastPage,
    required this.data,
    required this.firstPageUrl,
    required this.nextPageUrl,
    required this.prevPageUrl,
    required this.from,
    required this.to,
    required this.total,
    required this.perPage,
  });

  factory ArticlesListResponse.fromJson(Map<String, dynamic> json) =>
      _$ArticlesListResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ArticlesListResponseToJson(this);
}

@JsonSerializable()
class ArticlesLikeResponse {
  final int id;
  @JsonKey(name: 'likes_count')
  final int likesCount;
  final bool status;

  ArticlesLikeResponse({
    required this.id,
    required this.likesCount,
    required this.status,
  });

  factory ArticlesLikeResponse.fromJson(Map<String, dynamic> json) =>
      _$ArticlesLikeResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ArticlesLikeResponseToJson(this);
}

@JsonSerializable()
class ArticlesViewResponse {
  @JsonKey(name: 'views_count')
  final int viewsCount;

  ArticlesViewResponse({required this.viewsCount});

  factory ArticlesViewResponse.fromJson(Map<String, dynamic> json) =>
      _$ArticlesViewResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ArticlesViewResponseToJson(this);
}

@JsonSerializable(explicitToJson: true)
class CommentListResponse {
  List<CommentEntity> data;
  @JsonKey(name: 'current_page')
  int currentPage;
  @JsonKey(name: 'last_page')
  int lastPage;
  @JsonKey(name: 'first_page_url')
  String firstPageUrl;
  @JsonKey(name: 'next_page_url')
  String? nextPageUrl;
  @JsonKey(name: 'prev_page_url')
  String? prevPageUrl;
  int from;
  int to;
  int total;
  @JsonKey(name: 'per_page')
  int perPage;

  CommentListResponse({
    required this.currentPage,
    required this.lastPage,
    required this.data,
    required this.firstPageUrl,
    required this.nextPageUrl,
    required this.prevPageUrl,
    required this.from,
    required this.to,
    required this.total,
    required this.perPage,
  });

  factory CommentListResponse.fromJson(Map<String, dynamic> json) =>
      _$CommentListResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CommentListResponseToJson(this);
}
