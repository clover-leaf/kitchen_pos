part of 'order_bloc.dart';

abstract class OrderEvent extends Equatable {
  const OrderEvent();

  @override
  List<Object> get props => [];
}

class StartOrder extends OrderEvent {
  const StartOrder();
}

class SelectDish extends OrderEvent {
  const SelectDish(this.invoiceDish);

  final InvoiceDish invoiceDish;
}

class UnselectDish extends OrderEvent {
  const UnselectDish(this.invoiceDish);

  final InvoiceDish invoiceDish;
}

class DeliveryDish extends OrderEvent {
  const DeliveryDish();
}

class _InvoiceChange extends OrderEvent {
  const _InvoiceChange(this.invoice);

  final Invoice? invoice;
}

class _PrepareDishChange extends OrderEvent {
  const _PrepareDishChange(this.invoiceDishes);

  final List<InvoiceDish> invoiceDishes;
}

class _DeliveryDishChange extends OrderEvent {
  const _DeliveryDishChange(this.invoiceDishes);

  final List<InvoiceDish> invoiceDishes;
}
