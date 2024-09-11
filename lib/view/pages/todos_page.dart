import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sqlite_crud/data/todo_db.dart';
import 'package:intl/intl.dart'; // Импортируем DateFormat
import '../../domain/todo.dart';
import '../widgets/e_todo_widget.dart';

class TodosPage extends StatefulWidget {
  const TodosPage({super.key});

  @override
  State<TodosPage> createState() => _TodosPageState();
}

class _TodosPageState extends State<TodosPage> {
  Future<List<ToDo>>? futureTodos;
  final todoDB = TodoDB();

  @override
  void initState() {
    super.initState();
    fetchTodos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ToDo List'),
      ),
      body: FutureBuilder<List<ToDo>>(
        future: futureTodos,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator()); // Центрируем индикатор загрузки
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}')); // Показываем ошибку, если есть
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No todos...')); // Показываем сообщение, если нет данных
          } else {
            final todos = snapshot.data!;
            return ListView.separated(
              itemBuilder: (context, index) {
                final todo = todos[index];
                final subTitle = DateFormat('yyyy/MM/dd').format(
                  DateTime.parse(todo.updateAt ?? todo.createAt),
                );
                return ListTile(
                  title: Text(todo.title),
                  subtitle: Text(subTitle),
                  trailing: IconButton(
                    onPressed: () async {
                      await todoDB.delete(todo.id);
                      fetchTodos();
                    },
                    icon: Icon(Icons.delete),
                  ),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => CreateTodoWidget(
                        toDo: todo, // Передаем задачу для редактирования
                        onSubmit: (title) async {
                          await todoDB.update(id: todo.id, title: title);
                          fetchTodos();
                          if (mounted) Navigator.of(context).pop();
                        },
                      ),
                    );
                  },
                );
              },
              separatorBuilder: (context, index) => SizedBox(height: 12),
              itemCount: todos.length,
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (_) => CreateTodoWidget(
              onSubmit: (String title) async {
                await todoDB.create(title: title); // Сохраняем новую задачу в базе данных
                if (mounted) {
                  fetchTodos(); // Обновляем список задач
                  Navigator.of(context).pop(); // Закрываем диалоговое окно
                }
              },
            ),
          );
        },
        child: Icon(Icons.add), // Добавляем иконку к кнопке
      ),
    );
  }

  void fetchTodos() {
    setState(() {
      futureTodos = todoDB.fetchAll(); // Обновляем Future
    });
  }
}
