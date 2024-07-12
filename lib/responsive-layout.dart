import 'package:flutter/material.dart';

class Layout {
  final Widget body;
  final double breakpoint;
  const Layout({required this.body, required this.breakpoint});
}

class ResponsiveLayout extends StatelessWidget {
  final List<Layout> layouts;

  ResponsiveLayout({
    super.key,
    required this.layouts,
  }) {
    if (layouts.isEmpty) {
      throw Exception('ResponsiveLayout Error (1): list of layouts is empty');
    }
    // sort layouts in ascending order or breakpoints
    layouts.sort(
      (layout1, layout2) => layout1.breakpoint.compareTo(layout2.breakpoint),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      Layout currentLayout = layouts.firstWhere(
        (element) => constraints.maxWidth < element.breakpoint,
        orElse: () => layouts.last,
      );
      return currentLayout.body;
    });
  }
}
