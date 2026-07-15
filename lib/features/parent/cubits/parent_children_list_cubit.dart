import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_school/features/parent/cubits/children_list_state.dart';
import 'package:smart_school/features/parent/data/parent_repo.dart';

class ParentChildrenListCubit extends Cubit<ParentChildrenListState> {
  final ParentRepo repo;

  ParentChildrenListCubit(this.repo) : super(ParentChildrenListInitial());

  Future<void> getChildren() async {
    try {
      emit(ParentChildrenListLoading());

      final data = await repo.getMyChildren();

      emit(ParentChildrenListSuccess(data));
    } catch (e) {
      emit(ParentChildrenListError(e.toString()));
    }
  }

  

  Future<void> unlinkStudent({required String studentId}) async {
    try {
      emit(ParentChildrenListLoading());

      await repo.unlinkStudent(studentId: studentId);

      final updatedList = await repo.getMyChildren();

      emit(ParentChildrenListSuccess(updatedList));
    } catch (e) {
      emit(ParentChildrenListError(e.toString()));
    }
  }


}
