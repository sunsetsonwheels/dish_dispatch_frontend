import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';

class TabViewWrapper extends StatelessWidget {
  const TabViewWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final tabPage = TabPage.of(context);

    return Expanded(
      child: TabBarView(
        physics: const NeverScrollableScrollPhysics(),
        controller: tabPage.controller,
        children: [
          for (final stack in tabPage.stacks) PageStackNavigator(stack: stack)
        ],
      ),
    );
  }
}
