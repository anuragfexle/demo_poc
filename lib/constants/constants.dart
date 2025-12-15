final String baseUrl =
    "https://693724caf8dc350aff337d9d.mockapi.io/api/dummydata/v1/";

final String expensesEndPoint = "expenses";
final String budgetEndPoint = "budget";
// final String profileEndPoint = "profile";

// Expense Type Constants
class ExpenseTypeItem {
  final int id;
  final String label;
  final String value;

  const ExpenseTypeItem({
    required this.id,
    required this.label,
    required this.value,
  });
}

const List<ExpenseTypeItem> ExpenseType = [
  ExpenseTypeItem(id: 1, label: 'Food', value: 'food'),
  ExpenseTypeItem(id: 2, label: 'Travel', value: 'travel'),
  ExpenseTypeItem(id: 3, label: 'Garments', value: 'garments'),
  ExpenseTypeItem(id: 4, label: 'Entertainment', value: 'entertainment'),
  ExpenseTypeItem(id: 5, label: 'Fuel', value: 'fuel'),
  ExpenseTypeItem(id: 6, label: 'Study', value: 'study'),
  ExpenseTypeItem(id: 7, label: 'Household', value: 'household'),
  ExpenseTypeItem(id: 8, label: 'Other', value: 'other'),
];
