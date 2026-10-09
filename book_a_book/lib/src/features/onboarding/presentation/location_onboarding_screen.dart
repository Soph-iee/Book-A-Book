import 'package:book_a_book/src/core/services/location_providers.dart';
import 'package:book_a_book/src/core/theme/app_text_style.dart';
import 'package:book_a_book/src/core/theme/app_theme.dart';
import 'package:book_a_book/src/core/theme/color.dart';
import 'package:book_a_book/src/core/widgets/app_text_field.dart';
import 'package:book_a_book/src/core/widgets/buttons.dart';
import 'package:book_a_book/src/features/onboarding/widgets/location_preview.dart';
import 'package:book_a_book/src/features/onboarding/widgets/onboarding_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

final onboardingControllerProvider = Provider<OnboardingController>((ref) {
  final controller = OnboardingController();
  ref.onDispose(controller.dispose);
  return controller;
});

class OnboardingController extends ChangeNotifier {
  final Set<String> _selectedGenres = <String>{};
  int radius = 5;
  String? locationLabel;
  String? manualArea;

  List<String> get selectedGenres => List.unmodifiable(_selectedGenres);

  void toggleGenre(String genre) {
    if (!_selectedGenres.add(genre)) _selectedGenres.remove(genre);
    notifyListeners();
  }

  void setRadius(int value) {
    radius = value;
    notifyListeners();
  }

  void setLocation(String label) {
    locationLabel = label;
    notifyListeners();
  }

  void setManualArea(String value) {
    manualArea = value;
    notifyListeners();
  }
}

class LocationOnboardingScreen extends ConsumerStatefulWidget {
  const LocationOnboardingScreen({super.key});

  @override
  ConsumerState<LocationOnboardingScreen> createState() =>
      _LocationOnboardingScreenState();
}

class _LocationOnboardingScreenState
    extends ConsumerState<LocationOnboardingScreen> {
  late final TextEditingController _areaController;
  bool _manual = false;
  bool _loading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _areaController = TextEditingController(
      text: ref.read(onboardingControllerProvider).manualArea,
    );
  }

  @override
  void dispose() {
    _areaController.dispose();
    super.dispose();
  }

  Future<void> _useLocation() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final result = await ref
          .read(locationServiceProvider)
          .getCurrentLocation();
      ref.read(onboardingControllerProvider).setLocation(result.label);
      if (mounted) context.go('/onboarding/results');
    } catch (error) {
      if (mounted) setState(() => _error = error.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _continueManually() {
    final value = _areaController.text.trim();
    if (value.isEmpty) {
      setState(() => _error = 'Enter a city or neighbourhood.');
      return;
    }
    ref.read(onboardingControllerProvider).setManualArea(value);
    ref.read(onboardingControllerProvider).setLocation(value);
    context.go('/onboarding/results');
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.read(onboardingControllerProvider);
    return Column(
      children: [
        const OnboardingTitle('Find books around you.'),
        Insets.sm.verticalSpace,
        const OnboardingBody(
          'We use your neighbourhood to find books close enough to share.',
        ),
        Insets.lg.verticalSpace,
        Container(
          padding: EdgeInsets.all(Insets.lg),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: AppRadius.lgAll,
            border: Border.all(color: AppColors.cardBorder),
          ),
          child: Column(
            children: [
              const OnboardingLocationPreview(),
              Insets.lg.verticalSpace,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Search radius', style: AppTextStyle.featureTitle),
                  Text(
                    '${controller.radius} km',
                    style: AppTextStyle.featureTitle.copyWith(
                      color: AppColors.brandGreen,
                    ),
                  ),
                ],
              ),
              Slider(
                value: [2, 5, 10, 20].indexOf(controller.radius).toDouble(),
                max: 3,
                divisions: 3,
                label: '${controller.radius} kilometres',
                onChanged: (value) => ref
                    .read(onboardingControllerProvider)
                    .setRadius([2, 5, 10, 20][value.round()]),
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('2 km'),
                  Text('5 km'),
                  Text('10 km'),
                  Text('20 km'),
                ],
              ),
            ],
          ),
        ),
        if (_manual) ...[
          Insets.md.verticalSpace,
          AppTextField(
            controller: _areaController,
            label: 'Your area',
            hint: 'Yaba, Lagos',
          ),
        ],
        if (_error != null) ...[
          Insets.sm.verticalSpace,
          Text(
            _error!,
            style: AppTextStyle.statLabel.copyWith(color: AppColors.error),
          ),
        ],
        Insets.md.verticalSpace,
        Row(
          children: [
            Icon(
              Icons.shield_outlined,
              color: AppColors.brandGreen,
              size: 22.w,
            ),
            Insets.sm.horizontalSpace,
            Expanded(
              child: Text(
                'Only a neighbourhood-level area is shown to other readers.',
                style: AppTextStyle.body.copyWith(color: AppColors.inkMuted),
              ),
            ),
          ],
        ),
        Insets.lg.verticalSpace,
        PrimaryButton(
          label: _manual ? 'Continue' : 'Use my location',
          icon: _manual ? Icons.arrow_forward : Icons.my_location_outlined,
          expand: true,
          isLoading: _loading,
          onPressed: _loading
              ? null
              : (_manual ? _continueManually : _useLocation),
        ),
        TextLinkButton(
          label: _manual ? 'Use my location instead' : 'Enter my area manually',
          onPressed: _loading
              ? null
              : () => setState(() {
                  _manual = !_manual;
                  _error = null;
                }),
        ),
      ],
    );
  }
}
