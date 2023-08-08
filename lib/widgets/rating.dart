import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class Rating extends StatelessWidget {
  final dynamic rating;
  final double starSize;

  const Rating({Key? key, required this.rating, this.starSize = 16})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RatingBar(
      initialRating: rating.toDouble(),
      direction: Axis.horizontal,
      allowHalfRating: true,
      itemCount: 5,
      itemSize: starSize,
      ratingWidget: RatingWidget(
        full: Icon(
          Icons.star,
          color: Colors.orangeAccent,
        ),
        half: Icon(
          Icons.star_half,
          color: Colors.orangeAccent,
        ),
        empty: Icon(Icons.star_outline,
            color: Colors.orangeAccent.withOpacity(0.5)),
      ),
      onRatingUpdate: (rating) {},
    );
  }

// static star(int value) {
//   //value 0: holo
//   //value 1: half
//   //value 2: filled
//   IconData iconData;
//   Color color = Colors.orangeAccent;
//   if (value == 0) {
//     iconData = Icons.star_outline;
//     color = Colors.orangeAccent.withOpacity(0.3);
//   } else if (value == 1) {
//     iconData = Icons.star_half;
//   } else {
//     iconData = Icons.star;
//   }
//   return Icon(
//     iconData,
//     color: color,
//     size: 12,
//   );
// }
// }

}
