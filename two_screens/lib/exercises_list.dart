import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:two_screens/Image.dart';
import 'package:two_screens/ImageDB.dart';
import 'package:two_screens/exercice_page.dart';

class ExercisesList extends StatefulWidget {
  final List<SavedImage> items;
  const ExercisesList({
    Key? key,
    required this.items,
  }) : super(key: key);

  @override
  State<ExercisesList> createState() => _ExercisesListState(items: items);
}

class _ExercisesListState extends State<ExercisesList> {
  _ExercisesListState({
    required this.items,
  });

  final List<SavedImage> items;

  @override
  Widget build(BuildContext context) {
    var screen_height = MediaQuery.of(context).size.height;
    var screen_width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Color.fromRGBO(244, 248, 253, 1),
      appBar: AppBar(
        title: Text("Exercises List"),
        automaticallyImplyLeading: false,
        toolbarHeight: screen_height * 0.12,
        backgroundColor: Color.fromRGBO(38, 115, 209, 1), // appbar color.
        foregroundColor: Colors.white, // appbar text color.
      ),
      body: Center(
        child: Container(
          margin: EdgeInsets.only(
            top: screen_height * 0.05,
          ),
          width: screen_width * 0.9,
          child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                return Container(
                  height: screen_height * 0.27,
                  child: GestureDetector(
                    onTap: (() {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              ExercisePage(savedImage: items[index])));
                    }),
                    child: Card(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              //color: Color.fromRGBO(244, 248, 253, 1),
                              height: screen_height * 0.2,
                              width: screen_width * 0.18,
                              margin: EdgeInsets.only(
                                  // top: screen_height * 0.05,
                                  //bottom: screen_height * 0.01
                                  left: screen_width * 0.05),
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage('assets/old.png'),
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                          ),
////////////////////////////////////////////////////////////////////////////////
                          Container(
                            child: Text(items[index].name,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Color.fromRGBO(38, 115, 209, 1))),
                          ),
////////////////////////////////////////////////////////////////////////////////
                          Container(
                              width: screen_width * 0.14,
                              height: screen_height * 0.14,
                              margin:
                                  EdgeInsets.only(right: screen_width * 0.01),
                              child: IconButton(
                                icon: Image.asset('assets/delete.png'),
                                onPressed: () async {
                                  ImageDB imagedb = ImageDB.db;
                                  await imagedb.database;
                                  await imagedb.delete(items[index].name);
                                  setState(() {
                                    items.removeAt(index);
                                  });
                                },
                              ))
                        ],
                      ),
                    ),
                  ),
                );
              }),
        ),
      ),
    );
  }
}
