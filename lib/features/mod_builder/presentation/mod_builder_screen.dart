import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:ride_swg/core/theme/app_theme.dart';
import 'package:ride_swg/features/garage/data/car_model.dart';

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

  // Mod state
  String _selectedBodyKit = 'Stock';
  String _selectedWheels = 'Stock';
  String _selectedSpoiler = 'None';
  String _selectedExhaust = 'Stock';
  double _tintLevel = 0.0;

  final _bodyKits = ['Stock', 'Aero Wide Body', 'JDM Lip Kit', 'Track Pack'];
  final _wheels = ['Stock', 'Enkei RP03', 'BBS CH-R', 'Vossen CV3', 'SSR SP1'];
  final _spoilers = [
    'None',
    'Duck Tail',
    'GT Wing',
    'Diffuser Wing',
    'GTX Wide'
  ];
  final _exhausts = ['Stock', 'Borla S-Type', 'MagnaFlow', 'Akrapovic', 'HKS'];

  // Estimated performance
  int get _addedHP {
    int hp = 0;
    if (_selectedExhaust != 'Stock') hp += 25;
    if (_selectedBodyKit == 'Track Pack') hp += 15;
    return hp;
  }

  int get _addedWeight {
    int w = 0;
    if (_selectedBodyKit != 'Stock') w += 20;
    if (_selectedSpoiler != 'None') w += 8;
    if (_selectedWheels != 'Stock') w -= 15;
    return w;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // ─── Top bar ──────────────────────────────────────────
          _TopBar(car: _car),

          // ─── 3D Viewer ────────────────────────────────────────
          _ModelViewerPanel(car: _car),

          // ─── Stats row ────────────────────────────────────────
          _StatsRow(car: _car, addedHP: _addedHP, addedWeight: _addedWeight),

          // ─── Mod tabs + panels ────────────────────────────────
          Expanded(
            child: Column(
              children: [
                // Tab bar
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
                      letterSpacing: 1.2,
                    ),
                    tabs: const [
                      Tab(text: 'BODY'),
                      Tab(text: 'WHEELS'),
                      Tab(text: 'AERO'),
                      Tab(text: 'EXHAUST'),
                    ],
                  ),
                ),

                // Tab content
                Expanded(
                  child: TabBarView(
                    controller: _tabCtrl,
                    children: [
                      // Body kits
                      _ModOptionList(
                        options: _bodyKits,
                        selected: _selectedBodyKit,
                        icon: Icons.car_repair,
                        onSelect: (v) =>
                            setState(() => _selectedBodyKit = v),
                        extraWidget: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 16),
                            Text(
                              'WINDOW TINT',
                              style: AppTextStyles.labelSmall,
                            ),
                            const SizedBox(height: 8),
                            _TintSlider(
                              value: _tintLevel,
                              onChanged: (v) =>
                                  setState(() => _tintLevel = v),
                            ),
                          ],
                        ),
                      ),

                      // Wheels
                      _ModOptionList(
                        options: _selectedWheels.isEmpty ? _wheels : _wheels,
                        selected: _selectedWheels,
                        icon: Icons.album,
                        onSelect: (v) =>
                            setState(() => _selectedWheels = v),
                      ),

                      // Aero (spoilers)
                      _ModOptionList(
                        options: _spoilers,
                        selected: _selectedSpoiler,
                        icon: Icons.air,
                        onSelect: (v) =>
                            setState(() => _selectedSpoiler = v),
                      ),

                      // Exhaust
                      _ModOptionList(
                        options: _exhausts,
                        selected: _selectedExhaust,
                        icon: Icons.whatshot,
                        onSelect: (v) =>
                            setState(() => _selectedExhaust = v),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ─── Save button ──────────────────────────────────────
          _SaveBuildBar(car: _car),
        ],
      ),
    );
  }
}

// ─── Top Bar ─────────────────────────────────────────────────────────────────

class _TopBar extends StatelessWidget {
  const _TopBar({required this.car});
  final CarModel car;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 8,
        bottom: 12,
        left: 12,
        right: 20,
      ),
      color: AppColors.background,
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.surfaceElevated,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: const Icon(
                Icons.arrow_back_ios_new,
                size: 18,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(car.brand, style: AppTextStyles.bodySmall),
                Text(
                  car.fullName,
                  style: AppTextStyles.headlineSmall,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          // Share button
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.surfaceElevated,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: const Icon(
              Icons.share_outlined,
              size: 18,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── 3D Model Viewer Panel ────────────────────────────────────────────────────

class _ModelViewerPanel extends StatelessWidget {
  const _ModelViewerPanel({required this.car});
  final CarModel car;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 260,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border, width: 0.5),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryGlow.withOpacity(0.3),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      clipBehavior: Clip.hardEdge,
      child: Stack(
        children: [
          // Ambient background pattern
          Container(
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                colors: [Color(0xFF1E1E1E), AppColors.background],
                radius: 1.2,
              ),
            ),
          ),

          // Grid pattern for "floor"
          Positioned.fill(
            child: CustomPaint(
              painter: _GridPainter(),
            ),
          ),

          // 3D Model Viewer
          ModelViewer(
            src: car.modelUrl,
            alt: car.fullName,
            autoRotate: true,
            cameraControls: true,
            shadowIntensity: 1,
            shadowSoftness: 1,
            exposure: 1.2,
            backgroundColor: Colors.transparent,
            autoPlay: true,
            animationName: null,
            ar: false,
          ),

          // Top overlay: "3D" badge
          Positioned(
            top: 12,
            left: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.surfaceElevated.withOpacity(0.9),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.view_in_ar,
                    size: 12,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    '3D VIEW',
                    style: AppTextStyles.labelSmall.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Bottom hint
          Positioned(
            bottom: 12,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                'Drag to rotate • Pinch to zoom',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textMuted,
                ),
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 500.ms).scale(begin: const Offset(0.95, 0.95));
  }
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.border.withOpacity(0.3)
      ..strokeWidth = 0.5;

    const spacing = 30.0;
    for (double x = 0; x < size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(_GridPainter old) => false;
}

// ─── Stats Row ────────────────────────────────────────────────────────────────

class _StatsRow extends StatelessWidget {
  const _StatsRow({
    required this.car,
    required this.addedHP,
    required this.addedWeight,
  });
  final CarModel car;
  final int addedHP;
  final int addedWeight;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border, width: 0.5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _StatChip(
            label: 'POWER',
            value: '${(car.horsepower ?? 0) + addedHP}',
            unit: 'HP',
            color: AppColors.primary,
            delta: addedHP > 0 ? '+$addedHP' : null,
          ),
          _VertDivider(),
          _StatChip(
            label: 'TORQUE',
            value: '${car.torque ?? "—"}',
            unit: 'NM',
            color: AppColors.gold,
          ),
          _VertDivider(),
          _StatChip(
            label: 'WEIGHT',
            value: '${(car.weight ?? 0) + addedWeight}',
            unit: 'KG',
            color: AppColors.textSecondary,
            delta: addedWeight != 0
                ? '${addedWeight > 0 ? "+" : ""}$addedWeight'
                : null,
            deltaPositive: addedWeight < 0,
          ),
          _VertDivider(),
          _StatChip(
            label: 'DRIVE',
            value: car.drivetrain ?? '—',
            unit: '',
            color: AppColors.textSecondary,
          ),
        ],
      ),
    );
  }
}

class _VertDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 36,
      color: AppColors.border,
    );
  }
}

class _StatChip extends StatelessWidget {
  const _StatChip({
    required this.label,
    required this.value,
    required this.unit,
    required this.color,
    this.delta,
    this.deltaPositive = true,
  });

  final String label;
  final String value;
  final String unit;
  final Color color;
  final String? delta;
  final bool deltaPositive;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label, style: AppTextStyles.labelSmall),
        const SizedBox(height: 4),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: value,
                style: AppTextStyles.accentMedium.copyWith(color: color),
              ),
              if (unit.isNotEmpty)
                TextSpan(
                  text: ' $unit',
                  style: AppTextStyles.bodySmall.copyWith(color: color),
                ),
            ],
          ),
        ),
        if (delta != null) ...[
          const SizedBox(height: 2),
          Text(
            delta!,
            style: AppTextStyles.labelSmall.copyWith(
              color: deltaPositive ? AppColors.success : AppColors.primary,
            ),
          ),
        ],
      ],
    );
  }
}

// ─── Mod Option List ──────────────────────────────────────────────────────────

class _ModOptionList extends StatelessWidget {
  const _ModOptionList({
    required this.options,
    required this.selected,
    required this.icon,
    required this.onSelect,
    this.extraWidget,
  });

  final List<String> options;
  final String selected;
  final IconData icon;
  final void Function(String) onSelect;
  final Widget? extraWidget;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ...options.asMap().entries.map((e) {
            final isSelected = e.value == selected;
            return GestureDetector(
              onTap: () => onSelect(e.value),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primaryGlow
                      : AppColors.surfaceElevated,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.primary
                        : AppColors.border,
                    width: isSelected ? 1.5 : 0.5,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      icon,
                      size: 20,
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.textMuted,
                    ),
                    const SizedBox(width: 14),
                    Text(
                      e.value,
                      style: AppTextStyles.bodyLarge.copyWith(
                        color: isSelected
                            ? AppColors.textPrimary
                            : AppColors.textSecondary,
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.w400,
                      ),
                    ),
                    const Spacer(),
                    if (isSelected)
                      Container(
                        width: 22,
                        height: 22,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.check,
                          size: 14,
                          color: Colors.white,
                        ),
                      ),
                  ],
                ),
              )
                  .animate(delay: (e.key * 40).ms)
                  .fadeIn()
                  .slideX(begin: 0.1, end: 0),
            );
          }),
          if (extraWidget != null) extraWidget!,
        ],
      ),
    );
  }
}

// ─── Tint Slider ─────────────────────────────────────────────────────────────

class _TintSlider extends StatelessWidget {
  const _TintSlider({required this.value, required this.onChanged});
  final double value;
  final void Function(double) onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: 6,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
            activeTrackColor: AppColors.primary,
            inactiveTrackColor: AppColors.border,
            thumbColor: AppColors.primary,
            overlayColor: AppColors.primaryGlow,
          ),
          child: Slider(
            value: value,
            onChanged: onChanged,
            min: 0,
            max: 100,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('None', style: AppTextStyles.bodySmall),
            Text('${value.round()}%', style: AppTextStyles.labelMedium),
            Text('Limo Tint', style: AppTextStyles.bodySmall),
          ],
        ),
      ],
    );
  }
}

// ─── Save Build Bar ───────────────────────────────────────────────────────────

class _SaveBuildBar extends StatelessWidget {
  const _SaveBuildBar({required this.car});
  final CarModel car;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        bottom: MediaQuery.of(context).padding.bottom + 16,
        top: 16,
      ),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.border, width: 0.5)),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Row(
                      children: [
                        const Icon(
                          Icons.check_circle,
                          color: AppColors.success,
                          size: 18,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          '${car.name} build saved!',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
              child: Container(
                height: 52,
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryGlow,
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.save_outlined, color: Colors.white, size: 18),
                    SizedBox(width: 10),
                    Text(
                      'SAVE BUILD',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 2,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Share build
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: AppColors.surfaceElevated,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.border),
            ),
            child: const Icon(
              Icons.ios_share,
              color: AppColors.textPrimary,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }
}
