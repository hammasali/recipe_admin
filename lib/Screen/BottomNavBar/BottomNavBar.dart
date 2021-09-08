import 'dart:typed_data';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:recipe_admin/Screen/B1_Home_Screen/B1_HomeScreen.dart';
import 'package:recipe_admin/Screen/B2_Youtube_Video/B2_PlaylistVideo.dart';
import 'package:recipe_admin/Screen/B3_Discover/B3_Discover.dart';
import 'package:recipe_admin/Screen/B3_Favorite_Screen/B3_Favorite_Screen.dart';
import 'package:recipe_admin/Screen/B4_Profile_Screen/B4_Profile_Screen.dart';
import 'package:recipe_admin/Screen/BottomNavBar/NavBarItem.dart';
import 'package:recipe_admin/Screen/Settings/Bloc.dart';
import 'package:recipe_admin/Style/Style.dart';

class BottomNavBar extends StatefulWidget {
  String idUser;
  ThemeBloc themeBloc;
  BottomNavBar({this.idUser, this.themeBloc});
  createState() => _BottomNavBarState(themeBloc);
}

class _BottomNavBarState extends State<BottomNavBar> {
  ThemeBloc themeBloc;
  _BottomNavBarState(this.themeBloc);
  String barcode = '';
  Uint8List bytes = Uint8List(200);
  BottomNavBarBloc _bottomNavBarBloc;
  @override
  void initState() {
    super.initState();
    _bottomNavBarBloc = BottomNavBarBloc();
    barcode = '';
  }

  @override
  void dispose() {
    _bottomNavBarBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorStyle.whiteBackground,
      body: StreamBuilder<NavBarItem>(
        stream: _bottomNavBarBloc.itemStream,
        initialData: _bottomNavBarBloc.defaultItem,
        builder: (BuildContext context, AsyncSnapshot<NavBarItem> snapshot) {
          switch (snapshot.data) {
            case NavBarItem.HOME:
              return HomeScreenT1(
                userID: widget.idUser,
              );
            case NavBarItem.VIDEO:
              return B2Playlist(
                idUser: widget.idUser,
              );
            case NavBarItem.DISCOVER:
              return discover(
                userId: widget.idUser,
              );
            case NavBarItem.FAVORITE:
              return favoriteScreen(
                idUser: widget.idUser,
              );
            case NavBarItem.USERS:
              return B4ProfileScreen(
                idUser: widget.idUser,
              );
          }
          return Container();
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: StreamBuilder(
        stream: _bottomNavBarBloc.itemStream,
        initialData: _bottomNavBarBloc.defaultItem,
        builder: (BuildContext context, AsyncSnapshot<NavBarItem> snapshot) {
          return BottomNavigationBar(
            selectedFontSize: 10.0,
            unselectedFontSize: 10.0,
            selectedItemColor: colorStyle.primaryColor,
            unselectedItemColor: colorStyle.iconColorUnselecLight,
            backgroundColor: colorStyle.whiteBackground,
            type: BottomNavigationBarType.fixed,
            iconSize: 25.0,
            currentIndex: snapshot.data.index,
            onTap: _bottomNavBarBloc.pickItem,
            items: [
              BottomNavigationBarItem(
                title: Text('Home',
                    style: TextStyle(
                        fontSize: 12,
                        fontFamily: "Sofia",
                        fontWeight: FontWeight.w700)),
                icon: Icon(
                  EvaIcons.homeOutline,
                ),
                activeIcon: Icon(
                  Icons.home,
                ),
              ),
              BottomNavigationBarItem(
                title: Text('Video',
                    style: TextStyle(
                        fontSize: 12,
                        fontFamily: "Sofia",
                        fontWeight: FontWeight.w700)),
                icon: Icon(
                  EvaIcons.videoOutline,
                ),
                activeIcon: Icon(
                  EvaIcons.video,
                ),
              ),
              BottomNavigationBarItem(
                title: Text('Discover',
                    style: TextStyle(
                        fontSize: 12,
                        fontFamily: "Sofia",
                        fontWeight: FontWeight.w700)),
                icon: Icon(
                  EvaIcons.keypadOutline,
                ),
                activeIcon: Icon(
                  EvaIcons.keypad,
                ),
              ),
              BottomNavigationBarItem(
                title: Text('Favorite',
                    style: TextStyle(
                        fontSize: 12,
                        fontFamily: "Sofia",
                        fontWeight: FontWeight.w700)),
                icon: Icon(
                  EvaIcons.heartOutline,
                ),
                activeIcon: Icon(
                  EvaIcons.heart,
                ),
              ),
              BottomNavigationBarItem(
                title: Text('Users',
                    style: TextStyle(
                        fontSize: 12,
                        fontFamily: "Sofia",
                        fontWeight: FontWeight.w700)),
                icon: Icon(
                  EvaIcons.personOutline,
                ),
                activeIcon: Icon(
                  EvaIcons.person,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
