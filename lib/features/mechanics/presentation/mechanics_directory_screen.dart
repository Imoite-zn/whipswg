import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:ride_swg/core/theme/app_theme.dart';
import 'package:ride_swg/features/mechanics/data/mechanic_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';

class MechanicsDirectoryScreen extends StatefulWidget {
  const MechanicsDirectoryScreen({super.key});

  @override
  State<MechanicsDirectoryScreen> createState() => _MechanicsDirectoryScreenState();
}

class _MechanicsDirectoryScreenState extends State<MechanicsDirectoryScreen> {
  String _sortBy = 'Nearest';
  final _sortOptions = ['Nearest', 'Top Rated', 'Most Reviews', 'Price: Low'];
  final _searchCtrl = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  List<MechanicModel> get _sorted {
    final query = _searchQuery.toLowerCase();
    var list = MechanicModel.demo.where((m) {
      if (query.isEmpty) return true;
      return m.shopName.toLowerCase().contains(query) ||
          m.city.toLowerCase().contains(query) ||
          m.specializations.any((s) => s.toLowerCase().contains(query)) ||
          m.services.any((s) => s.toLowerCase().contains(query));
    }).toList();

    switch (_sortBy) {
      case 'Top Rated':
        list.sort((a, b) => b.rating.compareTo(a.rating));
      case 'Most Reviews':
        list.sort((a, b) => b.reviewCount.compareTo(a.reviewCount));
      case 'Price: Low':
        list.sort((a, b) => a.laborRatePerHour.compareTo(b.laborRatePerHour));
      default: // Nearest
        list.sort((a, b) => a.distanceKm.compareTo(b.distanceKm));
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // ── Header ──────────────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: _MechanicsHeader(),
          ),

          // ── Search bar ──────────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: TextField(
                controller: _searchCtrl,
                onChanged: (v) => setState(() => _searchQuery = v),
                style: AppTextStyles.bodyLarge.copyWith(fontSize: 14),
                decoration: InputDecoration(
                  hintText: 'Search shops, city, or specialty…',
                  prefixIcon: const Icon(Icons.search, size: 20),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.close, size: 18),
                          onPressed: () {
                            _searchCtrl.clear();
                            setState(() => _searchQuery = '');
                          },
                        )
                      : null,
                ),
              ),
            ),
          ),

          // ── Sort chips ───────────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: SizedBox(
              height: 38,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _sortOptions.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (_, i) {
                  final opt = _sortOptions[i];
                  final isActive = opt == _sortBy;
                  return GestureDetector(
                    onTap: () => setState(() => _sortBy = opt),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 220),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: isActive ? AppColors.primary : AppColors.surfaceElevated,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isActive ? AppColors.primary : AppColors.border,
                        ),
                      ),
                      child: Text(
                        opt,
                        style: AppTextStyles.labelMedium.copyWith(
                          color: isActive ? Colors.white : AppColors.textSecondary,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 16)),

          // ── Results count ────────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Text(
                    '${_sorted.length} workshop${_sorted.length != 1 ? "s" : ""} found',
                    style: AppTextStyles.bodySmall.copyWith(color: AppColors.textMuted),
                  ),
                  const Spacer(),
                  // Mechanic portal entry point
                  GestureDetector(
                    onTap: () => context.push('/mechanics/portal'),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: AppColors.goldGlow,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.gold.withValues(alpha: 0.5)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.handyman, size: 12, color: AppColors.gold),
                          const SizedBox(width: 5),
                          Text(
                            'LIST YOUR SHOP',
                            style: AppTextStyles.labelSmall.copyWith(
                              color: AppColors.gold,
                              fontSize: 9,
                              letterSpacing: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 12)),

          // ── Mechanic Cards ────────────────────────────────────────────────────
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverList.separated(
              itemCount: _sorted.length,
              separatorBuilder: (_, __) => const SizedBox(height: 14),
              itemBuilder: (_, i) => _MechanicCard(
                mechanic: _sorted[i],
                index: i,
                onTap: () => context.push('/mechanics/${_sorted[i].id}', extra: _sorted[i]),
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 40)),
        ],
      ),
    );
  }
}

// ─── Header ───────────────────────────────────────────────────────────────────

class _MechanicsHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 20,
        left: 20,
        right: 20,
        bottom: 20,
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF1A1200), AppColors.background],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShaderMask(
            shaderCallback: (b) => AppColors.goldGradient.createShader(b),
            child: Text(
              'Find Mechanics',
              style: AppTextStyles.headlineLarge.copyWith(color: Colors.white),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Verified workshops near you — rated by the community',
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}

// ─── Mechanic Card ─────────────────────────────────────────────────────────────

class _MechanicCard extends StatefulWidget {
  const _MechanicCard({
    required this.mechanic,
    required this.index,
    required this.onTap,
  });

  final MechanicModel mechanic;
  final int index;
  final VoidCallback onTap;

  @override
  State<_MechanicCard> createState() => _MechanicCardState();
}

class _MechanicCardState extends State<_MechanicCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final m = widget.mechanic;
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.cardBg,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: m.isVerified ? AppColors.gold.withValues(alpha: 0.3) : AppColors.border,
              width: m.isVerified ? 1 : 0.5,
            ),
            boxShadow: [
              BoxShadow(
                color: m.isTopRated
                    ? AppColors.gold.withValues(alpha: 0.12)
                    : Colors.black.withValues(alpha: 0.3),
                blurRadius: 20,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            children: [
              // ── Banner ──────────────────────────────────────────────────────
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                child: SizedBox(
                  height: 110,
                  width: double.infinity,
                  child: Stack(
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
                          child: const Icon(Icons.store, color: AppColors.textMuted, size: 36),
                        ),
                      ),
                      Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.transparent, Color(0xCC181818)],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      ),
                      // Badges
                      Positioned(
                        top: 10,
                        right: 10,
                        child: Row(
                          children: [
                            if (m.isTopRated)
                              _Badge(label: '⭐ TOP RATED', color: AppColors.gold, textColor: Colors.black),
                            if (m.isTopRated && m.isVerified) const SizedBox(width: 6),
                            if (m.isVerified)
                              _Badge(label: '✓ VERIFIED', color: AppColors.success, textColor: Colors.white),
                          ],
                        ),
                      ),
                      // Distance
                      Positioned(
                        bottom: 10,
                        left: 12,
                        child: Text(
                          '${m.distanceKm.toStringAsFixed(1)} km away',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // ── Content ──────────────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Avatar + Info row
                    Row(
                      children: [
                        ClipOval(
                          child: CachedNetworkImage(
                            imageUrl: m.avatarUrl,
                            width: 44,
                            height: 44,
                            fit: BoxFit.cover,
                            placeholder: (_, __) => Container(
                              color: AppColors.surfaceElevated,
                              child: const Icon(Icons.person, color: AppColors.textMuted),
                            ),
                            errorWidget: (_, __, ___) => Container(
                              color: AppColors.surfaceElevated,
                              child: const Icon(Icons.person, color: AppColors.textMuted),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                m.shopName,
                                style: AppTextStyles.headlineSmall.copyWith(fontSize: 15),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                m.ownerName,
                                style: AppTextStyles.bodySmall.copyWith(color: AppColors.textMuted),
                              ),
                            ],
                          ),
                        ),
                        // Rating
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.star, size: 14, color: AppColors.gold),
                                const SizedBox(width: 3),
                                Text(
                                  m.rating.toStringAsFixed(1),
                                  style: AppTextStyles.labelLarge.copyWith(
                                    color: AppColors.gold,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              '${m.reviewCount} reviews',
                              style: AppTextStyles.labelSmall.copyWith(fontSize: 9),
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // Location row
                    Row(
                      children: [
                        const Icon(Icons.location_on_outlined, size: 13, color: AppColors.textMuted),
                        const SizedBox(width: 4),
                        Text(
                          '${m.location}, ${m.city}',
                          style: AppTextStyles.bodySmall.copyWith(fontSize: 11),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    // Services chips
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: m.services.take(3).map((s) {
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: s.serviceColor.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: s.serviceColor.withValues(alpha: 0.4)),
                          ),
                          child: Text(
                            s,
                            style: TextStyle(
                              color: s.serviceColor,
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        );
                      }).toList()
                        ..addAll(m.services.length > 3
                            ? [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: AppColors.surfaceHighlight,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    '+${m.services.length - 3} more',
                                    style: const TextStyle(
                                      color: AppColors.textMuted,
                                      fontSize: 9,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ]
                            : []),
                    ),

                    const SizedBox(height: 12),

                    // Footer: rate + response time + CTA
                    Row(
                      children: [
                        Icon(Icons.access_time, size: 12, color: AppColors.textMuted),
                        const SizedBox(width: 4),
                        Text(
                          'Responds in ~${m.responseTimeHours}h',
                          style: AppTextStyles.labelSmall.copyWith(fontSize: 10),
                        ),
                        const Spacer(),
                        Text(
                          '\$${m.laborRatePerHour.toInt()}/hr',
                          style: AppTextStyles.labelLarge.copyWith(
                            color: AppColors.gold,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            gradient: AppColors.primaryGradient,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            'VIEW',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ).animate(delay: (widget.index * 60).ms).fadeIn(duration: 350.ms).slideY(begin: 0.12, end: 0),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.label, required this.color, required this.textColor});
  final String label;
  final Color color;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: textColor,
          fontSize: 8,
          fontWeight: FontWeight.w900,
          letterSpacing: 0.6,
        ),
      ),
    );
  }
}
