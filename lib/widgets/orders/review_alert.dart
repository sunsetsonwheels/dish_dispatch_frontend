import 'package:dish_dispatch/models/orders.dart';
import 'package:dish_dispatch/providers/api_provider.dart';
import 'package:dish_dispatch/widgets/utils/error_alert.dart';
import 'package:flutter/material.dart';
import 'package:animated_rating_stars/animated_rating_stars.dart';
import 'package:provider/provider.dart';

class OrderReviewAlert extends StatefulWidget {
  final String parentId;
  final String id;
  final OrderReview? previousReview;

  const OrderReviewAlert({
    super.key,
    required this.parentId,
    required this.id,
    this.previousReview,
  });

  @override
  State<OrderReviewAlert> createState() => _OrderReviewAlertState();
}

class _OrderReviewAlertState extends State<OrderReviewAlert> {
  final commentController = TextEditingController();
  OrderReview review = OrderReview(rating: 1, comment: "");
  bool isSubmitting = false;

  @override
  void initState() {
    if (widget.previousReview != null) {
      review = widget.previousReview!;
    }
    super.initState();
  }

  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }

  Future<void> submitReview() async {
    setState(() {
      isSubmitting = true;
    });
    try {
      if (commentController.text.isEmpty) {
        throw Exception("Comment cannot be empty!");
      }
      await Provider.of<APIProvider>(context, listen: false)
          .rateCustomerOrderInOrder(
        parentId: widget.parentId,
        id: widget.id,
        review: review,
      );
      Navigator.pop(context);
    } catch (err) {
      showDialog(
        context: context,
        builder: (_) => ErrorAlertWidget(error: err),
      );
      setState(() {
        isSubmitting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Review order"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedRatingStars(
            initialRating: 1,
            minRating: 1,
            maxRating: 5,
            onChanged: (rating) {
              setState(() {
                review.rating = rating;
              });
            },
            customFilledIcon: Icons.star,
            customHalfFilledIcon: Icons.star_half,
            customEmptyIcon: Icons.star_border,
          ),
          TextField(
            controller: commentController,
            maxLines: 3,
            decoration: const InputDecoration(hintText: "Comments..."),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
        TextButton(
          onPressed: submitReview,
          child: const Text("Submit"),
        ),
      ],
    );
  }
}
