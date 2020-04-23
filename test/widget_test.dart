// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:covid19tracker/helper/WorldAggregatedFeed.dart';
import 'package:covid19tracker/model/WorldAggregated.dart';
import 'package:covid19tracker/screens/MainScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mockito/mockito.dart';

class WorldAggregatedFeedMock extends Mock implements WorldAggregatedFeed {
  Future<List<WorldAggregated>> getWorldData() async {
    return Future.value(<WorldAggregated>[]);
  }
}

Widget buildTestableWidget(Widget widget) {
  return MediaQuery(data: MediaQueryData(), child: MaterialApp(home: widget));
}

void main() {
  testWidgets('Main screen smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(buildTestableWidget(MainScreen(feed: WorldAggregatedFeedMock())));
  });
}
