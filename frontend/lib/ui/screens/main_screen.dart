import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

import './../../import.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin {
  late List<ArticleEntity> lastArticleList;

  late TabController tabController;

  int tabPage = 0;

  @override
  void initState() {
    super.initState();

    lastArticleList = [];
    tabController =
        TabController(initialIndex: tabPage, length: 2, vsync: this);

    Future(_asyncInitState);
  }

  Future<void> _asyncInitState() async {
    final resp = await Provider.of<BlogRepository>(context, listen: false)
        .getArticlesLast();

    setState(() => lastArticleList = resp);
  }

  Widget mainTab() {
    return ArticleCatalogScreen();
  }

  Widget articleCatalogTab() {
    return ArticleCatalogScreen();
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
                child: Text(
                  'Главная страница',
                  style: navigationTextStyleActive,
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Router.of(context)
                        .routerDelegate
                        .setNewRoutePath(ArticlesRoutePath());
                  },
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: Text(
                      'Каталог статей',
                      style: navigationTextStyleInactive,
                      textAlign: TextAlign.center,
                    ),
                  ),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 11),
              child: Text(
                'Последние статьи',
                style: const TextStyle(fontSize: 20),
              ),
            ),
            Expanded(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 500),
                child: ListView.separated(
                  itemCount: lastArticleList.length,
                  separatorBuilder: (_, __) => Divider(),
                  itemBuilder: (_, index) =>
                      ArticleItemWidget(item: lastArticleList[index]),
                ),
              ),
            ),
          ],
        ),
      ),
    );

    return Scaffold(
      appBar: appBar,
      body: body,
    );
  }
}
