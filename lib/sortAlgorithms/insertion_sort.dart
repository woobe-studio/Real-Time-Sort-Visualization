import 'dart:async';

Future<void> insertionSort(List<int> numbers, int delayMs, Function(List<int>) update) async {
  for (int i = 1; i < numbers.length; i++) {
    int key = numbers[i];
    int j = i - 1;
    while (j >= 0 && numbers[j] > key) {
      numbers[j + 1] = numbers[j];
      j--;
      update(numbers);
      await Future.delayed(Duration(milliseconds: delayMs));
    }
    numbers[j + 1] = key;
    update(numbers);
    await Future.delayed(Duration(milliseconds: delayMs));
  }
}
