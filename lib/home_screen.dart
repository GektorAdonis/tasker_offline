import 'package:flutter/material.dart';
import 'package:tasker_offline/database_helper.dart';
import 'package:tasker_offline/task.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void _selectTime(BuildContext context, Task task, DateTime date) async {
    final TimeOfDay? selectedTime =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());
    date = DateTime(date.year, date.month, date.day, selectedTime!.hour,
        selectedTime.minute);
    task.date = date;
  }

  void _showModal(BuildContext context) {
    Task _newTask = Task(title: '', date: DateTime.now());
    var _titleController = TextEditingController();
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return Center(
            child: Column(
              children: [
                TextField(
                  controller: _titleController,
                  keyboardType: TextInputType.text,
                  onSubmitted: (title) {
                    _newTask.title = title;
                  },
                ),
                CalendarDatePicker(
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.utc(DateTime.now().year + 10),
                    onDateChanged: (date) {
                      _selectTime(context, _newTask, date);
                    }),
                ElevatedButton(
                    onPressed: () {
                      setState(() {
                        DatabaseHelper.instance.add(_newTask);
                        _titleController.clear();
                      });
                      Navigator.pop(context);
                    },
                    child: const Text('ADD'))
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tasker'),
      ),
      body: SafeArea(
        top: true,
        child: Center(
          child: FutureBuilder(
            future: DatabaseHelper.instance.getTasks(),
            builder: (context, AsyncSnapshot<List<Task>> snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return snapshot.data!.isEmpty
                  ? const Center(
                      child: Text('No tasks yet'),
                    )
                  : ListView(
                      children: snapshot.data!.map((task) {
                        return ListTile(
                          leading: IconButton(
                            onPressed: () {
                              setState(() {
                                if (task.isComplete == 0) {
                                  task.isComplete = 1;
                                } else {
                                  task.isComplete = 0;
                                }
                                DatabaseHelper.instance.update(task);
                              });
                            },
                            icon: task.isComplete == 0
                                ? const Icon(Icons.circle_outlined)
                                : const Icon(Icons.circle),
                          ),
                          title: Text(task.title),
                          trailing: Text(task.date.toString()),
                        );
                      }).toList(),
                    );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showModal(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
