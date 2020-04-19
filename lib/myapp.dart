import 'package:first_flutter_app/home_tab.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'home_tab.dart';

class CupertinoMyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en'),
        const Locale('ja'),
      ],
      home: CupertinoHomePage(),
    );
  }
}

class _TabInfo {
  const _TabInfo(this.title, this.icon);

  final String title;
  final IconData icon;
}

class CupertinoHomePage extends StatelessWidget {
  final List<_TabInfo> _tabInfo = [
    _TabInfo('Home', CupertinoIcons.home),
    _TabInfo('Search', CupertinoIcons.search),
    _TabInfo('Profile', CupertinoIcons.profile_circled),
  ];

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(items: [
        for (final tabInfo in _tabInfo)
          BottomNavigationBarItem(
            icon: Icon(tabInfo.icon),
            title: Text(tabInfo.title),
          )
      ]),
      tabBuilder: (context, index) {
        switch (index) {
          case 0:
            return CupertinoTabView(builder: (context) {
              return CupertinoPageScaffold(
                child: HomeTab(),
              );
            });
          case 1:
            return CupertinoTabView(builder: (context) {
              return const CupertinoPageScaffold(
                child: CustomScrollView(
                  slivers: const <Widget>[
                    CupertinoSliverNavigationBar(
                      largeTitle: Text('Search'),
                    ),
                  ],
                ),
              );
            });
          case 2:
            return CupertinoTabView(builder: (context) {
              return const CupertinoPageScaffold(
                child: CustomScrollView(
                  slivers: const <Widget>[
                    CupertinoSliverNavigationBar(
                      largeTitle: Text('Profile'),
                    ),
                  ],
                ),
              );
            });
        }
      },
    );
  }
}
