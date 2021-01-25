import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

import 'article_model.dart';

import './../../import.dart';

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
    return StreamBuilder<List<CommentEntity>>(
      stream: model.comments,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return SliverFillRemaining(
            child: Center(child: CircularProgressIndicator()),
          );
        }

        return SliverList(
          delegate: SliverChildBuilderDelegate(
            (_, index) {
              if (index.isEven) {
                final item = snapshot.data![index ~/ 2];

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
            childCount: max(0, snapshot.data!.length * 2 - 1),
          ),
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
                  onTap: () => Router.of(context)
                      .routerDelegate
                      .setNewRoutePath(AppRoutePath()),
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

    final body = StreamBuilder<ArticleEntity>(
      stream: model.article,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        return Column(
          children: [
            Expanded(
              child: CustomScrollView(
                controller: scrollController,
                slivers: [
                  SliverToBoxAdapter(
                    child: ArticleItemWidget(
                      item: snapshot.data!,
                      navigate: false,
                    ),
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
    );

    return Scaffold(
      appBar: appBar,
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: bodyWidth),
          child: body,
        ),
      ),
    );
  }
}
