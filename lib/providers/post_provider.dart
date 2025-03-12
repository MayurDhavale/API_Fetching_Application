import 'package:flutter/material.dart';
import '../services/api_service.dart';

class PostProvider with ChangeNotifier {
  List<dynamic> _posts = [];
  bool _isLoading = false; // Default to false
  String? _error;

  List<dynamic> get posts => _posts;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Fetches posts from API and updates state
  Future<void> fetchPosts({bool forceRefresh = false}) async {
    if (_posts.isNotEmpty && !forceRefresh) return; // Avoid redundant API calls

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final fetchedPosts = await ApiService.fetchPosts();
      if (fetchedPosts.isNotEmpty) {
        _posts = fetchedPosts;
      } else {
        _error = "No posts available.";
      }
    } catch (e) {
      _error = "Failed to load posts. Please try again.";
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Refresh posts manually (Pull-to-Refresh)
  Future<void> refreshPosts() async {
    await fetchPosts(forceRefresh: true);
  }
}
