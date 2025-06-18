import 'dart:io';

String promptForInput(String message) {
  stdout.write(message);
  return stdin.readLineSync()?.trim() ?? '';
}
