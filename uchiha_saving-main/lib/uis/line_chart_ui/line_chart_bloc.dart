import 'dart:async';

class LineChartBloc {
  StreamController<DateTime> _controller =
      StreamController<DateTime>.broadcast();

  Stream<DateTime> get stream => _controller.stream.asBroadcastStream();

  get dispose => _controller.close();

  update({required DateTime dateTime}) {
    _controller.sink.add(dateTime);
  }
}
