import 'package:demo_poc/repositories/init_dependencies.dart';
import 'package:demo_poc/routes/app_routes.dart';
import 'package:demo_poc/routes/route_generator.dart';
import 'package:demo_poc/screens/BudgetPage.dart';
import 'package:demo_poc/screens/ProfilePage.dart';
import 'package:demo_poc/screens/expense/ExpensePage.dart';
import 'package:flutter/material.dart';
import 'constants/TabArrayData.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/expense/expense_bloc.dart';
import 'bloc/expense/expense_event.dart';
import 'bloc/theme/theme_cubit.dart';
import 'config/app_theme.dart';
import 'dao/expense_hive_dao.dart';
import 'repositories/expense_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initHive();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final expenseRepository = ExpenseRepository(ExpenseHiveDao());

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => ExpenseBloc(expenseRepository)..add(LoadExpenses()),
        ),
        BlocProvider(create: (_) => ThemeCubit()),
      ],
      child: BlocBuilder<ThemeCubit, AppThemeMode>(
        builder: (context, appThemeMode) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'DEMO POC',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: appThemeMode == AppThemeMode.system
                ? ThemeMode.system
                : appThemeMode == AppThemeMode.dark
                ? ThemeMode.dark
                : ThemeMode.light,
            initialRoute: AppRoutes.expenses,
            onGenerateRoute: RouteGenerator.generateRoute,
          );
        },
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  int _currentIndex = 0;

  void _switchScreen(int index, {String? params}) {
    setState(() => _currentIndex = index);

    // Navigate using the nested navigator
    _navigatorKey.currentState!.pushReplacementNamed(
      tabs[index].routeName,
      arguments: params,
    );
  }

  @override
  Widget build(BuildContext context) {
    // final currentTab = tabs[_currentIndex];

    return Scaffold(
      body: Navigator(
        key: _navigatorKey,
        initialRoute: AppRoutes.expenses,
        onGenerateRoute: (settings) {
          // get params
          final params = settings.arguments as String?;

          Widget page;
          switch (settings.name) {
            case AppRoutes.expenses:
              page = ExpensePage(params: params);
              break;
            case AppRoutes.budget:
              page = BudgetPage(params: params, onNavigate: _switchScreen);
              break;
            case AppRoutes.profile:
              page = ProfilePage(params: params, onNavigate: _switchScreen);
              break;
            default:
              page = const Center(child: Text('Page not found'));
          }

          return PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => page,
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: tabs.asMap().entries.map((entry) {
              final index = entry.key;
              final tab = entry.value;

              return _BottomBarItem(
                icon: tab.icon,
                label: tab.label,
                isSelected: _currentIndex == index,
                onTap: () => _switchScreen(index),
              );
            }).toList(),
          ),
        ),
      ),

      // // floating and customized profile tab
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () => _onTabSelected(1),
      //   shape: const CircleBorder(),
      //   child: Icon(tabs[1].icon),
      // ),
      //),
    );
  }
}

// bottom bar item
class _BottomBarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _BottomBarItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = isSelected
        ? Theme.of(context).colorScheme.primary
        : Theme.of(context).colorScheme.onSurfaceVariant;

    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(fontSize: 12, color: color)),
        ],
      ),
    );
  }
}
