import 'package:flutter/material.dart';
import 'menuDetailPage.dart';

class Heartpage extends StatefulWidget {
  const Heartpage({super.key});

  @override
  _FavoriteMenuPage createState() => _FavoriteMenuPage();
}

class _FavoriteMenuPage extends State<Heartpage> {
  final List<String> favoriteMenus = [
    'Spaghetti Carbonara',
    'Margherita Pizza',
    'Caesar Salad',
    'Grilled Salmon',
    'Chicken Alfredo',
    'Beef Tacos',
    'Sushi Platter',
    'Vegetable Stir Fry',
    'BBQ Ribs',
    'Mango Smoothie'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('하트를 누른 메뉴'),
      ),
      body: ListView.builder(
        itemCount: favoriteMenus.length,
        itemBuilder: (context, index) {
          return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => menuDetailPage(menu_name: favoriteMenus[index]),
                  ),
                );
              },
              child: Card(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: ListTile(
                  leading: Icon(Icons.favorite, color: Colors.red),
                  title: Text(favoriteMenus[index]),
                ),
              ));
        },
      ),
    );
  }
}
