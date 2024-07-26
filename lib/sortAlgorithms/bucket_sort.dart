import 'dart:async';

Future<void> bucketSort(List<int> list, int delayMs, Function(List<int>) onUpdate) async {
  if (list.isEmpty) return;

  final int max = list.reduce((a, b) => a > b ? a : b);
  final int min = list.reduce((a, b) => a < b ? a : b);
  final int bucketCount = (max - min) ~/ 10 + 1;

  List<List<int>> buckets = List.generate(bucketCount, (_) => []);

  // Distribute elements into buckets
  for (int number in list) {
    int bucketIndex = (number - min) ~/ 10;
    buckets[bucketIndex].add(number);
  }

  list.clear();

  // Sort each bucket and merge
  for (List<int> bucket in buckets) {
    bucket.sort();
    list.addAll(bucket);
    onUpdate(list); // Update the UI with the current state
    await Future.delayed(Duration(milliseconds: delayMs));
  }
}
