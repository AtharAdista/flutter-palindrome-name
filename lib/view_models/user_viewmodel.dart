import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/user_model.dart';

class UserViewModel extends ChangeNotifier {
  List<User> users = [];
  int page = 1;
  bool isLoading = false;
  bool hasMore = true;
  String selectedUserName = '';
  bool isEmpty = false;
  String? errorMessage; 

  Future<void> fetchUsers({bool refresh = false}) async {
    if (isLoading) return;

    if (refresh) {
      page = 1;
      users.clear();
      hasMore = true;
      isEmpty = false;
      errorMessage = null;
    }

    isLoading = true;
    notifyListeners();

    try {
      final response = await http.get(
        Uri.parse('https://reqres.in/api/users?page=$page&per_page=10'),
        headers: {
          'x-api-key': 'reqres-free-v1',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final fetchedUsers = (data['data'] as List)
            .map((json) => User.fromJson(json))
            .toList();

        if (fetchedUsers.isEmpty) {
          if (users.isEmpty) {
            isEmpty = true;
          }
          hasMore = false;
        } else {
          users.addAll(fetchedUsers);
          page++;
        }

        errorMessage = null; 
      } else {
        errorMessage = 'Gagal memuat data';
        if (users.isEmpty) isEmpty = true;
        hasMore = false;
      }
    } catch (e) {
      errorMessage = 'Gagal memuat data';
      if (users.isEmpty) isEmpty = true;
      hasMore = false;
    }

    isLoading = false;
    notifyListeners();
  }

  void selectUser(String name) {
    selectedUserName = name;
    notifyListeners();
  }
}
