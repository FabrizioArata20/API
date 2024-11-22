import 'dart:convert';
import 'package:api_mvp/model/user.dart';
import 'package:http/http.dart' as http;

class UserService {
  final String baseUrl = "https://jsonplaceholder.typicode.com/users";

  Future<List<UserModel>> fetchUsers() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => UserModel.fromJson(json)).toList();
      } else {
        throw Exception("Failed to fetch users: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error fetching users: $e");
    }
  }

  Future<UserModel> createUser(UserModel user) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        body: jsonEncode(user.toJson()),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 201) {
        return UserModel.fromJson(jsonDecode(response.body));
      } else {
        throw Exception("Failed to create user: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error creating user: $e");
    }
  }

  Future<UserModel> updateUser(int id, UserModel user) async {
    try {
      final response = await http.put(
        Uri.parse("$baseUrl/$id"),
        body: jsonEncode(user.toJson()),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        return UserModel.fromJson(jsonDecode(response.body));
      } else {
        throw Exception("Failed to update user: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error updating user: $e");
    }
  }

  Future<void> deleteUser(int id) async {
    try {
      final response = await http.delete(Uri.parse("$baseUrl/$id"));
      if (response.statusCode != 200) {
        throw Exception("Failed to delete user: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error deleting user: $e");
    }
  }
}
