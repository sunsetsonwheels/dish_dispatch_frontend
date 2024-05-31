import 'package:dish_dispatch/models/restaurant.dart';
import 'package:dish_dispatch/providers/cart_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddToCartSheet extends StatefulWidget {
  final BaseRestaurant restaurant;
  final String name;
  final MenuItem item;

  const AddToCartSheet({
    super.key,
    required this.restaurant,
    required this.name,
    required this.item,
  });

  @override
  State<AddToCartSheet> createState() => _AddToCartSheetState();
}

class _AddToCartSheetState extends State<AddToCartSheet> {
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    CartProvider cartProvider =
        Provider.of<CartProvider>(context, listen: false);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 16),
        Text(
          "Quantity",
          style: Theme.of(context).textTheme.titleLarge,
          textAlign: TextAlign.center,
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton.filledTonal(
                onPressed: quantity > 1
                    ? () {
                        setState(() {
                          quantity--;
                        });
                      }
                    : null,
                icon: const Icon(Icons.remove),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  quantity.toString(),
                  style: const TextStyle(fontSize: 48),
                ),
              ),
              IconButton.filledTonal(
                onPressed: () {
                  setState(() {
                    quantity++;
                  });
                },
                icon: const Icon(Icons.add),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
          child: FilledButton(
            onPressed: () {
              cartProvider.add(
                restaurant: widget.restaurant,
                item: widget.name,
                price: widget.item.price,
                quantity: quantity,
              );
              Navigator.pop(context);
            },
            child: const Text("Add to cart"),
          ),
        ),
      ],
    );
  }
}
