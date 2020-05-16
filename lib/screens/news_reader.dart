import 'dart:async';

import 'package:covid19tracker/model/model.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class NewsReader extends StatefulWidget {
  static const routeName = '/news_reader';

  NewsReader({Key key}) : super(key: key);

  @override
  _NewsReaderState createState() => _NewsReaderState();
}

class _NewsReaderState extends State<NewsReader> {
  Completer<WebViewController> _controller = Completer<WebViewController>();

  @override
  Widget build(BuildContext context) {
    final News news = ModalRoute.of(context).settings.arguments;

    var url = news.endUrl;
    if (url == null) url = news.link;
    print('loading: $url');

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(40.0),
        child: AppBar(
          title: Align(child: Text(news.title), alignment: Alignment.center),
          actions: <Widget>[],
        ),
      ),
      body: SizedBox.expand(
        child: WebView(
          initialUrl: url,
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (WebViewController webViewController) {
            _controller.complete(webViewController);
          },
        ),
      ),
    );
  }
}
