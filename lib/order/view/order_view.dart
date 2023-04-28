import 'package:client_repository/client_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:kitchen_pos/gen/colors.gen.dart';
import 'package:kitchen_pos/order/order.dart';

class OrderView extends StatelessWidget {
  const OrderView({super.key});

  @override
  Widget build(BuildContext context) {
    final invoices = context.select((OrderBloc bloc) => bloc.state.invoices);
    final invoiceDishView =
        context.select((OrderBloc bloc) => bloc.state.invoiceDishView);
    final uncompleteInvoices = invoices
        .where((invoice) => invoiceDishView[invoice.id]!.isNotEmpty)
        .toList();

    final status = context.select((OrderBloc bloc) => bloc.state.status);

    if (status.isLoading()) {
      return const Center(
        child: CircularProgressIndicator(
          color: ColorName.blue700,
        ),
      );
    }

    if (status.isFailure()) {
      return const Center(
        child: Text(
          'Something wrong has happened!',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: ColorName.text100,
          ),
        ),
      );
    }

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(0, 24, 24, 24),
      child: Column(
        children: [
          Expanded(
            child: ListView.separated(
              itemCount: uncompleteInvoices.length,
              itemBuilder: (context, index) {
                final invoice = uncompleteInvoices[index];
                final invoiceDishes = invoiceDishView[invoice.id]!;
                return InvoiceCard(
                  invoice: invoice,
                  invoiceDishes: invoiceDishes,
                );
              },
              separatorBuilder: (context, index) => const SizedBox(height: 16),
            ),
          ),
          const DeliveryButton()
        ],
      ),
    );
  }
}

class InvoiceCard extends StatelessWidget {
  const InvoiceCard({
    required this.invoice,
    required this.invoiceDishes,
    super.key,
  });

  final Invoice invoice;
  final Iterable<InvoiceDish> invoiceDishes;

  @override
  Widget build(BuildContext context) {
    final time = DateFormat('dd MMM yyyy hh:mm:ss').format(invoice.time);

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        border: Border.all(
          color: ColorName.blue600,
          width: 1.2,
        ),
        // color: ColorName.blue100,
        // gradient: LinearGradient(
        //   colors: [
        //     ColorName.blue200,
        //     Colors.white,
        //   ],
        // ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'ORDER #${invoice.id.split("-").last}',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: ColorName.text200,
                ),
              ),
              Text(
                'Placed on $time',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: ColorName.text100,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: invoiceDishes.map(InvoiceDishCard.new).toList(),
          )
        ],
      ),
    );
  }
}

class DeliveryButton extends StatelessWidget {
  const DeliveryButton({super.key});

  @override
  Widget build(BuildContext context) {
    final selectedDishes =
        context.select((OrderBloc bloc) => bloc.state.selectedDishes);
    final isEnabled = selectedDishes.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 0, 8, 0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: isEnabled ? ColorName.blue700 : ColorName.grey100,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          minimumSize: const Size(double.infinity, 20),
        ),
        onPressed: isEnabled
            ? () => context.read<OrderBloc>().add(const DeliveryDish())
            : null,
        child: const Padding(
          padding: EdgeInsets.symmetric(vertical: 16),
          child: Text(
            'DELIVER',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }
}
