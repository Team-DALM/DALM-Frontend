import 'package:dalm/features/photo/presentation/view_models/photo_library_view_model.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Android에서 중단된 사진 선택 결과를 복구하는 비표시 위젯
class PhotoLostDataRecovery extends ConsumerStatefulWidget {
  const PhotoLostDataRecovery({
    super.key,
    required this.onRecovered,
    required this.onFailed,
  });

  final ValueChanged<String> onRecovered;
  final VoidCallback onFailed;

  @override
  ConsumerState<PhotoLostDataRecovery> createState() =>
      _PhotoLostDataRecoveryState();
}

class _PhotoLostDataRecoveryState extends ConsumerState<PhotoLostDataRecovery> {
  @override
  void initState() {
    super.initState();
    // 첫 화면 렌더링 후 시스템에 남은 사진 선택 결과 확인
    WidgetsBinding.instance.addPostFrameCallback((_) => _recover());
  }

  Future<void> _recover() async {
    final result = await ref
        .read(photoLibraryViewModelProvider)
        .recoverLostPhoto();
    if (!mounted) return;

    switch (result.outcome) {
      case PhotoLibrarySelectionOutcome.selected:
        widget.onRecovered(result.photoPath!);
        return;
      case PhotoLibrarySelectionOutcome.cancelled:
        return;
      case PhotoLibrarySelectionOutcome.failed:
        widget.onFailed();
        return;
    }
  }

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}
