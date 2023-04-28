part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class ChangeTab extends HomeEvent {
  const ChangeTab(this.tab);

  final HomeTab tab;
}

class SubscribeRobotReady extends HomeEvent {
  const SubscribeRobotReady();
}

class _Ready extends HomeEvent {
  const _Ready();
}

class _Unready extends HomeEvent {
  const _Unready();
}

class _OnDuty extends HomeEvent {
  const _OnDuty();
}
