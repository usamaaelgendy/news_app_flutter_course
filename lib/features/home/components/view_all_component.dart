import 'package:flutter/material.dart';
import 'package:news_app/core/constants/app_sizes.dart';

class ViewAllComponent extends StatelessWidget {
  const ViewAllComponent({super.key, required this.title, this.titleColor, required this.onTap});

  final String title;
  final Color? titleColor;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSizes.pw16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(color: titleColor ?? Color(0xFFFFFCFC), fontSize: AppSizes.sp18, fontWeight: FontWeight.w700),
          ),
          InkWell(
            onTap: () => onTap(),
            child: Text(
              "View all",
              style: TextStyle(
                color: titleColor ?? Color(0xFFFFFCFC),
                fontSize: AppSizes.sp14,
                fontWeight: FontWeight.w400,
                decoration: TextDecoration.underline,
                decorationColor: titleColor ?? Color(0xFFFFFCFC),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
