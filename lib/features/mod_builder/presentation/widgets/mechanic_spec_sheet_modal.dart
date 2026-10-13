import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ride_swg/core/theme/app_theme.dart';
import 'package:ride_swg/features/garage/data/car_model.dart';
import 'package:ride_swg/features/mod_builder/data/mod_options_data.dart';

class MechanicSpecSheetModal extends StatelessWidget {
  const MechanicSpecSheetModal({
    super.key,
    required this.car,
    required this.paint,
    required this.tintLevel,
    required this.bodyPackage,
    required this.modularParts,
    required this.wheelSetup,
    required this.exhaustSetup,
  });

  final CarModel car;
  final PaintColorOption paint;
  final double tintLevel;
  final BodyKitPackage bodyPackage;
  final Map<String, ModularBodyPart> modularParts;
  final WheelSetupOption wheelSetup;
  final ExhaustSetupOption exhaustSetup;

  double get totalPartsCost {
    double total = paint.price + bodyPackage.price + wheelSetup.price + exhaustSetup.price;
    for (final p in modularParts.values) {
      total += p.price;
    }
    return total;
  }

  double get totalLaborHours {
    double hours = paint.laborHours + bodyPackage.laborHours + wheelSetup.laborHours + exhaustSetup.laborHours;
    for (final p in modularParts.values) {
      hours += p.laborHours;
    }
    return hours;
  }

  double get estimatedLaborCost => totalLaborHours * 115.0; // Standard $115/hr shop rate

  String generatePlainTextSummary() {
    final buffer = StringBuffer();
    buffer.writeln('========================================');
    buffer.writeln('RIDESWG WORKSHOP BUILD SPECIFICATION');
    buffer.writeln('Target Vehicle: ${car.year} ${car.brand} ${car.name}');
    buffer.writeln('Chassis ID: ${car.id}');
    buffer.writeln('========================================\n');

    buffer.writeln('1. PAINT & FINISH:');
    buffer.writeln(' - Color: ${paint.name} (${paint.finishLabel})');
    buffer.writeln(' - Material: ${paint.filmType}');
    buffer.writeln(' - Ceramic Window Tint: ${tintLevel.round()}% VLT\n');

    buffer.writeln('2. AERO & BODY ARCHITECTURE:');
    buffer.writeln(' - Kit Package: ${bodyPackage.name} (${bodyPackage.manufacturer})');
    buffer.writeln(' - Dimensions: ${bodyPackage.measurements}');
    buffer.writeln(' - Chassis Requirements: ${bodyPackage.fitmentRequirements}');
    for (final entry in modularParts.entries) {
      if (entry.value.price > 0) {
        buffer.writeln(' - [${entry.key}] ${entry.value.name} (${entry.value.specs})');
        buffer.writeln('   Fitting Note: ${entry.value.mechanicRequirement}');
      }
    }
    buffer.writeln();

    buffer.writeln('3. WHEELS & STANCE FITMENT:');
    buffer.writeln(' - Model: ${wheelSetup.name} (${wheelSetup.brand})');
    buffer.writeln(' - Sizing: ${wheelSetup.size}');
    buffer.writeln(' - Bolt Pattern: ${wheelSetup.boltPattern}');
    buffer.writeln(' - Offsets: Front ${wheelSetup.offsetFront} / Rear ${wheelSetup.offsetRear}');
    buffer.writeln(' - Recommended Tires: ${wheelSetup.recommendedTires}');
    buffer.writeln(' - Workshop Note: ${wheelSetup.fitmentNote}\n');

    buffer.writeln('4. EXHAUST & POWERTRAIN:');
    buffer.writeln(' - System: ${exhaustSetup.name} (${exhaustSetup.brand})');
    buffer.writeln(' - Pipe Diameter: ${exhaustSetup.pipeDiameter} (${exhaustSetup.material})');
    buffer.writeln(' - Est. Sound: ${exhaustSetup.decibelRating} dB');
    buffer.writeln(' - Power Delta: +${exhaustSetup.hpGain} HP / -${exhaustSetup.weightReductionKg} kg');
    buffer.writeln(' - ECU Requirement: ${exhaustSetup.requirements}\n');

    buffer.writeln('ESTIMATED FINANCIALS:');
    buffer.writeln(' - Total Hardware/Parts: \$${totalPartsCost.toStringAsFixed(2)}');
    buffer.writeln(' - Estimated Shop Hours: ${totalLaborHours.toStringAsFixed(1)} hrs');
    buffer.writeln(' - Estimated Labor Cost: \$${estimatedLaborCost.toStringAsFixed(2)} (@\$115/hr)');
    buffer.writeln(' - Total Projected Build: \$${(totalPartsCost + estimatedLaborCost).toStringAsFixed(2)}');
    buffer.writeln('========================================');

    return buffer.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.88,
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Drag handle
          Container(
            margin: const EdgeInsets.only(top: 12, bottom: 8),
            width: 44,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.border,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'WORKSHOP SPEC SHEET',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close, color: AppColors.textSecondary),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),

          const Divider(color: AppColors.border, height: 1),

          // Scrollable Spec Content
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                // Vehicle Identification
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceElevated,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: AppColors.cardBg,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: const Icon(Icons.directions_car, color: AppColors.gold, size: 28),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              car.fullName,
                              style: AppTextStyles.headlineSmall.copyWith(fontSize: 17),
                            ),
                            Text(
                              'Target Spec: Stance & Track Aero • Chassis ${car.id}',
                              style: AppTextStyles.bodySmall.copyWith(color: AppColors.textMuted),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Section 1: Paint & Wrap
                _SpecSectionCard(
                  icon: Icons.format_paint,
                  title: 'PAINT, WRAP & TINTING',
                  items: [
                    _SpecRow(label: 'Colorway', value: paint.name),
                    _SpecRow(label: 'Finish Type', value: paint.finishLabel),
                    _SpecRow(label: 'Film Spec', value: paint.filmType),
                    _SpecRow(label: 'Window Tint', value: '${tintLevel.round()}% VLT Ceramic Film'),
                    _SpecRow(label: 'Install Hours', value: '~${paint.laborHours.toInt()} hrs'),
                  ],
                ),

                const SizedBox(height: 16),

                // Section 2: Aero & Body
                _SpecSectionCard(
                  icon: Icons.car_repair,
                  title: 'AERO & BODYWORK FITMENT',
                  items: [
                    _SpecRow(label: 'Main Package', value: bodyPackage.name),
                    _SpecRow(label: 'Body Geometry', value: bodyPackage.measurements),
                    _SpecRow(label: 'Downforce Gain', value: '+${bodyPackage.downforceKgAt160Kph} kg @ 160 km/h'),
                    _SpecRow(label: 'Workshop Requirement', value: bodyPackage.fitmentRequirements, isLong: true),
                    ...modularParts.entries.where((e) => e.value.price > 0).map((e) {
                      return _SpecRow(
                        label: e.key,
                        value: '${e.value.name}\n${e.value.mechanicRequirement}',
                        isLong: true,
                      );
                    }),
                  ],
                ),

                const SizedBox(height: 16),

                // Section 3: Wheels & Stance
                _SpecSectionCard(
                  icon: Icons.album,
                  title: 'WHEEL & TIRE GEOMETRY',
                  items: [
                    _SpecRow(label: 'Wheel Model', value: wheelSetup.name),
                    _SpecRow(label: 'Dimensions', value: wheelSetup.size),
                    _SpecRow(label: 'Bolt Pattern', value: wheelSetup.boltPattern),
                    _SpecRow(label: 'Offset (ET)', value: 'Front ${wheelSetup.offsetFront} / Rear ${wheelSetup.offsetRear}'),
                    _SpecRow(label: 'Target Tires', value: wheelSetup.recommendedTires),
                    _SpecRow(label: 'Hub Fitment Note', value: wheelSetup.fitmentNote, isLong: true),
                  ],
                ),

                const SizedBox(height: 16),

                // Section 4: Exhaust & Powertrain
                _SpecSectionCard(
                  icon: Icons.whatshot,
                  title: 'EXHAUST & POWERTRAIN SPECS',
                  items: [
                    _SpecRow(label: 'System', value: exhaustSetup.name),
                    _SpecRow(label: 'Pipe Diameter', value: exhaustSetup.pipeDiameter),
                    _SpecRow(label: 'Material', value: exhaustSetup.material),
                    _SpecRow(label: 'Sound Level', value: '${exhaustSetup.decibelRating} dB (${exhaustSetup.soundProfile})'),
                    _SpecRow(label: 'Performance Delta', value: '+${exhaustSetup.hpGain} HP / -${exhaustSetup.weightReductionKg} kg'),
                    _SpecRow(label: 'Software / ECU', value: exhaustSetup.requirements, isLong: true),
                  ],
                ),

                const SizedBox(height: 20),

                // Financial Summary Card
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceElevated,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: AppColors.gold.withValues(alpha: 0.5), width: 1),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('HARDWARE / PARTS TOTAL', style: AppTextStyles.bodyMedium),
                          Text(
                            '\$${totalPartsCost.toStringAsFixed(2)}',
                            style: AppTextStyles.labelLarge.copyWith(fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'EST. WORKSHOP LABOR (${totalLaborHours.toStringAsFixed(1)} hrs)',
                            style: AppTextStyles.bodyMedium,
                          ),
                          Text(
                            '\$${estimatedLaborCost.toStringAsFixed(2)}',
                            style: AppTextStyles.labelLarge.copyWith(fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                      const Divider(color: AppColors.border, height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'TOTAL ESTIMATED BUILD',
                            style: AppTextStyles.labelLarge.copyWith(
                              color: AppColors.gold,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1.2,
                            ),
                          ),
                          ShaderMask(
                            shaderCallback: (b) => AppColors.goldGradient.createShader(b),
                            child: Text(
                              '\$${(totalPartsCost + estimatedLaborCost).toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontFamily: 'Rajdhani',
                                fontSize: 24,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),

          // Bottom Actions
          Container(
            padding: EdgeInsets.fromLTRB(20, 16, 20, MediaQuery.of(context).padding.bottom + 16),
            decoration: const BoxDecoration(
              color: AppColors.surface,
              border: Border(top: BorderSide(color: AppColors.border, width: 0.5)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      final text = generatePlainTextSummary();
                      Clipboard.setData(ClipboardData(text: text));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('✅ Workshop Spec Sheet copied to clipboard! Ready to port to mechanic.'),
                        ),
                      );
                    },
                    icon: const Icon(Icons.copy, size: 18),
                    label: const Text('COPY TO MECHANIC'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SpecSectionCard extends StatelessWidget {
  const _SpecSectionCard({
    required this.icon,
    required this.title,
    required this.items,
  });

  final IconData icon;
  final String title;
  final List<_SpecRow> items;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border, width: 0.6),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: AppColors.primary),
              const SizedBox(width: 8),
              Text(
                title,
                style: AppTextStyles.labelSmall.copyWith(
                  letterSpacing: 1.2,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...items,
        ],
      ),
    );
  }
}

class _SpecRow extends StatelessWidget {
  const _SpecRow({
    required this.label,
    required this.value,
    this.isLong = false,
  });

  final String label;
  final String value;
  final bool isLong;

  @override
  Widget build(BuildContext context) {
    if (isLong) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textMuted, fontSize: 11)),
            const SizedBox(height: 2),
            Text(value, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary, fontSize: 12)),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textMuted, fontSize: 11)),
          Flexible(
            child: Text(
              value,
              style: AppTextStyles.labelMedium.copyWith(fontSize: 12),
              textAlign: TextAlign.end,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
