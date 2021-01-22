import 'dart:convert';

import 'entities.dart';
import 'responses.dart';

// ignore: import_of_legacy_library_into_null_safe
import 'package:http/http.dart' as http;

class BlogRepository {
  final String baseUrl;

  BlogRepository({required this.baseUrl});

  Future<List<ArticleEntity>> getArticlesLast() async {
    final resp = await http.get('$baseUrl/blog/articles_last');

    return (jsonDecode(resp.body) as List<dynamic>)
        .map((e) => ArticleEntity.fromJson(e))
        .toList();
  }

  Future<ArticlesListResponse> getArticles({int page = 1}) async {
    final resp = await http.get('$baseUrl/blog/articles?page=$page');

    return ArticlesListResponse.fromJson(
        jsonDecode(resp.body) as Map<String, dynamic>);
  }

  Future<ArticleEntity> getArticle({required int id}) async {
    final resp = await http.get('$baseUrl/blog/articles/$id');

    return ArticleEntity.fromJson(
        jsonDecode(resp.body) as Map<String, dynamic>);
  }

  Future<ArticlesLikeResponse> articleLike({required int articleId}) async {
    final resp = await http.post(
      '$baseUrl/blog/articles/like',
      body: jsonEncode({'article_id': articleId}),
      headers: {
        'accept': 'application/json',
        'content-type': 'application/json',
      },
    );

    return ArticlesLikeResponse.fromJson(jsonDecode(resp.body));
  }

  Future<ArticlesLikeResponse> articleUnlike({required int articleId}) async {
    final resp = await http.post(
      '$baseUrl/blog/articles/unlike',
      body: jsonEncode({'article_id': articleId}),
      headers: {
        'accept': 'application/json',
        'content-type': 'application/json',
      },
    );

    return ArticlesLikeResponse.fromJson(jsonDecode(resp.body));
  }

  Future<ArticlesViewResponse> viewArticle({required int articleId}) async {
    final resp = await http.post(
      '$baseUrl/blog/articles/view',
      body: jsonEncode({'article_id': articleId}),
      headers: {
        'accept': 'application/json',
        'content-type': 'application/json',
      },
    );

    return ArticlesViewResponse.fromJson(
        jsonDecode(resp.body) as Map<String, dynamic>);
  }

  Future<CommentListResponse> commentList({
    required int articleId,
    int page = 1,
  }) async {
    final resp =
        await http.get('$baseUrl/blog/comments/list/$articleId?page=$page');

    return CommentListResponse.fromJson(
        jsonDecode(resp.body) as Map<String, dynamic>);
  }

  Future<void> sendComment({
    required int articleId,
    required String subject,
    required String body,
  }) async {
    final resp = await http.post(
      '$baseUrl/blog/comments/create',
      body: jsonEncode(
          {'article_id': articleId, 'subject': subject, 'body': body}),
      headers: {
        'accept': 'application/json',
        'content-type': 'application/json',
      },
    );

    if (resp.statusCode == 422) {
      throw LaravelErrorBag.fromJson(jsonDecode(resp.body));
    }
  }
}
