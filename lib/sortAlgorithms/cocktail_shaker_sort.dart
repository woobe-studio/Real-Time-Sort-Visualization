import 'dart:async';

Future<void> cocktailShakerSort(List<int> list, int delayMs, Function(List<int>) onUpdate) async {
  bool swapped = true;
  int start = 0;
  int end = list.length - 1;

  while (swapped) {
    swapped = false;

    // Forward pass
    for (int i = start; i < end; i++) {
      if (list[i] > list[i + 1]) {
        final temp = list[i];
        list[i] = list[i + 1];
        list[i + 1] = temp;
        swapped = true;
        onUpdate(list); // Update the UI with the current state
        await Future.delayed(Duration(milliseconds: delayMs));
      }
    }

    if (!swapped) break;

    swapped = false;
    end--;

    // Backward pass
    for (int i = end; i >= start; i--) {
      if (list[i] > list[i + 1]) {
        final temp = list[i];
        list[i] = list[i + 1];
        list[i + 1] = temp;
        swapped = true;
        onUpdate(list); // Update the UI with the current state
        await Future.delayed(Duration(milliseconds: delayMs));
      }
    }
    start++;
  }
}
