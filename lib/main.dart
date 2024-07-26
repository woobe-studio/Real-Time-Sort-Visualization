import 'package:flutter/material.dart';
import 'sortAlgorithms/bubble_sort.dart';
import 'sortAlgorithms/insertion_sort.dart';
import 'sortAlgorithms/quick_sort.dart';
import 'sortAlgorithms/selection_sort.dart';
import 'sortAlgorithms/merge_sort.dart';
import 'sortAlgorithms/heap_sort.dart';


void main() {
  runApp(SortComparisonApp());
}

class SortComparisonApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sort Comparison',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SortComparisonPage(),
    );
  }
}

class SortComparisonPage extends StatefulWidget {
  @override
  _SortComparisonPageState createState() => _SortComparisonPageState();
}

class _SortComparisonPageState extends State<SortComparisonPage> {
  List<int> _bubbleSortNumbers = [];
  List<int> _quickSortNumbers = [];
  List<int> _selectionSortNumbers = [];
  List<int> _insertionSortNumbers = [];
  List<int> _heapSortNumbers = [];
  List<int> _mergeSortNumbers = [];
  bool _isSorting = false;
  bool _cancelSorting = false;
  int _duration = 1;

  @override
  void initState() {
    super.initState();
    _generateRandomNumbers();
  }

  void _generateRandomNumbers() {
    _bubbleSortNumbers = List.generate(100, (index) => index + 1)..shuffle();
    _quickSortNumbers = List.from(_bubbleSortNumbers);
    _selectionSortNumbers = List.from(_bubbleSortNumbers);
    _insertionSortNumbers = List.from(_bubbleSortNumbers);
    _mergeSortNumbers = List.from(_bubbleSortNumbers);
    _heapSortNumbers = List.from(_bubbleSortNumbers);
    setState(() {});
  }

  Future<void> _startSorting() async {
    setState(() {
      _isSorting = true;
      _cancelSorting = false;
    });

    final sortTasks = [
      bubbleSort(_bubbleSortNumbers, _duration, (updated) => setState(() => _bubbleSortNumbers = updated)),
      quickSort(_quickSortNumbers, 0, _quickSortNumbers.length - 1, _duration, (updated) => setState(() => _quickSortNumbers = updated)),
      selectionSort(_selectionSortNumbers, _duration, (updated) => setState(() => _selectionSortNumbers = updated)),
      insertionSort(_insertionSortNumbers, _duration, (updated) => setState(() => _insertionSortNumbers = updated)),
      heapSort(_heapSortNumbers, _duration, (updated) => setState(() => _heapSortNumbers = updated)),
      mergeSort(_mergeSortNumbers, (updated) => setState(() => _mergeSortNumbers = updated), _duration),
    ];

    await Future.wait(sortTasks);

    if (!_cancelSorting) {
      setState(() {
        _isSorting = false;
      });
    }
  }

  void _handlePlayButtonPress() {
    if (!_isSorting) {
      _cancelSorting = false;
      _startSorting();
    }
  }

  void _handleRestartOrShuffleButtonPress() {
    if (_isSorting) {
      setState(() {
        _cancelSorting = true;
      });
    } else {
      _generateRandomNumbers();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sort Comparison'),
        actions: [
          IconButton(
            icon: Icon(Icons.shuffle),
            onPressed: _isSorting ? null : _handleRestartOrShuffleButtonPress,
          ),
          IconButton(
            icon: Icon(Icons.speed),
            onPressed: _isSorting ? null : () {
              setState(() {
                _duration = _duration == 1 ? 100 : 1;
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.all(0),
                          child: Text('Bubble Sort', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                        ),
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.only(right: 0), // Ensure space for separator
                            child: CustomPaint(
                              painter: BarPainter(_bubbleSortNumbers),
                              child: Container(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  width: 20,
                  color: Colors.black,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.all(0),
                          child: Text('Quick Sort', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                        ),
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.only(left: 0), // Ensure space for separator
                            child: CustomPaint(
                              painter: BarPainter(_quickSortNumbers),
                              child: Container(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 20,
            color: Colors.black,
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.all(0),
                          child: Text('Selection Sort', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                        ),
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.only(right: 0), // Ensure space for separator
                            child: CustomPaint(
                              painter: BarPainter(_selectionSortNumbers),
                              child: Container(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  width: 20,
                  color: Colors.black,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.all(0),
                          child: Text('Insertion Sort', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                        ),
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.only(left: 0), // Ensure space for separator
                            child: CustomPaint(
                              painter: BarPainter(_insertionSortNumbers),
                              child: Container(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 20,
            color: Colors.black,
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.all(0),
                          child: Text('Merge Sort', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                        ),
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.only(right: 0), // Ensure space for separator
                            child: CustomPaint(
                              painter: BarPainter(_mergeSortNumbers),
                              child: Container(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  width: 20,
                  color: Colors.black,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.all(0),
                          child: Text('Heap Sort', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                        ),
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.only(left: 0), // Ensure space for separator
                            child: CustomPaint(
                              painter: BarPainter(_heapSortNumbers),
                              child: Container(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 20,
            color: Colors.black,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _handlePlayButtonPress,
        child: Icon(_isSorting ? Icons.restart_alt : Icons.play_arrow),
        tooltip: _isSorting ? 'Restart Sorting' : 'Start Sorting',
      ),
      persistentFooterButtons: [
        ElevatedButton.icon(
          onPressed: _handleRestartOrShuffleButtonPress,
          icon: Icon(_isSorting ? Icons.stop : Icons.shuffle),
          label: Text(_isSorting ? 'Stop Sorting' : 'Shuffle Numbers'),
        ),
      ],
    );
  }
}

class BarPainter extends CustomPainter {
  final List<int> numbers;

  BarPainter(this.numbers);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..strokeWidth = size.width / numbers.length;

    final barWidth = size.width / numbers.length;
    for (int i = 0; i < numbers.length; i++) {
      final barHeight = (numbers[i] / numbers.length) * size.height;
      final color = Color.lerp(Colors.red, Colors.green, numbers[i] / numbers.length);
      paint.color = color ?? Colors.blue;
      canvas.drawLine(
        Offset(i * barWidth, size.height),
        Offset(i * barWidth, size.height - barHeight),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}