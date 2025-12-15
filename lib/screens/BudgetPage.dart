import 'package:flutter/material.dart';

class BudgetPage extends StatelessWidget {
  final String? params;
  final Function(int, {String? params})? onNavigate;

  const BudgetPage({super.key, this.params, this.onNavigate});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Budget'),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Budget Page', style: TextStyle(fontSize: 22)),
            if (params != null) ...[
              SizedBox(height: 16),
              Text(
                'Received: $params',
                style: TextStyle(fontSize: 16, color: Colors.blue),
              ),
            ],
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                onNavigate?.call(2, params: 'Text From Budget');
              },
              child: Text('Go to Profile'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                onNavigate?.call(0, params: 'Text From Budget');
              },
              child: Text('Go to Expense'),
            ),
          ],
        ),
      ),
    );
  }
}
