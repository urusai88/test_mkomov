import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import './../../import.dart';

class ArticleModel {
  final int id;
  final BlogRepository blogRepository;

  final article = BehaviorSubject<ArticleEntity>();
  final comments = BehaviorSubject<List<CommentEntity>>();
  final commentsCount = BehaviorSubject<int>();

  final errorBag = ValueNotifier<LaravelErrorBag?>(null);
  final sending = ValueNotifier<bool>(false);

  final commentsLoading = ValueNotifier<bool>(true);

  final commentSendSuccess = ValueNotifier<bool>(false);

  bool _commentsLoading = false;
  int _page = 1;

  ArticleModel({
    required this.id,
    required this.blogRepository,
  });

  void dispose() {
    article.close();
    comments.close();
    commentsCount.close();
  }

  Future<void> load() async {
    final resp1 = await blogRepository.getArticle(id: id);
    final resp2 = await blogRepository.commentList(articleId: id, page: _page);

    article.add(resp1);
    comments.add(resp2.data);
    commentsCount.add(resp2.total);

    commentsLoading.value = false;
  }

  Future<void> loadNext() async {
    if (_commentsLoading) return;
    if (comments.requireValue.length >= commentsCount.requireValue) return;
    _commentsLoading = true;

    final commentListResponse = await blogRepository.commentList(
      articleId: id,
      page: ++_page,
    );

    comments.add(comments.requireValue..addAll(commentListResponse.data));
    commentsCount.add(commentListResponse.total);

    _commentsLoading = false;
  }

  Future<void> view() async {
    final resp = await blogRepository.viewArticle(articleId: id);

    article.add(article.value!.copyWithViewsCount(resp.viewsCount));
  }

  Future<void> sendComment({
    required String subject,
    required String body,
  }) async {
    try {
      errorBag.value = null;
      sending.value = true;

      await blogRepository.sendComment(
        articleId: id,
        subject: subject,
        body: body,
      );
      commentSendSuccess.value = true;
    } on LaravelErrorBag catch (e) {
      errorBag.value = e;
    } finally {
      sending.value = false;
    }
  }
}
