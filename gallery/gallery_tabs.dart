import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_experiments/widgets/common/animation/indexed_transition_switcher.dart';

class GalleryTabsPage extends StatefulWidget {
  @override
  _GalleryTabsPageState createState() => _GalleryTabsPageState();
}

class _GalleryTabsPageState extends State<GalleryTabsPage> {

  int _selectedTab;
  bool _reverse;
  List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _selectedTab = 0;
    _reverse = false;
    _screens = <Widget>[
      Container(
        alignment: Alignment.center,
        child: Text('Components')
      ),
      Container(
        alignment: Alignment.center,
        child: Text('Layouts')
      ),
      Container(
        alignment: Alignment.center,
        child: Text('Screens')
      ),
    ];
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: IndexedTransitionSwitcher(
      index: _selectedTab,
      children: _screens,
      reverse: _reverse,
      transitionBuilder: (child, animation, secondaryAnimation) => SharedAxisTransition(
        child: child,
        animation: animation,
        secondaryAnimation: secondaryAnimation,
        transitionType: SharedAxisTransitionType.horizontal,
        fillColor: Colors.transparent,
      )
    ),
    bottomNavigationBar: BottomNavigationBar(
      currentIndex: _selectedTab,
      items: [
        BottomNavigationBarItem(
          label: 'Components',
          icon: Icon(Icons.category),
        ),
        BottomNavigationBarItem(
          label: 'Layouts',
          icon: Icon(Icons.view_agenda),
        ),
        BottomNavigationBarItem(
          label: 'Screens',
          icon: Icon(Icons.phonelink),
        ),
      ],
      onTap: (index) => setState(() {
        _reverse = index < _selectedTab;
        _selectedTab = index;
      }),
    ),
  );
}