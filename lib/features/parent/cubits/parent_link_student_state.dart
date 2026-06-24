import 'package:equatable/equatable.dart';

abstract class ParentLinkStudentState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ParentLinkStudentInitial extends ParentLinkStudentState {}

class ParentLinkStudentLoading extends ParentLinkStudentState {}

class ParentLinkStudentSuccess extends ParentLinkStudentState {
  final String message;

  ParentLinkStudentSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class ParentLinkStudentError extends ParentLinkStudentState {
  final String message;

  ParentLinkStudentError(this.message);

  @override
  List<Object?> get props => [message];
}