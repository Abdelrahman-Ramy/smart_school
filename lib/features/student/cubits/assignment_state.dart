import 'package:equatable/equatable.dart';
import 'package:smart_school/features/student/data/assignment_student_model.dart';

abstract class AssignmentState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AssignmentInitial extends AssignmentState {}

class AssignmentLoading extends AssignmentState {}

class AssignmentUploading extends AssignmentState {}

class AssignmentUploadSuccess extends AssignmentState {
  final String message;

  AssignmentUploadSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class AssignmentAlreadySubmitted extends AssignmentState {
  final String message;

  AssignmentAlreadySubmitted(this.message);

  @override
  List<Object?> get props => [message];
}

class AssignmentError extends AssignmentState {
  final String message;

  AssignmentError(this.message);

  @override
  List<Object?> get props => [message];
}

class AssignmentLoaded extends AssignmentState {
  final List<AssignmentStudentModel> assignments;

  AssignmentLoaded({required this.assignments});

  @override
  List<Object?> get props => [assignments];
}