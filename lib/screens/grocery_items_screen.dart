import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shopping_list_app/data/categories.dart';
import 'package:shopping_list_app/models/grocery_item.dart';
import 'package:shopping_list_app/screens/new_item.dart';
import 'package:http/http.dart' as http;

class GroceryItemsScreen extends StatefulWidget {
  const GroceryItemsScreen({super.key});

  @override
  State<GroceryItemsScreen> createState() => _GroceryItemsScreenState();
}

class _GroceryItemsScreenState extends State<GroceryItemsScreen> {
  List<GroceryItem> _allItems = [];
  bool _isLoading = true;
  String? _isError;

  @override
  void initState() {
    super.initState();
    _loadItemsFromFirebase();
  }

  void _loadItemsFromFirebase() async {
    final url = Uri.https(
        'shopping-list-flutter-prep-default-rtdb.firebaseio.com',
        'shopping-list.json');
    try {
      final response = await http.get(url);
      if (response.statusCode >= 400) {
        setState(() {
          _isError = "Something went wrong please try again later.";
        });
      }

      if (response.body == 'null') {
        setState(() {
          _isLoading = false;
        });
        return;
      }
      final Map<String, dynamic> listData = json.decode(response.body);
      final List<GroceryItem> loadedItems = [];
      for (final item in listData.entries) {
        final category = categories.entries
            .firstWhere(
                (catItem) => catItem.value.title == item.value['category'])
            .value;
        loadedItems.add(
          GroceryItem(
              name: item.value['name'],
              id: item.key,
              category: category,
              quantity: item.value['quantity']),
        );
      }
      setState(() {
        _isLoading = false;
        _allItems = loadedItems;
      });
    } catch (error) {
      setState(() {
        _isError = "Something went wrong please try again later.";
      });
    }
  }

  void _addItem() async {
    final newItem = await Navigator.of(context).push<GroceryItem>(
      MaterialPageRoute(
        builder: (context) => const NewItemScreen(),
      ),
    );
    if (newItem == null) {
      return;
    }
    setState(() {
      _allItems.add(newItem);
    });
  }

  void _removeItem(GroceryItem item) async {
    final index = _allItems.indexOf(item);
    setState(() {
      _allItems.remove(item);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        duration: Duration(seconds: 4),
        content: Text("Item is removed from the list"),
      ),
    );
    final url = Uri.https(
        'shopping-list-flutter-prep-default-rtdb.firebaseio.com',
        'shopping-list/${item.id}.json');
    try {
      final response = await http.delete(url);
      if (response.statusCode >= 400) {
        setState(() {
          _allItems.insert(index, item);
        });
        if (!context.mounted) {
          return;
        }
        ScaffoldMessenger.of(context).clearSnackBars();
        showDialog(
            context: context,
            builder: (ctx) {
              return AlertDialog(
                title: const Text("Error 404, Try Again."),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text("Ok"),
                  ),
                ],
              );
            });
      }
    } catch (error) {
      setState(() {
        _isError = "Something went wrong. Item could not be deleted.";
        _allItems.insert(index, item);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget content = Center(
      child: Text(
        "You got no items :(",
        style: Theme.of(context).textTheme.headlineSmall,
      ),
    );

    if (_isLoading) {
      content = const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_allItems.isNotEmpty) {
      setState(() {
        content = ListView.builder(
            itemCount: _allItems.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Dismissible(
                  background: Container(
                    color: Theme.of(context).colorScheme.error,
                  ),
                  onDismissed: (direction) {
                    _removeItem(_allItems[index]);
                  },
                  key: ValueKey(_allItems[index].id),
                  child: ListTile(
                    tileColor: Theme.of(context).colorScheme.primaryContainer,
                    title:
                        Text(_allItems[index].name, textAlign: TextAlign.start),
                    leading: Container(
                      // margin: const EdgeInsets.only(top: 6.5),
                      color: _allItems[index].category.color,
                      width: 24,
                      height: 24,
                    ),
                    trailing: Text(_allItems[index].quantity.toString()),
                  ),
                ),
              );
            });
      });
    }

    if (_isError != null) {
      content = Center(
        child: Text(_isError!),
      );
    }
    return Scaffold(
        appBar: AppBar(
          title: const Text("Groceries"),
          actions: [
            IconButton(
                onPressed: _addItem,
                icon: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(Icons.add),
                ))
          ],
        ),
        body: content);
  }
}
