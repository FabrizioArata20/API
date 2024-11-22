import 'dart:convert';
import 'package:api_mvp/model/user.dart';
import 'package:http/http.dart' as http;

class UserService {
  final String baseUrl = "https://673bd9c496b8dcd5f3f7acf3.mockapi.io/api/v1/criptos/memecoins";

  Future<List<UserModel>> fetchUsers() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => UserModel.fromJson(json)).toList();
      } else {
        throw Exception("Failed to fetch memecoins: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error fetching memecoins: $e");
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
        throw Exception("Failed to create memecoin: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error creating memecoin: $e");
    }
  }

  Future<UserModel> updateUser(String id, UserModel user) async {
    try {
      final response = await http.put(
        Uri.parse("$baseUrl/$id"),
        body: jsonEncode(user.toJson()),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        return UserModel.fromJson(jsonDecode(response.body));
      } else {
        throw Exception("Failed to update memecoin: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error updating memecoin: $e");
    }
  }

  Future<void> deleteUser(String id) async {
    try {
      final response = await http.delete(Uri.parse("$baseUrl/$id"));
      if (response.statusCode != 200) {
        throw Exception("Failed to delete memecoin: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error deleting memecoin: $e");
    }
  }
}
