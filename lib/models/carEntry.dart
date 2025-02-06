enum EntryType { visitor, residential }

class CarEntry {
  final String numberPlate;
  final DateTime entryTime;
  final DateTime? exitTime; // Nullable for cases where exit time is not recorded yet
  final EntryType entryType; // Enum for visitor or residential

  CarEntry({
    required this.numberPlate,
    required this.entryTime,
    this.exitTime,
    required this.entryType,
  });

  Map<String, dynamic> toJson() => {
    'numberPlate': numberPlate,
    'entryTime': entryTime.toIso8601String(),
    'exitTime': exitTime?.toIso8601String(), // Null-safe conversion
    'entryType': entryType.toString().split('.').last, // Store as string in JSON
  };

  factory CarEntry.fromJson(Map<String, dynamic> json) {
    return CarEntry(
      numberPlate: json['numberPlate'],
      entryTime: DateTime.parse(json['entryTime']),
      exitTime: json['exitTime'] != null ? DateTime.parse(json['exitTime']) : null,
      entryType: EntryType.values.firstWhere(
              (e) => e.toString().split('.').last == json['entryType']),
    );
  }
}



// {
// "numberPlate": "UP32AB1234",
// "entryTime": "2025-02-06T10:00:00.000Z",
// "exitTime": null,
// "entryType": "visitor"
// }
