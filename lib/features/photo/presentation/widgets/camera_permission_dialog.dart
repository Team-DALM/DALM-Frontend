import 'package:dalm/app/theme/dalm_colors.dart';
import 'package:dalm/app/theme/dalm_typography.dart';
import 'package:flutter/material.dart';

class CameraPermissionDialog extends StatelessWidget {
  const CameraPermissionDialog({
    super.key,
    required this.onAllow,
    required this.onDeny,
  });

  final VoidCallback onAllow;
  final VoidCallback onDeny;

  static Future<void> show(
    BuildContext context, {
    required VoidCallback onAllow,
    required VoidCallback onDeny,
  }) {
    return showDialog<void>(
      context: context,
      builder: (context) =>
          CameraPermissionDialog(onAllow: onAllow, onDeny: onDeny),
    );
  }

  void _closeThen(BuildContext context, VoidCallback callback) {
    Navigator.of(context).pop();
    callback();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 35),
      backgroundColor: DalmColors.surfaceMuted,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: SizedBox(
        width: 320,
        height: 392,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: 30),
              const _CameraPermissionIcon(),
              const SizedBox(height: 14),
              Text(
                '카메라 사용 권한이 필요해요',
                style: DalmTypography.title.copyWith(color: DalmColors.textInk),
              ),
              const SizedBox(height: 17),
              Text(
                '오늘의 사진을 촬영하기 위해 사용하며\n허락 없이 카메라를 실행하지 않아요.',
                textAlign: TextAlign.center,
                style: DalmTypography.caption.copyWith(
                  fontSize: 10,
                  height: 1.8,
                  color: DalmColors.textWarm,
                ),
              ),
              const SizedBox(height: 19),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: FilledButton(
                  onPressed: () => _closeThen(context, onAllow),
                  style: FilledButton.styleFrom(
                    backgroundColor: DalmColors.primaryAction,
                    foregroundColor: DalmColors.surfaceMuted,
                    elevation: 0,
                    textStyle: DalmTypography.caption.copyWith(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  child: const Text('카메라 사용 허용'),
                ),
              ),
              const SizedBox(height: 18),
              TextButton(
                onPressed: () => _closeThen(context, onDeny),
                style: TextButton.styleFrom(
                  foregroundColor: DalmColors.textWarm,
                  minimumSize: const Size(280, 32),
                  padding: EdgeInsets.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  textStyle: DalmTypography.caption.copyWith(fontSize: 11),
                ),
                child: const Text('지금은 허용하지 않기'),
              ),
              const SizedBox(height: 18),
              const Divider(height: 1, color: DalmColors.warmBorder),
              const Spacer(),
              Text(
                '설정에서 언제든 변경할 수 있어요.',
                style: DalmTypography.caption.copyWith(
                  fontSize: 8,
                  color: DalmColors.textWarm,
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class _CameraPermissionIcon extends StatelessWidget {
  const _CameraPermissionIcon();

  @override
  Widget build(BuildContext context) {
    return const SizedBox.square(
      dimension: 56,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: DalmColors.background,
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.photo_camera_outlined,
          size: 25,
          color: DalmColors.secondaryAction,
        ),
      ),
    );
  }
}
