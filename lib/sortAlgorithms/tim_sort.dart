import 'dart:async';

Future<void> timSort(List<int> numbers, int delayMs, Function(List<int>) update) async {
  final minRun = 32; // Typical value for Tim Sort
  int n = numbers.length;

  // Sort small chunks using insertion sort
  for (int i = 0; i < n; i += minRun) {
    await Future.delayed(Duration(milliseconds: delayMs));
    int end = (i + minRun < n) ? i + minRun - 1 : n - 1;
    await _insertionSort(numbers, i, end, delayMs, update);
  }

  // Merge sorted chunks
  int size = minRun;
  while (size < n) {
    await Future.delayed(Duration(milliseconds: delayMs));
    for (int left = 0; left < n; left += 2 * size) {
      int mid = left + size - 1;
      int right = (left + 2 * size - 1 < n) ? left + 2 * size - 1 : n - 1;
      if (mid < right) {
        await _merge(numbers, left, mid, right, delayMs, update);
      }
    }
    size *= 2;
  }
}

Future<void> _insertionSort(List<int> numbers, int left, int right, int delayMs, Function(List<int>) update) async {
  for (int i = left + 1; i <= right; i++) {
    await Future.delayed(Duration(milliseconds: delayMs));
    int key = numbers[i];
    int j = i - 1;
    while (j >= left && numbers[j] > key) {
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

Future<void> _merge(List<int> numbers, int left, int mid, int right, int delayMs, Function(List<int>) update) async {
  int n1 = mid - left + 1;
  int n2 = right - mid;

  // Create temporary arrays
  List<int> leftArray = List.generate(n1, (i) => numbers[left + i]);
  List<int> rightArray = List.generate(n2, (i) => numbers[mid + 1 + i]);

  int i = 0, j = 0, k = left;
  while (i < n1 && j < n2) {
    await Future.delayed(Duration(milliseconds: delayMs));
    if (leftArray[i] <= rightArray[j]) {
      numbers[k++] = leftArray[i++];
    } else {
      numbers[k++] = rightArray[j++];
    }
  }

  while (i < n1) {
    await Future.delayed(Duration(milliseconds: delayMs));
    numbers[k++] = leftArray[i++];
  }
  while (j < n2) {
    await Future.delayed(Duration(milliseconds: delayMs));
    numbers[k++] = rightArray[j++];
  }

  update(numbers);
  await Future.delayed(Duration(milliseconds: delayMs));
}
