import 'package:hive/hive.dart';

part 'expense.g.dart'; // this will be generated file by using this command: "flutter pub run build_runner build --delete-conflicting-outputs"

@HiveType(typeId: 0)
class Expense extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final double amount;

  @HiveField(3)
  final DateTime createdAt;

  @HiveField(4)
  final DateTime? date;

  @HiveField(5)
  final String type;

  Expense({
    required this.id,
    required this.name,
    required this.amount,
    required this.createdAt,
    required this.date,
    required this.type,
  });

  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
      id: json['id']?.toString() ?? '',
      name: json['expense']?.toString() ?? '',
      amount: double.tryParse(json['amount']?.toString() ?? '0') ?? 0.0,
      createdAt: DateTime.parse(json['createdAt'].toString()),
      date: DateTime.parse(json['date'].toString()),
      type: json['type']?.toString() ?? 'other',
    );
  }

  Expense copyWith({
    String? id,
    String? name,
    double? amount,
    DateTime? createdAt,
    DateTime? date,
    String? type,
  }) {
    return Expense(
      id: id ?? this.id,
      name: name ?? this.name,
      amount: amount ?? this.amount,
      createdAt: createdAt ?? this.createdAt,
      date: date ?? this.date,
      type: type ?? this.type,
    );
  }
}
