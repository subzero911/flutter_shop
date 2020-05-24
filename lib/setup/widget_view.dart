import 'package:flutter/widgets.dart';

abstract class WidgetView<TWidget, TState> extends StatelessWidget {
  final TState _state;
 
  TWidget get widget => (_state as State).widget as TWidget;
 
  const WidgetView(this._state, {Key key}) : super(key: key);
 
  @override
  Widget build(BuildContext context);
}