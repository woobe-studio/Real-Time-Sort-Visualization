import 'dart:async';

// Main function to perform Merge Sort
Future<void> lazyStableSort(List<int> numbers, int delayMs, Function(List<int>) update) async {
  if (numbers.length <= 1) return;

  // Start the merge sort process
  await _mergeSort(numbers, 0, numbers.length - 1, delayMs, update);
}

// Recursive merge sort function
Future<void> _mergeSort(List<int> numbers, int left, int right, int delayMs, Function(List<int>) update) async {
  if (left < right) {
    int mid = (left + right) ~/ 2;

    // Sort the first and second halves
    await _mergeSort(numbers, left, mid, delayMs, update);
    await _mergeSort(numbers, mid + 1, right, delayMs, update);

    // Apply delay after sorting the halves
    await Future.delayed(Duration(milliseconds: delayMs));

    // Merge the sorted halves
    await merge(numbers, left, mid, right, delayMs, update);

    // Apply delay after merging
    await Future.delayed(Duration(milliseconds: delayMs));
  }
}

// Merge function
Future<void> merge(List<int> numbers, int left, int mid, int right, int delayMs, Function(List<int>) update) async {
  // Create temporary arrays
  List<int> leftArray = numbers.sublist(left, mid + 1);
  List<int> rightArray = numbers.sublist(mid + 1, right + 1);

  int i = 0, j = 0, k = left;

  // Merge the two arrays
  while (i < leftArray.length && j < rightArray.length) {
    if (leftArray[i] <= rightArray[j]) {
      numbers[k++] = leftArray[i++];
    } else {
      numbers[k++] = rightArray[j++];
    }
    // Update and apply delay for each merge step
    update(numbers);
    await Future.delayed(Duration(milliseconds: delayMs));
  }

  // Copy remaining elements
  while (i < leftArray.length) {
    numbers[k++] = leftArray[i++];
    // Update and apply delay for each copy step
    update(numbers);
    await Future.delayed(Duration(milliseconds: delayMs));
  }
  while (j < rightArray.length) {
    numbers[k++] = rightArray[j++];
    // Update and apply delay for each copy step
    update(numbers);
    await Future.delayed(Duration(milliseconds: delayMs));
  }
}
