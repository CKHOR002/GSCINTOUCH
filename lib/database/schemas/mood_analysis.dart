import 'package:cloud_firestore/cloud_firestore.dart';

// class MoodAnalysisData {
//   MoodAnalysisData(
//       {required this.consultationId,
//       required this.sentimentList,
//       String? id,
//       required this.overallSentiment,
//       required this.moodChart})
//       : id = id ?? 'demo_id_${DateTime.now().millisecondsSinceEpoch}';
//
//   final String id;
//   String consultationId;
//   List<double> sentimentList;
//   double overallSentiment;
//   Map<String, dynamic> moodChart;
//
//   factory MoodAnalysisData.fromFirestore(
//       DocumentSnapshot<Map<String, dynamic>> snapshot,
//       SnapshotOptions? options) {
//     final data = snapshot.data();
//     return MoodAnalysisData(
//       id: data?['id'],
//       consultationId: data?['consultationId'],
//       sentimentList: data?['sentimentValue'],
//       overallSentiment: data?['overallSentiment'],
//       moodChart: data?['moodChart'],
//     );
//   }
//
//   Map<String, dynamic> toFirestore() {
//     return {
//       "id": id,
//       "consultationId": consultationId,
//       "sentimentValue": sentimentList,
//       "overallSentiment": overallSentiment,
//       "moodChart": moodChart
//     };
//   }
// }

class MoodAnalysisData {
  MoodAnalysisData(
      {required this.consultationId, String? id, required this.moodChart})
      : id = id ?? 'demo_id_${DateTime.now().millisecondsSinceEpoch}';

  final String id;
  String consultationId;
  Map<String, dynamic> moodChart;

  factory MoodAnalysisData.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options) {
    final data = snapshot.data();
    return MoodAnalysisData(
      id: data?['id'],
      consultationId: data?['consultationId'],
      moodChart: data?['moodChart'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {"id": id, "consultationId": consultationId, "moodChart": moodChart};
  }
}
