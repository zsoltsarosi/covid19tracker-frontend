import 'package:covid19tracker/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';

class InformationPage extends StatelessWidget {
  Future<String> readFile() async {
    try {
      return await rootBundle.loadString('assets/text/information.md');
    } catch (e) {
      return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Container(color: kMainBgGradient1),
      Scaffold(
          backgroundColor: const Color(0x00000000),
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(40.0),
            child: AppBar(
              title: Text("Information and Tips"),
            ),
          ),
          body: SafeArea(
              child: Theme(
                  data: ThemeData(brightness: Brightness.dark),
                  child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FutureBuilder(
                        future: readFile(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState != ConnectionState.done) {
                            return Container(width: 0.0, height: 0.0);
                          }
                          if (snapshot.hasError) {
                            return Container(width: 0.0, height: 0.0);
                          }
                          if (snapshot.hasData) {
                            return Container(
                                child: Markdown(
                              data: snapshot.data,
                              styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
                                textAlign: WrapAlignment.spaceBetween,
                                unorderedListAlign: WrapAlignment.spaceBetween,
                                h1Align: WrapAlignment.center,
                                blockquote: TextStyle(color: Colors.red),
                                a: TextStyle(color: Colors.black, decoration: TextDecoration.underline),
                              ),
                              onTapLink: (link) async {
                                if (await canLaunch(link)) {
                                  await launch(link);
                                }
                              },
                            ));
                          }

                          return Container(width: 0.0, height: 0.0);
                        },
                      ))))),
    ]);
  }
}
