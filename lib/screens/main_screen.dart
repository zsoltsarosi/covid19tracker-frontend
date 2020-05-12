import 'package:covid19tracker/constants.dart';
import 'package:covid19tracker/pages/countries.dart';
import 'package:covid19tracker/pages/drawer.dart';
import 'package:covid19tracker/pages/news.dart';
import 'package:covid19tracker/pages/world.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  static const routeName = '/home';

  MainScreen({Key key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  PageController _pageController = new PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    final pages = <TabPage>{
      TabPage(name: 'World', icon: Icons.public, widget: World()),
      TabPage(name: 'Countries', icon: Icons.location_on, widget: Countries()),
      TabPage(name: 'News', icon: Icons.rss_feed, widget: News()),
    };

    return Stack(children: [
      Container(
        decoration: new BoxDecoration(
            gradient: new LinearGradient(
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
          title: Align(child: Text("COVID-19 Tracker"), alignment: Alignment.center),
          bottom: new CustomTabBar(
            pageController: _pageController,
            pages: pages.toList(),
          ),
          actions: <Widget>[
            Padding(
                padding: EdgeInsets.only(right: 20),
                child: GestureDetector(
                  onTap: () {},
                  child: Icon(Icons.info, size: 20),
                )),
          ],
        ),
        drawer: DrawerWidget(),
        body: new PageView(
          controller: _pageController,
          children: [for (var page in pages) page.widget],
        ),
      )
    ]);
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
