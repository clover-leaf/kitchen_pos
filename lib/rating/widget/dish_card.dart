import 'package:cached_network_image/cached_network_image.dart';
import 'package:client_repository/client_repository.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:kitchen_pos/gen/colors.gen.dart';

int dot(List<int> a, List<int> b) {
  var result = 0;
  if (a.length != b.length) return result;
  for (var i = 0; i < a.length; i++) {
    result += a[i] * b[i];
  }
  return result;
}

class DishCard extends StatelessWidget {
  const DishCard({required this.dish, required this.ratings, super.key});

  final Dish dish;
  final List<int> ratings;

  @override
  Widget build(BuildContext context) {
    final sumRating = dot(ratings, [1, 1, 1, 1, 1]);
    final avgRating =
        sumRating != 0 ? dot(ratings, [1, 2, 3, 4, 5]) / sumRating : 0.0;

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: ColorName.blue100.withAlpha(106),
      ),
      child: SizedBox(
        width: 204,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
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
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      dish.name,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: ColorName.text100,
                      ),
                    ),
                  ),
                  Text(
                    '\$${dish.price}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: ColorName.blue900,
                    ),
                  ),
                  // const Icon(
                  //   Icons.star,
                  //   size: 16,
                  //   color: Colors.amber,
                  // ),
                  // const SizedBox(width: 4),
                ],
              ),
            ),
            AvarageRating(avgRating: avgRating),
            ...ratings.mapIndexed(
              (idx, val) =>
                  RatingDetail(rating: idx + 1, voted: val, total: sumRating),
            )
          ],
        ),
      ),
    );
  }
}

class AvarageRating extends StatelessWidget {
  const AvarageRating({
    super.key,
    required this.avgRating,
  });

  final double avgRating;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16),
      child: Row(
        children: [
          RatingBar.builder(
            allowHalfRating: true,
            initialRating: avgRating.floor() == avgRating
                ? avgRating
                : avgRating.floor() + 0.5,
            ignoreGestures: true,
            itemSize: 16,
            itemPadding: const EdgeInsets.only(right: 2),
            itemBuilder: (context, _) => const Icon(
              Icons.star,
              color: Colors.amber,
            ),
            onRatingUpdate: (_) {},
          ),
          const SizedBox(width: 4),
          Text(
            '$avgRating',
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: ColorName.blue900,
            ),
          ),
        ],
      ),
    );
  }
}

class RatingDetail extends StatelessWidget {
  const RatingDetail({
    required this.rating,
    required this.voted,
    required this.total,
    super.key,
  });

  final int rating;
  final int voted;
  final int total;

  @override
  Widget build(BuildContext context) {
    final percentage = total != 0 ? ((voted / total) * 100).round() : 0;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
      child: Row(
        children: [
          SizedBox(
            width: 48,
            child: Text(
              '$rating star',
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: ColorName.text100,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: SizedBox(
              width: 72,
              height: 8,
              child: Stack(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                      color: Colors.grey,
                    ),
                    width: 72,
                    height: 8,
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                      color: Colors.amber,
                    ),
                    width: percentage * 72 / 100,
                    height: 8,
                  )
                ],
              ),
            ),
          ),
          Text(
            '$percentage%',
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: ColorName.text100,
            ),
          )
        ],
      ),
    );
  }
}
