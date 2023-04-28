import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:client_repository/client_repository.dart';
import 'package:equatable/equatable.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc({
    required ClientRepository clientRepository,
  })  : _clientRepository = clientRepository,
        super(
          HomeState(
            shouldShowRobotReadyNotify: const ShouldShowNotify(value: false),
            shouldShowRobotOnDutyNotify: const ShouldShowNotify(value: false),
            shouldShowRobotUnreadyNotify: const ShouldShowNotify(value: false),
          ),
        ) {
    on<ChangeTab>(_onChangeTab);
    on<SubscribeRobotReady>(_onSubscribeRobotReady);
    on<_Ready>(_onReady);
    on<_Unready>(_onUnready);
    on<_OnDuty>(_onOnDuty);
  }
  final ClientRepository _clientRepository;
  StreamSubscription<int>? _robotReadySubscription;

  void _onChangeTab(ChangeTab event, Emitter<HomeState> emit) {
    emit(state.copyWith(tab: event.tab));
  }

  void _onSubscribeRobotReady(
    SubscribeRobotReady event,
    Emitter<HomeState> emit,
  ) {
    _robotReadySubscription = _clientRepository.isReady.listen((readyStatus) {
      // 0: no food so cant deliver
      // 1: have food, start deliver
      // 2: is on delivering, cant start new deliver
      switch (readyStatus) {
        case 0:
          add(const _Unready());
          break;
        case 1:
          add(const _Ready());
          break;
        case 2:
          add(const _OnDuty());
          break;
        default:
      }
    });
  }

  void _onReady(_Ready event, Emitter<HomeState> emit) {
    emit(
      state.copyWith(
        shouldShowRobotReadyNotify: const ShouldShowNotify(value: true),
        shouldShowRobotOnDutyNotify: const ShouldShowNotify(value: false),
        shouldShowRobotUnreadyNotify: const ShouldShowNotify(value: false),
      ),
    );
  }

  void _onUnready(_Unready event, Emitter<HomeState> emit) {
    emit(
      state.copyWith(
        shouldShowRobotReadyNotify: const ShouldShowNotify(value: true),
        shouldShowRobotOnDutyNotify: const ShouldShowNotify(value: false),
        shouldShowRobotUnreadyNotify: const ShouldShowNotify(value: true),
      ),
    );
  }

  void _onOnDuty(_OnDuty event, Emitter<HomeState> emit) {
    emit(
      state.copyWith(
        shouldShowRobotReadyNotify: const ShouldShowNotify(value: true),
        shouldShowRobotOnDutyNotify: const ShouldShowNotify(value: true),
        shouldShowRobotUnreadyNotify: const ShouldShowNotify(value: true),
      ),
    );
  }

  @override
  Future<void> close() {
    _robotReadySubscription?.cancel();
    return super.close();
  }
}
