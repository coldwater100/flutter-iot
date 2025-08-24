class Event {
  final String type;
  final String? action;
  final String? source;
  final dynamic data;

  Event({
    required this.type,
    this.action,
    this.source,
    this.data,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      type: json['type'] ?? '',
      action: json['action'],
      source: json['source'],
      data: json['data'],
    );
  }
}
