import 'package:dalm/features/auth/presentation/views/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('로그인 화면에 필요한 콘텐츠를 표시한다', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: LoginScreen(onTermsPressed: () {}, onPrivacyPressed: () {}),
      ),
    );

    expect(find.text('당신의 하루가\n나란해질 준비를 해요.'), findsOneWidget);
    expect(find.text('카카오로 계속하기'), findsOneWidget);
    expect(find.text('서비스 이용약관'), findsOneWidget);
    expect(find.text('개인정보 처리방침'), findsOneWidget);
    expect(find.text('DAY 1'), findsOneWidget);
    expect(find.text('DAY 7'), findsOneWidget);
  });

  testWidgets('서비스 이용약관을 누르면 링크 콜백을 호출한다', (tester) async {
    var wasPressed = false;

    await tester.pumpWidget(
      MaterialApp(
        home: LoginScreen(
          onTermsPressed: () {
            wasPressed = true;
          },
        ),
      ),
    );

    await tester.ensureVisible(find.text('서비스 이용약관'));
    await tester.tap(find.text('서비스 이용약관'));

    expect(wasPressed, isTrue);
  });

  testWidgets('개인정보 처리방침을 누르면 링크 콜백을 호출한다', (tester) async {
    var wasPressed = false;

    await tester.pumpWidget(
      MaterialApp(
        home: LoginScreen(
          onPrivacyPressed: () {
            wasPressed = true;
          },
        ),
      ),
    );

    await tester.ensureVisible(find.text('개인정보 처리방침'));
    await tester.tap(find.text('개인정보 처리방침'));

    expect(wasPressed, isTrue);
  });
}
