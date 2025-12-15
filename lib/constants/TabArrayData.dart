import 'package:demo_poc/models/TabItems.dart';
import 'package:demo_poc/routes/app_routes.dart';
import 'package:flutter/material.dart';

final List<TabItem> tabs = [
  TabItem(
    id: 1,
    value: 'expenses',
    label: 'Expenses',
    icon: Icons.receipt_long,
    routeName: AppRoutes.expenses,
  ),
  TabItem(
    id: 2,
    value: 'budget',
    label: 'Budget',
    icon: Icons.pie_chart,
    routeName: AppRoutes.budget,
  ),
  TabItem(
    id: 3,
    value: 'profile',
    label: 'Profile',
    icon: Icons.person,
    routeName: AppRoutes.profile,
  ),
];
