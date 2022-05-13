import 'package:flutter/material.dart';

class ListDrawer extends StatefulWidget {
  const ListDrawer({Key key, this.lastFocusNode, this.newGame})
      : super(key: key);
  final Function newGame;
  final FocusNode lastFocusNode;

  @override
  _ListDrawerState createState() => _ListDrawerState();
}

class _ListDrawerState extends State<ListDrawer> {
  static final numItems = 3;

  int selectedItem = 0;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Drawer(
      child: SafeArea(
        child: ListView(
          children: [
            ListTile(
              title: Text(
                "2048",
                style: textTheme.title,
              ),
              subtitle: Text(
                "created by Graf",
                style: textTheme.body1,
              ),
            ),
            Divider(),
            ...Iterable<int>.generate(numItems).toList().map((i) {
              int fieldsize = i + 3;
              final listTile = ListTile(
                enabled: true,
                selected: i == selectedItem,
                leading: Icon(Icons.autorenew),
                title: Text(
                  fieldsize.toString() + "x" + fieldsize.toString(),
                ),
                onTap: () {
                  setState(() {
                    selectedItem = i;
                    widget.newGame(size: fieldsize);
                  });
                },
              );
              if (i == numItems - 1 && widget.lastFocusNode != null) {
                return Focus(
                  focusNode: widget.lastFocusNode,
                  child: listTile,
                );
              } else {
                return listTile;
              }
            }),
            Divider(),
            ListTile(),
          ],
        ),
      ),
    );
  }
}