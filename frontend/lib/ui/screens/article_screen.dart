import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:frontend/data/blog_repository.dart';
import 'package:frontend/data/entities.dart';
import 'package:frontend/ui/constants.dart';
import 'package:frontend/ui/widgets/article_item_widget.dart';
import 'package:provider/provider.dart';

import 'article_model.dart';

class ArticleScreen extends StatefulWidget {
  final int id;

  ArticleScreen({required this.id});

  @override
  _ArticleScreenState createState() => _ArticleScreenState();
}

class _ArticleScreenState extends State<ArticleScreen> {
  late final ArticleModel model;
  late final ScrollController scrollController;

  TextEditingController commentSubjectController = TextEditingController();
  TextEditingController commentBodyController = TextEditingController();

  late Timer viewTimer;

  @override
  void initState() {
    super.initState();

    viewTimer = new Timer(Duration(seconds: 5), () async {
      await model.view();
    });

    scrollController = ScrollController();
    scrollController.addListener(scrollControllerListener);

    model = ArticleModel(
      id: widget.id,
      blogRepository: Provider.of<BlogRepository>(context, listen: false),
    );

    Future(_asyncInitState);
  }

  @override
  void dispose() {
    super.dispose();

    viewTimer.cancel();
  }

  Future<void> _asyncInitState() async {
    try {
      await model.load();
    } catch (e) {
      await showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: Text('Статья не найдена'),
          );
        },
      );

      Navigator.pop(context);
    }
  }

  void scrollControllerListener() {
    if (scrollController.offset >= scrollController.position.maxScrollExtent &&
        !scrollController.position.outOfRange) {
      model.loadNext();
    }
  }

  Future<void> sendComment() async {
    await model.sendComment(
      subject: commentSubjectController.text.trim(),
      body: commentBodyController.text.trim(),
    );
  }

  Widget commentList() {
    return ValueListenableBuilder<bool>(
      valueListenable: model.commentsLoading,
      builder: (_, commentsLoading, __) {
        if (commentsLoading) {
          return SliverFillRemaining(
            child: Center(child: CircularProgressIndicator()),
          );
        }

        return ValueListenableBuilder<List<CommentEntity>>(
          valueListenable: model.comments,
          builder: (_, comments, __) {
            return SliverList(
              delegate: SliverChildBuilderDelegate(
                (_, index) {
                  if (index.isEven) {
                    final item = comments[index ~/ 2];

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(item.subject, textAlign: TextAlign.start),
                        Text(item.body, textAlign: TextAlign.start),
                      ],
                    );
                  }

                  return Divider(color: Colors.blueGrey);
                },
                childCount: max(0, comments.length * 2 - 1),
              ),
            );
          },
        );
      },
    );
  }

  Widget commentForm() {
    return ValueListenableBuilder<bool>(
      valueListenable: model.commentSendSuccess,
      builder: (_, success, __) {
        if (success) {
          return Container(
            height: 100,
            alignment: Alignment.center,
            child: Text('Ваше сообщение успешно отправлено'),
          );
        }

        return ValueListenableBuilder<LaravelErrorBag?>(
          valueListenable: model.errorBag,
          builder: (_, errorBag, __) {
            return Column(
              children: [
                TextField(
                  controller: commentSubjectController,
                  decoration: InputDecoration(
                    labelText: 'Тема',
                    errorText: LaravelErrorBag.getError('subject', errorBag),
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: commentBodyController,
                  decoration: InputDecoration(
                    labelText: 'Текст',
                    errorText: LaravelErrorBag.getError('body', errorBag),
                  ),
                ),
                const SizedBox(height: 8),
                ValueListenableBuilder<bool>(
                  valueListenable: model.sending,
                  builder: (_, sending, __) {
                    if (sending) {
                      return Center(child: CircularProgressIndicator());
                    }
                    return ElevatedButton(
                      onPressed: sendComment,
                      child: Text('Отправить'),
                    );
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final appBar = PreferredSize(
      preferredSize: Size.fromHeight(64),
      child: Container(
        color: Theme.of(context).accentColor,
        child: Center(
          child: Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: Text(
                      'Главная страница',
                      style: navigationTextStyleInactive,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  'Каталог статей',
                  style: navigationTextStyleActive,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );

    final body = Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: bodyWidth),
        child: ValueListenableBuilder<ArticleEntity?>(
          valueListenable: model.article,
          builder: (_, article, __) {
            if (article == null) {
              return Center(child: CircularProgressIndicator());
            }

            return Column(
              children: [
                Expanded(
                  child: CustomScrollView(
                    controller: scrollController,
                    slivers: [
                      SliverToBoxAdapter(
                        child: ArticleItemWidget(item: article),
                      ),
                      SliverToBoxAdapter(
                        child: Center(
                          child: Text(
                            'Комментарии',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      commentList(),
                    ],
                  ),
                ),
                commentForm(),
              ],
            );
          },
        ),
      ),
    );

    return Scaffold(
      appBar: appBar,
      body: body,
    );
  }
}
