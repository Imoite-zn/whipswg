import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:ride_swg/core/theme/app_theme.dart';
import 'package:ride_swg/features/mechanics/data/mechanic_model.dart';

const _kServiceOptions = [
  'Body Kit Installation',
  'Exhaust Systems',
  'Wheel & Tire Fitment',
  'ECU Tuning',
  'Paint & Wrap',
  'PPF Application',
  'Suspension Tuning',
  'Engine Swaps',
  'Carbon Fiber Work',
  'Custom Fabrication',
  'Roll Cage Installs',
  'Wheel Alignment',
  'Stage 1/2 Tunes',
  'Drift Prep',
  'Track Day Prep',
];

class MechanicPortalScreen extends StatefulWidget {
  const MechanicPortalScreen({super.key});

  @override
  State<MechanicPortalScreen> createState() => _MechanicPortalScreenState();
}

class _MechanicPortalScreenState extends State<MechanicPortalScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  late final PageController _pageCtrl;
  int _currentStep = 0;

  // ── Form state ───────────────────────────────────────────────────────────────
  final _shopNameCtrl = TextEditingController();
  final _ownerNameCtrl = TextEditingController();
  final _cityCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  final _yearsCtrl = TextEditingController();
  final _rateCtrl = TextEditingController();
  final _bioCtrl = TextEditingController();
  bool _isAseCertified = false;
  bool _requestVerifiedBadge = false;
  final Set<String> _selectedServices = {};
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _pageCtrl = PageController();
  }

  @override
  void dispose() {
    _pageCtrl.dispose();
    _shopNameCtrl.dispose();
    _ownerNameCtrl.dispose();
    _cityCtrl.dispose();
    _addressCtrl.dispose();
    _yearsCtrl.dispose();
    _rateCtrl.dispose();
    _bioCtrl.dispose();
    super.dispose();
  }

  void _goToStep(int step) {
    setState(() => _currentStep = step);
    _pageCtrl.animateToPage(step, duration: 350.ms, curve: Curves.easeInOut);
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _isSubmitting = true);
    await Future.delayed(800.ms); // simulate API call
    if (mounted) {
      setState(() => _isSubmitting = false);
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => _SuccessDialog(
          shopName: _shopNameCtrl.text.trim(),
          requestedVerified: _requestVerifiedBadge,
          onClose: () {
            Navigator.of(context).pop(); // close dialog
            context.pop(); // back to mechanics list
          },
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
          _PortalHeader(
            currentStep: _currentStep,
            onBack: () => _currentStep > 0 ? _goToStep(_currentStep - 1) : context.pop(),
          ),
          _StepIndicator(current: _currentStep),
          Expanded(
            child: Form(
              key: _formKey,
              child: PageView(
                controller: _pageCtrl,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _Step1ShopInfo(
                    shopNameCtrl: _shopNameCtrl,
                    ownerNameCtrl: _ownerNameCtrl,
                    cityCtrl: _cityCtrl,
                    addressCtrl: _addressCtrl,
                    yearsCtrl: _yearsCtrl,
                    rateCtrl: _rateCtrl,
                  ),
                  _Step2Services(
                    selectedServices: _selectedServices,
                    onToggle: (s) => setState(() {
                      if (_selectedServices.contains(s)) {
                        _selectedServices.remove(s);
                      } else {
                        _selectedServices.add(s);
                      }
                    }),
                  ),
                  _Step3Credentials(
                    bioCtrl: _bioCtrl,
                    isAseCertified: _isAseCertified,
                    requestVerified: _requestVerifiedBadge,
                    onAseCertChanged: (v) => setState(() => _isAseCertified = v),
                    onRequestVerifiedChanged: (v) => setState(() => _requestVerifiedBadge = v),
                  ),
                ],
              ),
            ),
          ),
          _BottomNav(
            currentStep: _currentStep,
            totalSteps: 3,
            isSubmitting: _isSubmitting,
            onNext: () => _currentStep < 2 ? _goToStep(_currentStep + 1) : _submit(),
          ),
        ],
      ),
    );
  }
}

// ─── Header ───────────────────────────────────────────────────────────────────

class _PortalHeader extends StatelessWidget {
  const _PortalHeader({required this.currentStep, required this.onBack});
  final int currentStep;
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
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF1A0A00), AppColors.background],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
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
                'MECHANIC PORTAL',
                style: AppTextStyles.labelSmall.copyWith(
                  color: AppColors.gold,
                  letterSpacing: 2,
                ),
              ),
              Text(
                'List Your Workshop',
                style: AppTextStyles.headlineSmall.copyWith(fontSize: 18),
              ),
            ],
          ),
          const Spacer(),
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.goldGlow,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.gold.withValues(alpha: 0.4)),
            ),
            child: const Icon(Icons.handyman, color: AppColors.gold, size: 22),
          ).animate(onPlay: (c) => c.repeat(reverse: true))
              .shimmer(duration: 2500.ms, color: AppColors.goldLight.withValues(alpha: 0.25)),
        ],
      ),
    );
  }
}

// ─── Step indicator ──────────────────────────────────────────────────────────

class _StepIndicator extends StatelessWidget {
  const _StepIndicator({required this.current});
  final int current;

  @override
  Widget build(BuildContext context) {
    final labels = ['SHOP INFO', 'SERVICES', 'CREDENTIALS'];
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
                      duration: 400.ms,
                      height: 2,
                      color: isDone ? AppColors.gold : AppColors.border,
                    ),
                  ),
                Column(
                  children: [
                    AnimatedContainer(
                      duration: 300.ms,
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isActive ? AppColors.gold : isDone ? AppColors.success : AppColors.surfaceElevated,
                        border: Border.all(
                          color: isActive ? AppColors.gold : isDone ? AppColors.success : AppColors.border,
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
                                  color: isActive ? Colors.black : AppColors.textMuted,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      labels[i],
                      style: AppTextStyles.labelSmall.copyWith(
                        color: isActive ? AppColors.gold : AppColors.textMuted,
                        fontSize: 8,
                      ),
                    ),
                  ],
                ),
                if (i < labels.length - 1)
                  Expanded(
                    child: AnimatedContainer(
                      duration: 400.ms,
                      height: 2,
                      color: i < current ? AppColors.gold : AppColors.border,
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

// ─── Step 1: Shop Info ────────────────────────────────────────────────────────

class _Step1ShopInfo extends StatelessWidget {
  const _Step1ShopInfo({
    required this.shopNameCtrl,
    required this.ownerNameCtrl,
    required this.cityCtrl,
    required this.addressCtrl,
    required this.yearsCtrl,
    required this.rateCtrl,
  });

  final TextEditingController shopNameCtrl;
  final TextEditingController ownerNameCtrl;
  final TextEditingController cityCtrl;
  final TextEditingController addressCtrl;
  final TextEditingController yearsCtrl;
  final TextEditingController rateCtrl;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionLabel(icon: Icons.store, label: 'Workshop Details'),
          const SizedBox(height: 16),
          _Field(ctrl: shopNameCtrl, label: 'Shop / Garage Name', hint: 'Apex Performance Garage', icon: Icons.storefront,
              validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null),
          const SizedBox(height: 12),
          _Field(ctrl: ownerNameCtrl, label: 'Owner / Lead Mechanic', hint: 'Carlos Mendez', icon: Icons.person_outline,
              validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null),
          const SizedBox(height: 20),
          _SectionLabel(icon: Icons.location_city_outlined, label: 'Location'),
          const SizedBox(height: 16),
          _Field(ctrl: addressCtrl, label: 'Street Address', hint: '142 Industrial Blvd', icon: Icons.pin_drop_outlined,
              validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null),
          const SizedBox(height: 12),
          _Field(ctrl: cityCtrl, label: 'City, State', hint: 'Los Angeles, CA', icon: Icons.location_city,
              validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null),
          const SizedBox(height: 20),
          _SectionLabel(icon: Icons.work_outline, label: 'Experience & Pricing'),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _Field(ctrl: yearsCtrl, label: 'Years in Business', hint: '8', icon: Icons.history,
                    keyboardType: TextInputType.number,
                    validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _Field(ctrl: rateCtrl, label: 'Labor Rate (USD/hr)', hint: '120', icon: Icons.attach_money,
                    keyboardType: TextInputType.number,
                    validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null),
              ),
            ],
          ),
        ].animate(interval: 60.ms).fadeIn(duration: 300.ms).slideY(begin: 0.1, end: 0),
      ),
    );
  }
}

// ─── Step 2: Services ─────────────────────────────────────────────────────────

class _Step2Services extends StatelessWidget {
  const _Step2Services({
    required this.selectedServices,
    required this.onToggle,
  });

  final Set<String> selectedServices;
  final void Function(String) onToggle;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionLabel(icon: Icons.build_circle_outlined, label: 'Services You Offer'),
          const SizedBox(height: 6),
          Text(
            'Select all that apply. This helps car owners find the right shop.',
            style: AppTextStyles.bodySmall.copyWith(color: AppColors.textMuted, height: 1.5),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: _kServiceOptions.map((s) {
              final isSelected = selectedServices.contains(s);
              return GestureDetector(
                onTap: () => onToggle(s),
                child: AnimatedContainer(
                  duration: 200.ms,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                  decoration: BoxDecoration(
                    color: isSelected ? s.serviceColor.withValues(alpha: 0.2) : AppColors.surfaceElevated,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isSelected ? s.serviceColor : AppColors.border,
                      width: isSelected ? 1.5 : 0.8,
                    ),
                    boxShadow: isSelected
                        ? [BoxShadow(color: s.serviceColor.withValues(alpha: 0.2), blurRadius: 8)]
                        : null,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (isSelected)
                        Icon(Icons.check_circle, size: 13, color: s.serviceColor),
                      if (isSelected) const SizedBox(width: 5),
                      Text(
                        s,
                        style: TextStyle(
                          color: isSelected ? s.serviceColor : AppColors.textSecondary,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          if (selectedServices.isEmpty)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.surfaceElevated,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.warning.withValues(alpha: 0.4)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.warning_amber, size: 15, color: AppColors.warning),
                  const SizedBox(width: 8),
                  Text(
                    'Select at least one service to continue.',
                    style: AppTextStyles.bodySmall.copyWith(color: AppColors.warning),
                  ),
                ],
              ),
            ),
        ].animate(interval: 50.ms).fadeIn(duration: 300.ms),
      ),
    );
  }
}

// ─── Step 3: Credentials ─────────────────────────────────────────────────────

class _Step3Credentials extends StatelessWidget {
  const _Step3Credentials({
    required this.bioCtrl,
    required this.isAseCertified,
    required this.requestVerified,
    required this.onAseCertChanged,
    required this.onRequestVerifiedChanged,
  });

  final TextEditingController bioCtrl;
  final bool isAseCertified;
  final bool requestVerified;
  final void Function(bool) onAseCertChanged;
  final void Function(bool) onRequestVerifiedChanged;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionLabel(icon: Icons.description_outlined, label: 'Workshop Bio'),
          const SizedBox(height: 12),
          TextFormField(
            controller: bioCtrl,
            maxLines: 5,
            style: AppTextStyles.bodyLarge.copyWith(fontSize: 14),
            decoration: const InputDecoration(
              hintText:
                  'Tell car owners about your expertise, your team, and what makes your workshop stand out…',
              alignLabelWithHint: true,
            ),
          ),
          const SizedBox(height: 24),
          _SectionLabel(icon: Icons.verified_outlined, label: 'Certifications & Verification'),
          const SizedBox(height: 16),
          _ToggleTile(
            icon: Icons.workspace_premium,
            iconColor: AppColors.gold,
            title: 'ASE Certified Technicians',
            subtitle: 'I employ ASE-certified mechanics',
            value: isAseCertified,
            onChanged: onAseCertChanged,
          ),
          const SizedBox(height: 12),
          _ToggleTile(
            icon: Icons.verified,
            iconColor: AppColors.primary,
            title: 'Request Verified Badge',
            subtitle: 'Submit for review by the RideSwg team (may take 2–5 business days)',
            value: requestVerified,
            onChanged: onRequestVerifiedChanged,
          ),
          const SizedBox(height: 24),
          Container(
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
                    'Your listing goes live immediately. The Verified Badge review is a separate process and does not block your listing.',
                    style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary, height: 1.5),
                  ),
                ),
              ],
            ),
          ),
        ].animate(interval: 60.ms).fadeIn(duration: 300.ms).slideY(begin: 0.1, end: 0),
      ),
    );
  }
}

// ─── Bottom Nav ───────────────────────────────────────────────────────────────

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
      padding: EdgeInsets.fromLTRB(20, 12, 20, MediaQuery.of(context).padding.bottom + 12),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.border, width: 0.5)),
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: isLast ? AppColors.gold : AppColors.primary,
          minimumSize: const Size(double.infinity, 56),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        onPressed: isSubmitting ? null : onNext,
        child: isSubmitting
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  color: Colors.black,
                  strokeWidth: 2.5,
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isLast ? Icons.check_circle : Icons.arrow_forward,
                    size: 18,
                    color: isLast ? Colors.black : Colors.white,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    isLast ? 'SUBMIT LISTING' : 'CONTINUE',
                    style: TextStyle(
                      color: isLast ? Colors.black : Colors.white,
                      fontWeight: FontWeight.w900,
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

// ─── Success Dialog ────────────────────────────────────────────────────────────

class _SuccessDialog extends StatelessWidget {
  const _SuccessDialog({
    required this.shopName,
    required this.requestedVerified,
    required this.onClose,
  });

  final String shopName;
  final bool requestedVerified;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.cardBg,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: AppColors.success.withValues(alpha: 0.15),
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.success.withValues(alpha: 0.5), width: 2),
              ),
              child: const Icon(Icons.check_circle_outline, size: 36, color: AppColors.success),
            ).animate().scale(duration: 500.ms, curve: Curves.elasticOut),
            const SizedBox(height: 20),
            Text('Workshop Listed!', style: AppTextStyles.headlineMedium),
            const SizedBox(height: 8),
            Text(
              '$shopName is now visible to car owners on RideSwg.',
              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
            if (requestedVerified) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.goldGlow,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.gold.withValues(alpha: 0.3)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.verified, size: 14, color: AppColors.gold),
                    const SizedBox(width: 6),
                    Text(
                      'Verified badge review in 2–5 days',
                      style: AppTextStyles.bodySmall.copyWith(color: AppColors.gold),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: onClose,
              child: const Text(
                'DONE',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, letterSpacing: 1.2),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Shared small widgets ──────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.icon, required this.label});
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 14, color: AppColors.gold),
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

class _Field extends StatelessWidget {
  const _Field({
    required this.ctrl,
    required this.label,
    required this.hint,
    required this.icon,
    this.keyboardType,
    this.validator,
  });

  final TextEditingController ctrl;
  final String label;
  final String hint;
  final IconData icon;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: ctrl,
      keyboardType: keyboardType,
      validator: validator,
      style: AppTextStyles.bodyLarge.copyWith(fontSize: 14),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, size: 18),
      ),
    );
  }
}

class _ToggleTile extends StatelessWidget {
  const _ToggleTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final bool value;
  final void Function(bool) onChanged;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: 200.ms,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: value ? iconColor.withValues(alpha: 0.1) : AppColors.surfaceElevated,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: value ? iconColor.withValues(alpha: 0.5) : AppColors.border,
            width: value ? 1.5 : 0.8,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, size: 22, color: value ? iconColor : AppColors.textMuted),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.labelLarge.copyWith(
                      color: value ? AppColors.textPrimary : AppColors.textSecondary,
                    ),
                  ),
                  Text(subtitle, style: AppTextStyles.bodySmall.copyWith(height: 1.4)),
                ],
              ),
            ),
            Switch(
              value: value,
              onChanged: onChanged,
              activeThumbColor: iconColor,
              inactiveTrackColor: AppColors.border,
            ),
          ],
        ),
      ),
    );
  }
}
