import 'dart:async';

Future<void> countingSort(List<int> list, int delayMs, Function(List<int>) onUpdate) async {
  if (list.isEmpty) return;

  final int max = list.reduce((a, b) => a > b ? a : b);
  final int min = list.reduce((a, b) => a < b ? a : b);
  final int range = max - min + 1;

  List<int> count = List.generate(range, (_) => 0);

  // Count occurrences of each number
  for (int number in list) {
    count[number - min]++;
  }

  list.clear();

  // Build the sorted list
  for (int i = 0; i < range; i++) {
    for (int j = 0; j < count[i]; j++) {
      list.add(i + min);
      onUpdate(list); // Update the UI with the current state
      await Future.delayed(Duration(milliseconds: delayMs));
    }
  }
}
