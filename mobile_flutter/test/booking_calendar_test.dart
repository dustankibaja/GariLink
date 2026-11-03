import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:garilink_mobile/features/booking/presentation/pages/booking_page.dart';
import 'package:intl/intl.dart';
import 'booking_request_experience_test.dart' as booking_fixture;

Finder _day(String day) =>
    find.descendant(of: find.byType(GridView), matching: find.text(day));

Future<void> _tapVisible(WidgetTester tester, Finder finder) async {
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

void main() {
  test('rental day count uses whole calendar days across months', () {
    expect(rentalDayCount(DateTime(2026, 11, 28), DateTime(2026, 12, 3)), 5);
    expect(rentalDayCount(DateTime(2026, 12, 30), DateTime(2027, 1, 2)), 3);
    expect(rentalDayCount(DateTime(2027, 2, 27), DateTime(2027, 3, 1)), 2);
  });

  testWidgets('calendar opens on the current month', (tester) async {
    await booking_fixture.render(tester);
    final now = DateTime.now();
    final month = DateFormat('MMMM yyyy').format(DateTime(now.year, now.month));
    expect(find.text(month), findsOneWidget);
  });

  testWidgets('a rental range can span two months', (tester) async {
    await booking_fixture.render(tester);
    final now = DateTime.now();
    final pickup = DateTime(now.year, now.month + 1, 28);
    final dropOff = DateTime(now.year, now.month + 2, 3);

    await _tapVisible(tester, find.byKey(const Key('calendar-next-month')));
    await _tapVisible(tester, _day('28'));
    await _tapVisible(tester, find.byKey(const Key('calendar-next-month')));
    await _tapVisible(tester, _day('3'));

    final days = rentalDayCount(pickup, dropOff);
    expect(find.text('$days rental days'), findsOneWidget);
    expect(
      find.textContaining(
        '${DateFormat('d MMM y').format(pickup)} – '
        '${DateFormat('d MMM y').format(dropOff)}',
      ),
      findsOneWidget,
    );
  });

  testWidgets('changing month keeps an existing selection', (tester) async {
    await booking_fixture.render(tester);
    await _tapVisible(tester, find.byKey(const Key('calendar-next-month')));
    await _tapVisible(tester, _day('10'));
    await _tapVisible(tester, _day('12'));
    expect(find.text('2 rental days'), findsOneWidget);
    await _tapVisible(tester, find.byKey(const Key('calendar-next-month')));
    await _tapVisible(tester, find.byKey(const Key('calendar-previous-month')));
    expect(find.text('2 rental days'), findsOneWidget);
  });
}
