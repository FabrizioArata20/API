import 'package:api_mvp/model/user.dart';
import 'package:flutter/material.dart';


class EditUserDialog extends StatefulWidget {
  final UserModel? user;
  final Function(UserModel) onUpdate;

  const EditUserDialog({
    Key? key,
    this.user,
    required this.onUpdate,
  }) : super(key: key);

  @override
  _EditUserDialogState createState() => _EditUserDialogState();
}

class _EditUserDialogState extends State<EditUserDialog> {
  late TextEditingController _nameController;
  late TextEditingController _currencyController;
  late TextEditingController _avatarController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user?.name ?? '');
    _currencyController = TextEditingController(text: widget.user?.currency?.toString() ?? '');
    _avatarController = TextEditingController(text: widget.user?.avatar ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _currencyController.dispose();
    _avatarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.user != null;
    return AlertDialog(
      title: Text(isEditing ? 'Edit Bitcoin' : 'Create Bitcoin'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildTextField(_nameController, 'Name'),
            _buildTextField(_currencyController, 'Currency'),
            _buildTextField(_avatarController, 'Avatar URL'),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _saveUser,
          child: Text(isEditing ? 'Update' : 'Create'),
        ),
      ],
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  void _saveUser() {
    // Try to parse currency as int, but keep as string if parsing fails
    var currencyValue = int.tryParse(_currencyController.text) ?? _currencyController.text;
    
    final updatedUser = UserModel(
      id: widget.user?.id ?? '0',
      createdAt: widget.user?.createdAt ?? DateTime.now().toIso8601String(),
      name: _nameController.text,
      avatar: _avatarController.text,
      currency: currencyValue,
    );
    widget.onUpdate(updatedUser);
  }
}

