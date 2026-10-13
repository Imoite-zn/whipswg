import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:ride_swg/core/theme/app_theme.dart';
import 'package:ride_swg/features/mod_builder/data/mod_options_data.dart';

class PaintWrapSelector extends StatelessWidget {
  const PaintWrapSelector({
    super.key,
    required this.selectedPaint,
    required this.onSelectPaint,
    required this.tintLevel,
    required this.onTintChanged,
  });

  final PaintColorOption selectedPaint;
  final ValueChanged<PaintColorOption> onSelectPaint;
  final double tintLevel;
  final ValueChanged<double> onTintChanged;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // ─── Current Selection Card ──────────────────────────
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surfaceElevated,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: selectedPaint.color.withValues(alpha: 0.5),
              width: 1.5,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: selectedPaint.color,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: selectedPaint.color.withValues(alpha: 0.4),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                  border: Border.all(color: Colors.white24, width: 1.5),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      selectedPaint.name,
                      style: AppTextStyles.labelLarge.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${selectedPaint.finishLabel} • ${selectedPaint.filmType}',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: 11,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '\$${selectedPaint.price.toInt()} • ~${selectedPaint.laborHours.toInt()}h install',
                      style: AppTextStyles.labelSmall.copyWith(
                        color: AppColors.gold,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),

        // ─── Paint & Wrap Palette ────────────────────────────
        Text(
          'COLOR & WRAP PALETTE',
          style: AppTextStyles.labelSmall.copyWith(letterSpacing: 1.5),
        ),
        const SizedBox(height: 12),

        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.1,
          ),
          itemCount: PaintColorOption.curatedColors.length,
          itemBuilder: (context, index) {
            final option = PaintColorOption.curatedColors[index];
            final isSelected = option.name == selectedPaint.name;

            return GestureDetector(
              onTap: () => onSelectPaint(option),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.surfaceElevated
                      : AppColors.cardBg,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isSelected
                        ? option.color
                        : AppColors.border,
                    width: isSelected ? 2 : 0.8,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: option.color.withValues(alpha: 0.35),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          )
                        ]
                      : null,
                ),
                padding: const EdgeInsets.all(8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: option.color,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white30, width: 1),
                          ),
                        ),
                        if (isSelected)
                          const Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 16,
                          ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      option.name,
                      style: AppTextStyles.labelSmall.copyWith(
                        fontSize: 10,
                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                        color: isSelected ? AppColors.textPrimary : AppColors.textSecondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      option.finishLabel.split(' ').first,
                      style: AppTextStyles.bodySmall.copyWith(
                        fontSize: 9,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ).animate(delay: (index * 25).ms).fadeIn().scale(begin: const Offset(0.95, 0.95));
          },
        ),

        const SizedBox(height: 24),

        // ─── Window Tint Slider ──────────────────────────────
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'CERAMIC WINDOW TINT',
              style: AppTextStyles.labelSmall.copyWith(letterSpacing: 1.5),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.surfaceElevated,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: AppColors.border),
              ),
              child: Text(
                '${tintLevel.round()}% VLT',
                style: AppTextStyles.labelMedium.copyWith(
                  color: AppColors.gold,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),

        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.surfaceElevated,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.border, width: 0.8),
          ),
          child: Column(
            children: [
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: 6,
                  thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
                  activeTrackColor: AppColors.primary,
                  inactiveTrackColor: AppColors.surfaceHighlight,
                  thumbColor: AppColors.primary,
                  overlayColor: AppColors.primaryGlow,
                ),
                child: Slider(
                  value: tintLevel,
                  onChanged: onTintChanged,
                  min: 0,
                  max: 95,
                  divisions: 19,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Clear (0%)', style: AppTextStyles.bodySmall.copyWith(fontSize: 10)),
                  Text('Street (35%)', style: AppTextStyles.bodySmall.copyWith(fontSize: 10)),
                  Text('Limo (95%)', style: AppTextStyles.bodySmall.copyWith(fontSize: 10)),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
