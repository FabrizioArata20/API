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
  }

  @override
  void onUserUpdated(UserModel user) {
    setState(() {
      final index = _users.indexWhere((u) => u.id == user.id);
      if (index != -1) {
        _users[index] = user;
      }
    });
  }

  @override
  void onUserDeleted(String id) {
    setState(() {
      _users.removeWhere((user) => user.id == id);
    });
  }

  @override
  void onError(String error) {
    setState(() => _isLoading = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(error)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bitcoin List'),
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
        onPressed: () => _showCreateUserDialog(),
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

