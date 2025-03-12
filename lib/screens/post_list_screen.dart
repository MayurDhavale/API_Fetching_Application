import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/post_provider.dart';

class PostListScreen extends StatelessWidget {
  final VoidCallback toggleTheme;
  final bool isDarkMode;

  const PostListScreen({super.key, required this.toggleTheme, required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    bool isDarkTheme = Theme.of(context).brightness == Brightness.dark; // Check theme mode

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '📢 Latest Posts',
          style: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.deepPurple, Colors.blue], 
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode, color: Colors.white),
            onPressed: toggleTheme,
          ),
        ],
      ),
      body: Consumer<PostProvider>(
        builder: (context, postProvider, child) {
          if (postProvider.isLoading) {
            return _buildShimmerEffect();
          }

          if (postProvider.error != null) {
            Future.microtask(() => ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(postProvider.error!, style: const TextStyle(color: Colors.white)),
                    backgroundColor: Colors.red,
                    duration: const Duration(seconds: 3),
                  ),
                ));
            return _buildRetryButton(postProvider);
          }

          if (postProvider.posts.isEmpty) {
            return const Center(child: Text("No posts available.", style: TextStyle(fontSize: 16)));
          }

          return RefreshIndicator(
            onRefresh: postProvider.fetchPosts,
            child: ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: postProvider.posts.length,
              itemBuilder: (context, index) {
                final post = postProvider.posts[index];

                return Card(
                  color: isDarkTheme ? Colors.grey[900] : Colors.white, // Dark mode support
                  elevation: 3,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 🎯 Post Title - Stylish
                        Text(
                          post['title'] ?? "No Title",
                          style: GoogleFonts.lobster(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: isDarkTheme ? Colors.cyanAccent : Colors.deepPurple, // Adjusted color
                          ),
                        ),
                        const SizedBox(height: 5),

                        // 📝 Post Body - Readable in Dark Mode
                        Text(
                          post['body'] ?? "No Content",
                          style: GoogleFonts.roboto(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: isDarkTheme ? Colors.white70 : Colors.black87, // Dark mode fix
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  /// Shimmer effect for loading state
  Widget _buildShimmerEffect() {
    return ListView.builder(
      padding: const EdgeInsets.all(8.0),
      itemCount: 6,
      itemBuilder: (context, index) {
        return Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: ListTile(
            leading: Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
              child: const CircleAvatar(radius: 20, backgroundColor: Colors.grey),
            ),
            title: Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
              child: Container(height: 16, width: double.infinity, color: Colors.grey),
            ),
            subtitle: Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
              child: Container(height: 14, width: double.infinity, color: Colors.grey),
            ),
          ),
        );
      },
    );
  }

  /// Retry button for errors
  Widget _buildRetryButton(PostProvider postProvider) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error, color: Colors.red, size: 50),
          const SizedBox(height: 10),
          const Text("Something went wrong!", style: TextStyle(fontSize: 16, color: Colors.red)),
          const SizedBox(height: 10),
          ElevatedButton.icon(
            onPressed: postProvider.fetchPosts,
            icon: const Icon(Icons.refresh),
            label: const Text("Retry"),
            style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10)),
          ),
        ],
      ),
    );
  }
}
