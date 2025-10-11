import 'package:flutter/material.dart';
import 'package:shopping_list/data/dummy_items.dart';
import 'package:shopping_list/widgets/new_item.dart';

class GroceryList extends StatefulWidget {
  const GroceryList({super.key});
  @override
  State<GroceryList> createState() {
    return GrocerylistState();
  }
}

class GrocerylistState extends State<GroceryList> {
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
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (ctx) => NewItem()));
            },
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: groceryItems.length,
        itemBuilder: (ctx, index) => ListTile(
          onTap: () {},
          title: Text(groceryItems[index].name, style: TextStyle(fontSize: 18)),
          leading: Container(
            width: 24,
            height: 24,
            color: groceryItems[index].category.whatColor,
          ),
          trailing: Text(
            groceryItems[index].quantity.toString(),
            style: TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }
}
