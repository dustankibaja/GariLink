import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/theme.dart';
import '../../../authentication/presentation/providers/auth_provider.dart';
import '../../../booking/presentation/pages/transport_need_form.dart';
import '../../../explore/domain/discovery_selection.dart';
import '../../../location/data/device_location_service.dart';
import '../../../location/domain/models/gari_location.dart';
import '../../../trips/domain/models/transport_need.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key, this.currentLocation});

  final Future<DeviceLocationResult> Function()? currentLocation;
  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final _needKey = GlobalKey<TransportNeedFormState>();
  SearchLocation _searchLocation = const SearchLocation();
  bool _locating = false;

  Future<void> _useCurrentLocation() async {
    setState(() => _locating = true);
    final result =
        await (widget.currentLocation?.call() ??
            const DeviceLocationService().currentLocation());
    if (!mounted) return;
    setState(() => _locating = false);
    if (result is DeviceLocationSuccess) {
      setState(
        () => _searchLocation = SearchLocation(location: result.location),
      );
    } else if (result is DeviceLocationUnavailable) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(result.message)));
    }
  }

  Future<void> _chooseArea() async {
    final selected = await showModalBottomSheet<GariLocation>(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => const _AreaPicker(),
    );
    if (selected != null && mounted) {
      setState(() => _searchLocation = SearchLocation(location: selected));
    }
  }

  void _findVehicles() {
    final state = _needKey.currentState;
    if (state == null || !state.validate() || state.need == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Choose what you need transport for.')),
      );
      return;
    }
    if (_searchLocation.location?.latitude == null ||
        _searchLocation.location?.longitude == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Choose where you need the vehicle.')),
      );
      return;
    }
    _openExplore(state.need!);
  }

  void _openExplore(TransportNeed need) => context.go(
    '/explore',
    extra: DiscoverySearchIntent(need: need, searchLocation: _searchLocation),
  );

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(authStateProvider).user?.profile;
    final name = profile?.firstName?.trim().isNotEmpty == true
        ? profile!.firstName!.trim()
        : profile?.fullName.trim().isNotEmpty == true
        ? profile!.fullName.trim()
        : 'GariLink member';
    final bottomClearance =
        MediaQuery.paddingOf(context).bottom +
        GariLinkDimensions.bottomNavigationHeight +
        28 +
        GariLinkSpacing.md;
    return Scaffold(
      backgroundColor: GariLinkColors.background,
      body: SafeArea(
        child: CustomScrollView(
          key: const Key('renter-home-scroll'),
          slivers: [
            SliverToBoxAdapter(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 680),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                      GariLinkSpacing.lg,
                      GariLinkSpacing.lg,
                      GariLinkSpacing.lg,
                      bottomClearance,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _Header(name: name),
                        const SizedBox(height: 20),
                        const _VehicleHero(),
                        const SizedBox(height: 24),
                        _Surface(
                          tint: GariLinkColors.surface,
                          child: TransportNeedForm(
                            key: _needKey,
                            variant: TransportNeedFormVariant.home,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _Surface(
                          tint: GariLinkColors.surface,
                          child: _locationContent,
                        ),
                        const SizedBox(height: 24),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Popular for you',
                                style: GariLinkTypography.titleLarge,
                              ),
                            ),
                            TextButton(
                              key: const Key('popular-see-all'),
                              onPressed: () => context.go('/explore'),
                              child: const Text('See all'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          height:
                              200 +
                              (MediaQuery.textScalerOf(context).scale(100) -
                                          100)
                                      .clamp(0, 100) *
                                  2.6,
                          child: ListView.separated(
                            key: const Key('popular-category-list'),
                            scrollDirection: Axis.horizontal,
                            itemCount: _popularCategories.length,
                            separatorBuilder: (_, _) =>
                                const SizedBox(width: 12),
                            itemBuilder: (_, index) => _PopularCard(
                              item: _popularCategories[index],
                              onTap: () =>
                                  _openExplore(_popularCategories[index].need),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget get _locationContent => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Wrap(
        alignment: WrapAlignment.spaceBetween,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 8,
        runSpacing: 4,
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 340),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Where do you need it?',
                  style: GariLinkTypography.titleLarge,
                ),
                const SizedBox(height: 4),
                Text(
                  'Choose an area or use your current location.',
                  style: GariLinkTypography.bodyMedium,
                ),
              ],
            ),
          ),
          TextButton.icon(
            key: const Key('use-current-location'),
            onPressed: _locating ? null : _useCurrentLocation,
            icon: _locating
                ? const SizedBox.square(
                    dimension: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const GariIcon(GariLinkIcons.myLocation, size: 18),
            label: const Text('Use my location'),
          ),
        ],
      ),
      const SizedBox(height: 16),
      Semantics(
        button: true,
        label: 'Choose area. Current selection: $_locationLabel',
        child: InkWell(
          key: const Key('manual-location-field'),
          borderRadius: BorderRadius.circular(GariLinkRadius.input),
          onTap: _chooseArea,
          child: Container(
            constraints: const BoxConstraints(minHeight: 56),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: GariLinkColors.neutral50,
              borderRadius: BorderRadius.circular(GariLinkRadius.input),
              border: Border.all(color: GariLinkColors.border),
            ),
            child: Row(
              children: [
                const GariIcon(
                  GariLinkIcons.location,
                  color: GariLinkColors.accent,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _locationLabel,
                    style: GariLinkTypography.bodyMedium.copyWith(
                      color: _searchLocation.location == null
                          ? GariLinkColors.textMuted
                          : GariLinkColors.textPrimary,
                    ),
                  ),
                ),
                const GariIcon(
                  GariLinkIcons.chevronRight,
                  color: GariLinkColors.textMuted,
                ),
              ],
            ),
          ),
        ),
      ),
      const SizedBox(height: 16),
      FilledButton.icon(
        key: const Key('find-vehicles-button'),
        onPressed: _findVehicles,
        icon: const GariIcon(GariLinkIcons.search),
        label: const Text('Find vehicles'),
      ),
    ],
  );

  String get _locationLabel {
    final location = _searchLocation.location;
    if (location == null) return 'Search for a city, town or area';
    return [
      location.locality,
      location.city,
    ].whereType<String>().where((value) => value.isNotEmpty).join(', ');
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.name});
  final String name;
  @override
  Widget build(BuildContext context) => Row(
    children: [
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'GariLink',
              style: GariLinkTypography.titleLarge.copyWith(
                color: GariLinkColors.accent,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Vehicles for the jobs that move you',
              style: GariLinkTypography.bodySmall,
            ),
          ],
        ),
      ),
      Semantics(
        button: true,
        label: 'Open profile for $name',
        child: InkWell(
          key: const Key('home-profile-action'),
          customBorder: const CircleBorder(),
          onTap: () => context.go('/profile'),
          child: CircleAvatar(
            radius: 22,
            backgroundColor: GariLinkColors.primary,
            child: Text(
              name.characters.first.toUpperCase(),
              style: GariLinkTypography.titleMedium.copyWith(
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    ],
  );
}

class _VehicleHero extends StatelessWidget {
  const _VehicleHero();
  @override
  Widget build(BuildContext context) => Semantics(
    image: true,
    label: 'Cars, an SUV and a truck ready for different journeys',
    child: ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: ColoredBox(
        key: const Key('home-vehicle-hero'),
        color: GariLinkColors.primary,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'MOVE WITH POSSIBILITY',
                    style: GariLinkTypography.labelSmall.copyWith(
                      color: const Color(0xFFBBD8FF),
                      letterSpacing: 2,
                      fontSize: 11,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Transport for\nevery move.',
                    key: const Key('home-hero-headline'),
                    style: GariLinkTypography.display.copyWith(
                      color: Colors.white,
                      fontSize: 32,
                      height: 1.12,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Cars, SUVs, pickups and trucks for people, goods and businesses.',
                    key: const Key('home-hero-supporting-copy'),
                    style: GariLinkTypography.bodySmall.copyWith(
                      color: const Color(0xFFDCE8F7),
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            DecoratedBox(
              key: const Key('home-hero-gradient'),
              decoration: const BoxDecoration(color: GariLinkColors.primary),
              child: AspectRatio(
                aspectRatio: 1280 / 311,
                child: Image.asset(
                  'assets/images/home/garilink_home_hero.jpg',
                  key: const Key('home-hero-photo'),
                  fit: BoxFit.contain,
                  cacheWidth: 1280,
                  excludeFromSemantics: true,
                  errorBuilder: (_, _, _) => const Center(
                    child: GariIcon(GariLinkIcons.photo, color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class _Surface extends StatelessWidget {
  const _Surface({required this.child, this.tint = GariLinkColors.surface});
  final Widget child;
  final Color tint;
  @override
  Widget build(BuildContext context) => Material(
    color: tint,
    shape: RoundedRectangleBorder(
      side: const BorderSide(color: GariLinkColors.border),
      borderRadius: BorderRadius.circular(24),
    ),
    clipBehavior: Clip.antiAlias,
    child: Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: GariLinkSpacing.md,
        vertical: GariLinkSpacing.lg,
      ),
      child: child,
    ),
  );
}

class _PopularCategory {
  const _PopularCategory(
    this.title,
    this.subtitle,
    this.assetPath,
    this.color,
    this.need,
  );
  final String title;
  final String subtitle;
  final String assetPath;
  final Color color;
  final TransportNeed need;
}

const _popularCategories = <_PopularCategory>[
  _PopularCategory(
    'Comfortable cars',
    'For daily trips and city travel',
    'assets/images/home/category_cars.jpg',
    Color(0xFF2563EB),
    TransportNeed(purpose: TransportPurpose.cityTravel),
  ),
  _PopularCategory(
    'SUVs',
    'Space for family and groups',
    'assets/images/home/category_suvs.jpg',
    GariLinkColors.primary,
    TransportNeed(purpose: TransportPurpose.familyOrGroup),
  ),
  _PopularCategory(
    'Pickups',
    'For work and business',
    'assets/images/home/category_pickups.jpg',
    GariLinkColors.accentDark,
    TransportNeed(purpose: TransportPurpose.businessTransport),
  ),
];

class _PopularCard extends StatelessWidget {
  const _PopularCard({required this.item, required this.onTap});
  final _PopularCategory item;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    final extraWidth = (MediaQuery.textScalerOf(context).scale(100) - 100)
        .clamp(0, 100)
        .toDouble();
    return Semantics(
      button: true,
      label: '${item.title}. ${item.subtitle}',
      child: SizedBox(
        width: 210 + extraWidth,
        child: Material(
          color: item.color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(GariLinkRadius.card),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            borderRadius: BorderRadius.circular(GariLinkRadius.card),
            onTap: onTap,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: 78,
                  child: Image.asset(
                    item.assetPath,
                    key: Key('popular-image-${item.title}'),
                    fit: BoxFit.cover,
                    alignment: Alignment.center,
                    cacheWidth: 480,
                    excludeFromSemantics: true,
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item.title, style: GariLinkTypography.cardTitle),
                        const SizedBox(height: 4),
                        Text(
                          item.subtitle,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: GariLinkTypography.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AreaPicker extends StatelessWidget {
  const _AreaPicker();
  static const _areas = <GariLocation>[
    GariLocation(
      latitude: -6.7924,
      longitude: 39.2083,
      city: 'Dar es Salaam',
      source: LocationSource.placeSelection,
    ),
    GariLocation(
      latitude: -3.3869,
      longitude: 36.6830,
      city: 'Arusha',
      source: LocationSource.placeSelection,
    ),
    GariLocation(
      latitude: -6.1630,
      longitude: 35.7516,
      city: 'Dodoma',
      source: LocationSource.placeSelection,
    ),
    GariLocation(
      latitude: -2.5164,
      longitude: 32.9175,
      city: 'Mwanza',
      source: LocationSource.placeSelection,
    ),
  ];
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Choose a search area', style: GariLinkTypography.titleLarge),
        const SizedBox(height: 4),
        Text(
          'We’ll search near the city centre. You can refine the pickup point later.',
          style: GariLinkTypography.bodyMedium,
        ),
        const SizedBox(height: 12),
        ..._areas.map(
          (area) => ListTile(
            minVerticalPadding: 12,
            leading: const GariIcon(GariLinkIcons.location),
            title: Text(area.city!),
            onTap: () => Navigator.pop(context, area),
          ),
        ),
      ],
    ),
  );
}
