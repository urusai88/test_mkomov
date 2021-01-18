// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'responses.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ArticlesListResponse _$ArticlesListResponseFromJson(Map<String, dynamic> json) {
  return ArticlesListResponse(
    currentPage: json['current_page'] as int,
    lastPage: json['last_page'] as int,
    data: (json['data'] as List<dynamic>)
        .map((e) => ArticleEntity.fromJson(e as Map<String, dynamic>))
        .toList(),
    firstPageUrl: json['first_page_url'] as String,
    nextPageUrl: json['next_page_url'] as String?,
    prevPageUrl: json['prev_page_url'] as String?,
    from: json['from'] as int,
    to: json['to'] as int,
    total: json['total'] as int,
    perPage: json['per_page'] as int,
  );
}

Map<String, dynamic> _$ArticlesListResponseToJson(
        ArticlesListResponse instance) =>
    <String, dynamic>{
      'data': instance.data.map((e) => e.toJson()).toList(),
      'current_page': instance.currentPage,
      'last_page': instance.lastPage,
      'first_page_url': instance.firstPageUrl,
      'next_page_url': instance.nextPageUrl,
      'prev_page_url': instance.prevPageUrl,
      'from': instance.from,
      'to': instance.to,
      'total': instance.total,
      'per_page': instance.perPage,
    };

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

CommentListResponse _$CommentListResponseFromJson(Map<String, dynamic> json) {
  return CommentListResponse(
    currentPage: json['current_page'] as int,
    lastPage: json['last_page'] as int,
    data: (json['data'] as List<dynamic>)
        .map((e) => CommentEntity.fromJson(e as Map<String, dynamic>))
        .toList(),
    firstPageUrl: json['first_page_url'] as String,
    nextPageUrl: json['next_page_url'] as String?,
    prevPageUrl: json['prev_page_url'] as String?,
    from: json['from'] as int,
    to: json['to'] as int,
    total: json['total'] as int,
    perPage: json['per_page'] as int,
  );
}

Map<String, dynamic> _$CommentListResponseToJson(
        CommentListResponse instance) =>
    <String, dynamic>{
      'data': instance.data.map((e) => e.toJson()).toList(),
      'current_page': instance.currentPage,
      'last_page': instance.lastPage,
      'first_page_url': instance.firstPageUrl,
      'next_page_url': instance.nextPageUrl,
      'prev_page_url': instance.prevPageUrl,
      'from': instance.from,
      'to': instance.to,
      'total': instance.total,
      'per_page': instance.perPage,
    };
