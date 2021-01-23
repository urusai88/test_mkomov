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
  final AppRouteParser routeParser;
  final AppRouterDelegate routerDelegate;

  MyApp()
      : routeParser = AppRouteParser(),
        routerDelegate = AppRouterDelegate();

  @override
  Widget build(BuildContext context) {
    Widget app = MaterialApp.router(
      title: 'Simple blog',
      routeInformationParser: routeParser,
      routerDelegate: routerDelegate,
    );

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
