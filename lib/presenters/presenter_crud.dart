
import 'package:api_mvp/model/user.dart';
import 'package:api_mvp/presenters/services/crud_service.dart';


abstract class UserViewContract {
  void onUsersFetched(List<UserModel> users);
  void onUserCreated(UserModel user);
  void onUserUpdated(UserModel user);
  void onUserDeleted(String id);
  void onError(String error);
}

class UserPresenter {
  UserViewContract? _view;
  final UserService _userService;

  UserPresenter(this._userService);

  void attachView(UserViewContract view) {
    _view = view;
  }

  void detachView() {
    _view = null;
  }

  Future<void> fetchUsers() async {
    try {
      final users = await _userService.fetchUsers();
      _view?.onUsersFetched(users);
    } catch (e) {
      _view?.onError(e.toString());
    }
  }

  Future<void> createUser(UserModel user) async {
    try {
      final createdUser = await _userService.createUser(user);
      _view?.onUserCreated(createdUser);
    } catch (e) {
      _view?.onError(e.toString());
    }
  }

  Future<void> updateUser(String id, UserModel user) async {
    try {
      final updatedUser = await _userService.updateUser(id, user);
      _view?.onUserUpdated(updatedUser);
    } catch (e) {
      _view?.onError(e.toString());
    }
  }

  Future<void> deleteUser(String id) async {
    try {
      await _userService.deleteUser(id);
      _view?.onUserDeleted(id);
    } catch (e) {
      _view?.onError(e.toString());
    }
  }
}

