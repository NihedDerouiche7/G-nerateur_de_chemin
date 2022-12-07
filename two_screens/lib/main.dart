import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui' as ui;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:two_screens/Image.dart';
import 'package:two_screens/ImageDB.dart';
import 'package:two_screens/home.dart';
import 'numberpicker.dart';
import 'package:http/http.dart' as http;

import 'globals.dart' as globals;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]).then((value) => runApp(MyApp()));

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Home(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage();
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  ///////////////paint_variables_functions////////////
  late GestureDetector touch;
  late CustomPaint canvas;
  late CustomPaint canvas2;
  late KanjiPainter kanjiPainter;
  late KanjiPainter2 kanjiPainter2;
  List l = [];
  List? direction;
  bool textIsEmpty = false;
  String d = "";

  String? direct() {
    setState(() {
      direction = globals.resultStrokes['direction'];
      for (String? i in direction!) {
        if (i == "UP") {
          print("aa ya na5LA");
          l.add('DOWN');
        } else if (i == 'DOWN') {
          l.add('UP');
        } else if (i == 'RIGHT') {
          l.add('RIGHT');
        } else if (i == 'LEFT') {
          l.add('LEFT');
        } else if (i == 'UP/RIGHT') {
          print("ufffff");
          l.add('DOWN/RIGHT');
        } else if (i == 'DOWN/RIGHT') {
          l.add('UP/RIGHT');
        } else if (i == 'DOWN/LEFT') {
          l.add('UP/LEFT');
        } else if (i == 'UP/LEFT",') {
          l.add('DOWN/LEFT');
        }
      }
    });
    globals.text = l.toString();
    if (!textIsEmpty) {
      d = globals.text;
    } else {
      d = "";
    }

    return l.toString();
  }

  void panStart(DragStartDetails details) {
    kanjiPainter.startStroke(details.globalPosition);
  }

  void panUpdate(DragUpdateDetails details) {
    kanjiPainter.appendStroke(details.globalPosition);
  }

  void panEnd(DragEndDetails details) {
    kanjiPainter.endStroke();
  }

  @override
  void initState() {
    super.initState();
    kanjiPainter = new KanjiPainter(const Color.fromRGBO(255, 255, 255, 1.0));

    kanjiPainter2 = new KanjiPainter2(const Color.fromRGBO(255, 255, 255, 1.0));
  }

  //////////////////////////////////////////
  @override
  Widget build(BuildContext context) {
    /////////paint_sections//////////////////////////////////////////////////////////////////////////////
    touch = new GestureDetector(
      onPanStart: panStart,
      onPanUpdate: panUpdate,
      onPanEnd: panEnd,
    );

    canvas = new CustomPaint(
      painter: kanjiPainter,
      child: touch,
    );
    // ignore: unnecessary_new
    canvas2 = new CustomPaint(
      painter: kanjiPainter2,
    );

    Container container = new Container(
        child: new ConstrainedBox(
            constraints: const BoxConstraints.expand(),
            child: new Card(
              child: canvas,
            )));

    Container container2 = new Container(
        child: new ConstrainedBox(
            constraints: const BoxConstraints.expand(),
            child: new Card(
              child: canvas2,
            )));

    //////////////////////////////////////////////////////////////////////////////////////////////////////
    ///fullscreen////////////////////////////////////////////////////////////////////////////////////////
    return Row(children: <Widget>[
      Expanded(
          child: Scaffold(
              backgroundColor: const Color.fromRGBO(200, 200, 200, 1.0),
              body: Stack(children: [
                container,
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    //will break to another line on overflow
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: [
                          Container(
                              height: 40,
                              width: 40,
                              margin: EdgeInsets.only(
                                left: 10,
                                right: 10,
                                bottom: 10,
                              ),
                              child: FloatingActionButton(
                                shape: RoundedRectangleBorder(),
                                onPressed: () {
                                  KanjiPainter.strokes = [];
                                  kanjiPainter2.canv2 = false;
                                  KanjiPainter.strokes_x = [];
                                  KanjiPainter.strokes_y = [];
                                  l = [];
                                  setState(() {
                                    globals.text = "";
                                  });
                                  textIsEmpty = true;

                                  //globals.test = true;
                                },
                                backgroundColor: Color.fromRGBO(51, 51, 255, 1),
                                child: SvgPicture.asset('assets/eraser.svg',
                                    height: 20.0,
                                    width: 20.0,
                                    color: Colors.white,
                                    allowDrawingOutsideViewBox: false),
                              )), // button second
                          Container(
                              height: 40,
                              width: 40,
                              margin: EdgeInsets.only(
                                left: 10,
                                right: 10,
                                bottom: 10,
                              ),
                              child: FloatingActionButton(
                                shape: RoundedRectangleBorder(),
                                onPressed: () async {
                                  ImageDB imagedb = ImageDB.db;
                                  await imagedb.database;

                                  await imagedb.insert(SavedImage(
                                      new_strokes_x: globals
                                          .resultStrokes["new_strokes_x"]!,
                                      new_strokes_y: globals
                                          .resultStrokes["new_strokes_y"]!,
                                      direction:
                                          globals.resultStrokes["direction"]!));
                                },
                                backgroundColor: Color.fromRGBO(51, 51, 255, 1),
                                child: SvgPicture.asset('assets/save.svg',
                                    height: 20.0,
                                    width: 20.0,
                                    color: Colors.white,
                                    allowDrawingOutsideViewBox: false),
                              )),
                        ],
                      ), // button third
                      Row(children: [
                        Container(
                            margin: EdgeInsets.only(bottom: 10),
                            width: 60,
                            height: 40,
                            child: NumberTextField()),
                        Container(
                            height: 40,
                            width: 40,
                            margin: EdgeInsets.only(
                              left: 10,
                              right: 10,
                              bottom: 10,
                            ),
                            child: FloatingActionButton(
                              shape: RoundedRectangleBorder(),
                              onPressed: () {
                                kanjiPainter2.canv2 = true;
                                // steps number globals.intValue mil main
                                print("step number : ${globals.intValue}");
                                direct();
                                print("directions : $l");
                              },
                              backgroundColor: Color.fromRGBO(51, 51, 255, 1),
                              child: SvgPicture.asset('assets/draw.svg',
                                  height: 20.0,
                                  width: 20.0,
                                  color: Colors.white,
                                  allowDrawingOutsideViewBox: false),
                            )),
                      ]),
                      // Add more buttons here
                    ],
                  ),
                ),
              ]))),
      Container(
        width: 5,
        color: Color.fromRGBO(51, 51, 255, 1),
      ),
      Expanded(
          child: Scaffold(
        backgroundColor: const Color.fromRGBO(200, 200, 200, 1.0),
        body: Stack(
          children: [
            container2,
            Text(globals.text),
          ],
        ),
      )),
    ]);
  }
}

/////////////////////////////////////////////////paint///////////////////////////////////////////////////////////
class KanjiPainter extends ChangeNotifier implements CustomPainter {
  Color strokeColor;
  static var strokes = <List<Offset>>[];
  var strokes_0 = <Offset>[];
  //eb3ath strokes_x fiha les x
  //eb3ath strokes_y fiha les y
  static List strokes_x = [];
  static List strokes_y = [];

  KanjiPainter(this.strokeColor);

  bool hitTest(Offset position) => true;
  void startStroke(Offset position) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.bottom]);

    strokes.add([position]);
    notifyListeners();
  }

  void appendStroke(Offset position) {
    var stroke = strokes.last;
    stroke.add(position);
    notifyListeners();
  }

  void endStroke() async {
    notifyListeners();

    strokes_0 = strokes.last;

    for (int i = 0; i < strokes_0.length; i++) {
      strokes_x.add(strokes_0[i].dx.round());
      strokes_y.add(strokes_0[i].dy.round());
    }

    var stringList_x = strokes_x.join(",");
    //print("list_x : $stringList_x");
    var stringList_y = strokes_y.join(",");
    //print("list_y : $stringList_y");

    await sendToServer(
        nbr_step: globals.intValue,
        strokes_x: stringList_x,
        strokes_y: stringList_y);
  }

  Future<List?> sendToServer(
      {required String strokes_x,
      required String strokes_y,
      required int? nbr_step}) async {
    globals.resultStrokes["new_strokes_x"] = [];
    globals.resultStrokes["new_strokes_y"] = [];
    final response = await http.post(
        Uri.parse('https://djangoserver-production.up.railway.app/API/input/'),
        body: {
          "X": strokes_x,
          "Y": strokes_y,
          "nbr_pas": nbr_step.toString(),
        });

    if (response.statusCode == 200) {
      globals.resultStrokes["new_strokes_x"] =
          jsonDecode(response.body)["newX"];
      globals.resultStrokes["new_strokes_y"] =
          jsonDecode(response.body)["newY"];
      globals.resultStrokes["direction"] =
          jsonDecode(response.body)["direction "];
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      print(response.body);
    }
    return null;
  }

  @override
  void paint(Canvas canvas, Size size) {
    //print("paint!");
    var rect = Offset.zero & size;
    Paint fillPaint = Paint();
    fillPaint.color = Colors.white;
    fillPaint.style = PaintingStyle.fill;
    canvas.drawRect(rect, fillPaint);

    Paint strokePaint = new Paint();
    strokePaint.color = Colors.black;
    strokePaint.strokeWidth = 3;
    strokePaint.style = PaintingStyle.stroke;

    for (var stroke in strokes) {
      Path strokePath = new Path();
      strokePath.addPolygon(stroke, false);
      canvas.drawPath(strokePath, strokePaint);
    }
  }

  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

  @override
  // TODO: implement semanticsBuilder
  SemanticsBuilderCallback? get semanticsBuilder => null;

  @override
  bool shouldRebuildSemantics(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRebuildSemantics
    return true;
  }
}

class KanjiPainter2 extends ChangeNotifier implements CustomPainter {
  Color? strokeColor;
  KanjiPainter2(this.strokeColor);

  bool hitTest(Offset position) => true;
  bool canv2 = false;
  @override
  void paint(Canvas canvas, Size size) {
    if (canv2 == true) {
      //print("paint!");
      var rect = Offset.zero & size;
      Paint fillPaint = Paint();
      fillPaint.color = Colors.white;
      fillPaint.style = PaintingStyle.fill;
      canvas.drawRect(rect, fillPaint);

      Paint strokePaint = new Paint();
      strokePaint.color = Colors.black;
      strokePaint.strokeWidth = 3;
      strokePaint.style = PaintingStyle.stroke;
      List<Offset> points = [];
      List list = [];
      //les x jdod yt7atou blaset KanjiPainter.strokes_x
      //les y jdod yt7atou blaset KanjiPainter.strokes_y

      for (int i = 0; i < globals.resultStrokes["new_strokes_x"]!.length; i++) {
        points.add(Offset(globals.resultStrokes["new_strokes_x"]![i].toDouble(),
            globals.resultStrokes["new_strokes_y"]![i].toDouble()));
      }
      list.add(points);
// {new_strokes_x: [70, 177, 262, 349], new_strokes_y: [123, 93, 78, 136], direction: []}

      // canvas.drawPoints(PointMode.points, points, strokePaint);
      print("points : $points");
      Path strokePath = new Path();
      for (var stroke in list) {
        strokePath.addPolygon(stroke, false);
        canvas.drawPath(strokePath, strokePaint);
      }

      /* strokePath.moveTo(KanjiPainter.strokes_x[0], KanjiPainter.strokes_y[0]);
      for (int i = 1; i < KanjiPainter.strokes_x.length; i++) {
        strokePath.lineTo(KanjiPainter.strokes_x[i], KanjiPainter.strokes_y[i]);
        canvas.drawPath(strokePath, strokePaint);
      }*/
    }
  }

  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

  @override
  // TODO: implement semanticsBuilder
  SemanticsBuilderCallback? get semanticsBuilder => null;

  @override
  bool shouldRebuildSemantics(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRebuildSemantics
    return true;
  }
}
