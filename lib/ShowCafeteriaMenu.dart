import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'ChangeTextScreen.dart';

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

  void _pickDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    menu = breakfast;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Row(children: [
      //     Text(
      //         "Lunch, 카이마루",
      //         style: TextStyle(
      //           fontSize: 24,
      //       ),
      //     ),
      //   ]),
      //   shape: Border(
      //     bottom: BorderSide(
      //       color: Colors.grey,
      //       width: 8,
      //     ),
      //   ),
      // ),
      body: MyCustomScrollView(),
      // body: Column(children: [
      //   MyCustomScrollView(),
      //   Image.asset(
      //     "assets/sample_image.jpg",
      //     height: 300,
      //     fit: BoxFit.cover,
      //   ),
      //   Container(
      //     height: 8,
      //     color: Colors.grey,
      //   ),
      //   Padding(
      //     padding: const EdgeInsets.all(8.0),
      //     child: Column(
      //       crossAxisAlignment: CrossAxisAlignment.center,
      //       children: <Widget>[
      //         Container(
      //           height: 100,
      //           child: Card(
      //                 elevation: 4,
      //                 shape: RoundedRectangleBorder(
      //                   borderRadius: BorderRadius.circular(16),
      //                 ),
      //                 child: Padding(
      //                   padding: const EdgeInsets.all(16.0),
      //                   child: Column(
      //                     mainAxisAlignment: MainAxisAlignment.center,
      //                     children: [
      //
      //                       Row(
      //                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //                         children: [
      //                           Text(
      //                             '${menu[0][1]}',
      //                             style: TextStyle(
      //                               fontSize: 24,
      //                               fontWeight: FontWeight.bold,
      //                             ),
      //                           ),
      //                           Column(
      //                             children: [
      //                           Row(
      //                             children: [Icon(Icons.star), Text(" 4.0")],
      //                           ),
      //
      //                               ])
      //                         ],
      //                       )
      //                     ],
      //                   ),
      //                 ),
      //               )
      //         ),
      //       ],
      //     ),
      //   ),
      //   Text("오늘의 반찬", style: TextStyle(fontSize: 24, ),),
      //   _buildFoodListWidget(),
      // ]),
    );
  }

  Widget _buildFoodListWidget() {
    return Expanded(
      child: ListView.builder(
        itemCount: menu.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              title: Text(menu[index][1]),
              subtitle: Text(menu[index].sublist(2).toString()),
            ),
          );
        },
      ),
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
                          Text(
                            'Lunch, 카이마루',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Row(
                            children: [Icon(Icons.star), Text(" 4.0")],
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
              return Card(
                  child: ListTile(
                title: Text(menu[0][index]),
                subtitle: Text(menu[0].sublist(2).toString()),
                trailing: SizedBox(
                  width: 80, // 적절한 크기를 설정합니다.
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.favorite_border),
                      Icon(Icons.star),
                      Text(" 4.0")
                    ],
                  ),
                ),
              ));
            },
            childCount: menu[0].length,
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
