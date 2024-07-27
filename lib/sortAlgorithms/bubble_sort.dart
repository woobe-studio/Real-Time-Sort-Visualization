import 'dart:async';

Future<void> bubbleSort(List<int> numbers, int delayMs, Function(List<int>) update) async {
  int n = numbers.length;
  bool swapped;
  do {
    swapped = false;
    for (int i = 0; i < n - 1; i++) {
      if (numbers[i] > numbers[i + 1]) {
        // Swap elements
        int temp = numbers[i];
        numbers[i] = numbers[i + 1];
        numbers[i + 1] = temp;
        swapped = true;
        update(numbers);
        // Delay for visualization
        await Future.delayed(Duration(milliseconds: delayMs));
      }
    }
    // Reduce the range of comparison for the next pass
    n--;
  } while (swapped);
}
