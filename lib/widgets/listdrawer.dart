import 'package:flutter/material.dart';

class ListDrawer extends StatefulWidget {
  const ListDrawer({Key? key, required this.newGame}) : super(key: key);
  final Function newGame;

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
                style: textTheme.titleMedium,
              ),
              subtitle: Text(
                "created by Graf",
                style: textTheme.bodyText1,
              ),
            ),
            const Divider(),
            for (var i in Iterable<int>.generate(numItems).toList())
              ListTile(
                enabled: true,
                selected: i == selectedItem,
                leading: const Icon(Icons.autorenew),
                title: Text(
                  "${i + 3}x${i + 3}",
                ),
                onTap: () {
                  setState(() {
                    selectedItem = i;
                    widget.newGame(size: i + 3);
                  });
                },
              ),
            const Divider(),
            const ListTile(),
          ],
        ),
      ),
    );
  }
}
