import 'package:flutter/material.dart';

class Layout {
  final Widget body;
  final double breakpoint;
  const Layout({required this.body, required this.breakpoint});
}

class ResponsiveLayout extends StatelessWidget {
  final List<Layout> layouts;

  const ResponsiveLayout({
    super.key,
    required this.layouts,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      Layout currentLayout = this.layouts.firstWhere((element) => constraints.maxWidth < element.breakpoint);
      return currentLayout.body;
    });
  }
}
