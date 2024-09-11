import 'package:flutter/widgets.dart';
import 'package:sqlite_crud/simple_code_crud/domain/entity/dog.dart';

import 'data/data_service.dart';

void main() async {
  // Избегаем ошибок, вызванных обновлением Flutter.
  // Импортирование 'package:flutter/widgets.dart' обязательно.
  WidgetsFlutterBinding.ensureInitialized();

  var fido = Dog(id: 0, name: 'Fido', age: 35);

  await insertDog(fido);
  print(await getAllDogs());

  fido = Dog(id: fido.id, name: fido.name, age: fido.age + 7);
  await updateDog(fido);
  print(await getAllDogs()); // Печатает Fido с возрастом 42.

  await deleteDog(fido.id);
  print(await getAllDogs());
}
