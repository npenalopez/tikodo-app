/// {@template todo}
/// Model for a todo.
/// {@endtemplate}
class Todo {
  /// {@macro todo}
  Todo({
    required this.id,
    required this.description,
    required this.done,
  });

  /// The id of this todo.
  late final int id;

  /// The description of this todo.
  late final String description;

  /// The status of this todo.
  late final bool done;

  Todo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    description = json['description'];
    done = json['done'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['description'] = description;
    data['done'] = done;
    return data;
  }
}
