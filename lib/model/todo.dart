class ToDo {
  String? id;
  String? todoText;
  String? description; // Add this line
  DateTime? expirationDate; // Add this line
  bool isDone;

  ToDo({
    required this.id,
    required this.todoText,
    this.description, // Add this line
    this.expirationDate, // Add this line
    this.isDone = false,
  });

  static List<ToDo> todoList() {
    return [
      ToDo(id: '01', todoText: 'Morning Exercise', isDone: true, description: 'Start the day with a workout', expirationDate: DateTime.now().add(Duration(days: 1))),
      ToDo(id: '02', todoText: 'Buy Groceries', isDone: true, description: 'Milk, eggs, bread', expirationDate: DateTime.now().add(Duration(days: 3))),
      ToDo(id: '03', todoText: 'Check Emails', expirationDate: DateTime.now().add(Duration(days: 2))),
      ToDo(id: '04', todoText: 'Team Meeting', expirationDate: DateTime.now().add(Duration(days: 5))),
      ToDo(id: '05', todoText: 'Work on mobile apps for 2 hours', description: 'Flutter project', expirationDate: DateTime.now().add(Duration(days: 7))),
      ToDo(id: '06', todoText: 'Dinner with Jenny', expirationDate: DateTime.now().add(Duration(days: 1))),
    ];
  }
}
