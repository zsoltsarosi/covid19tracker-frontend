import 'dart:convert';

import 'package:covid19tracker/base/future_builder_state.dart';
import 'package:covid19tracker/constants.dart';
import 'package:covid19tracker/model/model.dart' as model;
import 'package:covid19tracker/screens/news_reader.dart';
import 'package:covid19tracker/services/news_service.dart';
import 'package:flutter/material.dart';

class News extends StatefulWidget {
  News();

  @override
  _NewsState createState() => _NewsState();
}

class _NewsState extends FutureBuilderState<News> {
  final NewsService service = NewsService();
  Future<List<model.News>> getDataFuture;

  void getData() {
    this.getDataFuture = this.service.getData();
  }

  @override
  void initState() {
    super.initState();
    this.getData();
  }

  String _getNewsDateString(model.News news) {
    var local = news.date.toLocal();
    var now = DateTime.now();
    var difference = now.difference(local);

    if (difference.inHours > 24) {
      if (difference.inDays > 1) {
        return "${difference.inDays} days ago";
      } else {
        return "${difference.inDays} day ago";
      }
    } else if (difference.inMinutes >= 60) {
      if (difference.inHours > 1) {
        return "${difference.inHours} hours ago";
      } else {
        return "${difference.inHours} hour ago";
      }
    } else {
      if (difference.inMinutes > 1) {
        return "${difference.inMinutes} minutes ago";
      } else {
        return "${difference.inMinutes} minute ago";
      }
    }
  }

  Widget _buildDataView(BuildContext context, List<model.News> news) {
    TextTheme textTheme = Theme.of(context).textTheme;

    return ListView.separated(
      itemCount: news.length,
      separatorBuilder: (BuildContext context, int index) => Divider(height: 8.0),
      itemBuilder: (context, index) {
        var margin = EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0);
        // add extra margin at the bottom
        if (index == news.length - 1) margin = EdgeInsets.fromLTRB(10, 0, 10, 10);

        return InkWell(
          onTap: () {
            Navigator.pushNamed(context, NewsReader.routeName, arguments: news[index]);
          },
          child: Container(
            height: 100.0,
            decoration: BoxDecoration(
              color: kFigureBackground,
              borderRadius: BorderRadius.circular(3.0),
            ),
            margin: margin,
            child: Row(
              children: <Widget>[
                Expanded(
                    flex: 2,
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 2, horizontal: 4),
                      child: Column(
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              // color: Colors.blue,
                              child: Text(news[index].title, style: textTheme.bodyText1),
                            ),
                          ),
                          Container(
                            // color: Colors.yellow,
                            child: Row(
                              children: <Widget>[
                                Expanded(child: Text(_getNewsDateString(news[index]), style: textTheme.caption)),
                                Text(news[index].sourceName, style: textTheme.caption)
                              ],
                            ),
                          )
                        ],
                      ),
                    )),
                Expanded(
                  flex: 1,
                  child: news[index].imgBase64 == null
                      ? SizedBox()
                      : Container(
                          // color: Colors.red,
                          decoration: BoxDecoration(
                          image: DecorationImage(
                              image: MemoryImage(base64Decode(news[index].imgBase64)), fit: BoxFit.cover),
                        )),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<model.News>>(
      future: this.getDataFuture,
      builder: (BuildContext context, AsyncSnapshot<List<model.News>> snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return super.buildLoader();
        }
        if (snapshot.hasError) {
          return super.buildError(snapshot.error);
        }
        if (snapshot.hasData) {
          return _buildDataView(context, snapshot.data);
        }

        return super.buildNoData();
      },
    );
  }
}
