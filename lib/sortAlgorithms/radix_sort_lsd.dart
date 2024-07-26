import 'dart:async';

Future<void> radixSort(List<int> numbers, int delayMs, Function(List<int>) update) async {
  if (numbers.isEmpty) return;

  int max = numbers.reduce((a, b) => a > b ? a : b);
  int exp = 1;

  while (max ~/ exp > 0) {
    await countingSort(numbers, exp, delayMs, update);
    exp *= 10;
  }
}

Future<void> countingSort(List<int> numbers, int exp, int delayMs, Function(List<int>) update) async {
  int n = numbers.length;
  List<int> output = List.filled(n, 0);
  List<int> count = List.filled(10, 0);

  for (int i = 0; i < n; i++) {
    int digit = (numbers[i] ~/ exp) % 10;
    count[digit]++;
  }

  for (int i = 1; i < 10; i++) {
    count[i] += count[i - 1];
  }

  for (int i = n - 1; i >= 0; i--) {
    int digit = (numbers[i] ~/ exp) % 10;
    output[count[digit] - 1] = numbers[i];
    count[digit]--;
  }

  for (int i = 0; i < n; i++) {
    numbers[i] = output[i];
    update(numbers);
    await Future.delayed(Duration(milliseconds: delayMs));
  }
}
