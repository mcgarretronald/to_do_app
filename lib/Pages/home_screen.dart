import 'package:flutter/material.dart';
import '../models/task.dart';
import '../widgets/task_tile.dart';
import 'package:uuid/uuid.dart'; // For generating unique IDs

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Task> tasks = [];
  final Uuid _uuid = const Uuid(); // Instantiate Uuid

  @override
  void initState() {
    super.initState();
    _loadTasks(); // Load tasks when the page initializes
  }

  // --- Task Management Logic ---

  Future<void> _loadTasks() async {
    // In a production app, you would load tasks from persistent storage
    // (e.g., SQLite, Hive, Shared Preferences, or a remote API).
    // For this example, we'll start with an empty list.
    setState(() {
      tasks = []; // Initialize as empty for now, or load dummy data
    });
    // Example: Add some dummy tasks for testing the list view
    // Future.delayed(Duration(milliseconds: 500), () {
    //   setState(() {
    //     tasks = [
    //       Task(
    //         id: _uuid.v4(),
    //         title: 'Buy groceries',
    //         description: 'Milk, bread, eggs, vegetables',
    //         priority: 1,
    //         createdAt: DateTime.now().subtract(const Duration(days: 1)),
    //         taskTime: DateTime.now().add(const Duration(hours: 2)),
    //       ),
    //       Task(
    //         id: _uuid.v4(),
    //         title: 'Finish Flutter project',
    //         description: 'Implement task creation and storage',
    //         priority: 2,
    //         createdAt: DateTime.now().subtract(const Duration(hours: 5)),
    //         taskTime: DateTime.now().add(const Duration(days: 3)),
    //         isCompleted: false,
    //       ),
    //       Task(
    //         id: _uuid.v4(),
    //         title: 'Call mom',
    //         description: 'Check in and say hi',
    //         priority: 3,
    //         createdAt: DateTime.now().subtract(const Duration(hours: 1)),
    //         taskTime: DateTime.now().add(const Duration(hours: 1)),
    //         isCompleted: true,
    //       ),
    //     ];
    //   });
    // });
  }

  void _addTask(Task newTask) {
    setState(() {
      tasks.add(newTask);
    });
    // In a production app, you would also save this task to storage.
  }

  // You'd also need methods for _updateTask and _deleteTask
  // void _updateTask(Task updatedTask) { /* ... */ }
  // void _deleteTask(String taskId) { /* ... */ }

  // --- UI/UX for Add Task ---

  // This will be a bottom sheet or a full-screen dialog for adding a new task.
  Future<void> _showAddTaskSheet() async {
    final TextEditingController _titleController = TextEditingController();
    final TextEditingController _descriptionController =
        TextEditingController();
    DateTime _selectedDate = DateTime.now();
    TimeOfDay _selectedTime = TimeOfDay.now();
    int _selectedPriority = 3; // Default to low priority

    // Helper for picking date
    Future<void> _pickDate() async {
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: _selectedDate,
        firstDate: DateTime.now().subtract(const Duration(days: 365)),
        lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
      );
      if (picked != null && picked != _selectedDate) {
        setState(() {
          // setState here to update the dialog's UI if it's not a full screen
          _selectedDate = picked;
        });
        // Important: if this is a dialog, you might need to update the dialog state
        // or rebuild it. For a full-screen route, this setState would be for the route itself.
      }
    }

    // Helper for picking time
    Future<void> _pickTime() async {
      final TimeOfDay? picked = await showTimePicker(
        context: context,
        initialTime: _selectedTime,
      );
      if (picked != null && picked != _selectedTime) {
        setState(() {
          // setState here to update the dialog's UI if it's not a full screen
          _selectedTime = picked;
        });
      }
    }

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Allows content to push up above keyboard
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 20,
            right: 20,
            top: 20,
          ),
          child: SingleChildScrollView(
            // To prevent overflow when keyboard appears
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Create New Task',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Task Title',
                    border: OutlineInputBorder(),
                    hintText: 'e.g., Finish project report',
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description (Optional)',
                    border: OutlineInputBorder(),
                    hintText: 'e.g., Add charts and executive summary',
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                // Date Picker Row
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () async {
                          final DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: _selectedDate,
                            firstDate: DateTime.now(),
                            lastDate: DateTime.now().add(
                              const Duration(days: 365 * 5),
                            ),
                          );
                          if (picked != null) {
                            setState(() => _selectedDate = picked);
                            // If this is a modal sheet, you might need to use a StatefulBuilder
                            // to update the UI *within* the sheet without rebuilding the HomePage.
                            // For simplicity, we'll assume it updates the main state and rebuilds.
                          }
                        },
                        child: InputDecorator(
                          decoration: const InputDecoration(
                            labelText: 'Due Date',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.calendar_today),
                          ),
                          child: Text(
                            '${_selectedDate.toLocal().year}-${_selectedDate.toLocal().month.toString().padLeft(2, '0')}-${_selectedDate.toLocal().day.toString().padLeft(2, '0')}',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: InkWell(
                        onTap: () async {
                          final TimeOfDay? picked = await showTimePicker(
                            context: context,
                            initialTime: _selectedTime,
                          );
                          if (picked != null) {
                            setState(() => _selectedTime = picked);
                          }
                        },
                        child: InputDecorator(
                          decoration: const InputDecoration(
                            labelText: 'Due Time',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.access_time),
                          ),
                          child: Text(
                            _selectedTime.format(context),
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Priority Selector
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Priority',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    Wrap(
                      spacing: 8.0,
                      children: List<Widget>.generate(3, (int index) {
                        return ChoiceChip(
                          label: Text(
                            index == 0
                                ? 'High'
                                : (index == 1 ? 'Medium' : 'Low'),
                            style: TextStyle(
                              color: _selectedPriority == (index + 1)
                                  ? Colors.white
                                  : Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                          selected: _selectedPriority == (index + 1),
                          selectedColor: index == 0
                              ? Colors.red.shade700
                              : (index == 1
                                    ? Colors.orange.shade700
                                    : Colors.green.shade700),
                          onSelected: (bool selected) {
                            setState(() {
                              // Update state within the sheet
                              _selectedPriority = selected
                                  ? (index + 1)
                                  : _selectedPriority;
                            });
                          },
                        );
                      }).toList(),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_titleController.text.isEmpty) {
                        // Basic validation
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Task title cannot be empty!'),
                          ),
                        );
                        return;
                      }

                      final DateTime combinedDateTime = DateTime(
                        _selectedDate.year,
                        _selectedDate.month,
                        _selectedDate.day,
                        _selectedTime.hour,
                        _selectedTime.minute,
                      );

                      final newTask = Task(
                        id: _uuid.v4(), // Generate a unique ID
                        title: _titleController.text,
                        description: _descriptionController.text,
                        priority: _selectedPriority,
                        createdAt: DateTime.now(),
                        taskTime: combinedDateTime,
                      );
                      _addTask(newTask); // Add to the list
                      Navigator.pop(context); // Close the bottom sheet
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Add Task',
                      style: Theme.of(
                        context,
                      ).textTheme.titleLarge?.copyWith(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todyapp Home'),
        automaticallyImplyLeading: false, // Removes back arrow
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Today',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Best platform for creating to-do lists',
                  style: Theme.of(
                    context,
                  ).textTheme.titleMedium?.copyWith(color: Colors.grey[600]),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
          // Conditional rendering for the "Tap plus to create" card
          if (tasks.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: InkWell(
                onTap: _showAddTaskSheet,
                child: Card(
                  color: const Color(
                    0xFF38938C,
                  ), // Your teal/green color from the image
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.add_circle_outline,
                          color: Colors.white,
                          size: 30,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'Tap plus to create a new task',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          const SizedBox(height: 20),
          Expanded(
            child: tasks.isEmpty
                ? const Center(
                    // You might want a slightly more engaging empty state here
                    // e.g., an illustration and more descriptive text
                    // For now, the card above handles the primary empty state message.
                    child: Text('No tasks added yet!'),
                  )
                : ListView.builder(
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      final task = tasks[index];
                      return TaskTile(task: task);
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTaskSheet, // Use the shared function
        backgroundColor: const Color(
          0xFF38938C,
        ), // Match the card color for consistency
        child: const Icon(Icons.add, color: Colors.white),
      ),
      // FloatingActionButtonLocation: FloatingActionButtonLocation.centerFloat, // Optional: Center it
    );
  }
}
