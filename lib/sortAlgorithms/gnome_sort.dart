import 'dart:async';

Future<void> gnomeSort(List<int> list, int delayMs, Function(List<int>) onUpdate) async {
  int index = 0;
  while (index < list.length) {
    if (index == 0 || list[index] >= list[index - 1]) {
      index++;
    } else {
      final temp = list[index];
      list[index] = list[index - 1];
      list[index - 1] = temp;
      index--;
      onUpdate(list); // Update the UI with the current state
      await Future.delayed(Duration(milliseconds: delayMs));
    }
  }
}
