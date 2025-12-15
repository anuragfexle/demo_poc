import 'package:demo_poc/dao/expense_dao.dart';
import 'package:demo_poc/models/expense.dart';
import 'package:flutter/material.dart';
import 'package:demo_poc/utils/date_formatter.dart';

class ExpensePage extends StatefulWidget {
  const ExpensePage({super.key});

  @override
  State<ExpensePage> createState() => _ExpensePageState();
}

class _ExpensePageState extends State<ExpensePage> {
  final ExpenseDao _expenseDao = ExpenseDao();
  late Future<List<Expense>> _futureExpenses;

  @override
  void initState() {
    super.initState();
    _futureExpenses = _expenseDao.fetchExpenses();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Expense>>(
      future: _futureExpenses,
      builder: (context, snapshot) {
        // loading the data
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        // handl the error
        if (snapshot.hasError) {
          return Center(
            child: Text(
              'Something went wrong:\n${snapshot.error}',
              textAlign: TextAlign.center,
            ),
          );
        }

        // handle the empty data
        final expenses = snapshot.data ?? [];
        if (expenses.isEmpty) {
          return const Center(child: Text('No expenses found.'));
        }

        // success
        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: expenses.length,
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            final expense = expenses[index];

            return Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 4,
                    spreadRadius: 1,
                    offset: const Offset(0, 2),
                    // ignore: deprecated_member_use
                    color: Colors.black.withOpacity(0.05),
                  ),
                ],
              ),
              child: ListTile(
                leading: CircleAvatar(
                  child: Text(
                    expense.name.isNotEmpty
                        ? expense.name[0].toUpperCase()
                        : '?',
                  ),
                ),
                title: Text(expense.name),
                subtitle: Text(
                  DateFormatter.formatLocal(expense.createdAt),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: Text(
                  '₹${expense.amount.toStringAsFixed(2)}',
                  style: TextStyle(
                    color: Colors.red.shade700,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
