class Sprint {
  int sprintId;
  DateTime startDate;
  DateTime endDate;

  Sprint({required this.sprintId, required this.startDate, required this.endDate});

  factory Sprint.fromjson(Map<String, dynamic> json) {
    return Sprint(
      sprintId: json['sprintId'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
    );
  }

  Map<String, dynamic> tojson() {
    return {
      'sprintId': sprintId,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
    };
  }
}
