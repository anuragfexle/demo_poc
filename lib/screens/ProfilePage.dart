import 'package:demo_poc/bloc/theme/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfilePage extends StatelessWidget {
  final String? params;
  final Function(int, {String? params})? onNavigate;

  const ProfilePage({super.key, this.params, this.onNavigate});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Profile Page', style: TextStyle(fontSize: 22)),
            if (params != null) ...[
              const SizedBox(height: 16),
              Text(
                'Received: $params',
                style: const TextStyle(fontSize: 16, color: Colors.green),
              ),
            ],
            const SizedBox(height: 32),

            // Theme Toggle Card
            Card(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text(
                      'Theme Settings',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    BlocBuilder<ThemeCubit, AppThemeMode>(
                      builder: (context, themeMode) {
                        final isDark = themeMode == AppThemeMode.dark;
                        return SwitchListTile(
                          title: const Text('Dark Mode'),
                          subtitle: Text(
                            'Current: ${themeMode == AppThemeMode.system
                                ? 'System'
                                : themeMode == AppThemeMode.dark
                                ? 'Dark'
                                : 'Light'}',
                          ),
                          value: isDark,
                          onChanged: (value) {
                            context.read<ThemeCubit>().toggleTheme();
                          },
                          secondary: Icon(
                            isDark ? Icons.dark_mode : Icons.light_mode,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                onNavigate?.call(0, params: 'Text From Profile');
              },
              child: const Text('Go to Expense'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                onNavigate?.call(1, params: 'Text From Profile');
              },
              child: const Text('Go to Budget'),
            ),
          ],
        ),
      ),
    );
  }
}
