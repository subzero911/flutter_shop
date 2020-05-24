import 'package:flutter/widgets.dart';

abstract class StatelessView<TWidget> extends StatelessWidget {
  final TWidget widget;
 
  const StatelessView(this.widget, {Key key}) : super(key: key);
 
  @override
  Widget build(BuildContext context);
}