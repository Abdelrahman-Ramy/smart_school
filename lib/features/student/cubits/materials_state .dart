import 'package:smart_school/features/student/data/student_material_model.dart';

abstract class MaterialsState {}

class MaterialsInitial extends MaterialsState {}

class MaterialsLoading extends MaterialsState {}

class MaterialsLoaded extends MaterialsState {
  final List<StudentMaterialModel> materials;

  MaterialsLoaded(this.materials);
}

class MaterialsError extends MaterialsState {
  final String error;

  MaterialsError(this.error);
}
