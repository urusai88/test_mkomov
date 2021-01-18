import 'dart:convert';

import 'package:frontend/data/entities.dart';
import 'package:frontend/data/responses.dart';

// ignore: import_of_legacy_library_into_null_safe
import 'package:http/http.dart' as http;

class BlogRepository {
  final String baseUrl = 'http://127.0.0.1:8000/api';

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
    final resp = await http.get('$baseUrl/blog/article/$id');

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

  Future<void> viewArticle({required int articleId}) async {
    final resp = await http.post(
      '$baseUrl/blog/articles/view',
      body: jsonEncode({'article_id': articleId}),
      headers: {
        'accept': 'application/json',
        'content-type': 'application/json',
      },
    );
  }

  Future<CommentListResponse> commentList({
    required int articleId,
    int page = 1,
  }) async {
    final resp =
        await http.get('$baseUrl/blog/comment/list/$articleId?page=$page');

    return CommentListResponse.fromJson(
        jsonDecode(resp.body) as Map<String, dynamic>);
  }

  Future<void> sendComment({
    required int articleId,
    required String subject,
    required String body,
  }) async {
    final resp = await http.post(
      '$baseUrl/blog/comment/create',
      body: jsonEncode(
        {'article_id': articleId, 'subject': subject, 'body': body},
      ),
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
