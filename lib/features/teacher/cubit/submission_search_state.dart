import 'package:equatable/equatable.dart';
import 'package:smart_school/features/teacher/data/submission_model.dart';
import 'package:smart_school/features/teacher/data/assignment_model.dart';

abstract class SubmissionSearchState extends Equatable {
  @override
  List<Object?> get props => [];
}

class SubmissionSearchInitial extends SubmissionSearchState {}

class SubmissionSearchLoading extends SubmissionSearchState {}

class SubmissionSearchSuccess extends SubmissionSearchState {
  final AssignmentModel? assignment;
  final List<SubmissionModel> submissions;
  SubmissionSearchSuccess(this.assignment, this.submissions);

  @override
  List<Object?> get props => [assignment, submissions];
}

class SubmissionSearchEmpty extends SubmissionSearchState {}

class SubmissionSearchFailure extends SubmissionSearchState {
  final String error;
  SubmissionSearchFailure(this.error);

  @override
  List<Object?> get props => [error];
}
