import 'dart:async';

Future<void> heapify(List<int> numbers, int n, int i, Function(List<int>) update) async {
  int largest = i;
  int left = 2 * i + 1;
  int right = 2 * i + 2;

  if (left < n && numbers[left] > numbers[largest]) {
    largest = left;
  }

  if (right < n && numbers[right] > numbers[largest]) {
    largest = right;
  }

  if (largest != i) {
    int temp = numbers[i];
    numbers[i] = numbers[largest];
    numbers[largest] = temp;

    update(numbers);
    await Future.delayed(Duration(milliseconds: 100));

    await heapify(numbers, n, largest, update);
  }
}

Future<void> heapSort(List<int> numbers, int delayMs, Function(List<int>) update) async {
  int n = numbers.length;

  for (int i = n ~/ 2 - 1; i >= 0; i--) {
    await heapify(numbers, n, i, update);
  }

  for (int i = n - 1; i > 0; i--) {
    int temp = numbers[0];
    numbers[0] = numbers[i];
    numbers[i] = temp;

    update(numbers);
    await Future.delayed(Duration(milliseconds: delayMs));

    await heapify(numbers, i, 0, update);
  }
}
