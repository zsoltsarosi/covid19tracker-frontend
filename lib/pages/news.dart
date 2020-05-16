import 'dart:convert';

import 'package:covid19tracker/base/future_builder_state.dart';
import 'package:covid19tracker/bloc/news/bloc.dart';
import 'package:covid19tracker/constants.dart';
import 'package:covid19tracker/model/model.dart' as model;
import 'package:covid19tracker/screens/news_reader.dart';
import 'package:covid19tracker/services/news_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class News extends StatefulWidget {
  News();

  @override
  _NewsState createState() => _NewsState();
}

class _NewsState extends FutureBuilderState<News> {
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
                                Expanded(
                                    child: Text(_getNewsDateString(news[index]), style: textTheme.caption)),
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
    return BlocProvider(
        create: (context) => NewsBloc(service: NewsService())..add(NewsFetch()),
        child: BlocBuilder<NewsBloc, NewsState>(
          builder: (context, state) {
            if (state is NewsLoaded) {
              if (state.news == null || state.news.isEmpty) {
                return super.buildNoData();
              }

              return _buildDataView(context, state.news);
            }

            if (state is NewsFailure) {
              return super
                  .buildError(state.exception, () => BlocProvider.of<NewsBloc>(context).add(NewsFetch()));
            }

            if (state is NewsInitial) {
              return super.buildLoader();
            }

            return super.buildNoData();
          },
        ));
  }
}
