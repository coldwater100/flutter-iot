class Event {
  final String event; // ✅ 'type' → 'event'
  final String? value; // ✅ 'action' → 'value'
  final String? source;

  Event({
    required this.event,
    this.value,
    this.source,
  });

  /// JSON → Event
  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      event: json['event'] ?? '',
      value: json['value'] as String?,
      source: json['source'] as String?,
    );
  }

  /// Event → JSON
  Map<String, dynamic> toJson() {
    return {
      'event': event,
      'value': value,
      'source': source,
    };
  }

  @override
  String toString() {
    return 'Event(event: $event, value: $value, source: $source)';
  }
}
