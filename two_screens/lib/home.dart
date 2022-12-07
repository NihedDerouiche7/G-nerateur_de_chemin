import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:two_screens/Image.dart';
import 'package:two_screens/ImageDB.dart';
import 'package:two_screens/exercises_list.dart';
import 'package:two_screens/main.dart';

class Home extends StatelessWidget {
  //const Home({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    var screen_height = MediaQuery.of(context).size.height;
    var screen_width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Color.fromRGBO(244, 248, 253, 1),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Home"),
        toolbarHeight: screen_height * 0.12,
        backgroundColor: Color.fromRGBO(38, 115, 209, 1), // appbar color.
        foregroundColor: Colors.white, // appbar text color.
      ),
      body: Align(
        child: Container(
          width: screen_width * 0.8,
          color: Color.fromRGBO(244, 248, 253, 1),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  Container(
                    //color: Color.fromRGBO(244, 248, 253, 1),
                    height: screen_height * 0.4,
                    width: screen_width * 0.2,
                    margin: EdgeInsets.only(
                        top: screen_height * 0.06,
                        bottom: screen_height * 0.03),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/pencil.png'),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  Container(
                    // margin: EdgeInsets.only(bottom: screen_height * 0.001),
                    width: screen_width * 0.3,
                    height: screen_height * 0.15,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => MyHomePage()));
                      },
                      child: Text(
                        "Create Exercise",
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromRGBO(38, 115, 209, 1),
                        foregroundColor: Colors.white,
                        //padding: EdgeInsets.all(50),
                        //textStyle: MaterialStateProperty.all(TextStyle(fontSize: 30))
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                      ),
                    ),
                  ),
                ],
              ),
              Column(children: [
                Container(
                  //color: Color.fromRGBO(244, 248, 253, 1),
                  height: screen_height * 0.43,
                  width: screen_width * 0.24,
                  margin: EdgeInsets.only(
                      top: screen_height * 0.05, bottom: screen_height * 0.01),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/save.png'),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                Container(
                  //margin: EdgeInsets.only(bottom: screen_height * 0.05),
                  width: screen_width * 0.3,
                  height: screen_height * 0.15,
                  child: ElevatedButton(
                    onPressed: () async {
                      ImageDB imagedb = ImageDB.db;
                      await imagedb.database;
                      final List<SavedImage> imagesDB =
                          await imagedb.getAllImages();
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ExercisesList(
                                items: imagesDB,
                              )));
                    },
                    child: Text(
                      "Exercises list",
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromRGBO(38, 115, 209, 1),
                      foregroundColor: Colors.white,
                      //padding: EdgeInsets.all(50),
                      //textStyle: MaterialStateProperty.all(TextStyle(fontSize: 30))
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                    ),
                  ),
                ),
              ]),
            ],
          ),
        ),
      ),
    );
  }
}
