import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

abstract class FutureBuilderState<T extends StatefulWidget> extends State<T> {

  @protected
  void getData() {
  }

  @protected
  Widget buildLoader() {
    return Center(
        child: SizedBox(
      child: CircularProgressIndicator(),
      width: 20,
      height: 20,
    ));
  }
  
  @protected
  Widget buildError(Object error) {
    print('error: $error');
    return Column(
      children: <Widget>[
        Text('Error loading data'),
        IconButton(
            icon: Icon(Icons.refresh, color: Colors.black, size: 20),
            onPressed: () {
              this.getData();
              setState(() {});
            }),
      ],
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
    );
  }

  @protected
  Widget buildNoData() {
    return Container(width: 0.0, height: 0.0);
  }
}