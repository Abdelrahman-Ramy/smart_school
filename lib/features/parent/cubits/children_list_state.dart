import 'package:smart_school/features/parent/data/parent_student_model.dart';

abstract class ParentChildrenListState {}

class ParentChildrenListInitial extends ParentChildrenListState {}

class ParentChildrenListLoading extends ParentChildrenListState {}

class ParentChildrenListSuccess extends ParentChildrenListState {
  final List<ParentStudentModel> children;

  ParentChildrenListSuccess(this.children);
}

class ParentChildrenListError extends ParentChildrenListState {
  final String message;

  ParentChildrenListError(this.message);
}
