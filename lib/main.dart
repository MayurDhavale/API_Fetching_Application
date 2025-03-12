import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/post_list_screen.dart';
import 'providers/post_provider.dart';
import 'providers/theme_provider.dart';  // Import ThemeProvider
import 'theme/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PostProvider()..fetchPosts()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()), // Theme Provider
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Flutter API Fetch',
            theme: themeProvider.isDarkMode ? AppTheme.darkTheme : AppTheme.lightTheme,
            home: PostListScreen(
              toggleTheme: themeProvider.toggleTheme,
              isDarkMode: themeProvider.isDarkMode,
            ),
          );
        },
      ),
    );
  }
}
