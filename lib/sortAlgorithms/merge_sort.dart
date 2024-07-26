import 'dart:async';

Future<void> mergeSort(List<int> list, Function(List<int>) update, int delayMs) async {
  await _mergeSort(list, 0, list.length - 1, update, delayMs);
}

Future<void> _mergeSort(List<int> list, int left, int right, Function(List<int>) update, int delayMs) async {
  if (left < right) {
    int mid = (left + right) ~/ 2;
    await _mergeSort(list, left, mid, update, delayMs);
    await _mergeSort(list, mid + 1, right, update, delayMs);
    await _merge(list, left, mid, right, update, delayMs);
  }
}

Future<void> _merge(List<int> list, int left, int mid, int right, Function(List<int>) update, int delayMs) async {
  int n1 = mid - left + 1;
  int n2 = right - mid;
  List<int> leftList = List.generate(n1, (i) => list[left + i]);
  List<int> rightList = List.generate(n2, (i) => list[mid + 1 + i]);

  int i = 0, j = 0, k = left;
  while (i < n1 && j < n2) {
    if (leftList[i] <= rightList[j]) {
      list[k] = leftList[i];
      i++;
    } else {
      list[k] = rightList[j];
      j++;
    }
    k++;
    update(list);
    await Future.delayed(Duration(milliseconds: delayMs));
  }

  while (i < n1) {
    list[k] = leftList[i];
    i++;
    k++;
    update(list);
    await Future.delayed(Duration(milliseconds: delayMs));
  }

  while (j < n2) {
    list[k] = rightList[j];
    j++;
    k++;
    update(list);
    await Future.delayed(Duration(milliseconds: delayMs));
  }
}
