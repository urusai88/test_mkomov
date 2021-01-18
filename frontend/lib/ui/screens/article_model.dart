import 'package:flutter/foundation.dart';
import 'package:frontend/data/blog_repository.dart';
import 'package:frontend/data/entities.dart';

class ArticleModel {
  final int id;
  final BlogRepository blogRepository;

  final article = ValueNotifier<ArticleEntity?>(null);
  final comments = ValueNotifier<List<CommentEntity>>([]);
  final commentsCount = ValueNotifier<int>(0);

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

  Future<void> load() async {
    final resp = await blogRepository.getArticle(id: id);

    article.value = resp;

    final commentListResponse =
        await blogRepository.commentList(articleId: id, page: _page);

    comments.value = commentListResponse.data;
    commentsCount.value = commentListResponse.total;

    commentsLoading.value = false;
  }

  Future<void> loadNext() async {
    if (_commentsLoading) return;
    if (comments.value.length >= commentsCount.value) return;
    _commentsLoading = true;

    final commentListResponse = await blogRepository.commentList(
      articleId: id,
      page: ++_page,
    );

    comments.value = List.of(comments.value)..addAll(commentListResponse.data);
    commentsCount.value = commentListResponse.total;
    _commentsLoading = false;
  }

  Future<void> view() async {
    final resp = await blogRepository.viewArticle(articleId: id);

    article.value = article.value!.copyWithViewsCount(resp.viewsCount);
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
