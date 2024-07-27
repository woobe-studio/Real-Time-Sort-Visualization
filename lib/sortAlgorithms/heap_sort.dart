import 'dart:async';

Future<void> heapify(List<int> numbers, int n, int i, int delayMs, Function(List<int>) update) async {
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
    // Swap numbers[i] and numbers[largest]
    int temp = numbers[i];
    numbers[i] = numbers[largest];
    numbers[largest] = temp;

    update(numbers);
    await Future.delayed(Duration(milliseconds: delayMs)); // Delay after swap

    // Recursively heapify the affected subtree
    await heapify(numbers, n, largest, delayMs, update);
  }
}

Future<void> heapSort(List<int> numbers, int delayMs, Function(List<int>) update) async {
  int n = numbers.length;

  // Build the max heap
  for (int i = n ~/ 2 - 1; i >= 0; i--) {
    await heapify(numbers, n, i, delayMs, update);
  }

  // Extract elements from the heap one by one
  for (int i = n - 1; i > 0; i--) {
    // Move current root to end
    int temp = numbers[0];
    numbers[0] = numbers[i];
    numbers[i] = temp;

    update(numbers);
    await Future.delayed(Duration(milliseconds: delayMs)); // Delay after swap

    // Call heapify on the reduced heap
    await heapify(numbers, i, 0, delayMs, update);
  }
}
