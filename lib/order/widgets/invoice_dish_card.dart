import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kitchen_pos/gen/colors.gen.dart';
import 'package:kitchen_pos/order/order.dart';
import 'package:pos_server/server/server.dart';

class InvoiceDishCard extends StatelessWidget {
  const InvoiceDishCard(this.invoiceDish, {super.key});

  final InvoiceDish invoiceDish;

  @override
  Widget build(BuildContext context) {
    final selectedDishes =
        context.select((OrderBloc bloc) => bloc.state.selectedDishes);
    final dishView = context.select((OrderBloc bloc) => bloc.state.dishView);
    final dish = dishView[invoiceDish.dishId]!;
    final isSelected = selectedDishes.contains(invoiceDish);

    return GestureDetector(
      onTap: isSelected
          ? () => context.read<OrderBloc>().add(UnselectDish(invoiceDish))
          : () => context.read<OrderBloc>().add(SelectDish(invoiceDish)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
          border: Border.all(
            color: isSelected ? ColorName.blue900 : Colors.transparent,
          ),
        ),
        padding: const EdgeInsets.all(8),
        child: SizedBox(
          height: 64,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(8),
                  bottomLeft: Radius.circular(8),
                ),
                child: AspectRatio(
                  aspectRatio: 1.6,
                  child: CachedNetworkImage(
                    imageUrl: dish.url,
                    fit: BoxFit.cover,
                    placeholder: (context, _) => Container(
                      color: ColorName.grey100,
                    ),
                  ),
                ),
              ),
              NameAndQuantityLabel(
                dishName: dish.name,
                quantity: invoiceDish.quantity,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NameAndQuantityLabel extends StatelessWidget {
  const NameAndQuantityLabel({
    required this.dishName,
    required this.quantity,
    super.key,
  });

  final String dishName;
  final int quantity;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            dishName,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: ColorName.text100,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Quantity: $quantity',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: ColorName.text100,
            ),
          )
        ],
      ),
    );
  }
}
