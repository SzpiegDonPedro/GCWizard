import 'dart:io' as io;

import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/images_and_files/stegano/logic/stegano.dart';
import 'package:gc_wizard/utils/file_utils/gcw_file.dart';
import 'package:gc_wizard/utils/list_utils.dart';
import 'package:path/path.dart' as path;

var testDirPath = 'test/tools/images_and_files/stegano/resources/';

GCWFile _getFileData(String name) {
  io.File file = io.File(path.join(testDirPath, name));
  return GCWFile(bytes: file.readAsBytesSync());
}

void main() {

  group("stegano.decodeStegano:", () {

    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : 'test1.png', 'key': '', 'expectedOutput': 'Exception: abnormal_length_nothing_to_decode'},
      {'input' : 'test2result.png', 'key': '', 'expectedOutput': 'test message'},
      {'input' : 'test3result.png', 'key': 'test', 'expectedOutput': 'test message'},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']} key: ${elem['key']}', () async {
        String? _outData;
        try {
            _outData = await decodeStegano(_getFileData(elem['input'] as String), elem['key'] as String);
        } catch (e) {
          _outData = e.toString();
        }

        expect(_outData, elem['expectedOutput']);
      });
    }
  });

  group("stegano.encodeStegano:", () {

    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : 'test1.png', 'message': '', 'key': '', 'expectedOutput': 'test1result.png'},
      {'input' : 'test1.png', 'message': 'test message', 'key': '', 'expectedOutput': 'test2result.png'},
      {'input' : 'test1.png', 'message': 'test message', 'key': 'test', 'expectedOutput': 'test3result.png'}
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']} message: ${elem['message']} key: ${elem['key']}', () async {
        var _outData = await encodeStegano(_getFileData(elem['input'] as String), elem['message'] as String, elem['key'] as String, null);
        expect(uint8ListEquals(_outData!, _getFileData(elem['expectedOutput'] as String).bytes), true);
      });
    }
  });

}