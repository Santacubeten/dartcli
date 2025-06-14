warningMsg(String variable, line, type) {
  print(" ");
  print("###############");
  print("⚠️ WARNING ⚠️");
  print("###############");
  print(" ");
  print("Type : $type");
  print("endpoint : $line");
  print(" ");
  print("❌ Failed to add $variable variable name! already in used");
  print(" ");
}

success(String line) {
  print(" ");
  print("###############");
  print("✔️ SUCCESS ✔️");
  print("###############");
  print("✔️ $line");
  print(" ");
}

printf(String string) {
  print(" ");
  print(string);
  print(" ");
}
