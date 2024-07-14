import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class menuDetailPage extends StatefulWidget {
  const menuDetailPage({super.key, required this.menu_name});

  final String menu_name;

  @override
  _MenuDetailPage createState() => _MenuDetailPage();
}

class Review {
  final String content;
  final String menuName;
  final String userName;
  final double rating;

  Review(
      {required this.content,
      required this.menuName,
      required this.userName,
      required this.rating});
}

class _MenuDetailPage extends State<menuDetailPage> {
  String menuImageUrl = 'https://via.placeholder.com/400';
  String menuName = 'Spaghetti Carbonara';
  final double menuRating = 4.5;
  bool isFavorite = false;
  final List<Review> reviews = [
    Review(
        content: '정말 맛있어요!', menuName: "menu", userName: "String", rating: 5.0),
    Review(content: '괜찮아요.', menuName: "menu", userName: "String", rating: 3.0),
    Review(
        content: '별로였어요.', menuName: "menu", userName: "String", rating: 1.0),
  ];

  @override
  void initState() {
    super.initState();
    menuName = widget.menu_name;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(menuName),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              menuImageUrl,
              width: double.infinity,
              height: 250,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    menuName,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            RatingBarIndicator(
                              rating: menuRating,
                              itemBuilder: (context, index) => Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),
                              itemCount: 5,
                              itemSize: 20.0,
                              direction: Axis.horizontal,
                            ),
                            SizedBox(width: 8),
                            Text(menuRating.toString(),
                                style: TextStyle(fontSize: 16)),
                          ],
                        ),
                        IconButton(
                          icon: Icon(
                            isFavorite ? Icons.favorite : Icons.favorite_border,
                            color: isFavorite ? Colors.red : Colors.grey,
                          ),
                          onPressed: () {
                            setState(() {
                              isFavorite = !isFavorite;
                            });
                          },
                        )
                      ]),
                  SizedBox(height: 16),
                  Text("알레르기 정보: "),
                  SizedBox(height: 16),
                  Text(
                    '리뷰',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  ...reviews.map((review) {
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: ListTile(
                        title: Text(review.content),
                        subtitle: RatingBarIndicator(
                          rating: review.rating,
                          itemBuilder: (context, index) => Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          itemCount: 5,
                          itemSize: 20.0,
                          direction: Axis.horizontal,
                        ),
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
