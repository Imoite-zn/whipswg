import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:ride_swg/core/theme/app_theme.dart';

class ModCatalogScreen extends StatefulWidget {
  const ModCatalogScreen({super.key});

  @override
  State<ModCatalogScreen> createState() => _ModCatalogScreenState();
}

class _ModCatalogScreenState extends State<ModCatalogScreen> {
  String _selectedTag = 'All';
  final _searchCtrl = TextEditingController();

  final _tags = ['All', 'Engine', 'Suspension', 'Aero', 'Wheels', 'Interior'];

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // ─── Header ─────────────────────────────────────
          SliverToBoxAdapter(
            child: _CatalogHeader(),
          ),

          // ─── Search bar ─────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: TextField(
                controller: _searchCtrl,
                style: AppTextStyles.bodyLarge,
                decoration: InputDecoration(
                  hintText: 'Search parts & mods...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: const Icon(Icons.tune),
                ),
              ),
            ),
          ),

          // ─── Tag filter ─────────────────────────────────
          SliverToBoxAdapter(
            child: SizedBox(
              height: 48,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: _tags.length,
                separatorBuilder: (_, __) => const SizedBox(width: 10),
                itemBuilder: (_, i) {
                  final tag = _tags[i];
                  final isActive = tag == _selectedTag;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedTag = tag),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: isActive
                            ? AppColors.gold
                            : AppColors.surfaceElevated,
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(
                          color: isActive
                              ? AppColors.gold
                              : AppColors.border,
                        ),
                      ),
                      child: Text(
                        tag,
                        style: AppTextStyles.labelMedium.copyWith(
                          color: isActive
                              ? Colors.black
                              : AppColors.textSecondary,
                          fontWeight: isActive
                              ? FontWeight.w700
                              : FontWeight.w600,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          // ─── Featured Banner ─────────────────────────────
          SliverToBoxAdapter(
            child: _FeaturedBanner(),
          ),

          // ─── Section Title ───────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
              child: Text('Popular Parts', style: AppTextStyles.headlineSmall),
            ),
          ),

          // ─── Mod Parts Grid ──────────────────────────────
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 14,
                crossAxisSpacing: 14,
                childAspectRatio: 0.80,
              ),
              delegate: SliverChildBuilderDelegate(
                (ctx, i) => _ModPartCard(part: _demoMods[i], index: i),
                childCount: _demoMods.length,
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 32)),
        ],
      ),
    );
  }
}

// ─── Header ──────────────────────────────────────────────────────────────────

class _CatalogHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 20,
        left: 20,
        right: 20,
        bottom: 16,
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Mod Parts', style: AppTextStyles.headlineLarge),
              const SizedBox(height: 2),
              Text(
                'Premium aftermarket catalog',
                style: AppTextStyles.bodyMedium,
              ),
            ],
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              gradient: AppColors.goldGradient,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text(
              'COMPARE',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w800,
                fontSize: 11,
                letterSpacing: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Featured Banner ─────────────────────────────────────────────────────────

class _FeaturedBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [Color(0xFF1A0505), Color(0xFF2D1010), Color(0xFF1A0505)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        border: Border.all(color: AppColors.primaryDark, width: 0.5),
        boxShadow: const [
          BoxShadow(
            color: AppColors.primaryGlow,
            blurRadius: 20,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      'FEATURED',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Akrapovic\nExhaust System',
                    style: AppTextStyles.headlineSmall.copyWith(
                      fontSize: 16,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 6),
                  ShaderMask(
                    shaderCallback: (b) =>
                        AppColors.goldGradient.createShader(b),
                    child: const Text(
                      '\$2,499',
                      style: TextStyle(
                        fontFamily: 'Rajdhani',
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            const Icon(
              Icons.whatshot,
              size: 64,
              color: Color(0x30D62828),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(delay: 200.ms).slideX(begin: -0.1, end: 0);
  }
}

// ─── Mod Part Card ────────────────────────────────────────────────────────────

class _ModPartCard extends StatelessWidget {
  const _ModPartCard({required this.part, required this.index});
  final _ModPart part;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon section
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.surfaceElevated,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(18),
                ),
                gradient: LinearGradient(
                  colors: [
                    part.color.withValues(alpha: 0.1),
                    AppColors.surfaceElevated,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Center(
                child: Icon(
                  part.icon,
                  size: 52,
                  color: part.color.withValues(alpha: 0.85),
                ),
              ),
            ),
          ),

          // Info section
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  part.brand,
                  style: AppTextStyles.labelSmall.copyWith(
                    color: part.color,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  part.name,
                  style: AppTextStyles.bodyLarge.copyWith(fontSize: 13),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    ShaderMask(
                      shaderCallback: (b) =>
                          AppColors.goldGradient.createShader(b),
                      child: Text(
                        part.price,
                        style: const TextStyle(
                          fontFamily: 'Rajdhani',
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.add,
                        size: 16,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate(delay: (60 * index).ms).fadeIn().slideY(begin: 0.15, end: 0);
  }
}

// ─── Demo Data ────────────────────────────────────────────────────────────────

class _ModPart {
  const _ModPart({
    required this.name,
    required this.brand,
    required this.price,
    required this.icon,
    required this.color,
  });
  final String name;
  final String brand;
  final String price;
  final IconData icon;
  final Color color;
}

final _demoMods = [
  const _ModPart(
    name: 'Cold Air Intake',
    brand: 'K&N',
    price: '\$349',
    icon: Icons.air,
    color: Color(0xFF1565C0),
  ),
  const _ModPart(
    name: 'Sport Coilovers',
    brand: 'KW Suspension',
    price: '\$1,899',
    icon: Icons.compress,
    color: AppColors.gold,
  ),
  const _ModPart(
    name: 'Wide Arch Kit',
    brand: 'Rocket Bunny',
    price: '\$3,200',
    icon: Icons.car_crash,
    color: AppColors.primary,
  ),
  const _ModPart(
    name: 'Forged Wheels 18"',
    brand: 'Vossen',
    price: '\$2,100',
    icon: Icons.album,
    color: Color(0xFF546E7A),
  ),
  const _ModPart(
    name: 'Turbo Upgrade',
    brand: 'HKS',
    price: '\$4,500',
    icon: Icons.settings_input_svideo,
    color: AppColors.primary,
  ),
  const _ModPart(
    name: 'Carbon Splitter',
    brand: 'Seibon',
    price: '\$899',
    icon: Icons.call_split,
    color: Color(0xFF37474F),
  ),
];
