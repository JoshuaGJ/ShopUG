import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:manager/screens/note_list.dart';

void main() {
  testWidgets('NoteList screen builds without crashing', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: NoteList()));

    expect(find.text('Notes App'), findsOneWidget);
    expect(find.byType(FloatingActionButton), findsOneWidget);
  });
}
