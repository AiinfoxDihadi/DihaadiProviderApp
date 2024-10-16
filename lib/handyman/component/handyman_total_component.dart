import 'package:flutter/material.dart';
import 'package:handyman_provider_flutter/handyman/component/handyman_total_widget.dart';
import 'package:handyman_provider_flutter/handyman/handyman_dashboard_screen.dart';
import 'package:handyman_provider_flutter/main.dart';
import 'package:handyman_provider_flutter/models/handyman_dashboard_response.dart';
import 'package:handyman_provider_flutter/screens/total_earning_screen.dart';
import 'package:handyman_provider_flutter/store/AppStore.dart';
import 'package:handyman_provider_flutter/utils/colors.dart';
import 'package:handyman_provider_flutter/utils/configs.dart';
import 'package:handyman_provider_flutter/utils/constant.dart';
import 'package:handyman_provider_flutter/utils/extensions/num_extenstions.dart';
import 'package:handyman_provider_flutter/utils/images.dart';
import 'package:handyman_provider_flutter/utils/model_keys.dart';
import 'package:nb_utils/nb_utils.dart';

class HandymanTotalComponent extends StatelessWidget {
  final HandymanDashBoardResponse snap;

  HandymanTotalComponent({required this.snap});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      width: double.infinity,
      margin: EdgeInsets.only(left: 12, right: 12),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: borderColor)
      ),
      child: Column(
        children: [
          buildNameWidget('Appointment / Meeting'),
          15.height,
        Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {

                    },
                    child: Container(
                      height: 85,
                      width: 85,
                      decoration: BoxDecoration(
                          border: Border.all(color: borderColor),
                          borderRadius: BorderRadius.circular(8)
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('6', style: boldTextStyle(
                              size: 20,
                              color: primaryColor
                          ),),
                          Text('New\n Meeting', style: secondaryTextStyle(),
                              textAlign: TextAlign.center),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      appStore.setIndex(1);
                    },
                    child: Container(
                      height: 85,
                      width: 85,
                      decoration: BoxDecoration(
                          border: Border.all(color: borderColor),
                          borderRadius: BorderRadius.circular(8)
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('5', style: boldTextStyle(
                              size: 20,
                              color: primaryColor
                          ),),
                          Text('Pending\n Meeting', style: secondaryTextStyle(),
                              textAlign: TextAlign.center),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      appStore.setIndex(1);
                    },
                    child: Container(
                      height: 85,
                      width: 85,
                      decoration: BoxDecoration(
                          border: Border.all(color: borderColor),
                          borderRadius: BorderRadius.circular(8)
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('2', style: boldTextStyle(
                              size: 20,
                              color: primaryColor
                          ),),
                          Text('Completed\n Meeting',
                              style: secondaryTextStyle(), textAlign: TextAlign
                                  .center),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
          15.height,
          buildNameWidget('Jobs'),
          15.height,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                height: 85,
                width: 85,
                decoration: BoxDecoration(
                    border: Border.all(color: borderColor),
                    borderRadius: BorderRadius.circular(8)
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('4', style: boldTextStyle(
                        size: 20,
                        color: primaryColor
                    ),),
                    Text('Active ', style: secondaryTextStyle()),
                  ],
                ),
              ),
              Container(
                height: 85,
                width: 85,
                decoration: BoxDecoration(
                    border: Border.all(color: borderColor),
                    borderRadius: BorderRadius.circular(8)
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('3', style: boldTextStyle(
                        size: 20,
                        color: primaryColor
                    ),),
                    Text('Inactive', style: secondaryTextStyle()),
                  ],
                ),
              ),
              Container(
                height: 85,
                width: 85,
                decoration: BoxDecoration(
                    border: Border.all(color: borderColor),
                    borderRadius: BorderRadius.circular(8)
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('8', style: boldTextStyle(
                        size: 20,
                        color: primaryColor
                    ),),
                    Text('On Hold', style: secondaryTextStyle()),
                  ],
                ),
              ),
            ],
          ),
          15.height,
          buildNameWidget('Earning'),
          15.height,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  TotalEarningScreen().launch(context);
                },
                child: Container(
                  height: 85,
                  width: 85,
                  decoration: BoxDecoration(
                      border: Border.all(color: borderColor),
                      borderRadius: BorderRadius.circular(8)
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('4000', style: boldTextStyle(
                          size: 20,
                          color: primaryColor
                      ),),
                      Text('Monthly', style: secondaryTextStyle()),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  TotalEarningScreen().launch(context);
                },
                child: Container(
                  height: 85,
                  width: 85,
                  decoration: BoxDecoration(
                      border: Border.all(color: borderColor),
                      borderRadius: BorderRadius.circular(8)
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('50000', style: boldTextStyle(
                          size: 20,
                          color: primaryColor
                      ),),
                      Text('Yearly', style: secondaryTextStyle()),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  TotalEarningScreen().launch(context);
                },
                child: Container(
                  height: 85,
                  width: 85,
                  decoration: BoxDecoration(
                      border: Border.all(color: borderColor),
                      borderRadius: BorderRadius.circular(8)
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('4', style: boldTextStyle(
                          size: 20,
                          color: primaryColor
                      ),),
                      Text('Total\nservices', style: secondaryTextStyle(),
                          textAlign: TextAlign.center),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
    Wrap(
      spacing: 16,
      runSpacing: 16,
      children: [
        HandymanTotalWidget(
          title: languages.monthlyEarnings,
          total: snap.totalRevenue.validate().toPriceFormat(),
          icon: percent_line,
        ).onTap(
              () {
            TotalEarningScreen().launch(context);
          },
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
        ),
        HandymanTotalWidget(
          title: languages.lblTotalBooking,
          total: snap.totalBooking.validate().toString(),
          icon: total_services,
        ).onTap(
              () {
            // LiveStream().emit(LIVESTREAM_HANDYMAN_ALL_BOOKING, 1);
            LiveStream().emit(LIVESTREAM_CHANGE_HANDYMAN_TAB, {"index": 1});
          },
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
        ),
        HandymanTotalWidget(
          title: languages.lblUpcomingServices,
          total: snap.upcomingBookings!.length.validate().toString(),
          icon: total_services,
        ).onTap(
              () {
            // LiveStream().emit(LIVESTREAM_HANDY_BOARD, {"index": 1, "type": BookingStatusKeys.accept});
            LiveStream().emit(LIVESTREAM_CHANGE_HANDYMAN_TAB,
                {"index": 1, "booking_type": BookingStatusKeys.accept});
          },
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
        ),
        HandymanTotalWidget(
          title: languages.lblTodayServices,

          /// TODO translate to Today's Bookings text in all language
          total: snap.todayBooking.validate().toString(),
          icon: total_services,
        ).onTap(
              () {
            LiveStream().emit(LIVESTREAM_CHANGE_HANDYMAN_TAB, {"index": 1});
            // LiveStream().emit(LIVESTREAM_HANDYMAN_ALL_BOOKING, 1);
          },
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
        ),
      ],
    ).paddingAll(16);
  }

  Container buildNameWidget(String name) {
    return Container(
      height: 30,
      decoration: BoxDecoration(
          color: primaryColor,
          borderRadius: BorderRadius.circular(6)
      ),
      child: Center(child: Text(name, style: secondaryTextStyle(
          color: Colors.white,
          size: 14
      ),)),
    );
  }
}
