import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:ride_swg/core/theme/app_theme.dart';
import 'package:ride_swg/features/mod_builder/data/mod_options_data.dart';

class BodyPartsSelector extends StatefulWidget {
  const BodyPartsSelector({
    super.key,
    required this.selectedPackage,
    required this.onSelectPackage,
    required this.selectedParts,
    required this.onTogglePart,
  });

  final BodyKitPackage selectedPackage;
  final ValueChanged<BodyKitPackage> onSelectPackage;
  final Map<String, ModularBodyPart> selectedParts;
  final void Function(String slot, ModularBodyPart part) onTogglePart;

  @override
  State<BodyPartsSelector> createState() => _BodyPartsSelectorState();
}

class _BodyPartsSelectorState extends State<BodyPartsSelector> {
  int _activeCategoryIndex = 0; // 0: Body Packages, 1: Add-on Modular Parts

  final _slots = ['Front Splitter', 'Side Skirts', 'Rear Diffuser', 'Hood', 'Spoiler'];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Sub-toggle: Full Kits vs Modular Add-ons
        Container(
          margin: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: AppColors.surfaceElevated,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border, width: 0.8),
          ),
          child: Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _activeCategoryIndex = 0),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: _activeCategoryIndex == 0
                          ? AppColors.primary
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        'BODY KITS / PACKAGES',
                        style: TextStyle(
                          color: _activeCategoryIndex == 0
                              ? Colors.white
                              : AppColors.textSecondary,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _activeCategoryIndex = 1),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: _activeCategoryIndex == 1
                          ? AppColors.primary
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        'MODULAR ADD-ONS',
                        style: TextStyle(
                          color: _activeCategoryIndex == 1
                              ? Colors.white
                              : AppColors.textSecondary,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        Expanded(
          child: _activeCategoryIndex == 0
              ? _buildBodyPackagesList()
              : _buildModularPartsList(),
        ),
      ],
    );
  }

  Widget _buildBodyPackagesList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: BodyKitPackage.packages.length,
      itemBuilder: (context, index) {
        final pkg = BodyKitPackage.packages[index];
        final isSelected = pkg.id == widget.selectedPackage.id;

        return GestureDetector(
          onTap: () => widget.onSelectPackage(pkg),
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.surfaceElevated
                  : AppColors.cardBg,
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
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.surfaceHighlight,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        pkg.bodyType,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        pkg.manufacturer,
                        style: AppTextStyles.labelSmall.copyWith(
                          color: AppColors.gold,
                          fontSize: 11,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (isSelected) ...[
                      const SizedBox(width: 8),
                      const Icon(Icons.check_circle, color: AppColors.primary, size: 20),
                    ],
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  pkg.name,
                  style: AppTextStyles.headlineSmall.copyWith(fontSize: 16),
                ),
                const SizedBox(height: 6),
                // Specs details
                Row(
                  children: [
                    Icon(Icons.straighten, size: 14, color: AppColors.textMuted),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        pkg.measurements,
                        style: AppTextStyles.bodySmall.copyWith(fontSize: 11),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      pkg.price == 0 ? 'STOCK' : '\$${pkg.price.toInt()}',
                      style: AppTextStyles.labelLarge.copyWith(
                        color: AppColors.gold,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.build_circle_outlined, size: 14, color: AppColors.primary),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          'Req: ${pkg.fitmentRequirements}',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                            fontSize: 10,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '~${pkg.laborHours.toInt()}h',
                        style: AppTextStyles.labelSmall.copyWith(
                          color: AppColors.textPrimary,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ).animate(delay: (index * 40).ms).fadeIn().slideY(begin: 0.1, end: 0);
      },
    );
  }

  Widget _buildModularPartsList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _slots.length,
      itemBuilder: (context, slotIndex) {
        final slot = _slots[slotIndex];
        final partsForSlot = ModularBodyPart.allParts.where((p) => p.slot == slot).toList();
        final selectedPart = widget.selectedParts[slot] ?? partsForSlot.first;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  Icon(Icons.tune, size: 14, color: AppColors.gold),
                  const SizedBox(width: 6),
                  Text(
                    slot.toUpperCase(),
                    style: AppTextStyles.labelSmall.copyWith(
                      color: AppColors.gold,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      selectedPart.name,
                      textAlign: TextAlign.end,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textPrimary,
                        fontSize: 11,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            ...partsForSlot.map((part) {
              final isSelected = selectedPart.id == part.id;
              return GestureDetector(
                onTap: () => widget.onTogglePart(slot, part),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.surfaceElevated
                        : AppColors.cardBg,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected ? AppColors.primary : AppColors.border,
                      width: isSelected ? 1.2 : 0.6,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primaryGlow
                              : AppColors.surfaceHighlight,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          isSelected ? Icons.check : Icons.add,
                          size: 16,
                          color: isSelected ? AppColors.primary : AppColors.textMuted,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              part.name,
                              style: AppTextStyles.labelMedium.copyWith(
                                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${part.material} • ${part.specs}',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.textSecondary,
                                fontSize: 10,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        part.price == 0 ? 'FREE' : '\$${part.price.toInt()}',
                        style: AppTextStyles.labelMedium.copyWith(
                          color: AppColors.gold,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
            const SizedBox(height: 8),
          ],
        );
      },
    );
  }
}
