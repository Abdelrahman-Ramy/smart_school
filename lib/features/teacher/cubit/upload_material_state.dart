import 'package:equatable/equatable.dart';

abstract class UploadMaterialState extends Equatable {
  @override
  List<Object?> get props => [];
}

class UploadMaterialInitial extends UploadMaterialState {}

class UploadMaterialSubmitting extends UploadMaterialState {}

class UploadMaterialSuccess extends UploadMaterialState {
  final String message;
  UploadMaterialSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class UploadMaterialFailure extends UploadMaterialState {
  final String error;
  UploadMaterialFailure(this.error);

  @override
  List<Object?> get props => [error];
}
