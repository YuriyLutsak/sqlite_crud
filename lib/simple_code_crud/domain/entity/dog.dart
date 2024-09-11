
class Dog {
  final int id;
  final String name;
  final int age;

  Dog({
    required this.id,
    required this.name,
    required this.age,
  });

  // Преобразовать собаку в Map. Ключи должны соответствовать названиям
  // колонок в базе данных.
  Map<String, Object?> toMap() {
    return {
      'id': id,
      'name': name,
      'age': age,
    };
  }

  // Реализуйте toString, чтобы было легче увидеть информацию о
  // каждой собаке при использовании оператора print.
  @override
  String toString() {
    return 'Dog{id: $id, name: $name, age: $age}';
  }
}
