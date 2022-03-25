import 'package:event/event.dart';
import 'package:flutter/material.dart';
import 'package:pansy/basic/app_screen_data.dart';
import 'package:pansy/basic/config/in_china.dart';
import 'package:pansy/screens/search_title_screen.dart';
import 'package:pansy/screens/discovery_screen.dart';
import 'package:pansy/screens/hots_screen.dart';
import 'package:pansy/states/pixiv_login.dart';

class AppScreen extends StatefulWidget {
  const AppScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AppScreenState();
}

class _AppScreenState extends State<AppScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    pixivLoginEvent.subscribe(_onLoginChange);
    super.initState();
  }

  @override
  void dispose() {
    pixivLoginEvent.unsubscribe(_onLoginChange);
    _pageViewController.dispose();
    super.dispose();
  }

  void _onLoginChange(EventArgs? args) {
    setState(() {});
  }

  final _screens = [
    AppScreenData(
      PixivSearchScreen(),
      '搜索',
      Icons.widgets_outlined,
      Icons.widgets,
    ),
    AppScreenData(
      DiscoveryScreen(),
      '发现',
      Icons.web_outlined,
      Icons.web,
    ),
    AppScreenData(
      HotsScreen(),
      '热门',
      Icons.local_fire_department_outlined,
      Icons.local_fire_department_rounded,
    ),
  ];

  var _selectedIndex = 1;
  final _pageViewController = PageController(initialPage: 1);

  Future _onPage(int index) async {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onItemTapped(int index) {
    _pageViewController.animateToPage(
      index,
      duration: const Duration(milliseconds: 1),
      curve: Curves.ease,
    );
  }

  late final _pageView = PageView(
    children: _screens.map((e) => e.screen).toList(),
    controller: _pageViewController,
    onPageChanged: _onPage,
  );

  Widget _actionButton(AppScreenData data) {
    var active = _screens[_selectedIndex] == data;
    var icon = active ? data.activeIcon : data.icon;
    Color color = Colors.white.withAlpha(active ? 240 : 180);
    return Column(
      children: [
        Expanded(child: Container()),
        MaterialButton(
          minWidth: 50,
          textColor: color,
          onPressed: () {
            _onItemTapped(_screens.indexOf(data));
          },
          child: Column(
            children: [
              Icon(
                icon,
                size: 20,
              ),
              Text(
                data.title,
                style: const TextStyle(fontSize: 10),
              ),
            ],
          ),
        ),
        Expanded(child: Container()),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (!pixivLogin) {
      return Scaffold(
        body: Stack(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Image.asset(
                'lib/assets/startup_bg.png',
                fit: BoxFit.contain,
              ),
            ),
            Column(
              children: [
                Expanded(child: Container()),
                Container(height: 30),
                Container(height: 30),
                MaterialButton(
                  color: Colors.grey.shade50,
                  onPressed: () async {
                    pixivLoginAction(context);
                  },
                  child: const Text('登录'),
                ),
                Container(height: 30),
                const Divider(),
                Row(
                  children: [
                    Expanded(child: Container()),
                    const Text("对中国大陆网络优化"),
                    Switch(
                      value: inChina,
                      onChanged: (value) async {
                        await setInChina(value);
                        setState(() {});
                      },
                    ),
                    Expanded(child: Container()),
                  ],
                ),
                const Divider(),
                Expanded(child: Container()),
              ],
            ),
          ],
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Icon(Icons.menu),
        actions: _screens.map(_actionButton).toList(),
      ),
      body: _pageView,
    );
  }
}