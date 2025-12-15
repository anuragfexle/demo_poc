import 'package:demo_poc/constants/constants.dart';
import 'package:demo_poc/models/expense.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ExpenseChart extends StatefulWidget {
  final List<Expense> expenses;

  const ExpenseChart({super.key, required this.expenses});

  @override
  State<ExpenseChart> createState() => _ExpenseChartState();
}

class _ExpenseChartState extends State<ExpenseChart> {
  String _filter = 'Monthly'; // 'Weekly' or 'Monthly'
  DateTime _selectedDate = DateTime.now();
  bool _isComparisonMode = false;

  // Comparison dates
  DateTime _compareMonth1 = DateTime.now();
  DateTime _compareMonth2 = DateTime.now().subtract(const Duration(days: 30));

  // Define pastel colors for each type
  final Map<String, Color> categoryColors = {
    'food': const Color(0xFFFFB3BA),
    'travel': const Color(0xFFBAE1FF),
    'garments': const Color(0xFFB3E5BE),
    'entertainment': const Color(0xFFE2B3E5),
    'fuel': const Color(0xFFFFDFBA),
    'study': const Color(0xFFB3E5E1),
    'household': const Color(0xFFE5CBA8),
    'other': const Color(0xFFE0E0E0),
  };

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Mode Toggle
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ChoiceChip(
                label: const Text('Overview'),
                selected: !_isComparisonMode,
                onSelected: (selected) {
                  if (selected) setState(() => _isComparisonMode = false);
                },
              ),
              const SizedBox(width: 16),
              ChoiceChip(
                label: const Text('Comparison'),
                selected: _isComparisonMode,
                onSelected: (selected) {
                  if (selected) setState(() => _isComparisonMode = true);
                },
              ),
            ],
          ),
          const SizedBox(height: 24),

          if (!_isComparisonMode)
            _buildOverviewMode()
          else
            _buildComparisonMode(),
        ],
      ),
    );
  }

  Widget _buildOverviewMode() {
    // Filter expenses based on selection
    final filteredExpenses = widget.expenses.where((expense) {
      final date = expense.date ?? expense.createdAt;
      if (_filter == 'Weekly') {
        // Week containing the selected date (Mon-Sun)
        final startOfWeek = _selectedDate.subtract(
          Duration(days: _selectedDate.weekday - 1),
        );
        final endOfWeek = startOfWeek.add(const Duration(days: 6));
        final expenseDate = DateTime(date.year, date.month, date.day);
        final start = DateTime(
          startOfWeek.year,
          startOfWeek.month,
          startOfWeek.day,
        );
        final end = DateTime(endOfWeek.year, endOfWeek.month, endOfWeek.day);

        return expenseDate.compareTo(start) >= 0 &&
            expenseDate.compareTo(end) <= 0;
      } else {
        // Selected Month
        return date.year == _selectedDate.year &&
            date.month == _selectedDate.month;
      }
    }).toList();

    final Map<String, double> categoryTotals = {};
    double totalExpense = 0;

    for (var expense in filteredExpenses) {
      categoryTotals[expense.type] =
          (categoryTotals[expense.type] ?? 0) + expense.amount;
      totalExpense += expense.amount;
    }

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            DropdownButton<String>(
              value: _filter,
              items: ['Weekly', 'Monthly'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (newValue) {
                if (newValue != null) {
                  setState(() {
                    _filter = newValue;
                  });
                }
              },
            ),
            TextButton.icon(
              onPressed: () => _pickDate(context),
              icon: const Icon(Icons.calendar_today),
              label: Text(
                _filter == 'Monthly'
                    ? DateFormat('MMMM yyyy').format(_selectedDate)
                    : 'Week of ${DateFormat('MMM d').format(_selectedDate)}',
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        if (filteredExpenses.isEmpty)
          const SizedBox(
            height: 250,
            child: Center(child: Text('No expenses for this period')),
          )
        else
          SizedBox(
            height: 250,
            child: PieChart(
              PieChartData(
                sectionsSpace: 2,
                centerSpaceRadius: 40,
                sections: categoryTotals.entries.map((entry) {
                  final percentage = (entry.value / totalExpense) * 100;
                  return PieChartSectionData(
                    color: categoryColors[entry.key] ?? const Color(0xFFE0E0E0),
                    value: entry.value,
                    title: '${percentage.toStringAsFixed(1)}%',
                    radius: 100,
                    titleStyle: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        const SizedBox(height: 32),
        // Legend and Details
        ...categoryTotals.entries.map((entry) {
          final typeItem = ExpenseType.firstWhere(
            (e) => e.value == entry.key,
            orElse: () =>
                const ExpenseTypeItem(id: 0, label: 'Other', value: 'other'),
          );
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Row(
              children: [
                Container(
                  width: 16,
                  height: 16,
                  color: categoryColors[entry.key] ?? const Color(0xFFE0E0E0),
                ),
                const SizedBox(width: 8),
                Text(typeItem.label, style: const TextStyle(fontSize: 16)),
                const Spacer(),
                Text(
                  '₹${entry.value.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
        const Divider(height: 32),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Total Expense',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              '₹${totalExpense.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        // Insights
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Insights',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'This ${_filter.toLowerCase()} you have spent ₹${totalExpense.toStringAsFixed(2)}.',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildComparisonMode() {
    // Calculate totals for Month 1
    final month1Expenses = widget.expenses.where((e) {
      final date = e.date ?? e.createdAt;
      return date.year == _compareMonth1.year &&
          date.month == _compareMonth1.month;
    });

    final month2Expenses = widget.expenses.where((e) {
      final date = e.date ?? e.createdAt;
      return date.year == _compareMonth2.year &&
          date.month == _compareMonth2.month;
    });

    // Group by category
    final allCategories = {
      ...month1Expenses.map((e) => e.type),
      ...month2Expenses.map((e) => e.type),
    }.toList();

    // Prepare Bar Groups
    List<BarChartGroupData> barGroups = [];
    double maxY = 0;

    for (int i = 0; i < allCategories.length; i++) {
      final category = allCategories[i];
      final sum1 = month1Expenses
          .where((e) => e.type == category)
          .fold(0.0, (sum, e) => sum + e.amount);
      final sum2 = month2Expenses
          .where((e) => e.type == category)
          .fold(0.0, (sum, e) => sum + e.amount);

      if (sum1 > maxY) maxY = sum1;
      if (sum2 > maxY) maxY = sum2;

      barGroups.add(
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(toY: sum1, color: Colors.blue.shade300, width: 12),
            BarChartRodData(
              toY: sum2,
              color: Colors.orange.shade300,
              width: 12,
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildMonthSelector(
              _compareMonth1,
              (date) => setState(() => _compareMonth1 = date),
              Colors.blue.shade300,
            ),
            const Text('vs', style: TextStyle(fontWeight: FontWeight.bold)),
            _buildMonthSelector(
              _compareMonth2,
              (date) => setState(() => _compareMonth2 = date),
              Colors.orange.shade300,
            ),
          ],
        ),
        const SizedBox(height: 32),
        if (allCategories.isEmpty)
          const SizedBox(
            height: 300,
            child: Center(child: Text('No data for selected months')),
          )
        else
          SizedBox(
            height: 300,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: maxY * 1.2,
                barTouchData: BarTouchData(
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipColor: (_) => Colors.blueGrey,
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      final category = allCategories[group.x.toInt()];
                      final typeLabel = ExpenseType.firstWhere(
                        (e) => e.value == category,
                        orElse: () =>
                            const ExpenseTypeItem(id: 0, label: '?', value: ''),
                      ).label;
                      return BarTooltipItem(
                        '$typeLabel\n',
                        const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: '₹${rod.toY.toStringAsFixed(2)}',
                            style: const TextStyle(
                              color: Colors.yellow,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 60,
                      getTitlesWidget: (double value, TitleMeta meta) {
                        final index = value.toInt();
                        if (index < 0 || index >= allCategories.length)
                          return const SizedBox.shrink();
                        final category = allCategories[index];

                        final typeLabel = ExpenseType.firstWhere(
                          (e) => e.value == category,
                          orElse: () => const ExpenseTypeItem(
                            id: 0,
                            label: '?',
                            value: '',
                          ),
                        ).label;

                        return SideTitleWidget(
                          axisSide: meta.axisSide,
                          space: 10,
                          child: Transform.rotate(
                            angle: -0.8,
                            child: Text(
                              typeLabel,
                              style: const TextStyle(fontSize: 10),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  leftTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                borderData: FlBorderData(show: false),
                barGroups: barGroups,
                gridData: const FlGridData(show: false),
              ),
            ),
          ),
        const SizedBox(height: 16),
        // Legend for Comparison
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildLegendItem(
              DateFormat('MMM yyyy').format(_compareMonth1),
              Colors.blue.shade300,
            ),
            const SizedBox(width: 24),
            _buildLegendItem(
              DateFormat('MMM yyyy').format(_compareMonth2),
              Colors.orange.shade300,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMonthSelector(
    DateTime date,
    Function(DateTime) onSelect,
    Color color,
  ) {
    return InkWell(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: date,
          firstDate: DateTime(2020),
          lastDate: DateTime.now(),
          initialDatePickerMode: DatePickerMode.year,
        );
        if (picked != null) {
          onSelect(picked);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(color: color, width: 2),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          DateFormat('MMM yyyy').format(date),
          style: TextStyle(color: color, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(width: 12, height: 12, color: color),
        const SizedBox(width: 4),
        Text(label),
      ],
    );
  }

  Future<void> _pickDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }
}
