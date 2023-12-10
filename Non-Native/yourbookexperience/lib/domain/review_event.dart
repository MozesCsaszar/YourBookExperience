part of 'review_bloc.dart';

abstract class ReviewEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadingEvent extends ReviewEvent {}

class LoadedEvent extends ReviewEvent {}

class LoadingErrorEvent extends ReviewEvent {}

class ModifyingEvent extends ReviewEvent {}

class ModifiedEvent extends ReviewEvent {}

class ModifyingErrorEvent extends ReviewEvent {}
