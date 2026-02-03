import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shopping_list/data/categories.dart';
import 'package:shopping_list/models/grocery_item.dart';
import 'package:shopping_list/widgets/new_item.dart';
import 'package:http/http.dart' as http;

class GroceryList extends StatefulWidget {
  const GroceryList({super.key});
  @override
  State<GroceryList> createState() {
    return GrocerylistState();
  }
}

class GrocerylistState extends State<GroceryList> {
  List<GroceryItem> _groceryItems = [];
  late Future<List<GroceryItem>> loadeditems;
  String? _error;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadeditems = _loadItems();
  }

  Future<List<GroceryItem>> _loadItems() async {
    final url = Uri.https(
      'flutter-prep-dd52d-default-rtdb.firebaseio.com',
      'shopping-list.json',
    );
    final response = await http.get(url);
    if (response.statusCode >= 400) {
      throw Exception("Failed to get items");
    }
    if (response.body == 'null') {
      return [];
    }
    final List<GroceryItem> loadedItemsList = [];
    final Map<String, dynamic> listData = json.decode(response.body);
    for (final item in listData.entries) {
      final category = categories.entries
          .firstWhere((catItem) => catItem.value.name == item.value['category'])
          .value;
      loadedItemsList.add(
        GroceryItem(
          id: item.key,
          name: item.value['name'],
          quantity: item.value['quantity'],
          category: category,
        ),
      );
    }

    return loadedItemsList;
  }

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

  void _removeItem(GroceryItem item) async {
    final index = _groceryItems.indexOf(item);
    setState(() {
      _groceryItems.remove(item);
    });
    final url = Uri.https(
      'flutter-prep-dd52d-default-rtdb.firebaseio.com',
      'shopping-list/${item.id}.json',
    );
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      setState(() {
        _groceryItems.insert(index, item);
      });
    }
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
      body: FutureBuilder(
        future: loadeditems,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          } else if (snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                "No Items to display",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
              ),
            );
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,

              itemBuilder: (ctx, index) => Dismissible(
                direction: DismissDirection.endToStart,
                onDismissed: (direction) {
                  _removeItem(snapshot.data![index]);
                },
                key: ValueKey(snapshot.data![index].id),
                child: ListTile(
                  onTap: () {},
                  title: Text(
                    snapshot.data![index].name,
                    style: TextStyle(fontSize: 18),
                  ),
                  leading: Container(
                    width: 24,
                    height: 24,
                    color: snapshot.data![index].category.whatColor,
                  ),
                  trailing: Text(
                    snapshot.data![index].quantity.toString(),
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
