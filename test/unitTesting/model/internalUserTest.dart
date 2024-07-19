import 'package:flutter_test/flutter_test.dart';
import 'package:flashcard/model/internal_user.dart';

void main() {
  group('InternalUser', () {
    test('fromJson should return a valid model', () {
      // Arrange
      final json = {
        'uid': '12345',
        'fetched': true,
        'name': 'John Doe',
      };

      // Act
      final internalUser = InternalUser.fromJson(json);

      // Assert
      expect(internalUser.uid, '12345');
      expect(internalUser.fetched, true);
      expect(internalUser.name, 'John Doe');
    });

    test('toJson should return a valid JSON map', () {
      // Arrange
      final internalUser = InternalUser(
        uid: '12345',
        fetched: true,
        name: 'John Doe',
      );

      // Act
      final json = internalUser.toJson();

      // Assert
      expect(json['uid'], '12345');
      expect(json['fetched'], true);
      expect(json['name'], 'John Doe');
    });
  });
}
