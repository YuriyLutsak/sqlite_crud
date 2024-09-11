class ToDo {
  final int id;
  final String title;
  final String createAt;
  final String? updateAt;

  ToDo({
    required this.id,
    required this.title,
    required this.createAt,
    this.updateAt,
  });

  factory ToDo.fromSqfliteDatabase(Map<String, dynamic> map) => ToDo(
        id: map['id']?.toInt() ?? 0,
        title: map['title'] ?? '',
        createAt: DateTime.fromMillisecondsSinceEpoch(map['created_at'])
            .toIso8601String(),
        updateAt: map['updated_at'] == null
            ? null
            : DateTime.fromMillisecondsSinceEpoch(map['updated_at'])
                .toIso8601String(),
      );
}
