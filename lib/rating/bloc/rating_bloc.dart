import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:client_repository/client_repository.dart';
import 'package:equatable/equatable.dart';

part 'rating_event.dart';
part 'rating_state.dart';

class RatingBloc extends Bloc<RatingEvent, RatingState> {
  RatingBloc({
    required ClientRepository clientRepository,
  })  : _clientRepository = clientRepository,
        super(const RatingState()) {
    on<Start>(_onStart);
    on<Refresh>(_onRefresh);
  }

  final ClientRepository _clientRepository;

  Future<void> _onStart(Start event, Emitter<RatingState> emit) async {
    if (state.status.isSuccess()) return;
    try {
      final resMenu = await _clientRepository.requestMenu();
      // final categories = fromJson(Category.fromJson, resMenu['category']);
      final dishes = fromJson(Dish.fromJson, resMenu['dish']);
      final resReview = await _clientRepository.getReview();
      final reviews = resReview.map(
        (key, value) => MapEntry(
          key,
          (value as List<dynamic>).map((e) => e as int).toList(),
        ),
      );

      emit(
        state.copyWith(
          dishes: dishes,
          reviews: reviews,
          status: LoadingStatus.success,
        ),
      );
    } catch (e) {
      log(e.toString());
      emit(state.copyWith(status: LoadingStatus.failure));
    }
  }

  Future<void> _onRefresh(Refresh event, Emitter<RatingState> emit) async {
    emit(state.copyWith(status: LoadingStatus.loading));
    try {
      final resReview = await _clientRepository.getReview();
      final reviews = resReview.map(
        (key, value) => MapEntry(
          key,
          (value as List<dynamic>).map((e) => e as int).toList(),
        ),
      );

      emit(
        state.copyWith(
          reviews: reviews,
          status: LoadingStatus.success,
        ),
      );
    } catch (e) {
      log(e.toString());
      emit(state.copyWith(status: LoadingStatus.failure));
    }
  }
}
