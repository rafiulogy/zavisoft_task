import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../data/models/product_model.dart';
import 'product_card_widget.dart';

class TabContentWidget extends StatelessWidget {
  final List<ProductModel> products;
  final VoidCallback? onProductTap;

  const TabContentWidget({
    Key? key,
    required this.products,
    this.onProductTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          return ProductCardWidget(
            product: products[index],
            onTap: onProductTap,
          );
        },
        childCount: products.length,
      ),
    );
  }
}
