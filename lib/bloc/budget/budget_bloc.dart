import 'package:bloc/bloc.dart';
import 'package:demo_poc/bloc/budget/budget_event.dart';
import 'package:demo_poc/bloc/budget/budget_state.dart';
import 'package:demo_poc/repositories/budget_repository.dart';

class BudgetBloc extends Bloc<BudgetEvent, BudgetState> {
  final BudgetRepository _repository;

  BudgetBloc(this._repository) : super(BudgetInitial()) {
    on<LoadBudgets>(_onLoadBudgets);
    on<DeleteBudget>(_onDeleteBudget);
  }

  Future<void> _onLoadBudgets(
    LoadBudgets event,
    Emitter<BudgetState> emit,
  ) async {
    emit(BudgetLoading());
    try {
      final budgets = await _repository.getBudgets();
      emit(BudgetLoaded(budgets));
    } catch (e) {
      emit(BudgetError(e.toString()));
    }
  }

  Future<void> _onDeleteBudget(
    DeleteBudget event,
    Emitter<BudgetState> emit,
  ) async {
    // If we are not loaded, we can't delete effectively or shouldn't
    if (state is! BudgetLoaded) return;

    // We can optimistically remove from UI or wait for API
    // Let's do pessimistic for robustness (wait for repo)
    try {
      await _repository.deleteBudget(event.id);

      // After delete, we can either fetch again or filter the current list
      // Filtering is faster/smoother
      final currentBudgets = (state as BudgetLoaded).budgets;
      final updatedBudgets = currentBudgets
          .where((b) => b.id != event.id)
          .toList();
      emit(BudgetLoaded(updatedBudgets));
    } catch (e) {
      // Ideally emit an error side-effect, but for now we might stay in Loaded
      // or emit Error. Emitting Error replaces the list view with Error view.
      // Better to maybe emit a transient error or just keep it simple.
      // For now, let's just reload to be safe/sync.
      add(LoadBudgets());
    }
  }
}
