import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../controllers/home_controller.dart';
import '../widgets/collapsible_header_widget.dart';
import '../widgets/sticky_tab_bar_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      builder: (controller) {
        return Scaffold(
          body: SafeArea(
            child: RefreshIndicator(
              color: Colors.green,
              onRefresh: controller.refreshProducts,
              child: CustomScrollView(
                controller: controller.scrollController,
                slivers: [
                  // Collapsible Header with Search
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

                  // Sticky Tab Bar
                  Obx(
                    () => StickyTabBarWidget(
                      tabs: controller.tabs,
                      selectedIndex: controller.selectedTabIndex.value,
                      onTabSelected: (index) {
                        controller.selectTab(index);
                      },
                    ),
                  ),

                  // Tab Content with Vertical Scrolling and Horizontal Swipe Support
                  Obx(
                    () {
                      final products = controller.getProductsByTab();

                      if (products.isEmpty) {
                        return SliverFillRemaining(
                          child: GestureDetector(
                            onHorizontalDragEnd: (details) {
                              if (details.primaryVelocity! > 0) {
                                // Swiped right - go to previous tab
                                int newIndex =
                                    (controller.selectedTabIndex.value - 1) %
                                        controller.tabs.length;
                                if (newIndex < 0) {
                                  newIndex = controller.tabs.length - 1;
                                }
                                controller.selectTab(newIndex);
                              } else if (details.primaryVelocity! < 0) {
                                // Swiped left - go to next tab
                                int newIndex =
                                    (controller.selectedTabIndex.value + 1) %
                                        controller.tabs.length;
                                controller.selectTab(newIndex);
                              }
                            },
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
                          ),
                        );
                      }

                      return SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            return Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 16.w,
                                vertical: 8.h,
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  Get.snackbar(
                                    'Product Selected',
                                    products[index].name,
                                    snackPosition: SnackPosition.BOTTOM,
                                    backgroundColor: Colors.green,
                                    colorText: Colors.white,
                                  );
                                },
                                onHorizontalDragEnd: (details) {
                                  if (details.primaryVelocity! > 0) {
                                    // Swiped right - go to previous tab
                                    int newIndex =
                                        (controller.selectedTabIndex.value -
                                                1) %
                                            controller.tabs.length;
                                    if (newIndex < 0) {
                                      newIndex = controller.tabs.length - 1;
                                    }
                                    controller.selectTab(newIndex);
                                  } else if (details.primaryVelocity! < 0) {
                                    // Swiped left - go to next tab
                                    int newIndex =
                                        (controller.selectedTabIndex.value +
                                                1) %
                                            controller.tabs.length;
                                    controller.selectTab(newIndex);
                                  }
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade100,
                                    borderRadius: BorderRadius.circular(12.r),
                                    boxShadow: [
                                      BoxShadow(
                                        color:
                                            Colors.grey.withValues(alpha: 0.1),
                                        spreadRadius: 1,
                                        blurRadius: 4,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Product Image
                                      ClipRRect(
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(12.r),
                                          bottomLeft: Radius.circular(12.r),
                                        ),
                                        child: Container(
                                          width: 120.w,
                                          height: 120.h,
                                          color: Colors.white,
                                          child: Image.network(
                                            products[index].image,
                                            fit: BoxFit.cover,
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                              return Container(
                                                color: Colors.grey.shade300,
                                                child: Icon(
                                                  Icons.image_not_supported,
                                                  color: Colors.grey,
                                                  size: 40.w,
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 12.w),
                                      // Product Details
                                      Expanded(
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                            vertical: 12.h,
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              // Product Name
                                              Text(
                                                products[index].name,
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  fontSize: 14.sp,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.black87,
                                                ),
                                              ),
                                              SizedBox(height: 8.h),
                                              // Price
                                              Text(
                                                '\$${products[index].price.toStringAsFixed(2)}',
                                                style: TextStyle(
                                                  fontSize: 16.sp,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.green,
                                                ),
                                              ),
                                              SizedBox(height: 8.h),
                                              // Rating
                                              Row(
                                                children: [
                                                  Icon(
                                                    Icons.star,
                                                    color: Colors.green,
                                                    size: 16.w,
                                                  ),
                                                  SizedBox(width: 4.w),
                                                  Text(
                                                    products[index]
                                                        .rating
                                                        .toString(),
                                                    style: TextStyle(
                                                      fontSize: 13.sp,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Colors.black54,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 12.w),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                          childCount: products.length,
                        ),
                      );
                    },
                  ),
                  SliverPadding(
                    padding: EdgeInsets.only(bottom: 16.h),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
