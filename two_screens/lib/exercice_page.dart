import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:two_screens/Image.dart';
import 'globals.dart' as globals;

class ExercisePage extends StatelessWidget {
  final SavedImage savedImage;
  late KanjiPainter2 kanjiPainter2;
  ExercisePage({required this.savedImage}) {
    kanjiPainter2 =
        KanjiPainter2(const Color.fromRGBO(255, 255, 255, 1.0), savedImage);
    kanjiPainter2.canv2 = true;
  }
  List l = [];
  List? direction;
  bool textIsEmpty = false;
  String d = "";

  @override
  Widget build(BuildContext context) {
    double screen_height = MediaQuery.of(context).size.height;
    double screen_width = MediaQuery.of(context).size.width;
    CustomPaint canvas2 = new CustomPaint(
      painter: kanjiPainter2,
    );

    return Scaffold(
      backgroundColor: Color.fromRGBO(244, 248, 253, 1),
      body: Stack(children: [
        Container(
          alignment: Alignment.topCenter,
          margin: EdgeInsets.only(top: screen_height * 0.1),
          width: screen_width / 2,
          height: screen_height / 2,
          child: canvas2,
        ),
      ]),
    );
  }
}

class KanjiPainter2 extends ChangeNotifier implements CustomPainter {
  Color? strokeColor;
  final SavedImage savedImage;
  KanjiPainter2(this.strokeColor, this.savedImage);

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

      for (int i = 0; i < savedImage.new_strokes_x.length; i++) {
        points.add(Offset(savedImage.new_strokes_x[i].toDouble(),
            savedImage.new_strokes_y[i].toDouble()));
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
