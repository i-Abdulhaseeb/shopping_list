import 'package:flutter/material.dart';
import 'package:shopping_list/models/grocery_item.dart';
import 'package:shopping_list/widgets/new_item.dart';

class GroceryList extends StatefulWidget {
  const GroceryList({super.key});
  @override
  State<GroceryList> createState() {
    return GrocerylistState();
  }
}

class GrocerylistState extends State<GroceryList> {
  final List<GroceryItem> _groceryItems = [];
  void _addItem() async {
    final newItem = await Navigator.of(
      context,
    ).push<GroceryItem>(MaterialPageRoute(builder: (ctx) => NewItem()));
    if (newItem == null) {
      return;
    } else {
      setState(() {
        _groceryItems.add(newItem);
      });
    }
  }

  void _removeItem(GroceryItem item) {
    setState(() {
      _groceryItems.remove(item);
    });
  }

  @override
  Widget build(context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: const Text(
            "Your Groceries",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        actions: [IconButton(onPressed: _addItem, icon: Icon(Icons.add))],
      ),
      body: _groceryItems.isEmpty
          ? Center(
              child: Text(
                "No Grocery Item",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
              ),
            )
          : ListView.builder(
              itemCount: _groceryItems.length,

              itemBuilder: (ctx, index) => Dismissible(
                direction: DismissDirection.startToEnd,
                onDismissed: (direction) {
                  _removeItem(_groceryItems[index]);
                },
                key: ValueKey(_groceryItems[index]),
                child: ListTile(
                  onTap: () {},
                  title: Text(
                    _groceryItems[index].name,
                    style: TextStyle(fontSize: 18),
                  ),
                  leading: Container(
                    width: 24,
                    height: 24,
                    color: _groceryItems[index].category.whatColor,
                  ),
                  trailing: Text(
                    _groceryItems[index].quantity.toString(),
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ),
    );
  }
}
