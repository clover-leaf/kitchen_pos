part of 'home_bloc.dart';

class HomeState extends Equatable {
  const HomeState({this.count = ''});

  final String count;

  @override
  List<Object?> get props => [count];

  HomeState copyWith({String? count}) {
    return HomeState(
      count: count ?? this.count,
    );
  }
}
