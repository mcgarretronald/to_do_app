import 'package:flutter/material.dart';
import '../models/task.dart';
import 'package:intl/intl.dart';

class TaskTile extends StatelessWidget {
  final Task task;
  final ValueChanged<bool?>? onToggleComplete; // Callback for completion
  final VoidCallback? onEdit; // Callback for editing
  final VoidCallback? onDelete; // Callback for deleting

  const TaskTile({
    super.key,
    required this.task,
    this.onToggleComplete,
    this.onEdit,
    this.onDelete,
  });

  Color getPriorityColor(int priority) {
    switch (priority) {
      case 1:
        return Colors.red;
      case 2:
        return Colors.orange;
      case 3:
      default:
        return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    final DateFormat dateFormat = DateFormat('MMM d, h:mm a');

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      elevation: 2, // Added slight elevation for better visual separation
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: GestureDetector(
        // Use GestureDetector for potential tap to edit
        onTap: onEdit, // Link to edit functionality
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Checkbox(
                value: task.isCompleted,
                onChanged: onToggleComplete, // Connect to completion logic
                activeColor: Theme.of(context).primaryColor,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        decoration: task.isCompleted
                            ? TextDecoration.lineThrough
                            : null,
                        color: task.isCompleted ? Colors.grey : Colors.black,
                      ),
                    ),
                    if (task.description.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Text(
                          task.description,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[700],
                            decoration: task.isCompleted
                                ? TextDecoration.lineThrough
                                : null,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: 14,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Due: ${dateFormat.format(task.taskTime)}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 14,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Created: ${dateFormat.format(task.createdAt)}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  CircleAvatar(
                    backgroundColor: getPriorityColor(task.priority),
                    radius: 12,
                    child: Text(
                      task.priority.toString(),
                      style: const TextStyle(color: Colors.white, fontSize: 10),
                    ),
                  ),
                  // More actions can go here, e.g., a delete button or options menu
                  if (onDelete !=
                      null) // Only show delete if a callback is provided
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.redAccent),
                      onPressed: onDelete,
                      tooltip: 'Delete Task',
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
