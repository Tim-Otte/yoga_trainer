import 'package:flutter/material.dart';
import 'package:yoga_trainer/pages/poses.dart';
import 'package:yoga_trainer/pages/settings.dart';
import 'package:yoga_trainer/pages/page_infos.dart';
import 'package:yoga_trainer/pages/workouts.dart';

class Layout extends StatefulWidget {
  const Layout({super.key});

  @override
  State<Layout> createState() => _LayoutState();
}

class _LayoutState extends State<Layout> {
  int _currentIndex = 0;
  final _pages = [WorkoutsPage(), PosesPage(), SettingsPage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
        title: Text((_pages[_currentIndex] as PageInfos).getTitle(context)),
        titleTextStyle: Theme.of(context).textTheme.headlineMedium,
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: NavigationBar(
        destinations: _pages.map((item) {
          var page = item as PageInfos;
          return NavigationDestination(
            icon: Icon(page.getIcon()),
            label: page.getTitle(context),
          );
        }).toList(),
        selectedIndex: _currentIndex,
        onDestinationSelected: (int index) {
          setState(() => _currentIndex = index);
        },
      ),
      floatingActionButton: (_pages[_currentIndex] as PageInfos).getFAB(
        context,
      ),
    );
  }
}
