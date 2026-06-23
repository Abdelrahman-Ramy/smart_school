abstract class UploadGradesState {}

class UploadGradesInitial extends UploadGradesState {}

class UploadGradesLoading extends UploadGradesState {}

class UploadGradesStudentsLoaded extends UploadGradesState {
  final List<dynamic> students;
  UploadGradesStudentsLoaded(this.students);
}

class UploadGradesSubmitting extends UploadGradesState {}

class UploadGradesSuccess extends UploadGradesState {
  final String message;
  UploadGradesSuccess(this.message);
}

class UploadGradesFailure extends UploadGradesState {
  final String error;
  UploadGradesFailure(this.error);
}