part of 'order_bloc.dart';

enum LoadingStatus { loading, success, failure }

extension LoadingStatusX on LoadingStatus {
  bool isLoading() => this == LoadingStatus.loading;
  bool isSuccess() => this == LoadingStatus.success;
  bool isFailure() => this == LoadingStatus.failure;
}

class OrderState extends Equatable {
  const OrderState({
    this.status = LoadingStatus.loading,
    this.dishes = const <Dish>[],
    this.invoices = const <Invoice>[],
    this.prepareDishes = const <InvoiceDish>[],
    this.selectedDishes = const <InvoiceDish>[],
  });

  final LoadingStatus status;
  final List<Dish> dishes;
  final List<Invoice> invoices;
  final List<InvoiceDish> prepareDishes;
  final List<InvoiceDish> selectedDishes;

  int get prepareDishesNumber => prepareDishes.length;

  Map<String, Dish> get dishView => {for (final dish in dishes) dish.id: dish};

  Map<String, Invoice> get invoiceView =>
      {for (final invoice in invoices) invoice.id: invoice};

  Map<String, Iterable<InvoiceDish>> get invoiceDishView => {
        for (final invoice in invoices)
          invoice.id:
              prepareDishes.where((dish) => dish.invoiceId == invoice.id)
      };

  @override
  List<Object> get props =>
      [status, dishes, invoices, prepareDishes, selectedDishes];

  OrderState copyWith({
    LoadingStatus? status,
    List<Dish>? dishes,
    List<Invoice>? invoices,
    List<InvoiceDish>? prepareDishes,
    List<InvoiceDish>? selectedDishes,
  }) {
    return OrderState(
      status: status ?? this.status,
      dishes: dishes ?? this.dishes,
      invoices: invoices ?? this.invoices,
      prepareDishes: prepareDishes ?? this.prepareDishes,
      selectedDishes: selectedDishes ?? this.selectedDishes,
    );
  }
}
