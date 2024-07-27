import 'dart:async';

Future<void> quickSort(List<int> numbers, int low, int high, int delayMs, Function(List<int>) update) async {
  if (low < high) {
    int pi = await partition(numbers, low, high, delayMs, update);
    await quickSort(numbers, low, pi - 1, delayMs, update);
    await quickSort(numbers, pi + 1, high, delayMs, update);
  }
}

Future<int> partition(List<int> numbers, int low, int high, int delayMs, Function(List<int>) update) async {
  int pivot = numbers[high];
  int i = low - 1;

  for (int j = low; j < high; j++) {
    await Future.delayed(Duration(milliseconds: delayMs));
    if (numbers[j] < pivot) {
      i++;
      int temp = numbers[i];
      numbers[i] = numbers[j];
      numbers[j] = temp;
      update(numbers);
    }
  }

  int temp = numbers[i + 1];
  numbers[i + 1] = numbers[high];
  numbers[high] = temp;
  update(numbers);
  await Future.delayed(Duration(milliseconds: delayMs));

  return i + 1;
}
