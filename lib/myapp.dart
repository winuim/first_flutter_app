import 'package:flutter/cupertino.dart';

class CupertinoMyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      home: CupertinoHomePage(),
    );
  }
}

class CupertinoHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.home),
            title: Text('Home'),
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.search),
            title: Text('Search'),
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.profile_circled),
            title: Text('Profile'),
          ),
        ],
      ),
      tabBuilder: (context, index) {
        switch (index) {
          case 0:
            return CupertinoTabView(builder: (context) {
              return const CupertinoPageScaffold(
                child: CustomScrollView(
                  slivers: const <Widget>[
                    CupertinoSliverNavigationBar(
                      largeTitle: Text('Home'),
                    ),
                  ],
                ),
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
