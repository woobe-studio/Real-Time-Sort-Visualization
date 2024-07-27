import 'dart:async';

Future<void> selectionSort(List<int> numbers, int delayMs, Function(List<int>) update) async {
  for (int i = 0; i < numbers.length - 1; i++) {
    int minIndex = i;
    for (int j = i + 1; j < numbers.length; j++) {
      if (numbers[j] < numbers[minIndex]) {
        minIndex = j;
      }
      // Delay for visualization
      await Future.delayed(Duration(milliseconds: delayMs));
    }
    if (minIndex != i) {
      int temp = numbers[i];
      numbers[i] = numbers[minIndex];
      numbers[minIndex] = temp;
      update(numbers);
      await Future.delayed(Duration(milliseconds: delayMs));
    }
  }
}
