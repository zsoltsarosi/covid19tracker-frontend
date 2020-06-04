import 'dart:io';

import 'package:covid19tracker/constants.dart';
import 'package:covid19tracker/helper/app_config.dart';
import 'package:covid19tracker/localization/translations.dart';
import 'package:covid19tracker/pages/animated_drawer.dart';
import 'package:covid19tracker/pages/countries.dart';
import 'package:covid19tracker/pages/information.dart';
import 'package:covid19tracker/pages/news.dart';
import 'package:covid19tracker/pages/world.dart';
import 'package:covid19tracker/services/version_update_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:store_redirect/store_redirect.dart';

class MainScreen extends StatefulWidget {
  static const routeName = '/home';

  MainScreen({Key key}) : super(key: key);

  static _MainScreenState of(BuildContext context) => context.findAncestorStateOfType<_MainScreenState>();

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  PageController _pageController = PageController(initialPage: 0);
  VersionExpiration _versionExpiration;

  void selectPage(int pageIndex) => _pageController.jumpToPage(pageIndex);

  @override
  void initState() {
    super.initState();

    var expirationOp = VersionUpdateService().checkExpired();
    expirationOp.then((value) {
      _versionExpiration = value;
      if (_versionExpiration == VersionExpiration.ExiresSoon ||
          _versionExpiration == VersionExpiration.Expired) {
        WidgetsBinding.instance.addPostFrameCallback((callback) {
          _showVersionDialog(context);
        });
      }
    });
  }

  _launchStore() {
    StoreRedirect.redirect(androidAppId: AppConfig.androidAppId, iOSAppId: AppConfig.iOSAppId);
  }

  _showVersionDialog(context) {
    if (_versionExpiration == null || _versionExpiration == VersionExpiration.NotExpired) return;

    var tr = Translations.of(context);

    var actions = <Widget>[
      FlatButton(
        child: Text(tr.modal_ok),
        onPressed: () => _launchStore(),
      )
    ];
    if (_versionExpiration == VersionExpiration.ExiresSoon) {
      actions.add(FlatButton(
        child: Text(tr.modal_cancel),
        onPressed: () => Navigator.pop(context),
      ));
    }

    var dialogWidget = Platform.isIOS
        ? CupertinoAlertDialog(
            title: Text(tr.update_title),
            content: Text(tr.update_available),
            actions: actions,
          )
        : AlertDialog(
            title: Text(tr.update_title),
            content: Text(tr.update_available),
            actions: actions,
          );

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: dialogWidget,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var tr = Translations.of(context);

    final pages = <TabPage>{
      TabPage(name: tr.pageWorld, icon: Icons.public, widget: World()),
      TabPage(name: tr.pageCountries, icon: Icons.location_on, widget: Countries()),
      TabPage(name: tr.pageNews, icon: Icons.rss_feed, widget: News()),
    };

    return AnimatedDrawer(
      child: Stack(children: [
        Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
            begin: FractionalOffset.topCenter,
            end: FractionalOffset.bottomCenter,
            colors: [
              kMainBgGradient1,
              kMainBgGradient2,
            ],
            stops: [0.0, 1.0],
          )),
        ),
        Scaffold(
          backgroundColor: const Color(0x00000000),
          appBar: AppBar(
            backgroundColor: const Color(0x00000000),
            elevation: 0.0,
            title: Center(child: Text(Translations.of(context).title)),
            leading: Builder(
              builder: (context) {
                return IconButton(
                  icon: Icon(Icons.menu, size: 30),
                  onPressed: () => AnimatedDrawer.of(context).toggleDrawer(),
                );
              },
            ),
            bottom: CustomTabBar(
              pageController: _pageController,
              pages: pages.toList(),
            ),
            actions: <Widget>[
              Padding(
                  padding: EdgeInsets.only(right: 20),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => InformationPage(),
                        ),
                      );
                    },
                    child: Icon(Icons.info, size: 30),
                  )),
            ],
          ),
          body: PageView(
            controller: _pageController,
            children: [for (var page in pages) page.widget],
          ),
        )
      ]),
    );
  }
}

class CustomTabBar extends AnimatedWidget implements PreferredSizeWidget {
  final PageController pageController;
  final List<TabPage> pages;

  CustomTabBar({this.pageController, this.pages}) : super(listenable: pageController);

  @override
  final Size preferredSize = new Size(0.0, 60.0);

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    return Container(
      height: 60.0,
      margin: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: Colors.grey.shade800.withOpacity(0.5),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(pages.length, (int index) {
          final alignment = index == 0
              ? Alignment.centerLeft
              : index == pages.length - 1 ? Alignment.centerRight : Alignment.center;

          int currentPage =
              pageController.page == null ? pageController.initialPage : pageController.page.round();
          final itemColor = Colors.white.withOpacity(index == currentPage ? 1.0 : 0.2);
          return Expanded(
            flex: 1,
            child: InkWell(
                child: Align(
                  alignment: alignment,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Icon(pages[index].icon, size: 30, color: itemColor),
                        Text(pages[index].name, style: textTheme.bodyText1.copyWith(color: itemColor)),
                      ],
                    ),
                  ),
                ),
                onTap: () {
                  AnimatedDrawer.of(context).close();
                  pageController.animateToPage(
                    index,
                    curve: Curves.easeOut,
                    duration: const Duration(milliseconds: 300),
                  );
                }),
          );
        }).toList(),
      ),
    );
  }
}

class TabPage {
  final String name;
  final IconData icon;
  final Widget widget;

  TabPage({this.name, this.icon, this.widget});
}
