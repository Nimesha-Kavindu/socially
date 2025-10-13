import 'package:flutter/material.dart';
import 'package:socially/utils/constants/app_constants.dart';

class ResponsiveScreenLayout extends StatefulWidget {
  final Widget mobileScreenLayout;
  final Widget webScreenLayout;
  const ResponsiveScreenLayout(
    {
      super.key,
      required this.mobileScreenLayout,
      required this.webScreenLayout
    });

  @override
  State<ResponsiveScreenLayout> createState() => _ResponsiveScreenLayoutState();
}

class _ResponsiveScreenLayoutState extends State<ResponsiveScreenLayout> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < webScreenMinWidth) {
          return widget.mobileScreenLayout;
        } else {
          return widget.webScreenLayout;
        }
      },
    );
  }
}