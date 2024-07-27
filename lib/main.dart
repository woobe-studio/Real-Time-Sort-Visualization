import 'package:flutter/material.dart';
import 'sortAlgorithms/insertion_sort.dart';
import 'sortAlgorithms/quick_sort.dart';
import 'sortAlgorithms/selection_sort.dart';
import 'sortAlgorithms/merge_sort.dart';
import 'sortAlgorithms/heap_sort.dart';
import 'sortAlgorithms/lazy_stable_sort.dart';
import 'sortAlgorithms/radix_sort_lsd.dart';
import 'sortAlgorithms/gnome_sort.dart';
import 'sortAlgorithms/cocktail_shaker_sort.dart';
import 'sortAlgorithms/tim_sort.dart';
import 'sortAlgorithms/shell_sort.dart';

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
  List<int> _quickSortNumbers = [];
  List<int> _shellSortNumbers = [];
  List<int> _heapSortNumbers = [];
  List<int> _mergeSortNumbers = [];
  List<int> _lazyStableSortNumbers = [];
  bool _isSorting = false;
  bool _cancelSorting = false;
  int _duration = 50; // Default to milliseconds
  int _totalElements = 100;

  // Controllers for editable fields
  final TextEditingController _totalElementsController = TextEditingController(text: '100');
  final TextEditingController _delayController = TextEditingController(text: '5');

  // Variables to store sorting times
  Map<String, Duration> _sortingTimes = {
    'Quick Sort': Duration.zero,
    'Shell Sort': Duration.zero,
    'Merge Sort': Duration.zero,
    'Heap Sort': Duration.zero,
    'Lazy Stable Sort': Duration.zero,
  };

  // Manage ThemeMode
  ThemeMode _themeMode = ThemeMode.system;

  @override
  void initState() {
    super.initState();
    _generateRandomNumbers();
  }

  void _generateRandomNumbers() {
    final numbers = List.generate(_totalElements, (index) => index + 1)..shuffle();
    _quickSortNumbers = List.from(numbers);
    _shellSortNumbers = List.from(numbers);
    _heapSortNumbers = List.from(numbers);
    _mergeSortNumbers = List.from(numbers);
    _lazyStableSortNumbers = List.from(numbers);
    setState(() {});
  }

  Future<void> _startSorting() async {
    setState(() {
      _isSorting = true;
      _cancelSorting = false;
    });

    final sortTasks = [
      _measureSortTime('Quick Sort', () => quickSort(_quickSortNumbers, 0, _quickSortNumbers.length - 1, _duration, (updated) {
        setState(() => _quickSortNumbers = updated);
      })),
    _measureSortTime('Shell Sort', () => shellSort(_shellSortNumbers, _duration, (updated) {setState(() => _shellSortNumbers = updated);}
    )),
      _measureSortTime('Merge Sort', () => mergeSort(_mergeSortNumbers, (updated) {
        setState(() => _mergeSortNumbers = updated);
      }, _duration)),
      _measureSortTime('Heap Sort', () => heapSort(_heapSortNumbers, _duration, (updated) {
        setState(() => _heapSortNumbers = updated);
      })),
      _measureSortTime('Lazy Stable Sort', () => lazyStableSort(_lazyStableSortNumbers, _duration, (updated) {
        setState(() => _lazyStableSortNumbers = updated);
      })),
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
      setState(() {
        _totalElements = int.tryParse(_totalElementsController.text) ?? 100;
        _duration = int.tryParse(_delayController.text) ?? 50; // Default to milliseconds
        _generateRandomNumbers(); // Generate numbers based on new values
      });
      _cancelSorting = false;
      _startSorting();
    }
  }

  void _handleRefreshPage() {
    setState(() {
      _totalElementsController.text = '100';
      _delayController.text = '50'; // Default to milliseconds
      _totalElements = 100;
      _duration = 50;
      _generateRandomNumbers(); // Reset the numbers
      _isSorting = false; // Ensure sorting is stopped
    });
  }

  void _handleThemeToggle() {
    setState(() {
      if (_themeMode == ThemeMode.light) {
        _themeMode = ThemeMode.dark;
      } else if (_themeMode == ThemeMode.dark) {
        _themeMode = ThemeMode.system;
      } else {
        _themeMode = ThemeMode.light;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sort Check | Total: $_totalElements | Delay: ${_duration}ms'),
        actions: [
          if (!_isSorting) // Only show the restart button when not sorting
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: _handleRefreshPage,
            ),
          IconButton(
            icon: Icon(Icons.brightness_6),
            onPressed: _handleThemeToggle,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _totalElementsController,
                    decoration: InputDecoration(
                      labelText: 'Total amount',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    onSubmitted: (_) => _handlePlayButtonPress(),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    controller: _delayController,
                    decoration: InputDecoration(
                      labelText: 'Delay (ms)',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    onSubmitted: (_) => _handlePlayButtonPress(),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: [
                _buildSortColumn('Quick Sort', _quickSortNumbers, _sortingTimes['Quick Sort']!),
              ],
            ),
          ),
          _buildDivider(height: 20),
          Expanded(
            child: Row(
              children: [
                _buildSortColumn('Shell Sort', _shellSortNumbers, _sortingTimes['Shell Sort']!),
                _buildSortColumn('Merge Sort', _mergeSortNumbers, _sortingTimes['Merge Sort']!),
              ],
            ),
          ),
          _buildDivider(height: 20),
          Expanded(
            child: Row(
              children: [
                _buildSortColumn('Lazy Stable Sort', _lazyStableSortNumbers, _sortingTimes['Lazy Stable Sort']!),
                _buildSortColumn('Heap Sort', _heapSortNumbers, _sortingTimes['Heap Sort']!),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: _isSorting
          ? null // Hide button when sorting
          : FloatingActionButton(
        onPressed: _handlePlayButtonPress,
        child: Icon(Icons.play_arrow),
        tooltip: 'Start Sorting',
      ),
    );
  }

  Widget _buildSortColumn(String title, List<int> numbers, Duration time) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              '$title\nTime: ${(time.inMilliseconds / 1000).toStringAsFixed(2)} s',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
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
