import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:socially/views/responsive/moblie_layout.dart';
import 'package:socially/views/responsive/responsive_layout.dart';
import 'package:socially/views/responsive/web_layout.dart';

class RouterClass{
  final router = GoRouter(
    initialLocation: "/",
    errorBuilder: (context, state) {
      return Scaffold(
        body: Center(
          child: Text("This Page Not Found"),
        ),
      );
    },
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const ResponsiveScreenLayout(
          mobileScreenLayout: MobileScreenLayout(),
          webScreenLayout: WebSceenLayout(),
        ),
      ),
    ],
  );
}