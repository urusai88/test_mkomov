class RouteSlugDefinition {
  final String name;
  final bool required;

  RouteSlugDefinition({required this.name, required this.required});

  @override
  String toString() => '$name req: $required';
}

class RouteMatchResult {
  final List values;

  const RouteMatchResult({required this.values});
}

class RoutePattern {
  final String pattern;
  final Function resolver;
  final List<RouteSlugDefinition> slugs;

  const RoutePattern(
      {required this.pattern, required this.resolver, required this.slugs});

  RouteMatchResult? match(String path) {
    final pattern = this.pattern;
    final match = RegExp(pattern).firstMatch(path);

    if (match != null) {
      print('pattern: $pattern path: $path match: $match');

      return RouteMatchResult(
        values: match.groups(List.generate(match.groupCount, (i) => i + 1)),
      );
    }

    return null;
  }
}

T routeTransformer<T>(
    String location, Map<String, Function> routeList, T onUnknown) {
  final routeMap = <RoutePattern>[];

  for (final entry in routeList.entries) {
    final route = entry.key;
    final resolver = entry.value;

    final pattern = r'{([\w\:]+\??)}';
    final matchIt = RegExp(pattern).allMatches(route);

    final slugs = <RouteSlugDefinition>[];

    var pattern2 = route;

    for (final match in matchIt) {
      final group0 = match.group(0);
      final group1 = match.group(1);
      if (group0 == null || group1 == null) continue;

      var def = group1;
      if (def.endsWith('?')) {
        def = def.substring(0, def.length - 1);
      }

      final slug = RouteSlugDefinition(name: def, required: !def.endsWith('?'));

      var m = r'\w\d-_';
      var p = '(';
      p += '[' + m + ']';
      p += slug.required ? '+' : '?';
      p += ')';

      pattern2 = pattern2.replaceAll(group0, p);

      slugs.add(slug);
    }

    pattern2 = pattern2.replaceAll(r'/', r'\/').replaceAll('.', r'\.');
    pattern2 = '^$pattern2';

    routeMap.add(RoutePattern(
      pattern: pattern2,
      resolver: resolver,
      slugs: slugs,
    ));
  }

  var result = onUnknown;

  for (final route in routeMap) {
    final match = route.match(location);
    if (match != null) {
      result = Function.apply(route.resolver, match.values);
      break;
    }
  }

  print('location: $location result: $result');

  return result;

  return onUnknown;
}
