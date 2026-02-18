import 'package:flutter/material.dart';
import '../models/tile_colors.dart';
import '../models/field.dart';
import '../models/tile.dart';

class TileBox extends StatefulWidget {
  const TileBox({
      super.key,
    required this.tile,
    required this.buttonsList,
    required this.context,
    required this.tileNum,
    required this.tileWidth,
  });

  final Field buttonsList;
  final BuildContext context;
  final int tileNum;
  final double tileWidth;
  final Tile tile;

  @override
  _TileBoxState createState() => _TileBoxState();
}

class _TileBoxState extends State<TileBox> with SingleTickerProviderStateMixin{
  late AnimationController controller;
  late Animation<double> animation;
  @override
  Widget build(BuildContext context) {
    final tile = widget.tile;
    if (tile.isNew && !tile.isEmpty()) {
      controller.reset();
      controller.forward();
      tile.isNew = false;
    } else {
      controller.animateTo(1.0);
    }
    double tileWidth = widget.tileWidth;
    return AnimatedTile(tileWidth: tileWidth, animation: animation, widget: widget,);
  }
         @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: const Duration(
        milliseconds: 500,
      ),
      vsync: this,
    );     
    animation = Tween(begin: 0.9, end: 1.0).animate(controller);
  } 
    @override
  void dispose() {
    controller.dispose();
    super.dispose();
    widget.tile.isNew = false;
  } 
 




}

class AnimatedTile extends AnimatedWidget {
  const AnimatedTile({
     super.key,
    required this.tileWidth,
    required this.animation,
    required this.widget,
  }) : super(listenable: animation);

  final double tileWidth;
  final Animation<double> animation;
  final TileBox widget;


  @override
  Widget build(BuildContext context) {
    final tile = widget.tile;
    final tileValue = tile.value;
    return SizedBox(
                  width: tileWidth,
                  height: tileWidth,
                  child: Padding(
                    padding: EdgeInsets.all(5*animation.value.toDouble()),
                    child: Container(
                      color: tileColors.containsKey(tileValue)
                          ? tileColors[tileValue]
                          : Colors.blue[500],
                      
                      padding: const EdgeInsets.all(15.0),
                      child: FittedBox(
                        child: Text(
                          tileValue == 0
                              ? " "
                              : tileValue.toString(),
                          style: const TextStyle(
                              color: Colors.black, fontSize: 10.0),
                        ),
                      ),
                    ),
                  ),
                );
  }
}