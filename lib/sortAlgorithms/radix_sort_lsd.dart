import 'dart:async';

// Main function to perform Radix Sort
Future<void> radixSort(List<int> numbers, int delayMs, Function(List<int>) update) async {
  if (numbers.isEmpty) return;

  // Find the maximum number to determine the number of digits
  int max = numbers.reduce((a, b) => a > b ? a : b);
  int exp = 1; // Exponent for the digit place
  int base = 10; // Base for decimal system (0-9)

  // Process each digit
  while (max ~/ exp > 0) {
    await _countingSort(numbers, exp, base, delayMs, update);
    exp *= base;
  }
}

// Counting Sort for Radix Sort
Future<void> _countingSort(List<int> numbers, int exp, int base, int delayMs, Function(List<int>) update) async {
  int n = numbers.length;
  List<int> output = List.filled(n, 0);
  List<int> count = List.filled(base, 0);

  // Store count of occurrences in count[]
  for (int i = 0; i < n; i++) {
    int index = (numbers[i] ~/ exp) % base;
    count[index]++;
  }

  // Change count[i] so that count[i] contains the actual position of this digit in output[]
  for (int i = 1; i < base; i++) {
    count[i] += count[i - 1];
  }

  // Build the output array
  for (int i = n - 1; i >= 0; i--) {
    int index = (numbers[i] ~/ exp) % base;
    output[count[index] - 1] = numbers[i];
    count[index]--;
  }

  // Copy the output array to numbers[]
  for (int i = 0; i < n; i++) {
    numbers[i] = output[i];
    update(numbers);
    await Future.delayed(Duration(milliseconds: delayMs));
  }
}
