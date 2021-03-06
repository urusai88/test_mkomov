import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import './../../import.dart';

class ArticleItemWidget extends StatefulWidget {
  final ArticleEntity item;
  final bool navigate;

  ArticleItemWidget({required this.item, this.navigate = true});

  @override
  _ArticleItemWidgetState createState() => _ArticleItemWidgetState();
}

class _ArticleItemWidgetState extends State<ArticleItemWidget> {
  static final dateTimeFormat = DateFormat(DateFormat.YEAR_MONTH_DAY);

  late ArticleEntity item;

  @override
  void initState() {
    super.initState();

    item = widget.item;
  }

  Future<void> navigateToArticle() async {
    if (!widget.navigate) return;

    await Router.of(context).routerDelegate.setNewRoutePath(
        ArticlesRoutePath(articleId: item.id, articleSlug: item.slug));
  }

  Future<void> likeToggle() async {
    final blogRepository = Provider.of<BlogRepository>(context, listen: false);
    final resp = item.like == 0
        ? await blogRepository.articleLike(articleId: item.id)
        : await blogRepository.articleUnlike(articleId: item.id);

    setState(() {
      item = item.copyWith(
        like: resp.status ? 1 : 0,
        likesCount: resp.likesCount,
      );
    });
  }

  Widget tags(List<ArticleTagEntity> tagList) {
    final children = tagList.map<Widget>((e) => Text(e.label)).toList();

    for (var i = children.length - 1; i > 0; --i) {
      final w = Row(
        mainAxisSize: MainAxisSize.min,
        children: [Text(', '), const SizedBox(width: 5)],
      );

      children.insert(i, w);
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 11),
      child: Wrap(
        children: [
          Text('Теги: ', style: const TextStyle(fontWeight: FontWeight.bold)),
          ...children,
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const greyColor = Color.fromRGBO(89, 89, 89, 1.0);

    final viewsCount = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.remove_red_eye_rounded, color: greyColor),
        const SizedBox(width: 5),
        Text(
          '${item.viewsCount}',
          style: const TextStyle(color: greyColor),
        ),
      ],
    );

    final likesCount = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: likeToggle,
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: Icon(
              item.like == 0 ? Icons.thumb_up_alt_outlined : Icons.thumb_up_alt,
              color: greyColor,
            ),
          ),
        ),
        const SizedBox(width: 5),
        Text(
          '${item.likesCount}',
          style: const TextStyle(color: greyColor),
        ),
      ],
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          margin: const EdgeInsets.symmetric(vertical: 7),
          child: Text(
            item.title,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        GestureDetector(
          onTap: navigateToArticle,
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 4),
              child: Image.network(
                'https://via.placeholder.com/1920x1080',
              ),
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
          child: Text(
            item.body,
            style: const TextStyle(fontSize: 16),
          ),
        ),
        Row(
          children: [
            Text(
              dateTimeFormat.format(item.createdAt),
              style: const TextStyle(fontSize: 15, color: greyColor),
            ),
            Spacer(),
            viewsCount,
            const SizedBox(width: 20),
            likesCount,
          ],
        ),
        if (item.articleTags != null) tags(item.articleTags!),
      ],
    );
  }
}
