part of 'review_bloc.dart';

abstract class ReviewState extends Equatable {
  @override
  List<Object?> get props => [];
}

class InitialState extends ReviewState {}

class LoadingState extends ReviewState {}

class LoadedState extends ReviewState {}

class LoadingErrorState extends ReviewState {}

class ModifyingState extends ReviewState {}

class ModifiedState extends ReviewState {}

class ModifyingErrorState extends ReviewState {}
