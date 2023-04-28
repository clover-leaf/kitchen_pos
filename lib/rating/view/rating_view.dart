import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kitchen_pos/gen/colors.gen.dart';
import 'package:kitchen_pos/rating/rating.dart';

class RatingView extends StatelessWidget {
  const RatingView({super.key});

  @override
  Widget build(BuildContext context) {
    final status = context.select((RatingBloc bloc) => bloc.state.status);

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

    return const ColoredBox(
      color: Colors.white,
      child: RatingList(),
    );
  }
}

class RatingList extends StatelessWidget {
  const RatingList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final dishes = context.select((RatingBloc bloc) => bloc.state.dishes);
    final reviews = context.select((RatingBloc bloc) => bloc.state.reviews);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const RefreshButton(),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: dishes
                  .map(
                    (dish) => DishCard(dish: dish, ratings: reviews[dish.id]!),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class RefreshButton extends StatelessWidget {
  const RefreshButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: ElevatedButton(
        onPressed: () => context.read<RatingBloc>().add(const Refresh()),
        child: const Text('Refresh'),
      ),
    );
  }
}
