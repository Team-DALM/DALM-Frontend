import 'package:dalm/app/theme/dalm_colors.dart';
import 'package:dalm/app/theme/dalm_typography.dart';
import 'package:flutter/material.dart';

class CameraSettingsDialog extends StatelessWidget {
  const CameraSettingsDialog({super.key, required this.onOpenSettings});

  final VoidCallback onOpenSettings;

  static Future<void> show(
    BuildContext context, {
    required VoidCallback onOpenSettings,
  }) {
    return showDialog<void>(
      context: context,
      builder: (context) =>
          CameraSettingsDialog(onOpenSettings: onOpenSettings),
    );
  }

  void _closeThen(BuildContext context, VoidCallback callback) {
    Navigator.of(context).pop();
    callback();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: DalmColors.surfaceMuted,
      surfaceTintColor: Colors.transparent,
      title: Text(
        '설정에서 카메라를 허용해 주세요',
        style: DalmTypography.bodyBold.copyWith(color: DalmColors.textInk),
      ),
      content: Text(
        '카메라 권한이 꺼져 있어요. 앱 설정에서 카메라 권한을 켜면 촬영할 수 있어요.',
        style: DalmTypography.caption.copyWith(color: DalmColors.textWarm),
      ),
      actionsPadding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
      actions: [
        SizedBox(
          width: double.infinity,
          child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                height: 48,
                child: FilledButton(
                  onPressed: () => _closeThen(context, onOpenSettings),
                  style: FilledButton.styleFrom(
                    backgroundColor: DalmColors.primaryAction,
                    foregroundColor: DalmColors.textInverse,
                    textStyle: DalmTypography.button,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  child: const Text('설정 열기'),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: FilledButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: FilledButton.styleFrom(
                    foregroundColor: DalmColors.textWarm,
                    backgroundColor: DalmColors.background,
                    side: const BorderSide(color: DalmColors.warmBorder),
                    textStyle: DalmTypography.button,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  child: const Text('취소'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
