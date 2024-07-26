import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

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
    setState(() {});
  }

  Future<void> _bubbleSort() async {
    setState(() {
      _isSorting = true;
      _cancelSorting = false;
    });

    for (int i = 0; i < _bubbleSortNumbers.length - 1; i++) {
      if (_cancelSorting) {
        setState(() {
          _isSorting = false;
          _cancelSorting = false;
        });
        return;
      }
      for (int j = 0; j < _bubbleSortNumbers.length - i - 1; j++) {
        if (_cancelSorting) {
          setState(() {
            _isSorting = false;
            _cancelSorting = false;
          });
          return;
        }
        if (_bubbleSortNumbers[j] > _bubbleSortNumbers[j + 1]) {
          int temp = _bubbleSortNumbers[j];
          _bubbleSortNumbers[j] = _bubbleSortNumbers[j + 1];
          _bubbleSortNumbers[j + 1] = temp;
          setState(() {});
          await Future.delayed(Duration(milliseconds: _duration));
        }
      }
    }

    setState(() {
      _isSorting = false;
    });
  }

  Future<void> _quickSort(List<int> numbers, int low, int high) async {
    if (low < high) {
      int pi = await _partition(numbers, low, high);
      await _quickSort(numbers, low, pi - 1);
      await _quickSort(numbers, pi + 1, high);
      setState(() {});
    }
  }

  Future<int> _partition(List<int> numbers, int low, int high) async {
    int pivot = numbers[high];
    int i = low - 1;

    for (int j = low; j < high; j++) {
      if (numbers[j] < pivot) {
        i++;
        int temp = numbers[i];
        numbers[i] = numbers[j];
        numbers[j] = temp;
        setState(() {});
        await Future.delayed(Duration(milliseconds: _duration));
      }
    }

    int temp = numbers[i + 1];
    numbers[i + 1] = numbers[high];
    numbers[high] = temp;
    setState(() {});
    await Future.delayed(Duration(milliseconds: _duration));

    return i + 1;
  }

  void _handlePlayButtonPress() {
    if (!_isSorting) {
      _cancelSorting = false;
      _bubbleSort();
      _quickSort(_quickSortNumbers, 0, _quickSortNumbers.length - 1);
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
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: CustomPaint(
              painter: BarPainter(_bubbleSortNumbers),
              child: Container(),
            ),
          ),
          Expanded(
            child: CustomPaint(
              painter: BarPainter(_quickSortNumbers),
              child: Container(),
            ),
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
