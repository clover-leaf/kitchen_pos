part of 'home_bloc.dart';

abstract class HomeEvent {
  const HomeEvent();
}

class HomeStarted extends HomeEvent {
  const HomeStarted();
}

class _HomeOrderChanged extends HomeEvent {
  const _HomeOrderChanged(this.count);

  final String count;
}
