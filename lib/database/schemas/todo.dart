import 'package:azure_cosmosdb/azure_cosmosdb_debug.dart';

class ToDo extends BaseDocumentWithEtag {
  ToDo(
    this.label, {
    String? id,
    this.description,
    this.dueDate,
    this.done = false,
  }) : // automatic id assignment for demo purposes
        // do not use this in production!
        id = id ?? 'demo_id_${DateTime.now().millisecondsSinceEpoch}';

  @override
  final String id;

  String label;
  String? description;
  DateTime? dueDate;
  bool done;

  @override
  Map<String, dynamic> toJson() => {
        'id': id,
        'label': label,
        'description': description,
        'due-date': dueDate?.toUtc().toIso8601String(),
        'done': done,
      };

  static ToDo build(Map json) {
    var dueDate = json['due-date'];
    if (dueDate != null) {
      dueDate = DateTime.parse(dueDate).toLocal();
    }
    final todo = ToDo(
      json['label'],
      id: json['id']!,
      description: json['description'],
      dueDate: dueDate,
      done: json['done'],
    );
    todo.setEtag(json);
    return todo;
  }
}
