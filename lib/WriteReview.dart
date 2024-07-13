import 'package:flutter/material.dart';

class write_review extends StatefulWidget {
  const write_review({super.key});

  @override
  _write_review createState() => _write_review();
}

class _write_review extends State<write_review>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _reviewController = TextEditingController();
  double _rating = 0;

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  void _submitReview() {
    if (_formKey.currentState!.validate()) {
      // 여기에 리뷰를 제출하는 로직을 추가할 수 있습니다.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('리뷰가 제출되었습니다.')),
      );
      _reviewController.clear();
      setState(() {
        _rating = 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('리뷰 작성'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '메뉴',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),

              SizedBox(height: 8),
              Text(
                '평점',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Row(
                children: List.generate(5, (index) {
                  return IconButton(
                    icon: Icon(
                      index < _rating ? Icons.star : Icons.star_border,
                      color: Colors.amber,
                    ),
                    onPressed: () {
                      setState(() {
                        _rating = index + 1.0;
                      });
                    },
                  );
                }),
              ),
              SizedBox(height: 16),
              Text(
                '리뷰',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              TextFormField(
                controller: _reviewController,
                maxLines: 5,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: '리뷰를 입력하세요',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '리뷰를 입력해주세요.';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              Center(
                child: ElevatedButton(
                  onPressed: _submitReview,
                  child: Text('리뷰 제출'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
