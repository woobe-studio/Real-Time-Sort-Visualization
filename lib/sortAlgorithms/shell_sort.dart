import 'dart:async';

// Shell Sort function
Future<void> shellSort(List<int> array, int delayMs, Function(List<int>) update) async {
  int n = array.length;

  // Start with a large gap, then reduce the gap
  for (int gap = n ~/ 2; gap > 0; gap ~/= 2) {
    // Do a gapped insertion sort for this gap size.
    for (int i = gap; i < n; i++) {
      int temp = array[i];

      // Shift earlier gap-sorted elements up until the correct location for array[i] is found
      int j;
      for (j = i; j >= gap && array[j - gap] > temp; j -= gap) {
        array[j] = array[j - gap];
        update(List<int>.from(array)); // Update the array state
        await Future.delayed(Duration(milliseconds: delayMs));
      }

      // Put temp (the original array[i]) in its correct location
      array[j] = temp;
      update(List<int>.from(array)); // Update the array state
      await Future.delayed(Duration(milliseconds: delayMs));
    }
  }
}
