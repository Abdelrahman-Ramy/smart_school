import 'package:equatable/equatable.dart';
import 'package:smart_school/features/parent/data/parent_results_model.dart';

abstract class ParentResultsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ParentResultsInitial extends ParentResultsState {}

class ParentResultsLoading extends ParentResultsState {}

class ParentResultsSuccess extends ParentResultsState {
  final List<ParentResultModel> results;

  ParentResultsSuccess(this.results);

  @override
  List<Object?> get props => [results];
}

class ParentResultsError extends ParentResultsState {
  final String message;

  ParentResultsError(this.message);

  @override
  List<Object?> get props => [message];
}
