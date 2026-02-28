import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TabWidget extends StatelessWidget {
  final List<String> tabs;
  final String selectedTab;
  final ValueChanged<String> onTabSelected;

  const TabWidget({
    Key? key,
    required this.tabs,
    required this.selectedTab,
    required this.onTabSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        child: Row(
          children: tabs.map((tab) {
            final isSelected = selectedTab == tab;
            return GestureDetector(
              onTap: () => onTabSelected(tab),
              child: Padding(
                padding: EdgeInsets.only(right: 24.w),
                child: Column(
                  children: [
                    Text(
                      tab,
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.w400,
                        color: isSelected ? Colors.green : Colors.grey,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    if (isSelected)
                      Container(
                        height: 3.h,
                        width: 30.w,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(1.5.r),
                        ),
                      ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
