part of 'home_cubit.dart';

enum HomeTab {
  order('Orders');

  const HomeTab(this.value);
  final String value;
}

class HomeState extends Equatable {
  const HomeState({this.tab = HomeTab.order});

  final HomeTab tab;

  @override
  List<Object> get props => [tab];
}
