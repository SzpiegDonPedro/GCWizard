import 'dart:io' as io;
import 'dart:typed_data';

import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/images_and_files/animated_image/logic/animated_image.dart';
import 'package:gc_wizard/utils/list_utils.dart';
import 'package:path/path.dart' as path;

var testDirPath = 'test/tools/images_and_files/animated_image_morse_code/resources/';

Uint8List _getFileData(String name) {
  io.File file = io.File(path.join(testDirPath, name));
  return file.readAsBytesSync();
}

void main() {

  group("animated_image.analyseImage:", () {

    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : 'Der kleine Preuße.gif', 'expectedOutputLength': 313},
      {'input' : 'LEUCHTTURM.gif', 'expectedOutputLength': 189},
      {'input' : 'bibliothek.gif', 'expectedOutputLength': 63},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}', () async {
        var _outData = await analyseImage(_getFileData(elem['input'] as String));

        expect(_outData?.images.length, elem['expectedOutputLength']);
      });
    }
  });

  group("animated_image.checkImage:", () {

    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : 'LEUCHTTURM.gif', 'index': 1, 'expectedOutput': 'Leuchtturm2.gif'},
      {'input' : 'LEUCHTTURM.gif', 'index': 2, 'expectedOutput': 'Leuchtturm3.gif'},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']} index: ${elem['index']}', () async {
        var _outData = await analyseImage(_getFileData(elem['input'] as String));

        expect(uint8ListEquals(_outData!.images[elem['index']! as int], _getFileData(elem['expectedOutput'] as String)), true);
      });
    }
  });

}