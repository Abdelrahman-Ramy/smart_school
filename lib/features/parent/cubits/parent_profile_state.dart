import 'package:equatable/equatable.dart';
import 'package:smart_school/features/parent/data/parent_profile_model.dart';

abstract class ParentProfileState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ParentProfileInitial extends ParentProfileState {}

class ParentProfileLoading extends ParentProfileState {}

class ParentProfileLoaded extends ParentProfileState {
  final ParentProfileModel profile;

  ParentProfileLoaded(this.profile);

  @override
  List<Object?> get props => [profile];
}

class ParentProfileError extends ParentProfileState {
  final String message;

  ParentProfileError(this.message);

  @override
  List<Object?> get props => [message];
}
