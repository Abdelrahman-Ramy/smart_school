import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/parent_repo.dart';
import 'parent_profile_state.dart';

class ParentProfileCubit extends Cubit<ParentProfileState> {
  final ParentRepo repo;

  ParentProfileCubit(this.repo)
      : super(ParentProfileInitial());

  Future<void> getProfile() async {
    try {
      emit(ParentProfileLoading());

      final profile = await repo.getProfile();

      emit(ParentProfileLoaded(profile));
    } catch (e) {
      emit(
        ParentProfileError(
          e.toString(),
        ),
      );
    }
  }
}