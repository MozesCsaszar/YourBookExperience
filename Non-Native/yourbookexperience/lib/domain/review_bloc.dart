import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'review_event.dart';
part 'review_state.dart';

class ReviewBloc extends Bloc<ReviewEvent, ReviewState> {
  ReviewBloc() : super(InitialState()) {
    on<LoadingEvent>(_onLoading);
    on<LoadedEvent>(_onLoaded);
    on<LoadingErrorEvent>(_onLoadingError);
    on<ModifyingEvent>(_onModifying);
    on<ModifiedEvent>(_onModified);
    on<ModifyingErrorEvent>(_onModifyingError);
  }

  FutureOr<void> _onLoading(
      LoadingEvent event, Emitter<ReviewState> emit) async {
    emit(LoadingState());

    // await Repo.loadReviews();

    // emit(LoadedState());
  }

  FutureOr<void> _onLoaded(LoadedEvent event, Emitter<ReviewState> emit) async {
    emit(LoadedState());

    // await Repo.loadReviews();

    // emit(LoadedState());
  }

  FutureOr<void> _onLoadingError(
      LoadingErrorEvent event, Emitter<ReviewState> emit) async {
    emit(LoadingErrorState());

    // await Repo.loadReviews();

    // emit(LoadedState());
  }

  FutureOr<void> _onModifying(
      ModifyingEvent event, Emitter<ReviewState> emit) async {
    emit(ModifyingState());

    // await Repo.loadReviews();

    // emit(LoadedState());
  }

  FutureOr<void> _onModified(
      ModifiedEvent event, Emitter<ReviewState> emit) async {
    emit(ModifiedState());

    // await Repo.loadReviews();

    // emit(LoadedState());
  }

  FutureOr<void> _onModifyingError(
      ModifyingErrorEvent event, Emitter<ReviewState> emit) async {
    emit(ModifyingErrorState());

    // await Repo.loadReviews();

    // emit(LoadedState());
  }
}
