part of 'review_bloc.dart';

abstract class ReviewEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadingEvent extends ReviewEvent {}

class LoadedEvent extends ReviewEvent {}

class InitRepoEvent extends ReviewEvent {}

class AddReviewEvent extends ReviewEvent {
  final Review review;

  AddReviewEvent({required this.review});

  @override
  List<Object?> get props => [review];
}

class DeleteReviewEvent extends ReviewEvent {
  final int reviewId;

  DeleteReviewEvent({required this.reviewId});

  @override
  List<Object?> get props => [reviewId];
}

class UpdateReviewEvent extends ReviewEvent {
  final int reviewId;
  final Review review;
  UpdateReviewEvent({required this.reviewId, required this.review});

  @override
  List<Object?> get props => [review, reviewId];
}

class LoadingErrorEvent extends ReviewEvent {}

class ModifyingEvent extends ReviewEvent {}

class ModifiedEvent extends ReviewEvent {}

class ModifyingErrorEvent extends ReviewEvent {
  final String message;

  ModifyingErrorEvent({required this.message});

  @override
  List<Object?> get props => [message];
}
