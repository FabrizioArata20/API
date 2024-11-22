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
  late TextEditingController _ownerController;
  late TextEditingController _valueController;
  late TextEditingController _currencyController;
  late TextEditingController _avatarController;

  @override
  void initState() {
    super.initState();
    _ownerController = TextEditingController(text: widget.user?.owner ?? '');
    _valueController =
        TextEditingController(text: widget.user?.value.toString() ?? '');
    _currencyController =
        TextEditingController(text: widget.user?.currency ?? '');
    _avatarController = TextEditingController(text: widget.user?.avatar ?? '');
  }

  @override
  void dispose() {
    _ownerController.dispose();
    _valueController.dispose();
    _currencyController.dispose();
    _avatarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.user != null;
    return AlertDialog(
      title: Text(isEditing ? 'Edit Memecoin' : 'Create Memecoin'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildTextField(_ownerController, 'Owner'),
            _buildTextField(_valueController, 'Value'),
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
    final updatedUser = (widget.user ??
            UserModel(
                id: '0',
                createdAt: DateTime.now().toIso8601String(),
                owner: '',
                avatar: '',
                value: 0.0,
                currency: ''))
        .copyWith(
      owner: _ownerController.text,
      value: double.tryParse(_valueController.text) ?? 0.0,
      currency: _currencyController.text,
      avatar: _avatarController.text,
    );
    widget.onUpdate(updatedUser);
  }
}
