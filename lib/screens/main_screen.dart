import 'package:covid19tracker/pages/countries.dart';
import 'package:covid19tracker/pages/drawer.dart';
import 'package:covid19tracker/pages/news.dart';
import 'package:covid19tracker/pages/world.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  MainScreen({Key key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  PageController _pageController = new PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    // TextTheme textTheme = Theme.of(context).textTheme;

    final pages = <TabPage>{
      TabPage(name: 'World', icon: Icons.public, widget: World()),
      TabPage(name: 'Countries', icon: Icons.details, widget: Countries()),
      TabPage(name: 'News', icon: Icons.rss_feed, widget: News()),
    };

    return Stack(children: [
      Container(
        decoration: new BoxDecoration(
            gradient: new LinearGradient(
          begin: FractionalOffset.topCenter,
          end: FractionalOffset.bottomCenter,
          colors: [
            Colors.blueGrey,
            Color.fromARGB(255, 150, 171, 182),
          ],
          stops: [0.0, 1.0],
        )),
      ),
      Scaffold(
        backgroundColor: const Color(0x00000000),
        appBar: AppBar(
          backgroundColor: const Color(0x00000000),
          elevation: 0.0,
          title: const Text("covid-19 tracker"),
          bottom: new CustomTabBar(
            pageController: _pageController,
            pageNames: [for (var page in pages) page.name],
          ),
          actions: <Widget>[
            Padding(
                padding: EdgeInsets.only(right: 20.0),
                child: GestureDetector(
                  onTap: () {},
                  child: Icon(
                    Icons.person,
                    size: 26.0,
                  ),
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
  final List<String> pageNames;

  CustomTabBar({this.pageController, this.pageNames}) : super(listenable: pageController);

  @override
  final Size preferredSize = new Size(0.0, 20.0);

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return new Container(
      height: 20.0,
      margin: const EdgeInsets.all(10.0),
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      decoration: new BoxDecoration(
        color: Colors.grey.shade800.withOpacity(0.5),
        borderRadius: new BorderRadius.circular(20.0),
      ),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: new List.generate(pageNames.length, (int index) {
          return new InkWell(
              child: new Text(pageNames[index],
                  style: textTheme.subhead.copyWith(
                    color: Colors.white.withOpacity(
                      index == pageController.page ? 1.0 : 0.2,
                    ),
                  )),
              onTap: () {
                pageController.animateToPage(
                  index,
                  curve: Curves.easeOut,
                  duration: const Duration(milliseconds: 300),
                );
              });
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
