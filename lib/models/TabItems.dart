import 'package:flutter/material.dart';

class TabItem {
  final int id;
  final String value; // "expenses", "budget", "profile"
  final String label; // "Expenses", "Budget", "Profile"
  final IconData icon;
  final String routeName;

  const TabItem({
    required this.id,
    required this.value,
    required this.label,
    required this.icon,
    required this.routeName,
  });
}
