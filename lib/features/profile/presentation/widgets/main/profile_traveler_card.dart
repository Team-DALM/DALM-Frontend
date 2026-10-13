import 'package:dalm/app/theme/dalm_colors.dart';
import 'package:dalm/app/theme/dalm_typography.dart';
import 'package:dalm/features/profile/presentation/widgets/shared/profile_skeleton_bar.dart';
import 'package:flutter/material.dart';

class ProfileTravelerCard extends StatelessWidget {
  const ProfileTravelerCard({
    super.key,
    required this.nickname,
    required this.recordSince,
    this.onTap,
    this.isLoading = false,
  });

  final String nickname;
  final String recordSince;
  final VoidCallback? onTap;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: DalmColors.surfaceMuted,
      borderRadius: BorderRadius.circular(7),
      child: InkWell(
        key: const Key('traveler-card'),
        onTap: onTap,
        borderRadius: BorderRadius.circular(7),
        child: SizedBox(
          height: 64,
          child: Padding(
            padding: const EdgeInsets.only(left: 14, right: 10),
            child: isLoading
                ? const _ProfileTravelerSkeleton()
                : Row(
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              nickname,
                              style: DalmTypography.bodyBold.copyWith(
                                color: DalmColors.textPrimary,
                                fontSize: 14,
                              ),
                            ),
                            if (recordSince.isNotEmpty) ...[
                              const SizedBox(height: 10),
                              Text(
                                recordSince,
                                style: DalmTypography.caption.copyWith(
                                  color: DalmColors.textSecondary,
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      const Icon(
                        Icons.chevron_right,
                        color: DalmColors.textWarm,
                        size: 20,
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

class _ProfileTravelerSkeleton extends StatefulWidget {
  const _ProfileTravelerSkeleton();

  @override
  State<_ProfileTravelerSkeleton> createState() =>
      _ProfileTravelerSkeletonState();
}

class _ProfileTravelerSkeletonState extends State<_ProfileTravelerSkeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
    _opacity = Tween<double>(begin: 0.45, end: 0.85).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: AnimatedBuilder(
            animation: _opacity,
            builder: (context, child) {
              return Opacity(opacity: _opacity.value, child: child);
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                ProfileSkeletonBar(width: 92, height: 14),
                SizedBox(height: 10),
                ProfileSkeletonBar(width: 116, height: 10),
              ],
            ),
          ),
        ),
        const Icon(
          Icons.chevron_right,
          color: DalmColors.textWarm,
          size: 20,
        ),
      ],
    );
  }
}
