import 'package:flutter_riverpod/flutter_riverpod.dart';

class Todo {
  const Todo(this.title, {required this.id, this.done = false});

  final String id;
  final String title;
  final bool done;

  Todo copyWith({String? id, String? title, bool? done}) =>
      Todo(title ?? this.title, id: id ?? this.id, done: done ?? this.done);
}

class TodoListNotifier extends Notifier<List<Todo>> {
  int _nextId = 1;

  @override
  List<Todo> build() => const [];

  void add(String title) {
    final nextTodo = Todo(title, id: '${_nextId++}');
    state = [...state, nextTodo];
  }

  void toggle(int index) {
    final todos = [...state];
    todos[index] = todos[index].copyWith(done: !todos[index].done);
    state = todos;
  }

  void toggleById(String id) {
    state = [
      for (final todo in state)
        if (todo.id == id) todo.copyWith(done: !todo.done) else todo,
    ];
  }

  void remove(int index) => state = [...state]..removeAt(index);

  void removeById(String id) =>
      state = state.where((todo) => todo.id != id).toList();
}

final todoListProvider = NotifierProvider<TodoListNotifier, List<Todo>>(
  TodoListNotifier.new,
);

enum TodoFilter { all, pendingOnly }

class TodoFilterNotifier extends Notifier<TodoFilter> {
  @override
  TodoFilter build() => TodoFilter.all;

  void setFilter(TodoFilter filter) => state = filter;
}

final todoFilterProvider = NotifierProvider<TodoFilterNotifier, TodoFilter>(
  TodoFilterNotifier.new,
);

/// Provider turunan untuk memfilter daftar ToDo tanpa mutasi list asli.
final filteredTodosProvider = Provider<List<Todo>>((ref) {
  final todos = ref.watch(todoListProvider);
  final filter = ref.watch(todoFilterProvider);
  return switch (filter) {
    TodoFilter.all => todos,
    TodoFilter.pendingOnly => todos.where((todo) => !todo.done).toList(),
  };
});
