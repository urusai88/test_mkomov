import 'package:flutter/material.dart';
import 'package:frontend/data/blog_repository.dart';
import 'package:frontend/ui/main_screen.dart';
import 'package:frontend/ui/screens/article_catalog_screen.dart';
import 'package:frontend/ui/screens/article_screen.dart';
import 'package:provider/provider.dart';
import 'package:url_strategy/url_strategy.dart';

void main() {
  setPathUrlStrategy();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Widget app = MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      onGenerateRoute: (settings) {
        Widget? parseRoute(String name, Object? arguments) {
          if (name == '/articles') {
            return ArticleCatalogScreen();
          }

          var match = RegExp(r'^/articles/([\w-]+).([\d]+)').firstMatch(name);
          if (match != null) {
            final slug = match.group(1);
            final id = int.parse(match.group(2)!);

            return ArticleScreen(id: id);
          }
        }

        Widget? widget;

        if (settings.name != null) {
          widget = parseRoute(settings.name!, settings.arguments);
        }

        return MaterialPageRoute(
          builder: (_) => widget ?? MainScreen(),
          settings: settings,
        );
      },
    );

    app = MultiProvider(
      providers: [
        Provider<BlogRepository>(create: (_) => BlogRepository()),
      ],
      child: app,
    );

    return app;
  }
}
