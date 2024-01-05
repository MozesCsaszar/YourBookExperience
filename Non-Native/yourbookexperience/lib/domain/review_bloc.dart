import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yourbookexperience/domain/review.dart';
import 'package:yourbookexperience/repo/repo.dart';

part 'review_event.dart';
part 'review_state.dart';

class ReviewBloc extends Bloc<ReviewEvent, ReviewState> {
  final Repo _repo;
  ReviewBloc(this._repo) : super(InitialState()) {
    on<LoadingEvent>(_onLoading);
    on<LoadedEvent>(_onLoaded);
    on<LoadingErrorEvent>(_onLoadingError);
    on<ModifyingEvent>(_onModifying);
    on<ModifiedEvent>(_onModified);
    on<ModifyingErrorEvent>(_onModifyingError);
    on<AddReviewEvent>(_onAdd);
    on<DeleteReviewEvent>(_onDelete);
    on<UpdateReviewEvent>(_onUpdate);
    on<InitRepoEvent>(_onInitRepo);
  }

  FutureOr<void> _onInitRepo(
      InitRepoEvent event, Emitter<ReviewState> emit) async {
    await _repo.init().then((value) {
      add(LoadingEvent());
    }).catchError((error) {
      print("Error when initializing local DB of the repo: $error");
      if (error ==
          "Error when connecting to the server; data will be loaded from device.") {
        emit(ModifyingErrorState(message: error));
      } else {
        emit(LoadingErrorState());
      }
    });
  }

  FutureOr<void> _onLoading(
      LoadingEvent event, Emitter<ReviewState> emit) async {
    emit(LoadingState());

    await _repo.initialized.future;

    try {
      await _repo.loadReviews().then((value) => emit(LoadedState()));
    } catch (e) {
      if (e ==
          "Error when connecting to the server; data will be loaded from device.") {
        emit(ModifyingErrorState(message: e.toString()));
      } else {
        emit(LoadingErrorState());
      }
    }
  }

  FutureOr<void> _onAdd(AddReviewEvent event, Emitter<ReviewState> emit) async {
    emit(LoadingState());
    try {
      await _repo.initialized.future;

      await _repo.addReview(event.review);

      await Future.delayed(const Duration(seconds: 1));

      emit(LoadedState());
    } catch (e) {
      emit(ModifyingErrorState(message: "$e"));
    }
  }

  FutureOr<void> _onDelete(
      DeleteReviewEvent event, Emitter<ReviewState> emit) async {
    emit(LoadingState());

    try {
      await _repo.initialized.future;

      await _repo.removeReview(event.reviewId);

      await Future.delayed(const Duration(seconds: 1));

      emit(LoadedState());
    } catch (e) {
      emit(ModifyingErrorState(message: "$e"));
    }
  }

  FutureOr<void> _onUpdate(
      UpdateReviewEvent event, Emitter<ReviewState> emit) async {
    emit(LoadingState());

    try {
      await _repo.initialized.future;

      await _repo.updateReview(event.reviewId, event.review);

      await Future.delayed(const Duration(seconds: 1));

      emit(LoadedState());
    } catch (e) {
      emit(ModifyingErrorState(message: "$e"));
    }
  }

  FutureOr<void> _onLoaded(LoadedEvent event, Emitter<ReviewState> emit) async {
    emit(LoadedState());
  }

  FutureOr<void> _onLoadingError(
      LoadingErrorEvent event, Emitter<ReviewState> emit) async {
    emit(LoadingErrorState());
  }

  FutureOr<void> _onModifying(
      ModifyingEvent event, Emitter<ReviewState> emit) async {
    emit(ModifyingState());
  }

  FutureOr<void> _onModified(
      ModifiedEvent event, Emitter<ReviewState> emit) async {
    emit(ModifiedState());
  }

  FutureOr<void> _onModifyingError(
      ModifyingErrorEvent event, Emitter<ReviewState> emit) async {
    emit(ModifyingErrorState(message: event.message));
  }
}
