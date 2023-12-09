import 'category.dart';

class GroceryItem {
  const GroceryItem(
      {required this.name,
      required this.id,
       required this.category,
      required this.quantity});

  final String id;
  final String name;
  final int quantity;
   final Category category;
}
