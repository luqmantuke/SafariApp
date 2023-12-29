// private navigators
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:safaritop/models/post_model.dart';
import 'package:safaritop/screens/details/details_page.dart';
import 'package:safaritop/screens/homescreen/home_screen.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final goRouter = GoRouter(
  initialLocation: '/',
  navigatorKey: _rootNavigatorKey,
  debugLogDiagnostics: true,
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/post/:id',
      builder: (context, state) => DetailsPage(post: state.extra as PostModel),
    ),
  ],
);
