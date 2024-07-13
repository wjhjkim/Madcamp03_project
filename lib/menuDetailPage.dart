import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class menuDetailPage extends StatefulWidget {
  const menuDetailPage({super.key});

  @override
  _MenuDetailPage createState() => _MenuDetailPage();
}

class Review {
  final String content;
  final double rating;

  Review({required this.content, required this.rating});
}

class _MenuDetailPage extends State<menuDetailPage> {
  final String menuImageUrl = 'https://via.placeholder.com/400';
  final String menuName = 'Spaghetti Carbonara';
  final double menuRating = 4.5;
  final List<Review> reviews = [
    Review(content: '정말 맛있어요!', rating: 5.0),
    Review(content: '괜찮아요.', rating: 4.0),
    Review(content: '별로였어요.', rating: 2.0),
  ];

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
                        Icon(Icons.favorite_border)
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
