import 'package:book_a_book/src/core/services/location_providers.dart';
import 'package:book_a_book/src/core/theme/app_text_style.dart';
import 'package:book_a_book/src/core/theme/app_theme.dart';
import 'package:book_a_book/src/core/theme/color.dart';
import 'package:book_a_book/src/core/widgets/app_text_field.dart';
import 'package:book_a_book/src/core/widgets/buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

/// Shown right after sign-up. The user must set a location before they can
/// browse — books are filtered by proximity, so a location is the one field
/// the app cannot function without.
///
/// Two paths: GPS (one tap, accurate) or manual entry (text, stored as
/// `location_text` with a null `location` geography).
class LocationGateScreen extends ConsumerStatefulWidget {
  const LocationGateScreen({super.key, required this.profileName});

  final String profileName;

  @override
  ConsumerState<LocationGateScreen> createState() => _LocationGateScreenState();
}

class _LocationGateScreenState extends ConsumerState<LocationGateScreen> {
  final _manualLocation = TextEditingController();
  bool _isDetecting = false;
  String? _error;

  @override
  void dispose() {
    _manualLocation.dispose();
    super.dispose();
  }

  Future<void> _detect() async {
    setState(() {
      _isDetecting = true;
      _error = null;
    });

    final service = ref.read(locationServiceProvider);
    final result = await service.getCurrentLocation();

    if (!mounted) return;

    setState(() => _isDetecting = false);

    // TODO(backend): persist via ref.read(profileRepositoryProvider).update(...)
    // For now we just navigate forward — the profile exists, location can be
    // added later from settings.
    context.go('/books');
  }

  void _submitManual() {
    final text = _manualLocation.text.trim();
    if (text.isEmpty) {
      setState(() => _error = 'Enter a city or neighbourhood.');
      return;
    }

    // TODO(backend): persist text to profile.location_text
    context.go('/books');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(Insets.md),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 420.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Icon(
                    Icons.location_on_outlined,
                    size: 48.w,
                    color: AppColors.brandGreen,
                  ),
                  Insets.md.verticalSpace,
                  Text(
                    'Where are you, ${widget.profileName}?',
                    textAlign: TextAlign.center,
                    style: AppTextStyle.heroTitle.copyWith(
                      color: AppColors.ink,
                    ),
                  ),
                  Insets.xs.verticalSpace,
                  Text(
                    'We use this to find books nearby.',
                    textAlign: TextAlign.center,
                    style: AppTextStyle.heroBody.copyWith(
                      color: AppColors.inkMuted,
                    ),
                  ),
                  Insets.lg.verticalSpace,
                  PrimaryButton(
                    label: _isDetecting ? 'Finding you...' : 'Use my location',
                    expand: true,
                    isLoading: _isDetecting,
                    icon: Icons.my_location_outlined,
                    onPressed: _isDetecting ? null : _detect,
                  ),
                  Insets.md.verticalSpace,
                  Row(
                    children: [
                      const Expanded(child: Divider()),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: Insets.sm),
                        child: Text(
                          'or',
                          style: AppTextStyle.statLabel.copyWith(
                            color: AppColors.inkMuted,
                          ),
                        ),
                      ),
                      const Divider(),
                    ],
                  ),
                  Insets.md.verticalSpace,
                  AppTextField(
                    controller: _manualLocation,
                    label: 'Enter your area',
                    hint: 'Bodija, Ibadan',
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) => _submitManual(),
                  ),
                  if (_error != null) ...[
                    Insets.xs.verticalSpace,
                    Text(
                      _error!,
                      style: AppTextStyle.statLabel.copyWith(
                        color: AppColors.error,
                      ),
                    ),
                  ],
                  Insets.lg.verticalSpace,
                  SecondaryButton(
                    label: 'Continue',
                    expand: true,
                    onPressed: _submitManual,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
