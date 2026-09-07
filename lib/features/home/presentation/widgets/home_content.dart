import 'package:flutter/material.dart';

import '../../domain/entities/home_overview.dart';
import 'home_empty_searching_section.dart';
import 'home_recent_match_section.dart';
import 'home_searching_moment_section.dart';
import 'home_today_section.dart';

class HomeContent extends StatelessWidget {
  const HomeContent({
    super.key,
    required this.home,
    required this.onRefresh,
    required this.onPhotoUpload,
    required this.onMatchTap,
    required this.onSearchingMomentTap,
  });

  final HomeOverview home;
  final Future<void> Function() onRefresh;
  final VoidCallback onPhotoUpload;
  final ValueChanged<String> onMatchTap;
  final ValueChanged<String> onSearchingMomentTap;

  @override
  Widget build(BuildContext context) {
    final hasRecentMatch = home.recentMatch != null;
    final shouldShowEmptySearching =
        home.todayPhoto == null &&
        home.searchingMoments.isEmpty &&
        !hasRecentMatch;

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(20),
        children: [
          if (home.recentMatch case final recentMatch?) ...[
            HomeRecentMatchSection(
              match: recentMatch,
              unviewedMatchCount: home.unviewedMatchCount,
              onTap: () => onMatchTap(recentMatch.matchId),
            ),
            const SizedBox(height: 28),
          ],

          HomeTodaySection(
            canRegister: home.canRegister,
            photo: home.todayPhoto,
            layout: hasRecentMatch
                ? HomeTodaySectionLayout.compact
                : HomeTodaySectionLayout.primary,
            onPhotoUpload: onPhotoUpload,
            onMatchTap: onMatchTap,
          ),

          if (shouldShowEmptySearching) ...[
            const SizedBox(height: 28),
            const HomeEmptySearchingSection(),
          ],

          if (home.searchingMoments.isNotEmpty) ...[
            const SizedBox(height: 28),
            HomeSearchingMomentSection(
              moments: home.searchingMoments,
              onMomentTap: onSearchingMomentTap,
            ),
          ],
        ],
      ),
    );
  }
}
