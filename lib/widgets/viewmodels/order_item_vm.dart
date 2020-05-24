import 'dart:async';

class OrderItemVm {
  bool _expanded = false;

  final _orderItemController = StreamController<bool>.broadcast();  
  Stream<bool> get expanded => _orderItemController.stream;

  void onTilePressed() {    
    _expanded = !_expanded;       
    _orderItemController.sink.add(_expanded);
  }

  void dispose() {
    _orderItemController.close();
  }
}