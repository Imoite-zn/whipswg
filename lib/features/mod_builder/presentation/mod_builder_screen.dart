import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:ride_swg/core/theme/app_theme.dart';
import 'package:ride_swg/features/garage/data/car_model.dart';
import 'package:ride_swg/features/mod_builder/data/mod_options_data.dart';
import 'package:ride_swg/features/mod_builder/presentation/widgets/body_parts_selector.dart';
import 'package:ride_swg/features/mod_builder/presentation/widgets/mechanic_spec_sheet_modal.dart';
import 'package:ride_swg/features/mod_builder/presentation/widgets/paint_wrap_selector.dart';

class ModBuilderScreen extends StatefulWidget {
  const ModBuilderScreen({super.key, this.car});

  final CarModel? car;

  @override
  State<ModBuilderScreen> createState() => _ModBuilderScreenState();
}

class _ModBuilderScreenState extends State<ModBuilderScreen>
    with SingleTickerProviderStateMixin {
  late final CarModel _car;
  late TabController _tabCtrl;

  // ─── Active Customization State ───────────────────────────────────────────
  PaintColorOption _selectedPaint = PaintColorOption.curatedColors.first;
  double _tintLevel = 20.0;

  BodyKitPackage _selectedBodyPackage = BodyKitPackage.packages[1]; // default to widebody
  final Map<String, ModularBodyPart> _selectedModularParts = {
    'Front Splitter': ModularBodyPart.allParts[1],
    'Side Skirts': ModularBodyPart.allParts[4],
    'Rear Diffuser': ModularBodyPart.allParts[6],
    'Hood': ModularBodyPart.allParts[8],
    'Spoiler': ModularBodyPart.allParts[11],
  };

  WheelSetupOption _selectedWheel = WheelSetupOption.wheels[1]; // TE37
  ExhaustSetupOption _selectedExhaust = ExhaustSetupOption.exhausts[1]; // Akrapovic

  String _cameraOrbit = '45deg 75deg 105%';
  int _activeCameraIndex = 0;

  final _cameraAngles = [
    {'label': '3/4 FRONT', 'orbit': '45deg 75deg 105%'},
    {'label': 'PROFILE', 'orbit': '90deg 85deg 100%'},
    {'label': 'REAR AERO', 'orbit': '180deg 75deg 105%'},
    {'label': 'TOP DOWN', 'orbit': '0deg 20deg 115%'},
  ];

  // Estimated Performance Deltas
  int get _addedHP => _selectedExhaust.hpGain + (_selectedBodyPackage.id == 'gt3_track' ? 10 : 0);

  int get _addedDownforce => _selectedBodyPackage.downforceKgAt160Kph + (_selectedModularParts['Spoiler']?.price ?? 0) > 0 ? 45 : 0;

  double get _weightDeltaKg =>
      - (_selectedExhaust.weightReductionKg)
      - ((_selectedWheel.weightPerWheelKg - 13.8) * 4)
      + (_selectedBodyPackage.widthIncreaseMm > 0 ? 12.0 : 0.0);

  double get _totalBuildPrice {
    double total = _selectedPaint.price + _selectedBodyPackage.price + _selectedWheel.price + _selectedExhaust.price;
    for (final p in _selectedModularParts.values) {
      total += p.price;
    }
    return total;
  }

  @override
  void initState() {
    super.initState();
    _car = widget.car ?? CarModel.demo.first;
    _tabCtrl = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    super.dispose();
  }

  void _openMechanicSpecSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => MechanicSpecSheetModal(
        car: _car,
        paint: _selectedPaint,
        tintLevel: _tintLevel,
        bodyPackage: _selectedBodyPackage,
        modularParts: _selectedModularParts,
        wheelSetup: _selectedWheel,
        exhaustSetup: _selectedExhaust,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // ─── Top Bar ──────────────────────────────────────────
          _TopBar(
            car: _car,
            onPortToMechanic: _openMechanicSpecSheet,
          ),

          // ─── 3D Model Viewer Panel ────────────────────────────
          _ModelViewerPanel(
            car: _car,
            paintOption: _selectedPaint,
            tintLevel: _tintLevel,
            cameraOrbit: _cameraOrbit,
            activeCameraIndex: _activeCameraIndex,
            cameraAngles: _cameraAngles,
            onSelectCamera: (index, orbit) {
              setState(() {
                _activeCameraIndex = index;
                _cameraOrbit = orbit;
              });
            },
          ),

          // ─── Dynamic Engineering Stats Row ────────────────────
          _EngineeringStatsRow(
            car: _car,
            addedHP: _addedHP,
            addedDownforce: _addedDownforce,
            weightDeltaKg: _weightDeltaKg,
          ),

          // ─── Tabs & Customization Panels ──────────────────────
          Expanded(
            child: Column(
              children: [
                // Tab Bar
                Container(
                  color: AppColors.surface,
                  child: TabBar(
                    controller: _tabCtrl,
                    isScrollable: true,
                    tabAlignment: TabAlignment.start,
                    labelColor: AppColors.primary,
                    unselectedLabelColor: AppColors.textMuted,
                    indicatorColor: AppColors.primary,
                    indicatorSize: TabBarIndicatorSize.tab,
                    labelStyle: AppTextStyles.labelMedium.copyWith(
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.1,
                      fontSize: 11,
                    ),
                    tabs: const [
                      Tab(text: 'PAINT & WRAP'),
                      Tab(text: 'BODY & AERO'),
                      Tab(text: 'WHEELS & STANCE'),
                      Tab(text: 'EXHAUST'),
                    ],
                  ),
                ),

                // Tab Content
                Expanded(
                  child: TabBarView(
                    controller: _tabCtrl,
                    children: [
                      // Tab 1: Paint & Wrap
                      PaintWrapSelector(
                        selectedPaint: _selectedPaint,
                        onSelectPaint: (p) => setState(() => _selectedPaint = p),
                        tintLevel: _tintLevel,
                        onTintChanged: (t) => setState(() => _tintLevel = t),
                      ),

                      // Tab 2: Body & Aero
                      BodyPartsSelector(
                        selectedPackage: _selectedBodyPackage,
                        onSelectPackage: (pkg) => setState(() => _selectedBodyPackage = pkg),
                        selectedParts: _selectedModularParts,
                        onTogglePart: (slot, part) => setState(() => _selectedModularParts[slot] = part),
                      ),

                      // Tab 3: Wheels & Stance
                      _WheelsPanel(
                        selectedWheel: _selectedWheel,
                        onSelectWheel: (w) => setState(() => _selectedWheel = w),
                      ),

                      // Tab 4: Exhaust
                      _ExhaustPanel(
                        selectedExhaust: _selectedExhaust,
                        onSelectExhaust: (e) => setState(() => _selectedExhaust = e),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ─── Bottom Actions Bar ───────────────────────────────
          _BottomActionBar(
            totalPrice: _totalBuildPrice,
            onPortToMechanic: _openMechanicSpecSheet,
            onSave: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('✅ Custom ${_car.fullName} build saved to your garage!'),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

// ─── Top Bar ─────────────────────────────────────────────────────────────────

class _TopBar extends StatelessWidget {
  const _TopBar({required this.car, required this.onPortToMechanic});

  final CarModel car;
  final VoidCallback onPortToMechanic;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 8,
        bottom: 10,
        left: 12,
        right: 16,
      ),
      color: AppColors.background,
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: AppColors.surfaceElevated,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.border),
              ),
              child: const Icon(
                Icons.arrow_back_ios_new,
                size: 16,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(car.brand, style: AppTextStyles.bodySmall.copyWith(fontSize: 11)),
                Text(
                  car.fullName,
                  style: AppTextStyles.headlineSmall.copyWith(fontSize: 16),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          // Port to mechanic pill button
          OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              side: const BorderSide(color: AppColors.gold, width: 1),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: onPortToMechanic,
            icon: const Icon(Icons.handyman, size: 14, color: AppColors.gold),
            label: const Text(
              'SPEC SHEET',
              style: TextStyle(
                color: AppColors.gold,
                fontSize: 10,
                fontWeight: FontWeight.w800,
                letterSpacing: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── 3D Model Viewer Panel with Custom Lighting & Orbit Controls ─────────────

class _ModelViewerPanel extends StatelessWidget {
  const _ModelViewerPanel({
    required this.car,
    required this.paintOption,
    required this.tintLevel,
    required this.cameraOrbit,
    required this.activeCameraIndex,
    required this.cameraAngles,
    required this.onSelectCamera,
  });

  final CarModel car;
  final PaintColorOption paintOption;
  final double tintLevel;
  final String cameraOrbit;
  final int activeCameraIndex;
  final List<Map<String, String>> cameraAngles;
  final void Function(int index, String orbit) onSelectCamera;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: paintOption.color.withValues(alpha: 0.4),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: paintOption.color.withValues(alpha: 0.25),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      clipBehavior: Clip.hardEdge,
      child: Stack(
        children: [
          // Dynamic ambient gradient tailored to selected car color
          Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                colors: [
                  paintOption.color.withValues(alpha: 0.18),
                  AppColors.surfaceElevated,
                  AppColors.background,
                ],
                radius: 1.1,
              ),
            ),
          ),

          // Ground reflection grid
          Positioned.fill(
            child: CustomPaint(
              painter: _StudioFloorPainter(accentColor: paintOption.color),
            ),
          ),

          // Interactive 3D Model
          ModelViewer(
            key: ValueKey('${car.id}_$cameraOrbit'),
            src: car.modelUrl,
            alt: car.fullName,
            autoRotate: activeCameraIndex == 0,
            cameraControls: true,
            cameraOrbit: cameraOrbit,
            shadowIntensity: 1.0,
            shadowSoftness: 0.8,
            exposure: 1.25,
            backgroundColor: Colors.transparent,
            autoPlay: true,
            ar: false,
          ),

          // Active wrap/paint badge
          Positioned(
            top: 12,
            left: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.background.withValues(alpha: 0.85),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: paintOption.color.withValues(alpha: 0.6)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: paintOption.color,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '${paintOption.name} • ${tintLevel.round()}% Tint',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Camera View Angle Pills
          Positioned(
            bottom: 10,
            left: 10,
            right: 10,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: cameraAngles.asMap().entries.map((entry) {
                final idx = entry.key;
                final data = entry.value;
                final isActive = idx == activeCameraIndex;

                return GestureDetector(
                  onTap: () => onSelectCamera(idx, data['orbit']!),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: isActive
                          ? AppColors.primary
                          : AppColors.background.withValues(alpha: 0.75),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: isActive ? AppColors.primary : AppColors.border,
                        width: 0.8,
                      ),
                    ),
                    child: Text(
                      data['label']!,
                      style: TextStyle(
                        color: isActive ? Colors.white : AppColors.textMuted,
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _StudioFloorPainter extends CustomPainter {
  const _StudioFloorPainter({required this.accentColor});
  final Color accentColor;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = accentColor.withValues(alpha: 0.08)
      ..strokeWidth = 0.5;

    const spacing = 32.0;
    for (double x = 0; x < size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _StudioFloorPainter oldDelegate) =>
      oldDelegate.accentColor != accentColor;
}

// ─── Engineering Stats Row ───────────────────────────────────────────────────

class _EngineeringStatsRow extends StatelessWidget {
  const _EngineeringStatsRow({
    required this.car,
    required this.addedHP,
    required this.addedDownforce,
    required this.weightDeltaKg,
  });

  final CarModel car;
  final int addedHP;
  final int addedDownforce;
  final double weightDeltaKg;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 10, 16, 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border, width: 0.5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _StatCol(
            label: 'EST. POWER',
            value: '${(car.horsepower ?? 0) + addedHP}',
            unit: 'HP',
            delta: addedHP > 0 ? '+$addedHP' : null,
            color: AppColors.primary,
          ),
          _StatDivider(),
          _StatCol(
            label: 'DOWNFORCE',
            value: '+$addedDownforce',
            unit: 'KG',
            color: const Color(0xFF38BDF8),
          ),
          _StatDivider(),
          _StatCol(
            label: 'WEIGHT DELTA',
            value: '${weightDeltaKg > 0 ? "+" : ""}${weightDeltaKg.toStringAsFixed(1)}',
            unit: 'KG',
            color: weightDeltaKg <= 0 ? AppColors.success : AppColors.warning,
          ),
          _StatDivider(),
          _StatCol(
            label: 'DRIVETRAIN',
            value: car.drivetrain ?? 'AWD',
            unit: '',
            color: AppColors.gold,
          ),
        ],
      ),
    );
  }
}

class _StatCol extends StatelessWidget {
  const _StatCol({
    required this.label,
    required this.value,
    required this.unit,
    required this.color,
    this.delta,
  });

  final String label;
  final String value;
  final String unit;
  final Color color;
  final String? delta;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: AppTextStyles.labelSmall.copyWith(fontSize: 9, color: AppColors.textMuted),
        ),
        const SizedBox(height: 2),
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              value,
              style: AppTextStyles.labelLarge.copyWith(
                fontWeight: FontWeight.w800,
                fontSize: 14,
                color: color,
              ),
            ),
            if (unit.isNotEmpty) ...[
              const SizedBox(width: 2),
              Text(
                unit,
                style: AppTextStyles.bodySmall.copyWith(fontSize: 8, color: AppColors.textSecondary),
              ),
            ],
          ],
        ),
        if (delta != null)
          Text(
            delta!,
            style: const TextStyle(fontSize: 9, color: AppColors.success, fontWeight: FontWeight.w700),
          ),
      ],
    );
  }
}

class _StatDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(width: 0.5, height: 26, color: AppColors.border);
  }
}

// ─── Wheels Panel with Bolt Pattern & Offsets ────────────────────────────────

class _WheelsPanel extends StatelessWidget {
  const _WheelsPanel({
    required this.selectedWheel,
    required this.onSelectWheel,
  });

  final WheelSetupOption selectedWheel;
  final ValueChanged<WheelSetupOption> onSelectWheel;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: WheelSetupOption.wheels.length,
      itemBuilder: (context, index) {
        final wheel = WheelSetupOption.wheels[index];
        final isSelected = wheel.id == selectedWheel.id;

        return GestureDetector(
          onTap: () => onSelectWheel(wheel),
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.surfaceElevated : AppColors.cardBg,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected ? AppColors.primary : AppColors.border,
                width: isSelected ? 1.5 : 0.8,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.primaryGlow : AppColors.surfaceHighlight,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        Icons.album,
                        color: isSelected ? AppColors.primary : AppColors.textMuted,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            wheel.brand,
                            style: AppTextStyles.labelSmall.copyWith(color: AppColors.gold),
                          ),
                          Text(
                            wheel.name,
                            style: AppTextStyles.headlineSmall.copyWith(fontSize: 15),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      wheel.price == 0 ? 'STOCK' : '\$${wheel.price.toInt()}',
                      style: AppTextStyles.labelLarge.copyWith(
                        color: AppColors.gold,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                // Detailed specs
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      _MiniSpecRow(label: 'Diameter & Width', value: wheel.size),
                      _MiniSpecRow(label: 'Bolt Pattern (PCD)', value: wheel.boltPattern),
                      _MiniSpecRow(label: 'Offset (ET)', value: 'Front ${wheel.offsetFront} / Rear ${wheel.offsetRear}'),
                      _MiniSpecRow(label: 'Target Rubber', value: wheel.recommendedTires),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Fitment note: ${wheel.fitmentNote}',
                  style: AppTextStyles.bodySmall.copyWith(fontSize: 10, color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
        ).animate(delay: (index * 30).ms).fadeIn().slideY(begin: 0.1, end: 0);
      },
    );
  }
}

// ─── Exhaust Panel ────────────────────────────────────────────────────────────

class _ExhaustPanel extends StatelessWidget {
  const _ExhaustPanel({
    required this.selectedExhaust,
    required this.onSelectExhaust,
  });

  final ExhaustSetupOption selectedExhaust;
  final ValueChanged<ExhaustSetupOption> onSelectExhaust;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: ExhaustSetupOption.exhausts.length,
      itemBuilder: (context, index) {
        final exhaust = ExhaustSetupOption.exhausts[index];
        final isSelected = exhaust.id == selectedExhaust.id;

        return GestureDetector(
          onTap: () => onSelectExhaust(exhaust),
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.surfaceElevated : AppColors.cardBg,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected ? AppColors.primary : AppColors.border,
                width: isSelected ? 1.5 : 0.8,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.primaryGlow : AppColors.surfaceHighlight,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        Icons.whatshot,
                        color: isSelected ? AppColors.primary : AppColors.textMuted,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            exhaust.brand,
                            style: AppTextStyles.labelSmall.copyWith(color: AppColors.gold),
                          ),
                          Text(
                            exhaust.name,
                            style: AppTextStyles.headlineSmall.copyWith(fontSize: 15),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      exhaust.price == 0 ? 'STOCK' : '\$${exhaust.price.toInt()}',
                      style: AppTextStyles.labelLarge.copyWith(
                        color: AppColors.gold,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      _MiniSpecRow(label: 'Piping Spec', value: '${exhaust.pipeDiameter} • ${exhaust.material}'),
                      _MiniSpecRow(label: 'Sound Profile', value: '${exhaust.decibelRating} dB • ${exhaust.soundProfile}'),
                      _MiniSpecRow(label: 'Power / Weight Delta', value: '+${exhaust.hpGain} HP • -${exhaust.weightReductionKg} kg'),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'ECU Requirements: ${exhaust.requirements}',
                  style: AppTextStyles.bodySmall.copyWith(fontSize: 10, color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
        ).animate(delay: (index * 30).ms).fadeIn().slideY(begin: 0.1, end: 0);
      },
    );
  }
}

class _MiniSpecRow extends StatelessWidget {
  const _MiniSpecRow({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTextStyles.bodySmall.copyWith(fontSize: 10, color: AppColors.textMuted)),
          Flexible(
            child: Text(
              value,
              style: AppTextStyles.labelSmall.copyWith(fontSize: 10),
              textAlign: TextAlign.end,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Bottom Action Bar with Mechanic Port Button ──────────────────────────────

class _BottomActionBar extends StatelessWidget {
  const _BottomActionBar({
    required this.totalPrice,
    required this.onPortToMechanic,
    required this.onSave,
  });

  final double totalPrice;
  final VoidCallback onPortToMechanic;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 12,
        bottom: MediaQuery.of(context).padding.bottom + 12,
      ),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.border, width: 0.5)),
      ),
      child: Row(
        children: [
          // Total Build Price
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'BUILD ESTIMATE',
                style: AppTextStyles.labelSmall.copyWith(fontSize: 9, color: AppColors.textMuted),
              ),
              ShaderMask(
                shaderCallback: (b) => AppColors.goldGradient.createShader(b),
                child: Text(
                  '\$${totalPrice.toInt()}',
                  style: const TextStyle(
                    fontFamily: 'Rajdhani',
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 14),

          // Mechanic Spec Sheet Button
          Expanded(
            child: OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(0, 48),
                side: const BorderSide(color: AppColors.gold, width: 1.2),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: onPortToMechanic,
              icon: const Icon(Icons.handyman_outlined, color: AppColors.gold, size: 16),
              label: const Text(
                'PORT TO MECHANIC',
                style: TextStyle(
                  color: AppColors.gold,
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1,
                ),
              ),
            ),
          ),

          const SizedBox(width: 8),

          // Save Build Button
          IconButton(
            style: IconButton.styleFrom(
              backgroundColor: AppColors.primary,
              minimumSize: const Size(48, 48),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: onSave,
            icon: const Icon(Icons.check, color: Colors.white, size: 20),
            tooltip: 'Save Build to Garage',
          ),
        ],
      ),
    );
  }
}
