import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sweet_planner/src/feature/candy/model/candy.dart';
import '../src/feature/candy/presentation/add_screen.dart';
import '../src/feature/candy/presentation/home_screen.dart';
import '../src/feature/candy/presentation/history_screen.dart';
import '../src/feature/candy/presentation/notification_screen.dart';
import '../src/feature/candy/presentation/shopping_screen.dart';
import '../src/feature/candy/presentation/confirmation_screen.dart';

import '../src/feature/splash/presentation/screens/splash_screen.dart';
import 'root_navigation_screen.dart';
import 'route_value.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _homeNavigatorKey = GlobalKey<NavigatorState>();
final _historyNavigatorKey = GlobalKey<NavigatorState>();
final _shoppingNavigatorKey = GlobalKey<NavigatorState>();
final _confirmationNavigatorKey = GlobalKey<NavigatorState>();

final _shellNavigatorKey = GlobalKey<NavigatorState>();

GoRouter buildGoRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: RouteValue.splash.path,
  routes: <RouteBase>[
    StatefulShellRoute.indexedStack(
      pageBuilder: (context, state, navigationShell) {
        return NoTransitionPage(
          child: RootNavigationScreen(
            navigationShell: navigationShell,
          ),
        );
      },
      branches: [
        StatefulShellBranch(
            navigatorKey: _homeNavigatorKey,
            routes: <RouteBase>[
              GoRoute(
                  path: RouteValue.home.path,
                  builder: (BuildContext context, GoRouterState state) {
                    return const HomeScreen();
                  },
                  routes: <RouteBase>[
                    GoRoute(
                        path: RouteValue.add.path,
                        builder: (BuildContext context, GoRouterState state) {
                          return AddSweetScreen(
                            isShop: false,
                            candy: state.extra as Candy?,
                          );
                        }),
                    GoRoute(
                        path: RouteValue.notification.path,
                        builder: (BuildContext context, GoRouterState state) {
                          return const NotificationsScreen();
                        }),
                  ]),
            ]),
        StatefulShellBranch(
            navigatorKey: _shoppingNavigatorKey,
            routes: <RouteBase>[
              GoRoute(
                  path: RouteValue.shopping.path,
                  builder: (BuildContext context, GoRouterState state) {
                    return const ShoppingListScreen();
                  },
                  routes: <RouteBase>[
                    GoRoute(
                        path: RouteValue.add.path,
                        builder: (BuildContext context, GoRouterState state) {
                          return AddSweetScreen(
                            isShop: true,
                            candy: state.extra as Candy?,
                          );
                        }),
                  ])
            ]),
        StatefulShellBranch(
            navigatorKey: _historyNavigatorKey,
            routes: <RouteBase>[
              GoRoute(
                  path: RouteValue.history.path,
                  builder: (BuildContext context, GoRouterState state) {
                    return const HistoryScreen();
                  })
            ]),
        StatefulShellBranch(
            navigatorKey: _confirmationNavigatorKey,
            routes: <RouteBase>[
              GoRoute(
                  path: RouteValue.confirmation.path,
                  builder: (BuildContext context, GoRouterState state) {
                    return const ConfirmationScreen();
                  })
            ]),
      ],
    ),
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      pageBuilder: (context, state, child) {
        return NoTransitionPage(
          child: CupertinoPageScaffold(
            backgroundColor: CupertinoColors.black,
            child: child,
          ),
        );
      },
      routes: <RouteBase>[
        GoRoute(
          path: RouteValue.splash.path,
          builder: (BuildContext context, GoRouterState state) {
            return const SplashScreen();
          },
        ),
      ],
    ),
  ],
);
