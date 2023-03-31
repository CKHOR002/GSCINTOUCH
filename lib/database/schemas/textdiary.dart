import 'package:cloud_firestore/cloud_firestore.dart';

class TextDiaryEntryData {
  TextDiaryEntryData(
      {this.id,
      required this.details,
      required this.monthyear,
      required this.date,
      required this.time,
      this.sentimentscore,
      this.dateTime,
      required this.day,
      this.user_id});
  String? id;
  final String? details;
  final String? date;
  final int? sentimentscore;
  final String? monthyear;
  final String? time;
  final String? day;
  final DateTime? dateTime;
  final String? user_id;
}

class TextDiaryData {
  final String? details;
  final String? date;
  final String? time;
  final int? sentimentScore;
  final String? user_id;

  TextDiaryData(
      {this.details, this.date, this.time, this.sentimentScore, this.user_id});

  factory TextDiaryData.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return TextDiaryData(
        details: data?['details'],
        date: data?['date'],
        time: data?['time'],
        sentimentScore: data?['sentimentScore'],
        user_id: data?['user_id']);
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (details != null) "details": details,
      if (date != null) "date": date,
      if (time != null) "time": time,
      if (sentimentScore != null) "sentimentScore": sentimentScore,
      if (user_id != null) "user_id": user_id,
    };
  }
}
