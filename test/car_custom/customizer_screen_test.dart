import 'package:flutter_test/flutter_test.dart';
import 'package:ride_swg/features/mod_builder/data/mod_options_data.dart';

void main() {
  group('PaintColorOption', () {
    test('curatedColors list is populated', () {
      expect(PaintColorOption.curatedColors.isNotEmpty, isTrue);
    });

    test('each paint option has a non-zero price or is stock', () {
      for (final paint in PaintColorOption.curatedColors) {
        expect(paint.name.isNotEmpty, isTrue);
        expect(paint.price, greaterThan(0));
        expect(paint.laborHours, greaterThan(0));
        expect(paint.filmType.isNotEmpty, isTrue);
      }
    });

    test('finishes cover expected variety', () {
      final finishes =
          PaintColorOption.curatedColors.map((p) => p.finish).toSet();
      expect(finishes, contains(PaintFinish.gloss));
      expect(finishes, contains(PaintFinish.matte));
      expect(finishes, contains(PaintFinish.satin));
    });
  });

  group('BodyKitPackage', () {
    test('packages list includes stock option', () {
      final stock = BodyKitPackage.packages.where((p) => p.id == 'stock');
      expect(stock.length, equals(1));
      expect(stock.first.price, equals(0));
      expect(stock.first.widthIncreaseMm, equals(0));
    });

    test('aftermarket kits have positive price and labor', () {
      final aftermarket =
          BodyKitPackage.packages.where((p) => p.id != 'stock');
      for (final kit in aftermarket) {
        expect(kit.price, greaterThan(0),
            reason: '${kit.name} should have a price');
        expect(kit.laborHours, greaterThan(0),
            reason: '${kit.name} should require labor');
        expect(kit.material.isNotEmpty, isTrue);
        expect(kit.fitmentRequirements.isNotEmpty, isTrue);
      }
    });
  });

  group('ModularBodyPart', () {
    test('all expected slots are represented', () {
      final slots = ModularBodyPart.allParts.map((p) => p.slot).toSet();
      expect(slots, containsAll([
        'Front Splitter',
        'Side Skirts',
        'Rear Diffuser',
        'Hood',
        'Spoiler',
      ]));
    });

    test('stock parts are free', () {
      final stockParts =
          ModularBodyPart.allParts.where((p) => p.id.contains('stock'));
      for (final part in stockParts) {
        expect(part.price, equals(0),
            reason: '${part.name} stock part should be free');
        expect(part.laborHours, equals(0));
      }
    });

    test('aftermarket parts have material and specs', () {
      final mods = ModularBodyPart.allParts
          .where((p) => !p.id.contains('stock') && p.id != 'spoiler_none');
      for (final mod in mods) {
        expect(mod.material.isNotEmpty, isTrue,
            reason: '${mod.name} needs material info');
        expect(mod.specs.isNotEmpty, isTrue,
            reason: '${mod.name} needs specs');
        expect(mod.mechanicRequirement.isNotEmpty, isTrue,
            reason: '${mod.name} needs mechanic requirements');
      }
    });
  });

  group('WheelSetupOption', () {
    test('wheels list is populated with stock option', () {
      final stock = WheelSetupOption.wheels.where((w) => w.id == 'wheels_stock');
      expect(stock.length, equals(1));
      expect(stock.first.price, equals(0));
    });

    test('all wheels have bolt pattern and tire recommendations', () {
      for (final wheel in WheelSetupOption.wheels) {
        expect(wheel.boltPattern.isNotEmpty, isTrue,
            reason: '${wheel.name} needs bolt pattern');
        expect(wheel.recommendedTires.isNotEmpty, isTrue,
            reason: '${wheel.name} needs tire recommendation');
      }
    });
  });

  group('ExhaustSetupOption', () {
    test('exhausts list includes stock option', () {
      final stock =
          ExhaustSetupOption.exhausts.where((e) => e.id == 'exhaust_stock');
      expect(stock.length, equals(1));
      expect(stock.first.hpGain, equals(0));
    });

    test('aftermarket exhausts provide hp gain and weight reduction', () {
      final aftermarket =
          ExhaustSetupOption.exhausts.where((e) => e.id != 'exhaust_stock');
      for (final exhaust in aftermarket) {
        expect(exhaust.hpGain, greaterThan(0),
            reason: '${exhaust.name} should provide HP gain');
        expect(exhaust.weightReductionKg, greaterThan(0),
            reason: '${exhaust.name} should reduce weight');
        expect(exhaust.price, greaterThan(0));
      }
    });

    test('decibel ratings increase with performance', () {
      final stock = ExhaustSetupOption.exhausts
          .firstWhere((e) => e.id == 'exhaust_stock');
      final aftermarket =
          ExhaustSetupOption.exhausts.where((e) => e.id != 'exhaust_stock');
      for (final exhaust in aftermarket) {
        expect(exhaust.decibelRating, greaterThan(stock.decibelRating),
            reason:
                '${exhaust.name} should be louder than stock');
      }
    });
  });
}
