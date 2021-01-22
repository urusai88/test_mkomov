import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_strategy/url_strategy.dart';

import 'routing.dart';
import 'import.dart';

void main() {
  setPathUrlStrategy();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  late AppRouteParser routeParser;
  late AppRouterDelegate routerDelegate;

  MyApp() {
    routeParser = AppRouteParser();
    routerDelegate = AppRouterDelegate();
  }

  @override
  Widget build(BuildContext context) {
    Widget app = MaterialApp.router(
      title: 'Simple blog',
      routeInformationProvider: PlatformRouteInformationProvider(
        initialRouteInformation: RouteInformation(location: '/'),
      ),
      routeInformationParser: routeParser,
      routerDelegate: routerDelegate,
    );

    /*
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
    );*/

    app = MultiProvider(
      providers: [
        Provider<BlogRepository>(
          create: (_) => BlogRepository(
            baseUrl: 'http://127.0.0.1:80/api',
          ),
        ),
      ],
      child: app,
    );

    return app;
  }
}
