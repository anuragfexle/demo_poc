import 'package:flutter_bloc/flutter_bloc.dart';

// Theme State
enum AppThemeMode { light, dark, system }

class ThemeCubit extends Cubit<AppThemeMode> {
  ThemeCubit() : super(AppThemeMode.system);

  void setLightTheme() => emit(AppThemeMode.light);

  void setDarkTheme() => emit(AppThemeMode.dark);

  void setSystemTheme() => emit(AppThemeMode.system);

  void toggleTheme() {
    if (state == AppThemeMode.light) {
      emit(AppThemeMode.dark);
    } else {
      emit(AppThemeMode.light);
    }
  }
}
