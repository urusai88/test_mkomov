import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'import.dart';
import 'route.lib.dart';

class AppPage extends Page {
  final Widget page;

  AppPage({required this.page});

  @override
  Route createRoute(BuildContext context) {
    return MaterialPageRoute(
      settings: this,
      builder: (context) => page,
    );
  }
}

class AppRoutePath {}

class LoadingRoutePath extends AppRoutePath {}

class ArticlesRoutePath extends AppRoutePath {
  int? articleId;
  String? articleSlug;

  ArticlesRoutePath({this.articleId, this.articleSlug})
      : assert(() {
          return (articleId == null && articleSlug == null ||
              articleId != null && articleSlug != null);
        }(), 'articleId и articleSlug должны быть указаны оба или ни одного');

  @override
  String toString() =>
      '${this.runtimeType}{articleId: $articleId, articleSlug: $articleSlug}';
}

class AppRouteParser extends RouteInformationParser<AppRoutePath> {
  final routes = <String, Function>{
    '/articles/{slug}.{id}': (slug, id) =>
        ArticlesRoutePath(articleId: int.parse(id), articleSlug: slug),
    '/articles': () => ArticlesRoutePath(),
    '/': () => AppRoutePath(),
  };

  @override
  Future<AppRoutePath> parseRouteInformation(
    RouteInformation routeInformation,
  ) async {
    print('parse ${routeInformation.location}');
    return routeTransformer<AppRoutePath>(
      routeInformation.location ?? '',
      routes,
      AppRoutePath(),
    );
  }

  @override
  RouteInformation? restoreRouteInformation(AppRoutePath configuration) {
    print('restore $configuration');
    String? location;

    if (configuration is ArticlesRoutePath) {
      location = '/articles';
      if (configuration.articleId != null) {
        location += '/${configuration.articleSlug}.${configuration.articleId}';
      }
    }

    return RouteInformation(location: location ?? '/');
  }
}

class AppRouterDelegate extends RouterDelegate<AppRoutePath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin {
  @override
  GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  AppRoutePath routePath = LoadingRoutePath();

  @override
  Future<void> setNewRoutePath(AppRoutePath configuration) async {
    print('setNewRoutePath $configuration');
    routePath = configuration;
    notifyListeners();
  }

  @override
  AppRoutePath? get currentConfiguration => routePath;

  @override
  Widget build(BuildContext context) {
    if (routePath is LoadingRoutePath) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Navigator(
      key: navigatorKey,
      pages: [
        AppPage(page: MainScreen()),
        if (routePath is ArticlesRoutePath)
          ...articlesPages(routePath as ArticlesRoutePath),
      ],
      onPopPage: (route, result) {
        print('pop');
        return route.didPop(result);
      },
    );
  }

  List<Page> articlesPages(ArticlesRoutePath path) {
    return [
      if (path.articleId != null)
        AppPage(page: ArticleScreen(id: path.articleId!))
      else
        AppPage(page: ArticleCatalogScreen()),
    ];
  }
}
