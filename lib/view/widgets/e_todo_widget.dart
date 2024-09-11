import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sqlite_crud/domain/todo.dart';

class CreateTodoWidget extends StatefulWidget {
  final ToDo? toDo;
  final ValueChanged<String> onSubmit;

  const CreateTodoWidget({super.key, this.toDo, required this.onSubmit});

  @override
  State<CreateTodoWidget> createState() => _CreateTodoWidgetState();
}

class _CreateTodoWidgetState extends State<CreateTodoWidget> {
  final TextEditingController _controller = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // Устанавливаем начальный текст с помощью _controller.text
    _controller.text = widget.toDo?.title ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.toDo != null;
    return AlertDialog(
      title: Text(isEditing ? 'Edit todo' : 'Add todo'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          // Чтобы размер колонки соответствовал содержимому
          children: [
            TextFormField(
              controller: _controller,
              decoration: const InputDecoration(labelText: 'Title'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a title';
                }
                return null;
              },
            ),
            SizedBox(height: 16.0),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            if (_formKey.currentState?.validate() == true) {
              widget.onSubmit(_controller.text);
            }
          },
          child: const Text('ok'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context), // Закрывает диалоговое окно
          child: const Text('Cancel'),
        ),
      ],
    );
  }
}
