import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:kitchen_repository/kitchen_repository.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc({required KitchenRepository kitchenRepository})
      : _kitchenRepository = kitchenRepository,
        super(const HomeState()) {
    on<HomeStarted>(_onHomeStarted);
    on<_HomeOrderChanged>(_onHomeOrderChanged);
  }
  final KitchenRepository _kitchenRepository;
  StreamSubscription<String>? _messageSubscription;

  void _onHomeStarted(HomeStarted event, Emitter<HomeState> emit) {
    _messageSubscription = _kitchenRepository.count
        .listen((count) => add(_HomeOrderChanged(count)));
  }

  void _onHomeOrderChanged(_HomeOrderChanged event, Emitter<HomeState> emit) {
    emit(state.copyWith(count: event.count));
  }
}
