import 'dart:math';

import 'package:flutter/material.dart';
import 'package:custom_utils/custom_utils.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
     // showPerformanceOverlay: true,
      debugShowCheckedModeBanner: false,
      title: 'Fourier Circles',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(backgroundColor: Colors.black, body: Home()),
      //  Home())

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
  // BaseLength is the referene length, since the waves lengths(eg amplitudeor radius)
  // are all related to eachother by specific ratios, I can use this variable to tweak
  // the lengths of the overall system
  double baseLength = 100.0;

  double lineThickness = 8.0;
  double stepPerUpdate = 2.5; // How quickly the wave progresses
  // 1.0 means that it will take 100 frames to get a quarter of the circle
  // and 400 frames to make a full rotation(if the line has no multipliers)
  // Flutter usually runs at around 60 frames per second, meaning it updates
  // once every ~ 16ms so to get the time it takes for one rotation
  // do  stepsPerUpdate  x 1 circle over 400 steps x 60frames over second = circles per second
  // the inverse gives seconds per circle which is around 6.5 for 1.0
  List trace = [];

  @override
  void initState() {
    super.initState();
    segs =_squareWave(5, 70.0); // _triangleWave(10, 70.0); //

    animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 5))
          ..addListener(() {
            setState(() {});
          })
          ..repeat();
  }

  List<LineSegment2d> _squareWave(int numoflines, double line1Len,
      {List<Color> lineColors}) {
    // Square Wave is described here https:en.wikipedia.org/wiki/Square_wave
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
    // Square Wave is described here https:/en.wikipedia.org/wiki/Square_wave
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
            thickness: lineThickness,
            stepPerUpdate: stepPerUpdate,
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
            // segs[0].progress += 1.0;
            segs.forEach((seg) {
              seg.progress += 2.0;
            });
            setState(() {});
          })
          ..repeat();
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Stack(
      children: <Widget>[
        CustomPaint(
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
        ),
        ShapeCenteredAboutNode(
          shape: Shape(
              shapeType: ShapeType.polygon,
              location: segs[7].nodeLocation,
              color: Colors.blue,
              polygon: Polygon(
                sidelen: 30.0,
                sides: 6,
              )),
        ),
        ShapeCenteredAboutNode(
          shape: Shape(
              shapeType: ShapeType.polygon,
              location: segs[8].nodeLocation,
              color: Colors.red,
              polygon: Polygon(
                sidelen: 50.0,
                sides: 4,
              )),
        ),
        ShapeCenteredAboutNode(
          shape: Shape(
              shapeType: ShapeType.polygon,
              location: segs[9].nodeLocation,
              color: Colors.purple,
              polygon: Polygon(
                sidelen: 60.0,
                sides: 3,
              )),
        ),
        ShapeCenteredAboutNode(
          shape: Shape(
              shapeType: ShapeType.circle,
              color: Colors.green,
              location: segs[3].nodeLocation,
              circle: Circle(
                radius: 30.0,
              )),
        ),
      ],
    );
  }
}

enum chordType { major, minor }
