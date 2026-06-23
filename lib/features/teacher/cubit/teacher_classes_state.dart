import 'package:smart_school/features/teacher/data/teacher_class_model.dart';

abstract class TeacherClassesState {}

class TeacherClassesInitial extends TeacherClassesState {}

class TeacherClassesLoading extends TeacherClassesState {}

class TeacherClassesLoaded extends TeacherClassesState {
  final List<TeacherClassModel> classes;
  TeacherClassesLoaded(this.classes);
}

class TeacherClassesError extends TeacherClassesState {
  final String message;
  TeacherClassesError(this.message);
}
