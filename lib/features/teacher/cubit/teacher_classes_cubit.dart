import 'package:bloc/bloc.dart';
import 'package:smart_school/features/teacher/data/teacher_class_model.dart';
import 'package:smart_school/features/teacher/data/teacher_repo.dart';
import 'teacher_classes_state.dart';

class TeacherClassesCubit extends Cubit<TeacherClassesState> {
  final TeacherRepo _repo;
  TeacherClassesCubit(this._repo) : super(TeacherClassesInitial());

  Future<void> fetchClasses() async {
    emit(TeacherClassesLoading());
    try {
      final classes = await _repo.fetchTeacherClasses();
      emit(TeacherClassesLoaded(classes));
    } catch (e) {
      String msg = 'Failed to load classes';
      if (e is Exception) msg = e.toString();
      emit(TeacherClassesError(msg));
    }
  }
}
