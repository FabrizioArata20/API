import 'package:api_mvp/model/user.dart';
import 'package:api_mvp/presenters/presenter_crud.dart';
import 'package:api_mvp/view/ui/user_card.dart';
import 'package:api_mvp/view/ui/user_form.dart';
import 'package:api_mvp/view/user_detail.dart';
import 'package:flutter/material.dart';

class UserListView extends StatefulWidget {
  final UserPresenter presenter;

  const UserListView({Key? key, required this.presenter}) : super(key: key);

  @override
  _UserListViewState createState() => _UserListViewState();
}

class _UserListViewState extends State<UserListView> implements UserViewContract {
  List<UserModel> _users = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    widget.presenter.attachView(this);
    _loadUsers();
  }

  @override
  void dispose() {
    widget.presenter.detachView();
    super.dispose();
  }

  Future<void> _loadUsers() async {
    setState(() => _isLoading = true);
    await widget.presenter.fetchUsers();
  }

  void _showAlertDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  void onUsersFetched(List<UserModel> users) {
    setState(() {
      _users = users;
      _isLoading = false;
    });
  }

  @override
  void onUserCreated(UserModel user) {
    setState(() {
      _users.add(user);
    });
    _showAlertDialog("Éxito", "El usuario ha sido creado correctamente.");
  }

  @override
  void onUserUpdated(UserModel user) {
    setState(() {
      final index = _users.indexWhere((u) => u.id == user.id);
      if (index != -1) {
        _users[index] = user;
      }
    });
    _showAlertDialog("Éxito", "El usuario ha sido actualizado correctamente.");
  }

  @override
  void onUserDeleted(int id) {
    setState(() {
      _users.removeWhere((user) => user.id == id);
    });
    _showAlertDialog("Éxito", "El usuario ha sido eliminado correctamente.");
  }

  @override
  void onError(String error) {
    setState(() => _isLoading = false);
    _showAlertDialog("Error", error);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User List'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadUsers,
              child: ListView.builder(
                itemCount: _users.length,
                itemBuilder: (context, index) {
                  return UserCard(
                    user: _users[index],
                    onTap: () => _navigateToUserDetail(_users[index]),
                  );
                },
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showCreateUserDialog,
        child: const Icon(Icons.add),
      ),
    );
  }

  void _navigateToUserDetail(UserModel user) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => UserDetailView(
          user: user,
          onUpdate: (updatedUser) => widget.presenter.updateUser(user.id, updatedUser),
          onDelete: () => widget.presenter.deleteUser(user.id),
        ),
      ),
    );
  }

  void _showCreateUserDialog() {
    showDialog(
      context: context,
      builder: (context) => EditUserDialog(
        onUpdate: (newUser) {
          widget.presenter.createUser(newUser);
          Navigator.of(context).pop();
        },
      ),
    );
  }
}
