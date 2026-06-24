import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_school/features/parent/cubits/parent_results_state.dart';
import 'package:smart_school/features/parent/data/parent_repo.dart';

class ParentResultsCubit extends Cubit<ParentResultsState> {
  final ParentRepo repo;

  ParentResultsCubit(this.repo) : super(ParentResultsInitial());

  Future<void> getResults() async {
    try {
      emit(ParentResultsLoading());

      final results = await repo.getResults();

      emit(ParentResultsSuccess(results));
    } catch (e) {
      emit(ParentResultsError(e.toString()));
    }
  }
}
