import 'package:flutter/material.dart';
import 'menuDetailPage.dart';

class show_cafeteria_menu extends StatefulWidget {
  const show_cafeteria_menu({super.key});

  @override
  _show_menu createState() => _show_menu();
}

class _show_menu extends State<show_cafeteria_menu>
    with TickerProviderStateMixin {
  String selectedMeal = '아침';
  DateTime _selectedDate = DateTime.now();
  final PageController _pageController = PageController(initialPage: 0);
  List<List<String>> breakfast = [
    ['1', '주 메뉴 1', '국 1', '반찬 1', '반찬 2', '반찬 3'],
    ['1.1', '주 메뉴 2', '국 1', '반찬 1', '반찬 2', '반찬 3'],
    ['2', '주 메뉴 3', '국 1', '반찬 1', '반찬 2', '반찬 3'],
    ['3', '주 메뉴 4', '국 1', '반찬 1', '반찬 2', '반찬 3']
  ];
  List<List<String>> lunch = [
    ['카이마루', '주 메뉴 1', '국 1', '반찬 1', '반찬 2', '반찬 3'],
    ['카이마루', '주 메뉴 2', '국 1', '반찬 1', '반찬 2', '반찬 3'],
    ['교수회관', '주 메뉴 3', '국 1', '반찬 1', '반찬 2', '반찬 3'],
    ['동측식당', '주 메뉴 4', '국 1', '반찬 1', '반찬 2', '반찬 3']
  ];
  List<List<String>> dinner = [
    ['카이마루', '주 메뉴 1', '국 1', '반찬 1', '반찬 2', '반찬 3'],
    ['카이마루', '주 메뉴 2', '국 1', '반찬 1', '반찬 2', '반찬 3'],
    ['교수회관', '주 메뉴 3', '국 1', '반찬 1', '반찬 2', '반찬 3'],
    ['동측식당', '주 메뉴 4', '국 1', '반찬 1', '반찬 2', '반찬 3']
  ];
  List<List<String>> menu = [];
  List<bool> isSelected = [true, false, false];

  void updateMenu() {
    setState(() {
      switch (selectedMeal) {
        case '아침':
          menu = breakfast;
          break;
        case '점심':
          menu = lunch;
          break;
        default:
          menu = dinner;
          break;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    menu = breakfast;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MyCustomScrollView(),
    );
  }
}

class MyCustomScrollView extends StatelessWidget {
  List<List<String>> menu = [
    ['카이마루', '주 메뉴 1', '국 1', '반찬 1', '반찬 2', '반찬 3'],
    ['카이마루', '주 메뉴 2', '국 1', '반찬 1', '반찬 2', '반찬 3'],
    ['교수회관', '주 메뉴 3', '국 1', '반찬 1', '반찬 2', '반찬 3'],
    ['동측식당', '주 메뉴 4', '국 1', '반찬 1', '반찬 2', '반찬 3']
  ];

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          pinned: true,
          expandedHeight: 200.0,
          flexibleSpace: FlexibleSpaceBar(
            background: Image.asset(
              'assets/sample_image.jpg',
              fit: BoxFit.cover,
            ),
          ),
        ),
        SliverPersistentHeader(
          delegate: _SliverAppBarDelegate(
            child: Container(
              color: Colors.white,
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Lunch, 카이마루',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text('2024.09.06. 11:30 ~ 13:30')
                              ]),
                          Row(
                            children: [Icon(Icons.star, color: Colors.amber), Text(" 4.0")],
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
            minHeight: 100.0,
            maxHeight: 100.0,
          ),
          pinned: true,
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
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
                      child: ListTile(
                    title: Text(
                      menu[0][index],
                      style: TextStyle(fontSize: 18),
                    ),
                    subtitle: Text(
                      "알레르기 정보: " + menu[0].sublist(2).toString(),
                      style: TextStyle(fontSize: 14),
                    ),
                    trailing: SizedBox(
                      width: 80, // 적절한 크기를 설정합니다.
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.favorite_border),
                          Icon(Icons.star, color: Colors.amber),
                          Text(" 4.0")
                        ],
                      ),
                    ),
                  )));
            },
            childCount: menu[0].length,
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              '알레르기 표기 정보: 1.난류 2.우유 3.메밀 4.땅콩 5.대두 6.밀 7.고등어 8.게 9.새우 10.돼지고기 11.복숭아 12.토마토 13.아황산류 14.호두 15.닭고기 16.쇠고기 17.오징어 18.조개류 (굴, 전복, 홍합 포함)19.잣',
              style: TextStyle(fontSize: 10),
            ),
          ),
        ),
      ],
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final double minHeight;
  final double maxHeight;
  final Widget child;

  _SliverAppBarDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => maxHeight;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxExtent ||
        minHeight != oldDelegate.minExtent; // ||
    // child != oldDelegate.child;
  }
}
