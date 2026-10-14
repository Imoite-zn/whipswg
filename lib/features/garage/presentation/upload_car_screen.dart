import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ride_swg/core/theme/app_theme.dart';
import 'package:ride_swg/features/garage/data/car_model.dart';
import 'package:ride_swg/features/garage/data/garage_provider.dart';

// ─── Constants ────────────────────────────────────────────────────────────────

const _kCategories = ['Sports', 'Super Car', 'Muscle', 'Sedan', 'Rally', 'Truck', 'Hatchback', 'SUV'];
const _kDrivetrains = ['RWD', 'FWD', 'AWD', '4WD'];
const _kPresetColors = [
  {'label': 'Rosso Corsa', 'hex': '#D62828'},
  {'label': 'Nardo Grey', 'hex': '#6C7A89'},
  {'label': 'Bayside Blue', 'hex': '#1565C0'},
  {'label': 'Pearl White', 'hex': '#F5F5F0'},
  {'label': 'Midnight Black', 'hex': '#0D0D0D'},
  {'label': 'Sunset Orange', 'hex': '#FF6F00'},
  {'label': 'Liquid Gold', 'hex': '#CFA94E'},
  {'label': 'Emerald Green', 'hex': '#1B4D3E'},
  {'label': 'Ultraviolet', 'hex': '#4A148C'},
  {'label': 'Frozen Silver', 'hex': '#B0BEC5'},
];

// ─── Screen ───────────────────────────────────────────────────────────────────

class UploadCarScreen extends ConsumerStatefulWidget {
  const UploadCarScreen({super.key});

  @override
  ConsumerState<UploadCarScreen> createState() => _UploadCarScreenState();
}

class _UploadCarScreenState extends ConsumerState<UploadCarScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  late final PageController _pageCtrl;
  int _currentStep = 0;

  // ── Form Fields ─────────────────────────────────────────────────────────────
  final _vinCtrl = TextEditingController();
  final _makeCtrl = TextEditingController();
  final _modelCtrl = TextEditingController();
  final _trimCtrl = TextEditingController();
  final _yearCtrl = TextEditingController();
  final _hpCtrl = TextEditingController();
  final _torqueCtrl = TextEditingController();
  final _weightCtrl = TextEditingController();
  final _thumbnailUrlCtrl = TextEditingController();
  final _modelUrlCtrl = TextEditingController();

  String _selectedCategory = 'Sports';
  String _selectedDrivetrain = 'RWD';
  String _selectedColorHex = '#D62828';
  String _selectedColorLabel = 'Rosso Corsa';

  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _pageCtrl = PageController();
  }

  @override
  void dispose() {
    _pageCtrl.dispose();
    _vinCtrl.dispose();
    _makeCtrl.dispose();
    _modelCtrl.dispose();
    _trimCtrl.dispose();
    _yearCtrl.dispose();
    _hpCtrl.dispose();
    _torqueCtrl.dispose();
    _weightCtrl.dispose();
    _thumbnailUrlCtrl.dispose();
    _modelUrlCtrl.dispose();
    super.dispose();
  }

  void _goToStep(int step) {
    setState(() => _currentStep = step);
    _pageCtrl.animateToPage(
      step,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOut,
    );
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _isSubmitting = true);

    await Future.delayed(const Duration(milliseconds: 600)); // simulate upload

    final car = CarModel(
      id: 'custom_${DateTime.now().millisecondsSinceEpoch}',
      name: '${_modelCtrl.text.trim()} ${_trimCtrl.text.trim()}'.trim(),
      brand: _makeCtrl.text.trim(),
      year: int.tryParse(_yearCtrl.text.trim()) ?? 2024,
      category: _selectedCategory,
      modelUrl: _modelUrlCtrl.text.trim().isNotEmpty
          ? _modelUrlCtrl.text.trim()
          : 'https://modelviewer.dev/shared-assets/models/Astronaut.glb',
      thumbnailUrl: _thumbnailUrlCtrl.text.trim().isNotEmpty
          ? _thumbnailUrlCtrl.text.trim()
          : 'https://images.unsplash.com/photo-1503736334956-4c8f8e92946d?w=400',
      colorHex: _selectedColorHex,
      horsepower: int.tryParse(_hpCtrl.text.trim()),
      torque: int.tryParse(_torqueCtrl.text.trim()),
      weight: int.tryParse(_weightCtrl.text.trim()),
      drivetrain: _selectedDrivetrain,
      isCustomUpload: true,
    );

    await ref.read(garageProvider.notifier).addCar(car);

    if (mounted) {
      setState(() => _isSubmitting = false);
      context.pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('🚗 ${car.fullName} added to your garage!'),
          backgroundColor: AppColors.success,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // ── Header ──────────────────────────────────────────────────────────
          _UploadHeader(
            currentStep: _currentStep,
            totalSteps: 3,
            onBack: () {
              if (_currentStep > 0) {
                _goToStep(_currentStep - 1);
              } else {
                context.pop();
              }
            },
          ),

          // ── Step Indicator ──────────────────────────────────────────────────
          _StepIndicator(current: _currentStep),

          // ── Pages ────────────────────────────────────────────────────────────
          Expanded(
            child: Form(
              key: _formKey,
              child: PageView(
                controller: _pageCtrl,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _Step1VehicleIdentity(
                    vinCtrl: _vinCtrl,
                    makeCtrl: _makeCtrl,
                    modelCtrl: _modelCtrl,
                    trimCtrl: _trimCtrl,
                    yearCtrl: _yearCtrl,
                  ),
                  _Step2SpecsAndSetup(
                    hpCtrl: _hpCtrl,
                    torqueCtrl: _torqueCtrl,
                    weightCtrl: _weightCtrl,
                    selectedCategory: _selectedCategory,
                    selectedDrivetrain: _selectedDrivetrain,
                    onCategoryChanged: (v) => setState(() => _selectedCategory = v),
                    onDrivetrainChanged: (v) => setState(() => _selectedDrivetrain = v),
                  ),
                  _Step3Visual(
                    thumbnailUrlCtrl: _thumbnailUrlCtrl,
                    modelUrlCtrl: _modelUrlCtrl,
                    selectedColorHex: _selectedColorHex,
                    selectedColorLabel: _selectedColorLabel,
                    onColorSelected: (hex, label) => setState(() {
                      _selectedColorHex = hex;
                      _selectedColorLabel = label;
                    }),
                  ),
                ],
              ),
            ),
          ),

          // ── Bottom Actions ───────────────────────────────────────────────────
          _BottomNav(
            currentStep: _currentStep,
            totalSteps: 3,
            isSubmitting: _isSubmitting,
            onNext: () {
              if (_currentStep < 2) {
                _goToStep(_currentStep + 1);
              } else {
                _submit();
              }
            },
          ),
        ],
      ),
    );
  }
}

// ─── Header ────────────────────────────────────────────────────────────────────

class _UploadHeader extends StatelessWidget {
  const _UploadHeader({
    required this.currentStep,
    required this.totalSteps,
    required this.onBack,
  });

  final int currentStep;
  final int totalSteps;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 10,
        bottom: 12,
        left: 12,
        right: 20,
      ),
      color: AppColors.background,
      child: Row(
        children: [
          IconButton(
            onPressed: onBack,
            icon: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.surfaceElevated,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: const Icon(Icons.arrow_back_ios_new, size: 16, color: AppColors.textPrimary),
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'ADD YOUR VEHICLE',
                style: AppTextStyles.labelSmall.copyWith(
                  color: AppColors.primary,
                  letterSpacing: 2,
                ),
              ),
              Text(
                'Step ${currentStep + 1} of $totalSteps',
                style: AppTextStyles.headlineSmall.copyWith(fontSize: 18),
              ),
            ],
          ),
          const Spacer(),
          // Animated car icon
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.directions_car, color: Colors.white, size: 22),
          ).animate(onPlay: (c) => c.repeat(reverse: true))
              .shimmer(duration: 2000.ms, color: AppColors.primaryLight.withValues(alpha: 0.3)),
        ],
      ),
    );
  }
}

// ─── Step Indicator ────────────────────────────────────────────────────────────

class _StepIndicator extends StatelessWidget {
  const _StepIndicator({required this.current});
  final int current;

  @override
  Widget build(BuildContext context) {
    final labels = ['IDENTITY', 'SPECS', 'VISUAL'];
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: List.generate(labels.length, (i) {
          final isDone = i < current;
          final isActive = i == current;
          return Expanded(
            child: Row(
              children: [
                if (i > 0)
                  Expanded(
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 400),
                      height: 2,
                      color: isDone ? AppColors.primary : AppColors.border,
                    ),
                  ),
                Column(
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isActive
                            ? AppColors.primary
                            : isDone
                                ? AppColors.success
                                : AppColors.surfaceElevated,
                        border: Border.all(
                          color: isActive
                              ? AppColors.primary
                              : isDone
                                  ? AppColors.success
                                  : AppColors.border,
                          width: 1.5,
                        ),
                      ),
                      child: Center(
                        child: isDone
                            ? const Icon(Icons.check, size: 14, color: Colors.white)
                            : Text(
                                '${i + 1}',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: isActive ? Colors.white : AppColors.textMuted,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      labels[i],
                      style: AppTextStyles.labelSmall.copyWith(
                        color: isActive ? AppColors.primary : AppColors.textMuted,
                        fontSize: 9,
                      ),
                    ),
                  ],
                ),
                if (i < labels.length - 1)
                  Expanded(
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 400),
                      height: 2,
                      color: i < current ? AppColors.primary : AppColors.border,
                    ),
                  ),
              ],
            ),
          );
        }),
      ),
    );
  }
}

// ─── Step 1: Vehicle Identity ──────────────────────────────────────────────────

class _Step1VehicleIdentity extends StatelessWidget {
  const _Step1VehicleIdentity({
    required this.vinCtrl,
    required this.makeCtrl,
    required this.modelCtrl,
    required this.trimCtrl,
    required this.yearCtrl,
  });

  final TextEditingController vinCtrl;
  final TextEditingController makeCtrl;
  final TextEditingController modelCtrl;
  final TextEditingController trimCtrl;
  final TextEditingController yearCtrl;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionLabel(icon: Icons.fingerprint, label: 'Vehicle Identification'),
          const SizedBox(height: 16),
          _PremiumTextField(
            controller: vinCtrl,
            label: 'VIN Number',
            hint: '1HGBH41JXMN109186',
            icon: Icons.qr_code,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z0-9]')),
              LengthLimitingTextInputFormatter(17),
            ],
            validator: (v) {
              if (v == null || v.trim().isEmpty) return null; // optional
              if (v.trim().length != 17) return 'VIN must be exactly 17 characters';
              return null;
            },
          ),
          const SizedBox(height: 16),
          _SectionLabel(icon: Icons.directions_car_outlined, label: 'Make, Model & Trim'),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _PremiumTextField(
                  controller: makeCtrl,
                  label: 'Make',
                  hint: 'Toyota',
                  icon: Icons.business,
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Required' : null,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _PremiumTextField(
                  controller: yearCtrl,
                  label: 'Year',
                  hint: '1998',
                  icon: Icons.calendar_today,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(4),
                  ],
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'Required';
                    final y = int.tryParse(v.trim());
                    if (y == null || y < 1900 || y > 2030) return 'Invalid year';
                    return null;
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _PremiumTextField(
            controller: modelCtrl,
            label: 'Model',
            hint: 'Supra',
            icon: Icons.car_rental,
            validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'Required' : null,
          ),
          const SizedBox(height: 12),
          _PremiumTextField(
            controller: trimCtrl,
            label: 'Trim / Variant',
            hint: 'MK4 2JZ-GTE (optional)',
            icon: Icons.tune,
          ),
          const SizedBox(height: 24),
          _InfoBanner(
            message:
                'VIN is optional but helps generate an accurate mechanic spec sheet when porting your build.',
          ),
        ].animate(interval: 60.ms).fadeIn(duration: 300.ms).slideY(begin: 0.1, end: 0),
      ),
    );
  }
}

// ─── Step 2: Specs & Setup ─────────────────────────────────────────────────────

class _Step2SpecsAndSetup extends StatelessWidget {
  const _Step2SpecsAndSetup({
    required this.hpCtrl,
    required this.torqueCtrl,
    required this.weightCtrl,
    required this.selectedCategory,
    required this.selectedDrivetrain,
    required this.onCategoryChanged,
    required this.onDrivetrainChanged,
  });

  final TextEditingController hpCtrl;
  final TextEditingController torqueCtrl;
  final TextEditingController weightCtrl;
  final String selectedCategory;
  final String selectedDrivetrain;
  final void Function(String) onCategoryChanged;
  final void Function(String) onDrivetrainChanged;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionLabel(icon: Icons.speed, label: 'Performance Specs'),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _PremiumTextField(
                  controller: hpCtrl,
                  label: 'Horsepower',
                  hint: '320',
                  icon: Icons.flash_on,
                  suffix: 'HP',
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _PremiumTextField(
                  controller: torqueCtrl,
                  label: 'Torque',
                  hint: '427',
                  icon: Icons.rotate_right,
                  suffix: 'Nm',
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _PremiumTextField(
            controller: weightCtrl,
            label: 'Kerb Weight',
            hint: '1570',
            icon: Icons.monitor_weight_outlined,
            suffix: 'kg',
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          ),
          const SizedBox(height: 24),
          _SectionLabel(icon: Icons.category_outlined, label: 'Vehicle Category'),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: _kCategories.map((cat) {
              final isSelected = cat == selectedCategory;
              return GestureDetector(
                onTap: () => onCategoryChanged(cat),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primary : AppColors.surfaceElevated,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isSelected ? AppColors.primary : AppColors.border,
                    ),
                    boxShadow: isSelected
                        ? [BoxShadow(color: AppColors.primaryGlow, blurRadius: 10)]
                        : null,
                  ),
                  child: Text(
                    cat,
                    style: TextStyle(
                      color: isSelected ? Colors.white : AppColors.textSecondary,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
          _SectionLabel(icon: Icons.settings_input_component_outlined, label: 'Drivetrain Layout'),
          const SizedBox(height: 12),
          Row(
            children: _kDrivetrains.map((dt) {
              final isSelected = dt == selectedDrivetrain;
              return Expanded(
                child: GestureDetector(
                  onTap: () => onDrivetrainChanged(dt),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.primary : AppColors.surfaceElevated,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isSelected ? AppColors.primary : AppColors.border,
                      ),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          _drivetrainIcon(dt),
                          size: 18,
                          color: isSelected ? Colors.white : AppColors.textMuted,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          dt,
                          style: TextStyle(
                            color: isSelected ? Colors.white : AppColors.textSecondary,
                            fontWeight: FontWeight.w700,
                            fontSize: 11,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ].animate(interval: 60.ms).fadeIn(duration: 300.ms).slideY(begin: 0.1, end: 0),
      ),
    );
  }

  IconData _drivetrainIcon(String dt) {
    switch (dt) {
      case 'RWD': return Icons.arrow_forward;
      case 'FWD': return Icons.arrow_back;
      case 'AWD': return Icons.sync_alt;
      case '4WD': return Icons.terrain;
      default: return Icons.directions_car;
    }
  }
}

// ─── Step 3: Visual ────────────────────────────────────────────────────────────

class _Step3Visual extends StatelessWidget {
  const _Step3Visual({
    required this.thumbnailUrlCtrl,
    required this.modelUrlCtrl,
    required this.selectedColorHex,
    required this.selectedColorLabel,
    required this.onColorSelected,
  });

  final TextEditingController thumbnailUrlCtrl;
  final TextEditingController modelUrlCtrl;
  final String selectedColorHex;
  final String selectedColorLabel;
  final void Function(String hex, String label) onColorSelected;

  Color _hexColor(String hex) {
    try {
      return Color(int.parse(hex.replaceAll('#', '0xFF')));
    } catch (_) {
      return AppColors.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedColor = _hexColor(selectedColorHex);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Color Preview Card ─────────────────────────────────────────────
          Container(
            height: 100,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  selectedColor.withValues(alpha: 0.7),
                  selectedColor.withValues(alpha: 0.2),
                  AppColors.cardBg,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: selectedColor.withValues(alpha: 0.5)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: selectedColor,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(color: selectedColor.withValues(alpha: 0.5), blurRadius: 16),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'BASE COLOR',
                        style: AppTextStyles.labelSmall.copyWith(color: AppColors.textMuted),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        selectedColorLabel,
                        style: AppTextStyles.headlineSmall.copyWith(fontSize: 16),
                      ),
                      Text(
                        selectedColorHex.toUpperCase(),
                        style: AppTextStyles.bodySmall.copyWith(
                          color: selectedColor.withValues(alpha: 0.9),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          _SectionLabel(icon: Icons.palette_outlined, label: 'Select Base Color'),
          const SizedBox(height: 14),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: _kPresetColors.map((c) {
              final isSelected = c['hex'] == selectedColorHex;
              final color = _hexColor(c['hex']!);
              return GestureDetector(
                onTap: () => onColorSelected(c['hex']!, c['label']!),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected ? Colors.white : Colors.transparent,
                      width: 2.5,
                    ),
                    boxShadow: isSelected
                        ? [BoxShadow(color: color.withValues(alpha: 0.6), blurRadius: 12)]
                        : null,
                  ),
                  child: isSelected
                      ? const Icon(Icons.check, color: Colors.white, size: 18)
                      : null,
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),

          _SectionLabel(icon: Icons.image_outlined, label: 'Photo & 3D Model URLs'),
          const SizedBox(height: 16),
          _PremiumTextField(
            controller: thumbnailUrlCtrl,
            label: 'Thumbnail Photo URL',
            hint: 'https://unsplash.com/...',
            icon: Icons.photo_camera_outlined,
          ),
          const SizedBox(height: 12),
          _PremiumTextField(
            controller: modelUrlCtrl,
            label: '3D Model URL (.glb / .gltf)',
            hint: 'https://cdn.example.com/car.glb',
            icon: Icons.view_in_ar_outlined,
          ),
          const SizedBox(height: 12),
          _InfoBanner(
            message:
                'You can upload your GLB file to a CDN like Sketchfab, Poly.pizza or Google Cloud Storage and paste the URL here. If left blank, a placeholder 3D model is used.',
          ),
        ].animate(interval: 60.ms).fadeIn(duration: 300.ms).slideY(begin: 0.1, end: 0),
      ),
    );
  }
}

// ─── Bottom Nav ────────────────────────────────────────────────────────────────

class _BottomNav extends StatelessWidget {
  const _BottomNav({
    required this.currentStep,
    required this.totalSteps,
    required this.isSubmitting,
    required this.onNext,
  });

  final int currentStep;
  final int totalSteps;
  final bool isSubmitting;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final isLast = currentStep == totalSteps - 1;
    return Container(
      padding: EdgeInsets.fromLTRB(
        20,
        12,
        20,
        MediaQuery.of(context).padding.bottom + 12,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: const Border(top: BorderSide(color: AppColors.border, width: 0.5)),
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: isLast ? AppColors.success : AppColors.primary,
          minimumSize: const Size(double.infinity, 56),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        onPressed: isSubmitting ? null : onNext,
        child: isSubmitting
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isLast ? Icons.garage : Icons.arrow_forward,
                    size: 18,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    isLast ? 'ADD TO MY GARAGE' : 'CONTINUE',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.2,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

// ─── Shared Components ─────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.icon, required this.label});
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 14, color: AppColors.primary),
        const SizedBox(width: 8),
        Text(
          label.toUpperCase(),
          style: AppTextStyles.labelSmall.copyWith(
            color: AppColors.textSecondary,
            letterSpacing: 1.5,
            fontSize: 10,
          ),
        ),
      ],
    );
  }
}

class _PremiumTextField extends StatelessWidget {
  const _PremiumTextField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    this.suffix,
    this.keyboardType,
    this.inputFormatters,
    this.validator,
  });

  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final String? suffix;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      validator: validator,
      style: AppTextStyles.bodyLarge.copyWith(fontSize: 15),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, size: 18),
        suffixText: suffix,
        suffixStyle: AppTextStyles.labelMedium.copyWith(color: AppColors.gold),
      ),
    );
  }
}

class _InfoBanner extends StatelessWidget {
  const _InfoBanner({required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline, size: 16, color: AppColors.gold),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
