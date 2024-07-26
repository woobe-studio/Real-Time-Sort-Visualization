import 'package:flutter/material.dart';
import 'sortAlgorithms/bubble_sort.dart';
import 'sortAlgorithms/insertion_sort.dart';
import 'sortAlgorithms/quick_sort.dart';
import 'sortAlgorithms/selection_sort.dart';
import 'sortAlgorithms/merge_sort.dart';
import 'sortAlgorithms/heap_sort.dart';
import 'sortAlgorithms/lazy_stable_sort.dart';
import 'sortAlgorithms/radix_sort_lsd.dart';

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
        brightness: Brightness.light,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      themeMode: ThemeMode.system,
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
  List<int> _lazyStableSortNumbers = [];
  List<int> _radixSortNumbers = [];
  bool _isSorting = false;
  bool _cancelSorting = false;
  int _duration = 1;
  int _totalElements = 500;

  // Variables to store sorting times
  Map<String, Duration> _sortingTimes = {
    'Bubble Sort': Duration.zero,
    'Quick Sort': Duration.zero,
    'Selection Sort': Duration.zero,
    'Insertion Sort': Duration.zero,
    'Merge Sort': Duration.zero,
    'Heap Sort': Duration.zero,
    'Lazy Stable Sort': Duration.zero,
    'Radix Sort': Duration.zero,
  };

  @override
  void initState() {
    super.initState();
    _generateRandomNumbers();
  }

  void _generateRandomNumbers() {
    _bubbleSortNumbers = List.generate(_totalElements, (index) => index + 1)..shuffle();
    _quickSortNumbers = List.from(_bubbleSortNumbers);
    _selectionSortNumbers = List.from(_bubbleSortNumbers);
    _insertionSortNumbers = List.from(_bubbleSortNumbers);
    _heapSortNumbers = List.from(_bubbleSortNumbers);
    _mergeSortNumbers = List.from(_bubbleSortNumbers);
    _lazyStableSortNumbers = List.from(_bubbleSortNumbers);
    _radixSortNumbers = List.from(_bubbleSortNumbers);
    setState(() {});
  }

  Future<void> _startSorting() async {
    setState(() {
      _isSorting = true;
      _cancelSorting = false;
    });

    final sortTasks = [
      _measureSortTime('Bubble Sort', () => bubbleSort(_bubbleSortNumbers, _duration, (updated) => setState(() => _bubbleSortNumbers = updated))),
      _measureSortTime('Quick Sort', () => quickSort(_quickSortNumbers, 0, _quickSortNumbers.length - 1, _duration, (updated) => setState(() => _quickSortNumbers = updated))),
      _measureSortTime('Selection Sort', () => selectionSort(_selectionSortNumbers, _duration, (updated) => setState(() => _selectionSortNumbers = updated))),
      _measureSortTime('Insertion Sort', () => insertionSort(_insertionSortNumbers, _duration, (updated) => setState(() => _insertionSortNumbers = updated))),
      _measureSortTime('Merge Sort', () => mergeSort(_mergeSortNumbers, (updated) => setState(() => _mergeSortNumbers = updated), _duration)),
      _measureSortTime('Heap Sort', () => heapSort(_heapSortNumbers, _duration, (updated) => setState(() => _heapSortNumbers = updated))),
      _measureSortTime('Lazy Stable Sort', () => lazyStableSort(_lazyStableSortNumbers, _duration, (updated) => setState(() => _lazyStableSortNumbers = updated))),
      _measureSortTime('Radix Sort', () => radixSort(_radixSortNumbers, _duration, (updated) => setState(() => _radixSortNumbers = updated))),
    ];

    await Future.wait(sortTasks);

    if (!_cancelSorting) {
      setState(() {
        _isSorting = false;
      });
    }
  }

  Future<void> _measureSortTime(String algorithmName, Future<void> Function() sortFunction) async {
    final stopWatch = Stopwatch()..start();
    await sortFunction();
    stopWatch.stop();
    setState(() {
      _sortingTimes[algorithmName] = stopWatch.elapsed;
    });
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
        title: Text('Sort Comparison | Total: $_totalElements | Delay: ${_duration * 1000}ms'),
        actions: [
          IconButton(
            icon: Icon(Icons.shuffle),
            onPressed: _isSorting ? null : _handleRestartOrShuffleButtonPress,
          ),
          IconButton(
            icon: Icon(Icons.speed),
            onPressed: _isSorting ? null : () {
              setState(() {
                _duration = _duration == 1 ? 2 : 1;
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.brightness_6),
            onPressed: () {
              ThemeMode currentMode = Theme.of(context).brightness == Brightness.dark ? ThemeMode.light : ThemeMode.dark;
              setState(() {
                // Toggle the theme
                ThemeMode themeMode = currentMode;
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
                _buildSortColumn('Bubble Sort', _bubbleSortNumbers, _sortingTimes['Bubble Sort']!),
                _buildSortColumn('Quick Sort', _quickSortNumbers, _sortingTimes['Quick Sort']!),
              ],
            ),
          ),
          _buildDivider(height: 20),
          Expanded(
            child: Row(
              children: [
                _buildSortColumn('Selection Sort', _selectionSortNumbers, _sortingTimes['Selection Sort']!),
                _buildSortColumn('Insertion Sort', _insertionSortNumbers, _sortingTimes['Insertion Sort']!),
              ],
            ),
          ),
          _buildDivider(height: 20),
          Expanded(
            child: Row(
              children: [
                _buildSortColumn('Merge Sort', _mergeSortNumbers, _sortingTimes['Merge Sort']!),
                _buildSortColumn('Heap Sort', _heapSortNumbers, _sortingTimes['Heap Sort']!),
              ],
            ),
          ),
          _buildDivider(height: 20),
          Expanded(
            child: Row(
              children: [
                _buildSortColumn('Lazy Stable Sort', _lazyStableSortNumbers, _sortingTimes['Lazy Stable Sort']!),
                _buildSortColumn('Radix Sort', _radixSortNumbers, _sortingTimes['Radix Sort']!),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _isSorting ? () {
          setState(() {
            _cancelSorting = true;
          });
        } : _handlePlayButtonPress,
        child: Icon(_isSorting ? Icons.restart_alt : Icons.play_arrow),
        tooltip: _isSorting ? 'Stop Sorting' : 'Start Sorting',
      ),
    );
  }

  Widget _buildSortColumn(String title, List<int> numbers, Duration time) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('$title\nTime: ${time.inMilliseconds} ms', textAlign: TextAlign.center, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Expanded(
              child: CustomPaint(
                painter: BarPainter(numbers),
                child: Container(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider({double height = 20}) {
    return Container(
      width: height,
      color: Colors.black,
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
