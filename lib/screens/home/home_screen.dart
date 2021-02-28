import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_experiments/screens/home/tabs/components_tab.dart';
import 'package:flutter_experiments/screens/home/tabs/layouts_tab.dart';
import 'package:flutter_experiments/screens/home/tabs/screens_tab.dart';
import 'package:flutter_experiments/widgets/animation/indexed_transition_switcher.dart';
import 'package:flutter_experiments/widgets/bars/platform_app_bar.dart';
import 'package:flutter_experiments/widgets/bars/platform_bottom_navigation_bar.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedTab = 0;
  bool _reverse = false;
  List<String> _titles = [];
  List<Widget> _screens = [];

  @override
  void initState() {
    super.initState();
    _selectedTab = 0;
    _reverse = false;
    _titles = <String>['Components', 'Layouts', 'Screens'];
    _screens = <Widget>[
      ComponentsTab(),
      LayoutsTab(),
      ScreensTab(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PlatformAppBar(
        context,
        title: Text(_titles[_selectedTab]),
        centerTitle: true,
      ),
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
        ),
      ),
      bottomNavigationBar: PlatformBottomNavigationBar(
        currentIndex: _selectedTab,
        items: const [
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
}
