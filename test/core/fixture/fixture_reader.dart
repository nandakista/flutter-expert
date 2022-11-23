import 'dart:io';

String fixture(String name) => File('test/core/fixture/$name').readAsStringSync();