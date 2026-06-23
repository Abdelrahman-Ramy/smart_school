import 'package:bloc/bloc.dart';
import 'package:smart_school/features/teacher/data/teacher_repo.dart';
import 'upload_material_state.dart';

class UploadMaterialCubit extends Cubit<UploadMaterialState> {
  final TeacherRepo _repo;
  UploadMaterialCubit(this._repo) : super(UploadMaterialInitial());

  Future<void> uploadMaterial({
    required String classId,
    required String title,
    required String filePath,
  }) async {
    emit(UploadMaterialSubmitting());
    try {
      final res = await _repo.uploadMaterial(
        classId: classId,
        title: title,
        filePath: filePath,
      );

      final msg = res.message ?? 'Upload completed';
      if (res.success == true) {
        emit(UploadMaterialSuccess(msg));
      } else {
        emit(UploadMaterialFailure(msg));
      }
    } catch (e) {
      emit(UploadMaterialFailure(e.toString()));
    }
  }
}
