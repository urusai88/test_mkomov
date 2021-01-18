import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:frontend/data/blog_repository.dart';
import 'package:frontend/data/entities.dart';
import 'package:frontend/ui/constants.dart';
import 'package:frontend/ui/screens/article_catalog_model.dart';
import 'package:frontend/ui/widgets/article_item_widget.dart';
import 'package:provider/provider.dart';

class ArticleCatalogScreen extends StatefulWidget {
  @override
  _ArticleCatalogScreeState createState() => _ArticleCatalogScreeState();
}

class _ArticleCatalogScreeState extends State<ArticleCatalogScreen> {
  late final ArticleCatalogModel model;
  late final ScrollController scrollController;

  @override
  void initState() {
    super.initState();

    scrollController = ScrollController();
    scrollController.addListener(scrollControllerListener);

    model = ArticleCatalogModel(
      blogRepository: Provider.of<BlogRepository>(context, listen: false),
    );

    Future(_asyncInitState);
  }

  @override
  void dispose() {
    super.dispose();

    scrollController.removeListener(scrollControllerListener);
  }

  Future<void> _asyncInitState() async {
    await model.load();
  }

  void scrollControllerListener() {
    if (scrollController.offset >= scrollController.position.maxScrollExtent &&
        !scrollController.position.outOfRange) {
      model.loadNext();
    }
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
                  onTap: () => Navigator.pushNamed(context, '/'),
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: Text(
                      'Главная страница',
                      style: navigationTextStyleInactive,textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  'Каталог статей',
                  style: navigationTextStyleActive,textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );

    return Scaffold(
      appBar: appBar,
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: bodyWidth),
          child: ValueListenableBuilder<List<ArticleEntity>>(
            valueListenable: model.items,
            builder: (_, items, __) {
              return ListView.separated(
                controller: scrollController,
                itemCount: items.length,
                separatorBuilder: (_, __) => Divider(),
                itemBuilder: (_, index) =>
                    ArticleItemWidget(item: items[index]),
              );
            },
          ),
        ),
      ),
    );
    return Container(
      color: Colors.red,
    );
  }
}
