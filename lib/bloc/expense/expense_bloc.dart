import 'package:bloc/bloc.dart';
import 'package:demo_poc/bloc/expense/expense_event.dart';
import 'package:demo_poc/bloc/expense/expense_state.dart';
import 'package:demo_poc/models/expense.dart';
import 'package:demo_poc/repositories/expense_repository.dart';

class ExpenseBloc extends Bloc<ExpenseEvent, ExpenseState> {
  final ExpenseRepository _repository;

  ExpenseBloc(this._repository) : super(ExpenseInitial()) {
    on<LoadExpenses>(_onLoadExpenses);
    on<AddExpenseEvent>(_onAddExpense);
    on<UpdateExpenseEvent>(_onUpdateExpense);
    on<DeleteExpenseEvent>(_onDeleteExpense);
  }

  Future<void> _onLoadExpenses(
    LoadExpenses event,
    Emitter<ExpenseState> emit,
  ) async {
    emit(ExpenseLoading());
    try {
      final expenses = await _repository.getExpenses();
      emit(ExpenseLoaded(expenses));
    } catch (e) {
      emit(ExpenseError(e.toString()));
    }
  }

  Future<void> _onAddExpense(
    AddExpenseEvent event,
    Emitter<ExpenseState> emit,
  ) async {
    if (state is! ExpenseLoaded) return;
    final current = (state as ExpenseLoaded).expenses;

    await _repository.addExpense(event.expense);

    final updated = List<Expense>.from(current)..add(event.expense);
    emit(ExpenseLoaded(updated));
  }

  Future<void> _onUpdateExpense(
    UpdateExpenseEvent event,
    Emitter<ExpenseState> emit,
  ) async {
    if (state is! ExpenseLoaded) return;
    final current = (state as ExpenseLoaded).expenses;

    await _repository.updateExpense(event.expense);

    final updated = current
        .map((e) => e.id == event.expense.id ? event.expense : e)
        .toList();
    emit(ExpenseLoaded(updated));
  }

  Future<void> _onDeleteExpense(
    DeleteExpenseEvent event,
    Emitter<ExpenseState> emit,
  ) async {
    if (state is! ExpenseLoaded) return;
    final current = (state as ExpenseLoaded).expenses;

    await _repository.deleteExpense(event.id);

    final updated = current.where((e) => e.id != event.id).toList();
    emit(ExpenseLoaded(updated));
  }
}
