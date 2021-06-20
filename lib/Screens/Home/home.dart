import 'package:esv_audio_player/CustomWidgets/gradientContainers.dart';
import 'package:esv_audio_player/Screens/Library/downloaded.dart';
import 'package:esv_audio_player/Screens/Library/library.dart';
import 'package:esv_audio_player/Screens/Settings/setting.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:esv_audio_player/CustomWidgets/miniplayer.dart';
import 'dart:math';
import 'trending.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  Box settingsBox;
  double appVersion;
  bool checked = false;
  bool update = false;
  bool status = false;

  String capitalize(String msg) {
    return "${msg[0].toUpperCase()}${msg.substring(1)}";
  }

  void callback() {
    setState(() {});
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      pageController.animateToPage(index,
          duration: Duration(milliseconds: 400), curve: Curves.ease);
    });
  }

  Widget checkVersion() {
    return SizedBox();
  }

  ScrollController _scrollController;
  double _size = 0.0;

  void _scrollListener() {
    setState(() {
      _size = _scrollController.offset;
    });
  }

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    super.dispose();
  }

  PageController pageController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return GradientContainer(
      child: Scaffold(
          backgroundColor: Colors.transparent,
          drawer: Drawer(
            child: GradientContainer(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ListView(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      children: <Widget>[
                        ListTile(
                          title: Text(
                            'Home',
                            style: TextStyle(
                              color: Theme.of(context).accentColor,
                            ),
                          ),
                          leading: Icon(
                            Icons.home_rounded,
                            color: Theme.of(context).accentColor,
                          ),
                          selected: true,
                          onTap: () {
                            Navigator.pop(context);
                          },
                        ),
                        ListTile(
                          title: Text('My Music'),
                          leading: Icon(
                            MdiIcons.folderMusic,
                            color: Theme.of(context).iconTheme.color,
                          ),
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        DownloadedSongs(type: 'all')));
                          },
                        ),
                        ListTile(
                          title: Text('Settings'),
                          leading: Icon(
                            Icons
                                .settings_rounded, // miscellaneous_services_rounded,
                            color: Theme.of(context).iconTheme.color,
                          ),
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        SettingPage(callback: callback)));
                          },
                        ),
                        ListTile(
                          title: Text('About'),
                          leading: Icon(
                            Icons.info_outline_rounded,
                            color: Theme.of(context).iconTheme.color,
                          ),
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.pushNamed(context, '/about');
                          },
                        ),
                      ]),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(5, 30, 5, 20),
                    child: Center(
                      child: Text(
                        'Made with ♥ by Abel Tran',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: PageView(
                    onPageChanged: (indx) {
                      setState(() {
                        _selectedIndex = indx;
                        if (indx == 0) {
                          try {
                            _size = _scrollController.offset;
                          } catch (e) {}
                        }
                      });
                    },
                    controller: pageController,
                    children: [
                      Stack(
                        children: [
                          checkVersion(),
                          NotificationListener<OverscrollIndicatorNotification>(
                            onNotification: (overScroll) {
                              overScroll.disallowGlow();
                              return;
                            },
                            child: NestedScrollView(
                              physics:
                                  NeverScrollableScrollPhysics(),
                              headerSliverBuilder: (BuildContext context,
                                  bool innerBoxScrolled) {
                                final controller = TextEditingController();
                                return <Widget>[
                                  SliverAppBar(
                                    expandedHeight: 90,
                                    backgroundColor: Colors.transparent,
                                    elevation: 0,
                                    // pinned: true,
                                    toolbarHeight: 65,
                                    // floating: true,
                                    automaticallyImplyLeading: false,
                                    flexibleSpace: LayoutBuilder(
                                      builder: (BuildContext context,
                                          BoxConstraints constraints) {
                                        return FlexibleSpaceBar(
                                          // collapseMode: CollapseMode.parallax,
                                          background: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              SizedBox(
                                                height: 50,
                                              ),
                                              Row(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 15.0),
                                                    child: Text(
                                                      'Praise the LORD!',
                                                      textAlign: TextAlign.center,
                                                      style: TextStyle(
                                                      
                                                          letterSpacing: 1.5,
                                                          color:
                                                              Theme.of(context)
                                                                  .accentColor,
                                                          fontSize: 25,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  SliverAppBar(
                                    automaticallyImplyLeading: false,
                                    // pinned: true,
                                    // floating: false,
                                    backgroundColor: Colors.transparent,
                                    elevation: 0,
                                    stretch: true,
                                    toolbarHeight: 65,
                                    title: Align(
                                      alignment: Alignment.centerRight,
                                      child: AnimatedContainer(
                                        width: max(
                                            MediaQuery.of(context).size.width -
                                                _size,
                                            MediaQuery.of(context).size.width -
                                                85),

                                        duration: Duration(milliseconds: 300),
                                        padding:
                                            EdgeInsets.only(top: 3, bottom: 1),
                                        // margin: EdgeInsets.zero,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          color: Theme.of(context).cardColor,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black26,
                                              blurRadius: 5.0,
                                              spreadRadius: 0.0,
                                              offset: Offset(0.0, 3.0),
                                              // shadow direction: bottom right
                                            )
                                          ],
                                        ),
                                        child: TextField(
                                          controller: controller,
                                          decoration: InputDecoration(
                                            focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  width: 1.5,
                                                  color: Colors.transparent),
                                            ),
                                            fillColor:
                                                Theme.of(context).accentColor,
                                            prefixIcon: Icon(
                                              CupertinoIcons.search,
                                              color:
                                                  Theme.of(context).accentColor,
                                            ),
                                            border: InputBorder.none,
                                            hintText:
                                                "Books, Chapters",
                                          ),
                                          autofocus: false,
                                          onSubmitted: (query) {
                                            query == ''
                                                ? showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return AlertDialog(
                                                        title: Text(
                                                          'Invalid search',
                                                          style: TextStyle(
                                                              color: Theme.of(
                                                                      context)
                                                                  .accentColor),
                                                        ),
                                                        content: Column(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
                                                            SizedBox(
                                                              height: 10,
                                                            ),
                                                            Text(
                                                                'Please enter a valid search query'),
                                                          ],
                                                        ),
                                                        actions: [
                                                          TextButton(
                                                              style: TextButton
                                                                  .styleFrom(
                                                                primary: Theme.of(
                                                                        context)
                                                                    .accentColor,
                                                              ),
                                                              onPressed: () {
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              child: Text('Ok'))
                                                        ],
                                                      );
                                                    },
                                                  )
                                                : Navigator.pushNamed(
                                                    context, '/search',
                                                    arguments: query);
                                            controller.text = '';
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                ];
                              },
                              body: TrendingPage(),
                            ),
                          ),
                          Builder(
                            builder: (context) => Padding(
                              padding:
                                  const EdgeInsets.only(top: 8.0, left: 4.0),
                              child: Transform.rotate(
                                angle: 22 / 7 * 2,
                                child: IconButton(
                                  icon: const Icon(Icons
                                      .horizontal_split_rounded), // line_weight_rounded),
                                  // color: Theme.of(context).accentColor,
                                  color: Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? null
                                      : Colors.grey[700],
                                  onPressed: () {
                                    Scaffold.of(context).openDrawer();
                                  },
                                  tooltip: MaterialLocalizations.of(context)
                                      .openAppDrawerTooltip,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      LibraryPage(),
                    ],
                  ),
                ),
                MiniPlayer()
              ],
            ),
          ),
          bottomNavigationBar: ValueListenableBuilder(
              valueListenable: playerExpandProgress,
              builder: (BuildContext context, double value, Widget child) {
                return AnimatedContainer(
                  duration: Duration(milliseconds: 100),
                  height: 60 *
                      (MediaQuery.of(context).size.height - value) /
                      (MediaQuery.of(context).size.height - 76),
                  child: SalomonBottomBar(
                    currentIndex: _selectedIndex,
                    onTap: (index) {
                      _onItemTapped(index);
                    },
                    items: [
                      /// Home
                      SalomonBottomBarItem(
                        icon: Icon(Icons.home_rounded),
                        title: Text("Home"),
                        selectedColor: Theme.of(context).accentColor,
                      ),
                      SalomonBottomBarItem(
                        icon: Icon(Icons.my_library_music_rounded),
                        title: Text("Library"),
                        selectedColor: Theme.of(context).accentColor,
                      ),
                    ],
                  ),
                );
              })),
    );
  }
}
