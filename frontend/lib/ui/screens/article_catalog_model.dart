import 'package:flutter/cupertino.dart';
import 'package:frontend/data/blog_repository.dart';
import 'package:frontend/data/entities.dart';

class ArticleCatalogModel {
  final BlogRepository blogRepository;

  final items = ValueNotifier<List<ArticleEntity>>([]);
  final count = ValueNotifier<int>(0);

  int page = 1;

  bool loading = false;

  ArticleCatalogModel({required this.blogRepository});

  Future<void> load() async {
    final resp = await blogRepository.getArticles();

    items.value = List.of(items.value)..addAll(resp.data);
    count.value = resp.total;
  }

  Future<void> loadNext() async {
    if (loading) return;
    if (items.value.length >= count.value) return;
    loading = true;

    final resp = await blogRepository.getArticles(page: ++page);

    items.value = List.of(items.value)..addAll(resp.data);
    count.value = resp.total;
    loading = false;
  }
}
