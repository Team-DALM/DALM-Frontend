import 'package:dalm/app/theme/dalm_colors.dart';
import 'package:dalm/app/theme/dalm_typography.dart';
import 'package:flutter/material.dart';

class PhotoSettingsDialog extends StatelessWidget {
  const PhotoSettingsDialog({super.key, required this.onOpenSettings});

  final VoidCallback onOpenSettings;

  static Future<void> show(
    BuildContext context, {
    required VoidCallback onOpenSettings,
  }) {
    return showDialog<void>(
      context: context,
      builder: (context) => PhotoSettingsDialog(onOpenSettings: onOpenSettings),
    );
  }

  void _closeThen(BuildContext context, VoidCallback callback) {
    Navigator.of(context).pop();
    callback();
  }

  @override
  Widget build(BuildContext context) {
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(6),
    );

    return AlertDialog(
      backgroundColor: DalmColors.surfaceMuted,
      surfaceTintColor: Colors.transparent,
      title: Text(
        '설정에서 사진 접근을 허용해 주세요',
        style: DalmTypography.bodyBold.copyWith(color: DalmColors.textInk),
      ),
      content: Text(
        '사진 접근 권한이 꺼져 있어요. 앱 설정에서 사진 권한을 켜면 앨범을 이용할 수 있어요.',
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
                  style: FilledButton.styleFrom(shape: shape),
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
                    shape: shape,
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
