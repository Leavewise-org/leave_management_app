import 'dart:mirrors';
import 'package:file_picker/file_picker.dart';

void main() {
  ClassMirror cm = reflectClass(FilePicker);
  for (var m in cm.declarations.values) {
    print(m.simpleName);
  }
}
