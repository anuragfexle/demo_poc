import 'package:demo_poc/bloc/budget/budget_bloc.dart';
import 'package:demo_poc/bloc/budget/budget_event.dart';
import 'package:demo_poc/bloc/budget/budget_state.dart';
import 'package:demo_poc/components/BudgetListItem.dart';
import 'package:demo_poc/components/custom_alert_dialog.dart';
import 'package:demo_poc/models/budget.dart';
import 'package:demo_poc/screens/budget/BudgetChart.dart';
import 'package:demo_poc/utils/date_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BudgetPage extends StatefulWidget {
  final String? params;
  final Function(int, {String? params})? onNavigate;

  const BudgetPage({super.key, this.params, this.onNavigate});

  @override
  State<BudgetPage> createState() => _BudgetPageState();
}

class _BudgetPageState extends State<BudgetPage> {
  bool _showInsights = false;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    if (widget.params == 'show_chart') {
      _showInsights = true;
    }
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showBudgetDetails(Budget budget) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          width: double.infinity,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Budget Details',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 16),
              _detailRow('Name', budget.name),
              const SizedBox(height: 8),
              _detailRow('Type', budget.type),
              const SizedBox(height: 8),
              _detailRow(
                'Amount',
                '₹${budget.amount.toStringAsFixed(2)}',
                isAmount: true,
              ),
              const SizedBox(height: 8),
              _detailRow(
                'Created At',
                DateFormatter.formatLocal(budget.createdAt),
              ),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }

  Widget _detailRow(String label, String value, {bool isAmount = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            color: isAmount ? Colors.red.shade700 : null,
            fontWeight: isAmount ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Budget'),
        automaticallyImplyLeading: false,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: TextButton.icon(
              onPressed: () {
                setState(() {
                  _showInsights = !_showInsights;
                });
              },
              icon: Icon(_showInsights ? Icons.list : Icons.pie_chart),
              label: Text(_showInsights ? 'List' : 'Insights'),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          if (!_showInsights)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search by name or type...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                ),
              ),
            ),

          Expanded(
            child: BlocBuilder<BudgetBloc, BudgetState>(
              builder: (context, state) {
                if (state is BudgetLoading || state is BudgetInitial) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is BudgetError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Something went wrong:\n${state.message}',
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            context.read<BudgetBloc>().add(LoadBudgets());
                          },
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }

                if (state is BudgetLoaded) {
                  final budgets = state.budgets;

                  // Filter budgets
                  final filteredBudgets = budgets.where((budget) {
                    final name = budget.name.toLowerCase();
                    final type = budget.type.toLowerCase();
                    return name.contains(_searchQuery) ||
                        type.contains(_searchQuery);
                  }).toList();

                  if (filteredBudgets.isEmpty) {
                    return const Center(child: Text('No budgets found.'));
                  }

                  return RefreshIndicator(
                    onRefresh: () async {
                      context.read<BudgetBloc>().add(LoadBudgets());
                    },
                    child: Builder(
                      builder: (context) {
                        if (_showInsights) {
                          return BudgetChart(budgets: filteredBudgets);
                        }

                        return ListView.separated(
                          padding: const EdgeInsets.all(16),
                          itemCount: filteredBudgets.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 8),
                          itemBuilder: (context, index) {
                            final budget = filteredBudgets[index];

                            return Dismissible(
                              key: ValueKey(budget.id),
                              direction: DismissDirection.endToStart,
                              background: Container(
                                alignment: Alignment.centerRight,
                                padding: const EdgeInsets.only(right: 16),
                                color: Colors.red.shade100,
                                child: Icon(
                                  Icons.delete,
                                  color: Colors.red.shade900,
                                ),
                              ),
                              confirmDismiss: (direction) async {
                                return await showDialog<bool>(
                                  context: context,
                                  builder: (context) {
                                    return CustomAlertDialog(
                                      title: 'Delete Budget',
                                      message:
                                          'Are you sure you want to delete ${budget.name}?',
                                      onCancel: () =>
                                          Navigator.of(context).pop(false),
                                      onConfirm: () =>
                                          Navigator.of(context).pop(true),
                                    );
                                  },
                                );
                              },
                              onDismissed: (_) {
                                context.read<BudgetBloc>().add(
                                  DeleteBudget(budget.id),
                                );
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Budget deleted'),
                                  ),
                                );
                              },
                              child: BudgetListItem(
                                budget: budget,
                                onTap: () => _showBudgetDetails(budget),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}
