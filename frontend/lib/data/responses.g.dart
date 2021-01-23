// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'responses.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ArticlesLikeResponse _$ArticlesLikeResponseFromJson(Map<String, dynamic> json) {
  return ArticlesLikeResponse(
    id: json['id'] as int,
    likesCount: json['likes_count'] as int,
    status: json['status'] as bool,
  );
}

Map<String, dynamic> _$ArticlesLikeResponseToJson(
        ArticlesLikeResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'likes_count': instance.likesCount,
      'status': instance.status,
    };

ArticlesViewResponse _$ArticlesViewResponseFromJson(Map<String, dynamic> json) {
  return ArticlesViewResponse(
    viewsCount: json['views_count'] as int,
  );
}

Map<String, dynamic> _$ArticlesViewResponseToJson(
        ArticlesViewResponse instance) =>
    <String, dynamic>{
      'views_count': instance.viewsCount,
    };

LaravelPaginationResponse<T> _$LaravelPaginationResponseFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) {
  return LaravelPaginationResponse<T>(
    data: (json['data'] as List<dynamic>).map(fromJsonT).toList(),
    currentPage: json['currentPage'] as int,
    lastPage: json['lastPage'] as int,
    firstPageUrl: json['firstPageUrl'] as String?,
    nextPageUrl: json['nextPageUrl'] as String?,
    prevPageUrl: json['prevPageUrl'] as String?,
    from: json['from'] as int,
    to: json['to'] as int,
    total: json['total'] as int,
    perPage: json['perPage'] as int,
  );
}

Map<String, dynamic> _$LaravelPaginationResponseToJson<T>(
  LaravelPaginationResponse<T> instance,
  Object Function(T value) toJsonT,
) =>
    <String, dynamic>{
      'data': instance.data.map(toJsonT).toList(),
      'currentPage': instance.currentPage,
      'lastPage': instance.lastPage,
      'firstPageUrl': instance.firstPageUrl,
      'nextPageUrl': instance.nextPageUrl,
      'prevPageUrl': instance.prevPageUrl,
      'from': instance.from,
      'to': instance.to,
      'total': instance.total,
      'perPage': instance.perPage,
    };
