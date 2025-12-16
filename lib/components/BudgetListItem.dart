import 'package:demo_poc/models/budget.dart';
import 'package:demo_poc/utils/date_formatter.dart';
import 'package:flutter/material.dart';

class BudgetListItem extends StatelessWidget {
  final Budget budget;
  final VoidCallback? onTap;

  const BudgetListItem({super.key, required this.budget, this.onTap});

  @override
  Widget build(BuildContext context) {
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
        onTap: onTap,
        leading: CircleAvatar(
          child: Text(
            budget.name.isNotEmpty ? budget.name[0].toUpperCase() : '?',
          ),
        ),
        title: Text(
          budget.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              budget.type,
              style: TextStyle(
                color: Theme.of(context).textTheme.bodySmall?.color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              DateFormatter.formatLocal(budget.createdAt),
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).disabledColor,
              ),
            ),
          ],
        ),
        trailing: Text(
          '₹${budget.amount.toStringAsFixed(2)}',
          style: TextStyle(
            color: Colors.red.shade700,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        isThreeLine: true,
      ),
    );
  }
}
