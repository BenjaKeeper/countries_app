import 'package:countries_app/features/countries/domain/entities/continent.dart';
import 'package:countries_app/features/countries/domain/entities/country.dart';
import 'package:countries_app/features/countries/domain/entities/language.dart';
import 'package:countries_app/features/countries/presentation/widgets/country_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CountryListItem Widget', () {
    const tCountry = Country(
      code: 'US',
      name: 'United States',
      emoji: '🇺🇸',
      capital: 'Washington D.C.',
      currency: 'USD',
      phone: '+1',
      continent: Continent(code: 'NA', name: 'North America'),
      languages: [
        Language(code: 'en', name: 'English'),
      ],
    );

    testWidgets('should display country name', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CountryListItem(
              country: tCountry,
              onTap: () {},
            ),
          ),
        ),
      );

      // Assert
      expect(find.text('United States'), findsOneWidget);
    });

    testWidgets('should display continent name', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CountryListItem(
              country: tCountry,
              onTap: () {},
            ),
          ),
        ),
      );

      // Assert
      expect(find.text('North America'), findsOneWidget);
    });

    testWidgets('should display country emoji', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CountryListItem(
              country: tCountry,
              onTap: () {},
            ),
          ),
        ),
      );

      // Assert
      expect(find.text('🇺🇸'), findsOneWidget);
    });

    testWidgets('should display capital if available',
        (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CountryListItem(
              country: tCountry,
              onTap: () {},
            ),
          ),
        ),
      );

      // Assert
      expect(find.text('Washington D.C.'), findsOneWidget);
    });

    testWidgets('should call onTap when tapped', (WidgetTester tester) async {
      // Arrange
      bool tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CountryListItem(
              country: tCountry,
              onTap: () {
                tapped = true;
              },
            ),
          ),
        ),
      );

      // Act
      await tester.tap(find.byType(InkWell));
      await tester.pump();

      // Assert
      expect(tapped, true);
    });

    testWidgets('should not display capital when it is null',
        (WidgetTester tester) async {
      // Arrange
      const countryWithoutCapital = Country(
        code: 'XX',
        name: 'Test Country',
        emoji: '🏳️',
        capital: null,
        currency: 'XXX',
        phone: '+0',
        continent: Continent(code: 'NA', name: 'North America'),
        languages: [],
      );

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CountryListItem(
              country: countryWithoutCapital,
              onTap: () {},
            ),
          ),
        ),
      );

      // Assert
      // Should not display capital icon when capital is null
      expect(find.byIcon(Icons.location_city), findsNothing);
    });
  });
}
