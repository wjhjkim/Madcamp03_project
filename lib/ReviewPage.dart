import 'package:flutter/material.dart';
import 'menuDetailPage.dart';

class reviewlistpage extends StatefulWidget {
  const reviewlistpage({super.key});

  @override
  ReviewListPage createState() => ReviewListPage();
}

class Review {
  final String content;
  final double rating;

  Review({required this.content, required this.rating});
}

class ReviewListPage extends State<reviewlistpage> {
  final List<Review> reviews = [
    Review(content: '정말 맛있어요!', rating: 5.0),
    Review(content: '괜찮아요.', rating: 3.0),
    Review(content: '별로였어요.', rating: 1.0),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('내 리뷰'),
      ),
      body: ListView.builder(
        itemCount: reviews.length,
        itemBuilder: (context, index) {
          return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => menuDetailPage(),
                  ),
                );
              },
              child: Card(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: ListTile(
                  leading: Icon(Icons.star, color: Colors.amber),
                  title: Text(reviews[index].content),
                  subtitle: Text('평점: ${reviews[index].rating}'),
                ),
              ));
        },
      ),
    );
  }
}
