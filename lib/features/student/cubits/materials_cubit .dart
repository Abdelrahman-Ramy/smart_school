import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_school/features/student/cubits/materials_state%20.dart';
import 'package:smart_school/features/student/data/student_repo.dart';

class MaterialsCubit extends Cubit<MaterialsState> {
  final StudentRepo repo;

  MaterialsCubit(this.repo) : super(MaterialsInitial());

  Future<void> getMaterials() async {
    emit(MaterialsLoading());

    try {
      final data = await repo.getMaterials();
      emit(MaterialsLoaded(data));
    } catch (e) {
      emit(MaterialsError(e.toString()));
    }
  }
}
