import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../controllers/home_controller.dart';
import '../widgets/collapsible_header_widget.dart';
import '../widgets/product_card_widget.dart';
import '../widgets/sticky_tab_bar_widget.dart';

/// HomeScreen — Single-scroll, Daraz-style product listing.
///
/// ## Scroll Architecture
/// - **Single vertical scrollable**: One [CustomScrollView] owns ALL vertical
///   scrolling. There are no nested `ListView`s, `PageView`s, or secondary
///   scrollables anywhere on this screen.
/// - **Scroll owner**: A single [ScrollController] lives in [HomeController]
///   and is attached to the [CustomScrollView]. Every sliver participates in
///   this one scroll context.
/// - **Pull-to-refresh**: [RefreshIndicator] wraps the [CustomScrollView] and
///   reacts to over-scroll from any tab.
///
/// ## Horizontal Swipe (Tab Switching)
/// - A top-level [GestureDetector] with [onHorizontalDragEnd] sits above the
///   [RefreshIndicator] and [CustomScrollView].
/// - Flutter's gesture arena naturally disambiguates between horizontal drag
///   (tab switch) and vertical drag (scroll):
///     - If the user's initial movement is clearly horizontal →
///       [HorizontalDragGestureRecognizer] wins, the [CustomScrollView] does
///       NOT scroll. Tab is switched.
///     - If vertical → [VerticalDragGestureRecognizer] wins, no tab switch.
/// - A minimum velocity threshold (300 px/s) prevents accidental swipes.
/// - Tabs are also switchable by tapping the tab bar.
///
/// ## Tab Switching & Scroll Position
/// - Switching tabs only mutates the reactive [selectedTabIndex]; the
///   [SliverList] rebuilds with new data via [Obx]. The [ScrollController]
///   offset is **never** reset, so the user's scroll position is preserved.
/// - If the new tab's list is shorter than the current scroll offset, the
///   [CustomScrollView] clamps naturally — no jump or jitter.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      builder: (controller) {
        return Scaffold(
          body: SafeArea(
            // ── Horizontal swipe detection ──
            // Wraps the entire scrollable area. Flutter's gesture arena
            // ensures that only ONE of horizontal-drag or vertical-drag
            // wins per pointer sequence, so this never conflicts with
            // the CustomScrollView's vertical scrolling.
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onHorizontalDragEnd: (details) {
                controller.handleHorizontalSwipe(details);
              },
              child: RefreshIndicator(
                color: Colors.green,
                onRefresh: controller.refreshProducts,
                // ── Single vertical scrollable ──
                // This CustomScrollView is the ONLY scrollable widget
                // on the screen. All content is rendered as slivers.
                child: CustomScrollView(
                  controller: controller.scrollController,
                  slivers: [
                    // ── Collapsible header (banner + search bar) ──
                    // Collapses on scroll; not pinned.
                    CollapsibleHeaderWidget(
                      userName: controller.userName.value,
                      searchController: controller.searchController,
                      onSearchChanged: (query) {
                        controller.searchProducts(query);
                      },
                      onProfileTap: () {
                        Get.toNamed('/profileScreen');
                      },
                    ),

                    // ── Sticky tab bar ──
                    // Pinned via SliverPersistentHeader so it remains
                    // visible once the header collapses.
                    Obx(
                      () => StickyTabBarWidget(
                        tabs: controller.tabs,
                        selectedIndex: controller.selectedTabIndex.value,
                        onTabSelected: (index) {
                          controller.selectTab(index);
                        },
                      ),
                    ),

                    // ── Tab content ──
                    // Reactive SliverList that rebuilds when the selected
                    // tab or product data changes. No secondary scrollable.
                    Obx(() {
                      // Loading state
                      if (controller.isLoading.value) {
                        return const SliverFillRemaining(
                          child: Center(
                            child: CircularProgressIndicator(
                              color: Colors.green,
                            ),
                          ),
                        );
                      }

                      // Error state
                      if (controller.errorMessage.value.isNotEmpty &&
                          controller.allProducts.isEmpty) {
                        return SliverFillRemaining(
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.error_outline,
                                  size: 64.w,
                                  color: Colors.red.shade300,
                                ),
                                SizedBox(height: 16.h),
                                Text(
                                  controller.errorMessage.value,
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    color: Colors.grey,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: 16.h),
                                ElevatedButton(
                                  onPressed: controller.fetchProducts,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                  ),
                                  child: const Text(
                                    'Retry',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }

                      final products = controller.getProductsByTab();

                      // Empty state
                      if (products.isEmpty) {
                        return SliverFillRemaining(
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.shopping_bag_outlined,
                                  size: 64.w,
                                  color: Colors.grey,
                                ),
                                SizedBox(height: 16.h),
                                Text(
                                  'No products found',
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }

                      // Product list — rendered as sliver children
                      return SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            return ProductCardWidget(
                              product: products[index],
                              onTap: () {
                                Get.snackbar(
                                  'Product Selected',
                                  products[index].title,
                                  snackPosition: SnackPosition.BOTTOM,
                                  backgroundColor: Colors.green,
                                  colorText: Colors.white,
                                );
                              },
                            );
                          },
                          childCount: products.length,
                        ),
                      );
                    }),

                    // Bottom padding
                    SliverPadding(
                      padding: EdgeInsets.only(bottom: 16.h),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
