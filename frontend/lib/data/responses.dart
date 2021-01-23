import 'package:json_annotation/json_annotation.dart';

import 'entities.dart';

part 'responses.g.dart';

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

@JsonSerializable(genericArgumentFactories: true)
class LaravelPaginationResponse<T> {
  final List<T> data;
  final int currentPage;
  final int lastPage;
  final String? firstPageUrl;
  final String? nextPageUrl;
  final String? prevPageUrl;
  final int from;
  final int to;
  final int total;
  final int perPage;

  LaravelPaginationResponse({
    required this.data,
    required this.currentPage,
    required this.lastPage,
    required this.firstPageUrl,
    required this.nextPageUrl,
    required this.prevPageUrl,
    required this.from,
    required this.to,
    required this.total,
    required this.perPage,
  });

  factory LaravelPaginationResponse.fromJson(
          Map<String, dynamic> json, T Function(Object?) fromJsonT) =>
      _$LaravelPaginationResponseFromJson(json, fromJsonT);

  Map<String, dynamic> toJson(Object Function(T) toJsonT) =>
      _$LaravelPaginationResponseToJson(this, toJsonT);
}
