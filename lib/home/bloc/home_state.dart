part of 'home_bloc.dart';

enum HomeTab {
  orders('Orders'),
  rating('Reviews');

  const HomeTab(this.value);
  final String value;
}

class HomeState {
  HomeState({
    this.tab = HomeTab.orders,
    required this.shouldShowRobotReadyNotify,
    required this.shouldShowRobotOnDutyNotify,
    required this.shouldShowRobotUnreadyNotify,
  });

  final HomeTab tab;
  final ShouldShowNotify shouldShowRobotReadyNotify;
  final ShouldShowNotify shouldShowRobotOnDutyNotify;
  final ShouldShowNotify shouldShowRobotUnreadyNotify;

  // @override
  // List<Object> get props => [tab, isShowDeliveryNotify];

  HomeState copyWith({
    HomeTab? tab,
    ShouldShowNotify? shouldShowRobotReadyNotify,
    ShouldShowNotify? shouldShowRobotOnDutyNotify,
    ShouldShowNotify? shouldShowRobotUnreadyNotify,
  }) =>
      HomeState(
        tab: tab ?? this.tab,
        shouldShowRobotReadyNotify:
            shouldShowRobotReadyNotify ?? this.shouldShowRobotReadyNotify,
        shouldShowRobotOnDutyNotify:
            shouldShowRobotOnDutyNotify ?? this.shouldShowRobotOnDutyNotify,
        shouldShowRobotUnreadyNotify:
            shouldShowRobotUnreadyNotify ?? this.shouldShowRobotUnreadyNotify,
      );
}

class ShouldShowNotify {
  const ShouldShowNotify({required this.value});
  final bool value;
}
