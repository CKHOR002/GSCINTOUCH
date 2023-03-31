import 'package:azure_cosmosdb/azure_cosmosdb_debug.dart';

class VideoDiaryData extends BaseDocumentWithEtag {
  VideoDiaryData(
      {required this.userId,
      required this.date,
      required this.time,
      required this.videoUrl,
      String? id})
      : id = id ?? 'demo_id_${DateTime.now().millisecondsSinceEpoch}';

  final String id;
  String userId;
  String date;
  String time;
  String videoUrl;

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'date': date,
        'time': time,
        'videoUrl': videoUrl
      };

  static VideoDiaryData build(Map json) {
    print(json);
    final videoDairyData = VideoDiaryData(
        userId: json['userId'],
        date: json['date'],
        time: json['time'],
        videoUrl: json['videoUrl']);

    videoDairyData.setEtag(json);
    return videoDairyData;
  }
}

class VideoDiaryEntryData {
  VideoDiaryEntryData(
      {required this.id,
      required this.userId,
      required this.date,
      required this.time,
      required this.videoUrl});

  final String id;
  final String? userId;
  final String? date;
  final String? time;
  final String? videoUrl;
}
