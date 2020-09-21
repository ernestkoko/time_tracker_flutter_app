import 'package:flutter/material.dart';

typedef ItemWidgetBuilder<T> = Widget Function( BuildContext context, T item);
class ListItemBuilder<T> extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
