import 'package:demo_poc/models/budget.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BudgetChart extends StatefulWidget {
  final List<Budget> budgets;

  const BudgetChart({super.key, required this.budgets});

  @override
  State<BudgetChart> createState() => _BudgetChartState();
}

class _BudgetChartState extends State<BudgetChart> {
  bool _isComparisonMode = false;

  // Comparison dates
  DateTime _compareMonth1 = DateTime.now();
  DateTime _compareMonth2 = DateTime.now().subtract(const Duration(days: 30));

  @override
  Widget build(BuildContext context) {
    bool isMobile = MediaQuery.of(context).size.width < 600;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Mode Toggle
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
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
          ),
          SizedBox(height: isMobile ? 48 : 24),

          if (!_isComparisonMode)
            _buildOverviewMode()
          else
            _buildComparisonMode(),
        ],
      ),
    );
  }

  Widget _buildOverviewMode() {
    final Map<String, double> typeTotals = {};
    double totalBudget = 0;

    for (var budget in widget.budgets) {
      typeTotals[budget.type] = (typeTotals[budget.type] ?? 0) + budget.amount;
      totalBudget += budget.amount;
    }

    if (totalBudget == 0) {
      return const Center(child: Text('No budget data available'));
    }

    // Check if mobile width (simple check)
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Column(
      children: [
        SizedBox(
          height: 250,
          child: PieChart(
            PieChartData(
              sectionsSpace: 2,
              centerSpaceRadius: 40,
              sections: typeTotals.entries.map((entry) {
                final percentage = (entry.value / totalBudget) * 100;
                return PieChartSectionData(
                  color:
                      Colors.primaries[typeTotals.keys.toList().indexOf(
                            entry.key,
                          ) %
                          Colors.primaries.length],
                  value: entry.value,
                  title: '${percentage.toStringAsFixed(1)}%',
                  radius: 100,
                  titleStyle: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: isMobile ? Colors.black : Colors.white,
                  ),
                  showTitle: true,
                  titlePositionPercentageOffset: isMobile ? 1.2 : 0.6,
                );
              }).toList(),
            ),
          ),
        ),
        const SizedBox(height: 32),
        // Legend
        ...typeTotals.entries.map((entry) {
          final color =
              Colors.primaries[typeTotals.keys.toList().indexOf(entry.key) %
                  Colors.primaries.length];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Row(
              children: [
                Container(width: 16, height: 16, color: color),
                const SizedBox(width: 8),
                Text(entry.key, style: const TextStyle(fontSize: 16)),
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
      ],
    );
  }

  Widget _buildComparisonMode() {
    // Filter by Month 1
    final month1Budgets = widget.budgets.where((b) {
      final date = b.createdAt;
      return date.year == _compareMonth1.year &&
          date.month == _compareMonth1.month;
    });

    // Filter by Month 2
    final month2Budgets = widget.budgets.where((b) {
      final date = b.createdAt;
      return date.year == _compareMonth2.year &&
          date.month == _compareMonth2.month;
    });

    // All types involved
    final allTypes = {
      ...month1Budgets.map((b) => b.type),
      ...month2Budgets.map((b) => b.type),
    }.toList();

    double maxY = 0;
    List<BarChartGroupData> barGroups = [];

    for (int i = 0; i < allTypes.length; i++) {
      final type = allTypes[i];
      final sum1 = month1Budgets
          .where((b) => b.type == type)
          .fold(0.0, (sum, b) => sum + b.amount);
      final sum2 = month2Budgets
          .where((b) => b.type == type)
          .fold(0.0, (sum, b) => sum + b.amount);

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
        const SizedBox(height: 32),
        if (allTypes.isEmpty)
          const SizedBox(
            height: 300,
            child: Center(child: Text('No data for selected months')),
          )
        else
          SizedBox(
            height: 350, // Increased height for tilted labels
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: maxY * 1.2,
                barTouchData: BarTouchData(
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipColor: (_) => Colors.blueGrey,
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      final type = allTypes[group.x.toInt()];
                      return BarTooltipItem(
                        '$type\n',
                        const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        children: [
                          TextSpan(
                            text: '₹${rod.toY.toStringAsFixed(2)}',
                            style: const TextStyle(
                              color: Colors.yellow,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 60, // Reserved size for tilted text
                      getTitlesWidget: (value, meta) {
                        final index = value.toInt();
                        if (index < 0 || index >= allTypes.length) {
                          return const SizedBox.shrink();
                        }
                        return SideTitleWidget(
                          axisSide: meta.axisSide,
                          space: 8.0,
                          child: Transform.rotate(
                            angle: -0.5, // Tilt angle
                            child: Text(
                              allTypes[index],
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
                gridData: const FlGridData(show: false),
                barGroups: barGroups,
              ),
            ),
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
}
