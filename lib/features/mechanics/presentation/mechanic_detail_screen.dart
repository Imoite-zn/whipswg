import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:ride_swg/core/theme/app_theme.dart';
import 'package:ride_swg/features/mechanics/data/mechanic_model.dart';
import 'package:shimmer/shimmer.dart';

class MechanicDetailScreen extends StatefulWidget {
  const MechanicDetailScreen({super.key, required this.mechanic});
  final MechanicModel mechanic;

  @override
  State<MechanicDetailScreen> createState() => _MechanicDetailScreenState();
}

class _MechanicDetailScreenState extends State<MechanicDetailScreen> {
  final _quoteCtrl = TextEditingController();

  @override
  void dispose() {
    _quoteCtrl.dispose();
    super.dispose();
  }

  MechanicModel get m => widget.mechanic;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // ── Collapsing Banner ────────────────────────────────────────────────
          SliverAppBar(
            expandedHeight: 220,
            pinned: true,
            backgroundColor: AppColors.background,
            leading: IconButton(
              onPressed: () => context.pop(),
              icon: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.background.withValues(alpha: 0.7),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.border),
                ),
                child: const Icon(Icons.arrow_back_ios_new, size: 14, color: AppColors.textPrimary),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  CachedNetworkImage(
                    imageUrl: m.bannerUrl,
                    fit: BoxFit.cover,
                    placeholder: (_, __) => Shimmer.fromColors(
                      baseColor: AppColors.surfaceElevated,
                      highlightColor: AppColors.surfaceHighlight,
                      child: Container(color: AppColors.surfaceElevated),
                    ),
                    errorWidget: (_, __, ___) => Container(
                      color: AppColors.surfaceElevated,
                      child: const Icon(Icons.store, color: AppColors.textMuted, size: 48),
                    ),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.transparent, AppColors.background],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Shop identity + quick stats ──────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // Avatar
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: m.isVerified ? AppColors.gold : AppColors.border,
                            width: 2.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: m.isVerified ? AppColors.goldGlow : Colors.transparent,
                              blurRadius: 16,
                            ),
                          ],
                        ),
                        child: ClipOval(
                          child: CachedNetworkImage(
                            imageUrl: m.avatarUrl,
                            width: 64,
                            height: 64,
                            fit: BoxFit.cover,
                            errorWidget: (_, __, ___) => Container(
                              color: AppColors.surfaceElevated,
                              child: const Icon(Icons.person, color: AppColors.textMuted),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Flexible(
                                  child: Text(
                                    m.shopName,
                                    style: AppTextStyles.headlineMedium.copyWith(fontSize: 19),
                                    maxLines: 2,
                                  ),
                                ),
                                if (m.isVerified) ...[
                                  const SizedBox(width: 6),
                                  const Icon(Icons.verified, size: 18, color: AppColors.gold),
                                ],
                              ],
                            ),
                            Text(
                              m.ownerName,
                              style: AppTextStyles.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Quick stats row
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: AppColors.cardBg,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.border, width: 0.5),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _QuickStat(
                          icon: Icons.star,
                          iconColor: AppColors.gold,
                          value: m.rating.toStringAsFixed(1),
                          label: '${m.reviewCount} reviews',
                        ),
                        _VDivider(),
                        _QuickStat(
                          icon: Icons.work_history,
                          iconColor: AppColors.primary,
                          value: '${m.yearsInBusiness}yr',
                          label: 'in business',
                        ),
                        _VDivider(),
                        _QuickStat(
                          icon: Icons.attach_money,
                          iconColor: const Color(0xFF22C55E),
                          value: '\$${m.laborRatePerHour.toInt()}',
                          label: 'per hour',
                        ),
                        _VDivider(),
                        _QuickStat(
                          icon: Icons.timer_outlined,
                          iconColor: const Color(0xFF38BDF8),
                          value: '~${m.responseTimeHours}h',
                          label: 'response',
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Location
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 16, color: AppColors.primary),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          '${m.location}, ${m.city} · ${m.distanceKm.toStringAsFixed(1)} km from you',
                          style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                        ),
                      ),
                    ],
                  ),

                  // Certifications
                  if (m.isAseCertified) ...[
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.workspace_premium, size: 15, color: AppColors.gold),
                        const SizedBox(width: 6),
                        Text(
                          'ASE Certified Technicians',
                          style: AppTextStyles.bodySmall.copyWith(color: AppColors.gold),
                        ),
                      ],
                    ),
                  ],

                  const SizedBox(height: 24),
                ].animate(interval: 50.ms).fadeIn(duration: 300.ms),
              ),
            ),
          ),

          // ── Services Section ─────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SectionTitle(title: 'Services Offered'),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: m.services.map((s) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                        decoration: BoxDecoration(
                          color: s.serviceColor.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: s.serviceColor.withValues(alpha: 0.45)),
                        ),
                        child: Text(
                          s,
                          style: TextStyle(
                            color: s.serviceColor,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),
                  _SectionTitle(title: 'Specializations'),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: m.specializations.map((s) => Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                      decoration: BoxDecoration(
                        color: AppColors.primaryGlow,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColors.primary.withValues(alpha: 0.4)),
                      ),
                      child: Text(
                        s,
                        style: const TextStyle(
                          color: AppColors.primaryLight,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    )).toList(),
                  ),
                  const SizedBox(height: 28),
                ],
              ),
            ),
          ),

          // ── Reviews ──────────────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SectionTitle(title: 'Customer Reviews'),
                  const SizedBox(height: 4),
                  _RatingBreakdownBar(rating: m.rating, reviewCount: m.reviewCount),
                  const SizedBox(height: 16),
                  ...m.reviews.asMap().entries.map((entry) =>
                    _ReviewCard(review: entry.value, index: entry.key),
                  ),
                  const SizedBox(height: 28),
                ],
              ),
            ),
          ),

          // ── Send Build Quote ─────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SectionTitle(title: 'Send Build for Quote'),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.cardBg,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Describe your build requirements',
                          style: AppTextStyles.bodyMedium,
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _quoteCtrl,
                          maxLines: 4,
                          style: AppTextStyles.bodyLarge.copyWith(fontSize: 14),
                          decoration: const InputDecoration(
                            hintText:
                                'e.g. Install Pandem V3 widebody on my Nissan GT-R, Akrapovic exhaust, and TE37 wheels. Need quote for labor and lead time.',
                          ),
                        ),
                        const SizedBox(height: 14),
                        ElevatedButton.icon(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  '📤 Quote request sent to ${m.shopName}!',
                                ),
                                backgroundColor: AppColors.success,
                              ),
                            );
                            _quoteCtrl.clear();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.gold,
                            minimumSize: const Size(double.infinity, 52),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          icon: const Icon(Icons.send, color: Colors.black, size: 18),
                          label: const Text(
                            'SEND QUOTE REQUEST',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.2,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Shared small widgets ──────────────────────────────────────────────────────

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(width: 3, height: 18, decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(2),
        )),
        const SizedBox(width: 10),
        Text(title, style: AppTextStyles.headlineSmall.copyWith(fontSize: 16)),
      ],
    );
  }
}

class _VDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      Container(width: 0.5, height: 30, color: AppColors.border);
}

class _QuickStat extends StatelessWidget {
  const _QuickStat({
    required this.icon,
    required this.iconColor,
    required this.value,
    required this.label,
  });

  final IconData icon;
  final Color iconColor;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: iconColor),
        const SizedBox(height: 4),
        Text(
          value,
          style: AppTextStyles.labelLarge.copyWith(
            color: iconColor,
            fontSize: 14,
            fontWeight: FontWeight.w800,
          ),
        ),
        Text(label, style: AppTextStyles.labelSmall.copyWith(fontSize: 9)),
      ],
    );
  }
}

class _RatingBreakdownBar extends StatelessWidget {
  const _RatingBreakdownBar({required this.rating, required this.reviewCount});
  final double rating;
  final int reviewCount;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              rating.toStringAsFixed(1),
              style: AppTextStyles.accentLarge.copyWith(fontSize: 42),
            ),
            Row(
              children: List.generate(5, (i) {
                final filled = i < rating.floor();
                final half = !filled && i < rating;
                return Icon(
                  filled ? Icons.star : (half ? Icons.star_half : Icons.star_outline),
                  size: 14,
                  color: AppColors.gold,
                );
              }),
            ),
            const SizedBox(height: 2),
            Text('$reviewCount reviews', style: AppTextStyles.bodySmall),
          ],
        ),
        const SizedBox(width: 20),
        Expanded(
          child: Column(
            children: [5, 4, 3, 2, 1].map((star) {
              // Fake distribution based on rating
              final frac = star == 5
                  ? 0.70 * (rating / 5)
                  : star == 4
                      ? 0.20
                      : star == 3
                          ? 0.07
                          : 0.03;
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Row(
                  children: [
                    Text(
                      '$star',
                      style: AppTextStyles.labelSmall.copyWith(color: AppColors.gold),
                    ),
                    const SizedBox(width: 6),
                    const Icon(Icons.star, size: 10, color: AppColors.gold),
                    const SizedBox(width: 6),
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: frac,
                          backgroundColor: AppColors.surfaceElevated,
                          valueColor: const AlwaysStoppedAnimation<Color>(AppColors.gold),
                          minHeight: 5,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class _ReviewCard extends StatelessWidget {
  const _ReviewCard({required this.review, required this.index});
  final MechanicReview review;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Initials avatar
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.primaryGlow,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    review.authorName[0],
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w800,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review.authorName,
                      style: AppTextStyles.labelLarge.copyWith(fontSize: 13),
                    ),
                    Text(
                      review.carName,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.gold,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(
                      5,
                      (i) => Icon(
                        i < review.rating.floor() ? Icons.star : Icons.star_outline,
                        size: 12,
                        color: AppColors.gold,
                      ),
                    ),
                  ),
                  Text(review.date, style: AppTextStyles.labelSmall.copyWith(fontSize: 9)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            '"${review.comment}"',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
              fontStyle: FontStyle.italic,
              height: 1.5,
            ),
          ),
        ],
      ),
    ).animate(delay: (index * 80).ms).fadeIn(duration: 350.ms).slideY(begin: 0.1, end: 0);
  }
}
