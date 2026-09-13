import 'package:dalm/app/theme/dalm_colors.dart';
import 'package:dalm/app/theme/dalm_typography.dart';
import 'package:flutter/material.dart';

class PhotoPermissionDialog extends StatelessWidget {
  const PhotoPermissionDialog({
    super.key,
    required this.onAllowAll,
    required this.onAllowSelected,
    required this.onDeny,
  });

  final VoidCallback onAllowAll;
  final VoidCallback onAllowSelected;
  final VoidCallback onDeny;

  static Future<void> show(
    BuildContext context, {
    required VoidCallback onAllowAll,
    required VoidCallback onAllowSelected,
    required VoidCallback onDeny,
  }) {
    return showDialog<void>(
      context: context,
      builder: (context) => PhotoPermissionDialog(
        onAllowAll: onAllowAll,
        onAllowSelected: onAllowSelected,
        onDeny: onDeny,
      ),
    );
  }

  void _closeThen(VoidCallback callback, BuildContext context) {
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
              const _PhotoPermissionIcon(),
              const SizedBox(height: 14),
              Text(
                '사진 접근 권한이 필요해요',
                style: DalmTypography.title.copyWith(
                  color: DalmColors.textPrimary,
                ),
              ),
              const SizedBox(height: 17),
              Text(
                '선택한 사진을 불러오기 위해 사용하며\n허락 없이 다른 사진을 업로드하지 않아요.',
                textAlign: TextAlign.center,
                style: DalmTypography.caption.copyWith(
                  fontSize: 10,
                  height: 1.8,
                  color: DalmColors.textSecondary,
                ),
              ),
              const SizedBox(height: 19),
              _PermissionButton(
                label: '모든 사진 허용',
                backgroundColor: DalmColors.primaryAction,
                foregroundColor: DalmColors.surfaceMuted,
                onPressed: () => _closeThen(onAllowAll, context),
              ),
              const SizedBox(height: 10),
              _PermissionButton(
                label: '선택한 사진만 허용',
                backgroundColor: DalmColors.background,
                foregroundColor: DalmColors.secondaryAction,
                onPressed: () => _closeThen(onAllowSelected, context),
              ),
              const SizedBox(height: 13),
              TextButton(
                onPressed: () => _closeThen(onDeny, context),
                style: TextButton.styleFrom(
                  foregroundColor: DalmColors.textSecondary,
                  minimumSize: const Size(280, 32),
                  padding: EdgeInsets.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  textStyle: DalmTypography.caption.copyWith(fontSize: 11),
                ),
                child: const Text('지금은 허용하지 않기'),
              ),
              const Divider(
                height: 1,
                thickness: 1,
                color: DalmColors.warmBorder,
              ),
              const Spacer(),
              Text(
                '설정에서 언제든 변경할 수 있어요.',
                style: DalmTypography.caption.copyWith(
                  fontSize: 8,
                  color: DalmColors.textSecondary,
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

class _PhotoPermissionIcon extends StatelessWidget {
  const _PhotoPermissionIcon();

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
          Icons.photo_outlined,
          size: 25,
          color: DalmColors.secondaryAction,
        ),
      ),
    );
  }
}

class _PermissionButton extends StatelessWidget {
  const _PermissionButton({
    required this.label,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.onPressed,
  });

  final String label;
  final Color backgroundColor;
  final Color foregroundColor;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          elevation: 0,
          textStyle: DalmTypography.caption.copyWith(
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        ),
        child: Text(label),
      ),
    );
  }
}
