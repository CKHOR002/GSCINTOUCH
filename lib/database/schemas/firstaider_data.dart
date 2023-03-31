import 'package:azure_cosmosdb/azure_cosmosdb_debug.dart';

class FirstAiderData extends BaseDocumentWithEtag {
  FirstAiderData({
    this.name,
    this.numberOfConsultation,
    String? id,
    this.hoursOfConsultation,
    this.progress,
  }) : // automatic id assignment for demo purposes
        // do not use this in production!
        id = id ?? 'demo_id_${DateTime.now().millisecondsSinceEpoch}';

  @override
  final String id;
  String? name;
  int? numberOfConsultation;
  int? hoursOfConsultation;
  int? progress;

  @override
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'numberOfConsultation': numberOfConsultation,
        'hoursOfConsultation': hoursOfConsultation,
        'progress': progress
      };

  static FirstAiderData build(Map json) {
    print(json);
    final firstaiderdata = FirstAiderData(
      name: json['name'],
      id: json['id']!,
      numberOfConsultation: json['numberOfConsultation'],
      hoursOfConsultation: json['hoursOfConsultation'],
      progress: json['progress'],
    );
    firstaiderdata.setEtag(json);
    return firstaiderdata;
  }
}
