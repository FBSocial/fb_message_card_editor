import 'package:event_bus/event_bus.dart';

class RemoveOverlayNotifier {
  RemoveOverlayNotifier._();

  static final RemoveOverlayNotifier instance = RemoveOverlayNotifier._();

  EventBus eventBus = EventBus();

  void emit(RemoveOverlayEvent event) {
    eventBus.fire(event);
  }

  void listen(void Function(RemoveOverlayEvent event) onData) {
    eventBus.on<RemoveOverlayEvent>().listen(onData);
  }
}

class RemoveOverlayEvent {

  bool remove;

  RemoveOverlayEvent({this.remove = false});
}
