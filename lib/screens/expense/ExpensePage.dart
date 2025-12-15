// ignore_for_file: deprecated_member_use

import 'package:demo_poc/bloc/expense/expense_bloc.dart';
import 'package:demo_poc/bloc/expense/expense_event.dart';
import 'package:demo_poc/bloc/expense/expense_state.dart';
import 'package:demo_poc/components/ExpenseListItem.dart';
import 'package:demo_poc/components/custom_alert_dialog.dart';

import 'package:demo_poc/routes/app_routes.dart';
import 'package:demo_poc/screens/expense/ExpenseChart.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExpensePage extends StatefulWidget {
  final String? params;

  const ExpensePage({super.key, this.params});

  @override
  State<ExpensePage> createState() => _ExpensePageState();
}

class _ExpensePageState extends State<ExpensePage> {
  bool _showChart = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Expenses'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: TextButton.icon(
              onPressed: () {
                setState(() {
                  _showChart = !_showChart;
                });
              },
              icon: Icon(_showChart ? Icons.list : Icons.pie_chart),
              label: Text(_showChart ? 'Expense' : 'Insights'),
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          if (widget.params != null)
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.orange.shade100,
              width: double.infinity,
              child: Text(
                'Received: ${widget.params}',
                style: TextStyle(fontSize: 16, color: Colors.orange.shade900),
                textAlign: TextAlign.center,
              ),
            ),
          Expanded(
            child: BlocBuilder<ExpenseBloc, ExpenseState>(
              builder: (context, state) {
                if (state is ExpenseLoading || state is ExpenseInitial) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is ExpenseError) {
                  return Center(child: Text('Error: ${state.message}'));
                }

                if (state is ExpenseLoaded) {
                  final expenses = state.expenses;
                  if (expenses.isEmpty) {
                    return const Center(child: Text('No expenses found.'));
                  }

                  if (_showChart) {
                    return ExpenseChart(expenses: expenses);
                  }

                  return ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: expenses.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final expense = expenses[index];

                      return Dismissible(
                        key: ValueKey(expense.id),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 16),
                          color: const Color.fromARGB(255, 247, 181, 176),
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        confirmDismiss: (direction) async {
                          return await showDialog<bool>(
                            context: context,
                            builder: (context) {
                              return CustomAlertDialog(
                                title: 'Delete Expense',
                                message:
                                    'Are you sure you want to delete ${expense.name}?',
                                onCancel: () =>
                                    Navigator.of(context).pop(false),
                                onConfirm: () =>
                                    Navigator.of(context).pop(true),
                              );
                            },
                          );
                        },
                        onDismissed: (_) {
                          context.read<ExpenseBloc>().add(
                            DeleteExpenseEvent(expense.id),
                          );
                        },
                        child: ExpenseListItem(expense: expense),
                      );
                    },
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
      floatingActionButton: !_showChart
          ? FloatingActionButton(
              onPressed: () {
                Navigator.of(
                  context,
                  rootNavigator: true,
                ).pushNamed(AppRoutes.addExpense);
              },
              shape: const CircleBorder(),
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}
