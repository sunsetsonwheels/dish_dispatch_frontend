import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';

class RootNavigation extends StatelessWidget {
  const RootNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    final tabPage = TabPage.of(context);
    bool isVertical = MediaQuery.of(context).size.width < 640;

    return Scaffold(
      body: Row(
        children: [
          if (!isVertical)
            NavigationRail(
              selectedIndex: tabPage.index,
              destinations: const [
                NavigationRailDestination(
                  icon: Icon(Icons.restaurant),
                  label: Text("Restaurants"),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.trolley),
                  label: Text("Cart"),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.account_box),
                  label: Text("Orders"),
                ),
              ],
              onDestinationSelected: (value) => tabPage.index = value,
              groupAlignment: 0,
              labelType: NavigationRailLabelType.all,
            ),
          if (!isVertical)
            const VerticalDivider(
              width: 1,
              thickness: 1,
            ),
          Expanded(
            child: TabBarView(
              controller: tabPage.controller,
              children: [
                for (final stack in tabPage.stacks)
                  PageStackNavigator(stack: stack)
              ],
            ),
          )
        ],
      ),
      bottomNavigationBar: isVertical
          ? NavigationBar(
              selectedIndex: tabPage.index,
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.restaurant),
                  label: "Restaurants",
                ),
                NavigationDestination(
                  icon: Icon(Icons.trolley),
                  label: "Cart",
                ),
                NavigationDestination(
                  icon: Icon(Icons.account_box),
                  label: "Orders",
                ),
              ],
              onDestinationSelected: (value) => tabPage.index = value,
            )
          : null,
    );
  }
}
