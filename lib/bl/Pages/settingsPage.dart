import 'package:flutter/material.dart';
import 'package:flutter_app/bl/Pages/profilePics.dart';
import 'package:flutter_app/main.dart';
import 'package:flutter_app/ui/themes.dart';

class SettingsPage extends StatefulWidget{
  @override
  _SettingsPageState  createState() {
    return  _SettingsPageState();
  }

}


class _SettingsPageState extends State<SettingsPage>{
  ThemeSwitcher inheritedThemeSwitcher;
  bool note = false;
  bool click = false;
  bool mode = false;

  @override
  Widget build(BuildContext context) {
   inheritedThemeSwitcher = ThemeSwitcher.of(context);
    return new Scaffold(
      appBar: new AppBar(
        title: Text(
            "Settings",style:Theme.of(context).textTheme.subhead
        ),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                new Text("Changing color of app",style:Theme.of(context).textTheme.subhead),
                new Switch(
                  value: click ,
                  onChanged: (bool valueOfClick) => changingColor(valueOfClick),
                ),
             ],),
            Row(
              children: <Widget>[
                new Text("Dark mode",style:Theme.of(context).textTheme.subhead),
                new Switch(
                  value: mode,
                  onChanged: (bool valueOfMode) => darkMode(valueOfMode),
                ),
              ],),
             Row(
              children: <Widget>[
                new Text("Turn on the notifications",style:Theme.of(context).textTheme.subhead),
                new Switch(
                    value: note,
                    onChanged: (bool valueOfNote) => setNotifications(valueOfNote),
                ),
              ],
          ),
            Container(
              height: 30.0,
              width: 150.0,
              child: Material(
                borderRadius: BorderRadius.circular(20.0),
                shadowColor: Colors.pinkAccent,
                color: Colors.pink,
                elevation: 7.0,
                child: FlatButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => SelectProfilePicPage()));
                  },
                  child: Center(
                    child: Text(
                        "Change Profile Data",
                        style: new TextStyle(
                            fontSize: 12.0,
                            color: Colors.white,
                            fontWeight: FontWeight.w400
                        )
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      )
    );

  }

    DemoTheme _buildPinkTheme() {
    return DemoTheme(
        'pink',
        new ThemeData(
            primaryColor: Colors.pink[400],
            scaffoldBackgroundColor: Colors.grey[50],
            accentColor: Colors.pink[400],
            buttonColor: Colors.pink,
            fontFamily: 'Quicksand',
            indicatorColor: Colors.blueGrey,
            brightness: Brightness.light,
    ));
  }

  DemoTheme _buildBlueTheme() {
    return DemoTheme(
        'blue',
        new ThemeData(
          primaryColor: Colors.blue[400],
          scaffoldBackgroundColor: Colors.grey[50],
          accentColor: Colors.blueAccent[400],
          buttonColor: Colors.blue,
          toggleableActiveColor: Colors.lightBlue,
          unselectedWidgetColor: Colors.blueAccent,
          fontFamily: 'Quicksand',
          indicatorColor: Colors.blueGrey,
          brightness: Brightness.light,
          textTheme: TextTheme(button: TextStyle(color: Colors.white))
        ));
  }


  DemoTheme _buildDarkMode() {
    return DemoTheme(
        'dark',
        new ThemeData(
            textTheme: TextTheme(subhead: TextStyle(color: Colors.white),),
            primaryColor: Colors.black,
            scaffoldBackgroundColor: Colors.black,
            accentColor: Colors.black45,
            buttonColor: Colors.white12,
            toggleableActiveColor: Colors.black54,
            unselectedWidgetColor: Colors.black45,
            fontFamily: 'Quicksand',
            indicatorColor: Colors.black54,
        ));
  }

  void changingColor(bool valueOfClick){
    setState(() {
      if(valueOfClick){
        inheritedThemeSwitcher.themeBloc.selectedTheme.add(_buildBlueTheme());
        valueOfClick = true;
        click = true;
      } else {
        inheritedThemeSwitcher.themeBloc.selectedTheme.add(_buildPinkTheme());
        valueOfClick =false;
        click = false;
      }
    });
  }

  void darkMode(bool valueOfMode){
    setState(() {
      if(valueOfMode){
        inheritedThemeSwitcher.themeBloc.selectedTheme.add(_buildDarkMode());
        valueOfMode = true;
        mode = true;
      } else {
       inheritedThemeSwitcher.themeBloc.selectedTheme.add(_buildPinkTheme());
        valueOfMode =false;
        mode = false;
      }
    });
  }

  void setNotifications(bool valueOfNote){
    setState(() {
      if(valueOfNote){
        note = false;
        valueOfNote = false;
      } else {
        note = true;
        valueOfNote = true;
      }
    });
  }
}