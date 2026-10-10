import 'package:dalm/app/theme/dalm_colors.dart';
import 'package:dalm/app/theme/dalm_typography.dart';
import 'package:flutter/material.dart';

class PhotoRejectionReasons extends StatelessWidget {
  const PhotoRejectionReasons({super.key});

  static const _reasons = [
    ('빛 정보 부족', DalmColors.destructive, Color(0xFFFFF1EB)),
    ('피사체 인식 어려움', DalmColors.secondaryAction, Color(0xFFF2F4F8)),
    ('낮은 선명도', DalmColors.emotionalAccent, Color(0xFFF8F4E8)),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 20),
      decoration: BoxDecoration(
        color: DalmColors.surface,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '사진에서 확인하기 어려웠던 부분',
            style: DalmTypography.caption.copyWith(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: DalmColors.textPrimary,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: _reasons.map((reason) {
              return Expanded(
                child: Container(
                  margin: EdgeInsets.only(
                    right: reason == _reasons.last ? 0 : 7,
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: reason.$3,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    reason.$1,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    style: DalmTypography.caption.copyWith(
                      fontSize: 8,
                      color: reason.$2,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
