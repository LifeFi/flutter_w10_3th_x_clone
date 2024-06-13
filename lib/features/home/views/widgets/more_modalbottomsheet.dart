import 'package:flutter/material.dart';
import 'package:flutter_w10_3th_x_clone/constants/gaps.dart';
import 'package:flutter_w10_3th_x_clone/constants/sizes.dart';
import 'package:flutter_w10_3th_x_clone/features/home/views/widgets/report_modalmottomsheet.dart';

class MoreModalbottomsheet extends StatelessWidget {
  const MoreModalbottomsheet({super.key});

  void _onReportTap(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
      showDragHandle: true,
      elevation: 0,
      context: context,
      builder: (context) => const ReportModalbottomsheet(),
      backgroundColor: Colors.white,
      clipBehavior: Clip.hardEdge,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Sizes.size16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400,
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: Sizes.size20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Sizes.size12),
                  color: Colors.grey.shade200,
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        top: Sizes.size20,
                        bottom: Sizes.size12,
                        left: Sizes.size20,
                        right: Sizes.size20,
                      ),
                      child: SizedBox(
                        width: double.maxFinite,
                        child: Text(
                          "Unfollow",
                          style: TextStyle(
                            fontSize: Sizes.size20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    Divider(),
                    Padding(
                      padding: EdgeInsets.only(
                        top: Sizes.size12,
                        bottom: Sizes.size20,
                        left: Sizes.size20,
                        right: Sizes.size20,
                      ),
                      child: SizedBox(
                        width: double.maxFinite,
                        child: Text(
                          "Mute",
                          style: TextStyle(
                            fontSize: Sizes.size20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Gaps.v20,
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Sizes.size12),
                  color: Colors.grey.shade200,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(
                        top: Sizes.size20,
                        bottom: Sizes.size12,
                        left: Sizes.size20,
                        right: Sizes.size20,
                      ),
                      child: SizedBox(
                        width: double.maxFinite,
                        child: Text(
                          "Hide",
                          style: TextStyle(
                            fontSize: Sizes.size20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const Divider(),
                    GestureDetector(
                      onTap: () => _onReportTap(context),
                      child: const Padding(
                        padding: EdgeInsets.only(
                          top: Sizes.size12,
                          bottom: Sizes.size20,
                          left: Sizes.size20,
                          right: Sizes.size20,
                        ),
                        child: SizedBox(
                          width: double.maxFinite,
                          child: Text(
                            "Report",
                            style: TextStyle(
                                fontSize: Sizes.size20,
                                fontWeight: FontWeight.w600,
                                color: Colors.red),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
