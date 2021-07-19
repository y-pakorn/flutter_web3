part of ethers;

class Event extends Log<_EventImpl> {
  const Event._(_EventImpl impl) : super._(impl);

  factory Event.fromJS(dynamic jsObject) => Event._(jsObject);

  String get event => impl.event;

  String get eventSignature => impl.eventSignature;

  List<dynamic> get args => impl.args;

  @override
  String toString() => 'Event: $event $eventSignature with args $args';
}
