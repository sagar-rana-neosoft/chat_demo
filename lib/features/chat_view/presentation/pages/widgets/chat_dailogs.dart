import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/constants/app_string_constants.dart';

class MessageEditDeleteDialog extends StatelessWidget {
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const MessageEditDeleteDialog({
    super.key,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      title: const Text(AppStringConstants.editOrDeleteMessage),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.edit, color: Colors.blueAccent),
            title: const Text(AppStringConstants.edit),
            onTap: onEdit,
          ),
          ListTile(
            leading: const Icon(Icons.delete, color: Colors.redAccent),
            title: const Text(AppStringConstants.delete),
            onTap: onDelete,
          ),
        ],
      ),
    );
  }
}

class MessageEditDialog extends StatefulWidget {
  final String initialText;
  final ValueChanged<String> onSave;

  const MessageEditDialog({
    super.key,
    required this.initialText,
    required this.onSave,
  });

  @override
  _MessageEditDialogState createState() => _MessageEditDialogState();
}

class _MessageEditDialogState extends State<MessageEditDialog> {
  late TextEditingController _editController;

  @override
  void initState() {
    super.initState();
    _editController = TextEditingController(text: widget.initialText);
  }

  @override
  void dispose() {
    _editController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      title: const Text(AppStringConstants.editMessage),
      content: TextField(
        controller: _editController,
        decoration: InputDecoration(
          hintText: AppStringConstants.enterNewMessage,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => context.pop(),
          child: const Text(AppStringConstants.cancel, style: TextStyle(color: Colors.grey)),
        ),
        TextButton(
          onPressed: () {
            if (_editController.text.isNotEmpty) {
              widget.onSave(_editController.text);
              context.pop();
            }
          },
          child: const Text(AppStringConstants.save, style: TextStyle(color: Colors.blueAccent)),
        ),
      ],
    );
  }
}