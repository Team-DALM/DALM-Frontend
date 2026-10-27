import 'package:dalm/app/theme/dalm_colors.dart';
import 'package:dalm/app/theme/dalm_typography.dart';
import 'package:flutter/material.dart';

/// 사진 크롭 화면의 초기화, 4:5 비율, 회전 도구
class PhotoCropToolbar extends StatelessWidget {
  const PhotoCropToolbar({
    super.key,
    required this.onReset,
    required this.onRotate,
  });

  final VoidCallback onReset;
  final VoidCallback onRotate;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _CropToolButton(
          icon: Icons.history,
          label: '초기화',
          tooltip: '사진 위치 초기화',
          onPressed: onReset,
        ),
        const _AspectRatioIndicator(),
        _CropToolButton(
          icon: Icons.crop_rotate,
          label: '회전',
          tooltip: '사진 90도 회전',
          onPressed: onRotate,
        ),
      ],
    );
  }
}

/// 크롭 기능 하나를 실행하는 아이콘 버튼
class _CropToolButton extends StatelessWidget {
  const _CropToolButton({
    required this.icon,
    required this.label,
    required this.tooltip,
    required this.onPressed,
  });

  final IconData icon;
  final String label;
  final String tooltip;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: tooltip,
      child: InkResponse(
        onTap: onPressed,
        radius: 32,
        child: SizedBox(
          width: 72,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: DalmColors.textInverse, size: 26),
              const SizedBox(height: 9),
              Text(
                label,
                style: DalmTypography.caption.copyWith(
                  fontSize: 10,
                  color: DalmColors.photoEditorTextSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 고정된 4:5 크롭 비율 표시
class _AspectRatioIndicator extends StatelessWidget {
  const _AspectRatioIndicator();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 72,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 42,
            height: 34,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: DalmColors.photoEditorSurface,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              '4 : 5',
              style: DalmTypography.caption.copyWith(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: DalmColors.emotionalAccent,
              ),
            ),
          ),
          const SizedBox(height: 9),
          Text(
            '고정 비율',
            style: DalmTypography.caption.copyWith(
              fontSize: 10,
              color: DalmColors.photoEditorTextSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
