import 'dart:math';

import 'package:flutter/material.dart';
import 'package:custom_utils/custom_utils.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        //showPerformanceOverlay: true,
        debugShowCheckedModeBanner: false,
        title: 'Fourier Circles',
        theme: new ThemeData(
            primarySwatch: Colors.blue, backgroundColor: Colors.black),
        home: Scaffold(backgroundColor: Colors.black, body: Home())

        //new MyHomePage(),
        );
  }
}

class Home extends StatefulWidget {
  @override
  HomeState createState() {
    return new HomeState();
  }
}

class HomeState extends State<Home> with TickerProviderStateMixin {
  List<LineSegment2d> segs;
  AnimationController animationController;
  double baseLength = 100.0 * (4 / pi);

  List trace = [];

  @override
  void initState() {
    super.initState();
    segs = _squareWave(20, 70.0); // _triangleWave(10, 70.0);

    animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 5))
          ..addListener(() {
            setState(() {});
          })
          ..repeat();
  }

  List<LineSegment2d> _squareWave(int numoflines, double line1Len,
      {List<Color> lineColors}) {
    // Square Wave is described here https://en.wikipedia.org/wiki/Square_wave
    List<LineSegment2d> lines = [];
    for (int i = 0; i < numoflines; i++) {
      lines.add(LineSegment2d(
          length: baseLength * (1 / (1.0 + (i * 2))),
          node: i,
          root: i == 0,
          freqMultiplier: 1.0 + (i * 2),
          lineColor: (lineColors != null && lineColors.length > i)
              ? lineColors[i]
              : RandomColor.next(),
          progress: 0.0,
          connectionNode: i - 1));
    }
    return lines;
  }

  List<LineSegment2d> _triangleWave(int numoflines, double line1Len,
      {List<Color> lineColors}) {
    // Square Wave is described here https://en.wikipedia.org/wiki/Square_wave
    List<LineSegment2d> lines = [];
    for (int i = 0; i < numoflines; i++) {
      lines.add(LineSegment2d(
          length: baseLength / (pow((2 * i + 1), 2)),
          node: i,
          root: i == 0,
          freqMultiplier: 2.0 * i + 1.0,
          lineColor: (lineColors != null && lineColors.length > i)
              ? lineColors[i]
              : RandomColor.next(),
          progress: i % 2 == 0 ? 0.0 : 200.0,
          connectionNode: i - 1));
    }
    return lines;
  }

  List<LineSegment2d> _chord() {
    List<LineSegment2d> lines = [
      LineSegment2d(
        length: baseLength / 3,
        node: 0,
        root: true,
        freqMultiplier: 1.0,
        lineColor: Colors.green,
        progress: 0.0,
      ),
      LineSegment2d(
        length: baseLength / 3,
        node: 1,
        freqMultiplier: 1.5,
        lineColor: Colors.blue,
        progress: 0.0,
        connectionNode: 0,
      ),
      LineSegment2d(
        length: baseLength / 3.0,
        node: 2,
        freqMultiplier: 5 / 4,
        lineColor: Colors.red,
        progress: 0.0,
        connectionNode: 1,
      ),
    ];
    return lines;
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Stack(
      children: <Widget>[
        CustomPaint(
          painter: LinePainterWOscilloscope(
            showYAxis: true,
            yAxisColor: Colors.orange,
            traceColor: Colors.lightGreen,
            trace: trace,
            points: segs,
            thickness: 8.0,
            stepPerUpdate: 0.5,
          ),
          child: Container(
            // color: Colors.grey,
            height: h,
            width: w,
          ),
        ),
      ],
    );
  }
}

class Art extends StatefulWidget {
  @override
  _ArtState createState() => _ArtState();
}

class _ArtState extends State<Art> with TickerProviderStateMixin {
  List<LineSegment2d> segs;
  AnimationController animationController;

  @override
  void initState() {
    super.initState();

    segs = [
      LineSegment2d(
          length: 50.0 * sqrt(2),
          node: 0,
          root: true,
          lineColor: Colors.transparent,
          progress: 50.0),
      LineSegment2d(
        length: 100.0,
        node: 1,
        lineColor: Colors.red,
        progress: 300.0,
        connectionNode: 0,
      ),
      LineSegment2d(
          length: 100.0,
          node: 2,
          lineColor: Colors.indigo,
          progress: 200.0,
          connectionNode: 1),
      LineSegment2d(
          length: 100.0,
          node: 3,
          lineColor: Colors.pink,
          progress: 100.0,
          connectionNode: 2),
      LineSegment2d(
          length: 100.0,
          node: 4,
          lineColor: Colors.orange,
          progress: 0.0,
          connectionNode: 3),
      LineSegment2d(
          length: 50.0 * sqrt(2),
          node: 5,
          lineColor: Colors.green,
          progress: 50.0,
          connectionNode: 4),
      LineSegment2d(
        length: 200.0,
        node: 6,
        lineColor: Colors.red,
        progress: 300.0,
        connectionNode: 5,
      ),
      LineSegment2d(
          length: 200.0,
          node: 7,
          lineColor: Colors.indigo,
          progress: 200.0,
          connectionNode: 6),
      LineSegment2d(
          length: 200.0,
          node: 8,
          lineColor: Colors.pink,
          progress: 100.0,
          connectionNode: 7),
      LineSegment2d(
          length: 200.0,
          node: 9,
          lineColor: Colors.orange,
          progress: 0.0,
          connectionNode: 8),
      LineSegment2d(
          length: 100.0 * sqrt(2),
          node: 10,
          lineColor: Colors.brown,
          progress: 250.0,
          connectionNode: 9),
      LineSegment2d(
          length: 50.0 * sqrt(2),
          node: 11,
          lineColor: Colors.green,
          progress: 250.0,
          connectionNode: 2),
      LineSegment2d(
          length: 50.0 * sqrt(2),
          node: 12,
          lineColor: Colors.green,
          progress: 150.0,
          connectionNode: 3),
      LineSegment2d(
          length: 100.0 * sqrt(2),
          node: 13,
          lineColor: Colors.brown,
          progress: 350.0,
          connectionNode: 10),
      LineSegment2d(
          length: 50.0 * sqrt(2),
          node: 14,
          lineColor: Colors.brown,
          progress: 350.0,
          connectionNode: 1),
    ];

    animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 5))
          ..addListener(() {
            setState(() {});
            //segs[0].progress += 1.0;
            segs.forEach((seg) {
              seg.progress += 5.0;
            });
            setState(() {});
          })
          ..repeat();
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return CustomPaint(
      painter: LinePainter(
        points: segs,
        thickness: 10.0,
        xRootFromCenter: 0.0,
        yRootFromCenter: 0.0,
      ),
      child: Container(
        // color: Colors.grey,
        height: h,
        width: w,
      ),
    );
    ;
  }
}

enum chordType { major, minor }
