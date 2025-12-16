import 'package:bloc/bloc.dart';
import 'package:demo_poc/bloc/profile/profile_event.dart';
import 'package:demo_poc/bloc/profile/profile_state.dart';
import 'package:demo_poc/repositories/profile_repository.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepository _repository;

  ProfileBloc(this._repository) : super(ProfileInitial()) {
    on<LoadProfile>(_onLoadProfile);
    on<UpdateProfile>(_onUpdateProfile);
  }

  Future<void> _onLoadProfile(
    LoadProfile event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());
    try {
      final profile = await _repository.getProfile();
      emit(ProfileLoaded(profile));
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  Future<void> _onUpdateProfile(
    UpdateProfile event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      await _repository.saveProfile(event.profile);
      emit(ProfileLoaded(event.profile));
    } catch (e) {
      emit(ProfileError(e.toString()));
      // Optionally reload to revert state
      add(LoadProfile());
    }
  }
}
