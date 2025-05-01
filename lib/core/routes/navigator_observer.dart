import 'package:flutter/cupertino.dart';
import 'package:injectable/injectable.dart';

String? _currentRoute = 'undefined';
String? get appCurrentRoute => _currentRoute;

String? _previousRoute = 'undefined';
String? get appPreviousRoute => _previousRoute;

@singleton
class AppNavigatorObserver extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _currentRoute = route.settings.name;
    _previousRoute = previousRoute?.settings.name;
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _currentRoute = previousRoute?.settings.name;
    _previousRoute = previousRoute?.settings.name;
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    _currentRoute = newRoute?.settings.name;
    _previousRoute = oldRoute?.settings.name;
  }
}
