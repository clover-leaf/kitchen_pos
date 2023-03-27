import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:client_repository/client_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:pos_server/pos_server.dart';

part 'order_event.dart';
part 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  OrderBloc({required ClientRepository clientRepository})
      : _clientRepository = clientRepository,
        super(const OrderState()) {
    on<StartOrder>(_onStart);
    on<SelectDish>(_onSelectDish);
    on<UnselectDish>(_onUnselectDish);
    on<DeliveryDish>(_onDeliveryDish);
    on<_InvoiceChange>(_onInvoiceChange);
    on<_DeliveryDishChange>(_onDeliveryDishChange);
    on<_PrepareDishChange>(_onPrepareDishChange);
  }

  final ClientRepository _clientRepository;
  StreamSubscription<Invoice?>? _invoiceSubscription;
  StreamSubscription<List<InvoiceDish>>? _prepareDishesSubscription;
  StreamSubscription<List<InvoiceDish>>? _deliveryDishesSubscription;

  Future<void> _onStart(StartOrder event, Emitter<OrderState> emit) async {
    if (state.status.isSuccess()) return;

    try {
      final res = await _clientRepository.requestMenu();
      final dishes = fromJson(Dish.fromJson, res['dish']);

      _invoiceSubscription = _clientRepository.invoice
          .listen((invoice) => add(_InvoiceChange(invoice)));
      _prepareDishesSubscription = _clientRepository.prepareDishes
          .listen((state) => add(_PrepareDishChange(state)));
      _deliveryDishesSubscription = _clientRepository.deliveryDishes
          .listen((state) => add(_DeliveryDishChange(state)));

      emit(state.copyWith(dishes: dishes, status: LoadingStatus.success));
    } catch (e) {
      emit(state.copyWith(status: LoadingStatus.failure));
    }
  }

  void _onSelectDish(SelectDish event, Emitter<OrderState> emit) {
    final selectedDishes = List<InvoiceDish>.from(state.selectedDishes);
    if (!selectedDishes.contains(event.invoiceDish)) {
      selectedDishes.add(event.invoiceDish);
      emit(state.copyWith(selectedDishes: selectedDishes));
    }
  }

  void _onUnselectDish(UnselectDish event, Emitter<OrderState> emit) {
    final selectedDishes = List<InvoiceDish>.from(state.selectedDishes);
    if (selectedDishes.contains(event.invoiceDish)) {
      selectedDishes.remove(event.invoiceDish);
      emit(state.copyWith(selectedDishes: selectedDishes));
    }
  }

  void _onDeliveryDish(DeliveryDish event, Emitter<OrderState> emit) {
    final data = {'invoice_dishes': state.selectedDishes};
    _clientRepository.delivery(data);
    emit(state.copyWith(selectedDishes: []));
  }

  void _onInvoiceChange(_InvoiceChange event, Emitter<OrderState> emit) {
    if (event.invoice == null) return;
    final invoices = List<Invoice>.from(state.invoices)..add(event.invoice!);
    emit(state.copyWith(invoices: invoices));
  }

  void _onPrepareDishChange(
    _PrepareDishChange event,
    Emitter<OrderState> emit,
  ) {
    final updatePrepareDishes = [
      ...state.prepareDishes,
      ...event.invoiceDishes
    ];
    emit(state.copyWith(prepareDishes: updatePrepareDishes));
  }

  void _onDeliveryDishChange(
    _DeliveryDishChange event,
    Emitter<OrderState> emit,
  ) {
    final newDeliveryDishId = event.invoiceDishes.map((dish) => dish.id);
    final updatePrepareDishes = List<InvoiceDish>.from(state.prepareDishes)
      ..removeWhere((dish) => newDeliveryDishId.contains(dish.id));

    emit(state.copyWith(prepareDishes: updatePrepareDishes));
  }

  @override
  Future<void> close() {
    _invoiceSubscription?.cancel();
    _prepareDishesSubscription?.cancel();
    _deliveryDishesSubscription?.cancel();
    return super.close();
  }
}
