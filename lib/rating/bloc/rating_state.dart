part of 'rating_bloc.dart';

enum LoadingStatus { loading, success, failure }

extension LoadingStatusX on LoadingStatus {
  bool isLoading() => this == LoadingStatus.loading;
  bool isSuccess() => this == LoadingStatus.success;
  bool isFailure() => this == LoadingStatus.failure;
}

class RatingState extends Equatable {
  const RatingState({
    this.dishes = const <Dish>[],
    this.reviews = const <String, List<int>>{},
    this.status = LoadingStatus.loading,
  });

  // Data got from server
  final List<Dish> dishes;
  final Map<String, List<int>> reviews;
  final LoadingStatus status;

  @override
  List<Object?> get props => [
        dishes,
        status,
      ];

  RatingState copyWith({
    List<Dish>? dishes,
    Map<String, List<int>>? reviews,
    LoadingStatus? status,
  }) =>
      RatingState(
        dishes: dishes ?? this.dishes,
        reviews: reviews ?? this.reviews,
        status: status ?? this.status,
      );
}
