import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' as vector;

///
/// project: travel_photos_challenge
/// @package:
/// @author dammyololade
/// created on 25/08/2020
class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery
        .of(context)
        .size;
    final topCardHeight = (size.height / 2);
    final horizontalListHeight = 160.0;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Positioned(
            height: topCardHeight,
              width: size.width,
//                    left: 0,
//                    right: 0,
              child: PlaceDetails()),

          Positioned(
            //bottom: 0,
            left: 0,
            right: 0,
            top: topCardHeight - horizontalListHeight / 2,
            height: horizontalListHeight,
            child: PlaceListWidget(),
          )
        ],
      ),
    );
  }
}

class PlaceDetails extends StatefulWidget {
  @override
  _PlaceDetailsState createState() => _PlaceDetailsState();
}

class _PlaceDetailsState extends State<PlaceDetails> with SingleTickerProviderStateMixin{
  
  AnimationController _controller;
  final _movement = 100.0;

  @override
  void initState() {
    _controller = AnimationController(vsync: this,
      duration: Duration(seconds: 10)
    );
    _controller.repeat(reverse: true);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery
        .of(context)
        .size;
    return AnimatedBuilder(
      animation: _controller,
      builder: (ct, widget) {
        return Stack(
          fit: StackFit.expand,
          //overflow: Overflow.visible,
          children: [
            Positioned.fill(
              left: _movement * _controller.value,
              right: _movement * (1 - _controller.value),
              child: Image.asset("images/image_1.jpg",
//                height: (size.height / 2),
//                width: size.width,
                fit: BoxFit.cover,
              ),
            ),

            Positioned(
                top: 40,
                left: 10,
                right: 10,
                height: 100,
                child: FittedBox(
                  child: Text("Paris",
                    style: TextStyle(color: Colors.white),
                  ),
                )),
          ],
        );
      },
    );
  }
}


class PlaceListWidget extends StatefulWidget {
  @override
  _PlaceListWidgetState createState() => _PlaceListWidgetState();
}

class _PlaceListWidgetState extends State<PlaceListWidget> {
  var listKey = GlobalKey<AnimatedListState>();
  double page = 0.0;
  var _pageController = PageController();

  List<String> items = List.generate(10, (index) => "$index");

  @override
  void initState() {
    _pageController.addListener(_listenScroll);
    super.initState();
  }

  @override
  void dispose() {
    _pageController.removeListener(_listenScroll);
    _pageController.dispose();
    super.dispose();
  }

  void _listenScroll() {
    setState(() {
      page = _pageController.page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedList(
      key: listKey,
      scrollDirection: Axis.horizontal,
      physics: PageScrollPhysics(),
      controller: _pageController,
      initialItemCount: items.length,
      itemBuilder: (ct, index, animation) {
        var item = items[index];
        final percent = page - page.floor();
        final factor = percent > 0.5 ? (1 - percent) : percent;
        return InkWell(
            onTap: () {
              items.insert(items.length, item);
              listKey.currentState.insertItem(items.length - 1);
              final itemDeleted = item;
              items.removeAt(index);

              listKey.currentState.removeItem(
                  index,
                      (context, animation) =>
                      FadeTransition(
                        opacity: animation,
                        child: SizeTransition(
                          sizeFactor: animation,
                          axis: Axis.horizontal,
                          child: PlaceItemWidget(item, index),
                        ),
                      ));
            },
            child: Transform(
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001)
                  ..rotateY(vector.radians(90 * factor)),
                child: PlaceItemWidget(item, index)));
      },
    );
  }
}

class PlaceItemWidget extends StatelessWidget {
  String name;
  int index;

  PlaceItemWidget(this.name, this.index);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160,
      width: 130,
      margin: EdgeInsets.symmetric(horizontal: 10),
      color: Colors.red,
      child: Center(
        child: Text(
          name,
          style: TextStyle(
              fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    );
  }
}
