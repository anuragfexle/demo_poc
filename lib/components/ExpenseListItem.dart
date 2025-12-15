import 'package:demo_poc/constants/constants.dart';
import 'package:demo_poc/models/expense.dart';
import 'package:demo_poc/routes/app_routes.dart';
import 'package:demo_poc/utils/date_formatter.dart';
import 'package:flutter/material.dart';

class ExpenseListItem extends StatelessWidget {
  final Expense expense;

  const ExpenseListItem({super.key, required this.expense});

  @override
  Widget build(BuildContext context) {
    // Find label for the type
    final typeLabel = ExpenseType.firstWhere(
      (e) => e.value == expense.type,
      orElse: () => const ExpenseTypeItem(id: 0, label: '', value: ''),
    ).label;

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            blurRadius: 4,
            spreadRadius: 1,
            offset: const Offset(0, 2),
            color: Colors.black.withOpacity(0.05),
          ),
        ],
      ),
      child: ListTile(
        onTap: () {
          Navigator.of(
            context,
            rootNavigator: true,
          ).pushNamed(AppRoutes.updateExpense, arguments: expense);
        },
        leading: CircleAvatar(
          child: Text(
            expense.name.isNotEmpty ? expense.name[0].toUpperCase() : '?',
          ),
        ),
        title: Row(
          children: [
            Flexible(
              child: Text(expense.name, overflow: TextOverflow.ellipsis),
            ),
            if (typeLabel.isNotEmpty) ...[
              const SizedBox(width: 8),
              Text(
                '($typeLabel)',
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.grey.shade400
                      : Colors.grey.shade600,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ],
          ],
        ),
        subtitle: Text(
          expense.date != null
              ? DateFormatter.format(expense.date!)
              : DateFormatter.format(expense.createdAt),
        ),
        trailing: Text(
          '₹${expense.amount.toStringAsFixed(2)}',
          style: TextStyle(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.red.shade300
                : Colors.red.shade700,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
