import 'package:flashcard/calendar_and_recap/settings/settingsWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:flashcard/ChatGPT_services/model-view/api_service.dart';
import 'package:flashcard/settings/settings_widget.dart';
import 'mocks.dart';  // Import the generated mocks file

void main() {
  late MockApiService mockApiService;
  late String initialApiKey;

  setUp(() {
    mockApiService = MockApiService();
    initialApiKey = 'initialApiKey';
    when(mockApiService.getApiKey(any)).thenReturn(initialApiKey);
  });

  Widget createSettingsWidget(Function(bool) onThemeChanged) {
    return MaterialApp(
      home: Scaffold(
        body: SettingsWidget(onThemeChanged: onThemeChanged),
      ),
    );
  }

  testWidgets('SettingsWidget displays correctly and interacts properly', (WidgetTester tester) async {
    bool isDarkMode = false;

    // Create the SettingsWidget
    await tester.pumpWidget(createSettingsWidget((bool value) {
      isDarkMode = value;
    }));

    // Verify initial state
    expect(find.text('Here there are some settings :'), findsOneWidget);
    expect(find.text('Dark Mode'), findsOneWidget);
    expect(find.text('initialApiKey'), findsOneWidget);

    // Toggle dark mode
    await tester.tap(find.byType(SwitchListTile));
    await tester.pumpAndSettle();

    // Verify dark mode toggle
    expect(isDarkMode, true);

    // Copy API key to clipboard
    await tester.tap(find.text('initialApiKey'));
    await tester.pumpAndSettle();

    // Verify snack bar
    expect(find.text('API key copied to clipboard'), findsOneWidget);

    // Open change API key dialog
    await tester.tap(find.text('Click here to change the API'));
    await tester.pumpAndSettle();
    expect(find.text('Change API Key'), findsOneWidget);

    // Enter new API key
    await tester.enterText(find.byType(TextField), 'newApiKey');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    // Verify new API key is set
    verify(mockApiService.setApiKey(any, 'newApiKey')).called(1);
    expect(find.text('newApiKey'), findsOneWidget);
  });
}

class MockApiService {
  void setApiKey(any, String input)
  {}

  getApiKey(any) {}
}
