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
    final theme = Theme.of(context);
    final currentPage = (_pages[_currentIndex] as PageInfos);

    final scaffold = Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surfaceContainer,
        foregroundColor: theme.colorScheme.onSurface,
        title: currentPage.getPageType() == PageType.normal
            ? Text(
                currentPage.getTitle(context),
                style: TextStyle(color: theme.colorScheme.onSurface),
              )
            : null,
        titleTextStyle: theme.textTheme.headlineMedium,
        flexibleSpace: currentPage.getPageType() == PageType.tabs
            ? Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [TabBar(tabs: currentPage.getTabs(context))],
              )
            : null,
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: NavigationBar(
        destinations: _pages.map((item) {
          var page = item as PageInfos;
          return NavigationDestination(
            icon: Icon(page.getIcon()),
            selectedIcon: Icon(page.getIcon(), fill: 1),
            label: page.getTitle(context),
          );
        }).toList(),
        selectedIndex: _currentIndex,
        onDestinationSelected: (int index) {
          setState(() => _currentIndex = index);
        },
      ),
      floatingActionButton: currentPage.getFAB(context),
    );

    if (currentPage.getPageType() == PageType.tabs) {
      return DefaultTabController(
        length: currentPage.getTabs(context).length,
        child: scaffold,
      );
    } else {
      return scaffold;
    }
  }
}
