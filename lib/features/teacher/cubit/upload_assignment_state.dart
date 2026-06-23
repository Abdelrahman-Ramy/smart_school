import 'package:equatable/equatable.dart';

abstract class UploadAssignmentState extends Equatable {
  @override
  List<Object?> get props => [];
}

class UploadAssignmentInitial extends UploadAssignmentState {}

class UploadAssignmentSubmitting extends UploadAssignmentState {}

class UploadAssignmentSuccess extends UploadAssignmentState {
  final String message;
  final dynamic data;
  UploadAssignmentSuccess(this.message, {this.data});

  @override
  List<Object?> get props => [message, data];
}

class UploadAssignmentFailure extends UploadAssignmentState {
  final String error;
  UploadAssignmentFailure(this.error);

  @override
  List<Object?> get props => [error];
}
