import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:handyman_provider_flutter/fragments/booking_fragment.dart';
import 'package:handyman_provider_flutter/main.dart';
import 'package:handyman_provider_flutter/models/dashboard_response.dart';
import 'package:handyman_provider_flutter/provider/components/total_widget.dart';
import 'package:handyman_provider_flutter/provider/handyman_list_screen.dart';
import 'package:handyman_provider_flutter/provider/provider_dashboard_screen.dart';
import 'package:handyman_provider_flutter/provider/services/service_list_screen.dart';
import 'package:handyman_provider_flutter/provider/wallet/wallet_history_screen.dart';
import 'package:handyman_provider_flutter/screens/total_earning_screen.dart';
import 'package:handyman_provider_flutter/utils/colors.dart';
import 'package:handyman_provider_flutter/utils/common.dart';
import 'package:handyman_provider_flutter/utils/configs.dart';
import 'package:handyman_provider_flutter/utils/constant.dart';
import 'package:handyman_provider_flutter/utils/extensions/num_extenstions.dart';
import 'package:handyman_provider_flutter/utils/images.dart';
import 'package:nb_utils/nb_utils.dart';

class TotalComponent extends StatelessWidget {
  final DashboardResponse snap;

  TotalComponent({required this.snap});

  @override
  Widget build(BuildContext context) {
    return  Container(
      padding: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
      width: double.infinity,
      margin: EdgeInsets.only(left: 12,right: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: context.dividerColor)
      ),
      child: Column(
        children: [
          buildNameWidget('Appointment / Meeting'),
          15.height,
          buildRow(snap.totalBooking.toString(),'5','10'),
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
                border: Border.all(color: context.dividerColor),
                borderRadius: BorderRadius.circular(8)
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('4',style: boldTextStyle(
                    size: 20,
                    color: primaryColor
                ),),
                Text('Active ',style: secondaryTextStyle()),
              ],
            ),
          ),
          Container(
            height: 85,
            width: 85,
            decoration: BoxDecoration(
                border: Border.all(color: context.dividerColor),
                borderRadius: BorderRadius.circular(8)
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('3',style: boldTextStyle(
                    size: 20,
                    color: primaryColor
                ),),
                Text('Inactive',style: secondaryTextStyle()),
              ],
            ),
          ),
          Container(
            height: 85,
            width: 85,
            decoration: BoxDecoration(
                border: Border.all(color: context.dividerColor),
                borderRadius: BorderRadius.circular(8)
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('8',style: boldTextStyle(
                    size: 20,
                    color: primaryColor
                ),),
                Text('On Hold',style: secondaryTextStyle()),
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
                onTap: ()=> TotalEarningScreen().launch(context),
                behavior: HitTestBehavior.opaque,
                child: Container(
                  height: 85,
                  width: 85,
                  decoration: BoxDecoration(
                      border: Border.all(color: context.dividerColor),
                      borderRadius: BorderRadius.circular(8)
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('4000',style: boldTextStyle(
                          size: 20,
                          color: primaryColor
                      ),),
                      Text('Monthly',style: secondaryTextStyle()),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: ()=> TotalEarningScreen().launch(context),
                behavior: HitTestBehavior.opaque,
                child: Container(
                  height: 85,
                  width: 85,
                  decoration: BoxDecoration(
                      border: Border.all(color: context.dividerColor),
                      borderRadius: BorderRadius.circular(8)
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('50000',style: boldTextStyle(
                          size: 20,
                          color: primaryColor
                      ),),
                      Text('Yearly',style: secondaryTextStyle()),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: ()=> TotalEarningScreen().launch(context),
                behavior: HitTestBehavior.opaque,
                child: Container(
                  height: 85,
                  width: 85,
                  decoration: BoxDecoration(
                      border: Border.all(color: context.dividerColor),
                      borderRadius: BorderRadius.circular(8)
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('4',style: boldTextStyle(
                          size: 20,
                          color: primaryColor
                      ),),
                      Text('Total\nservices',style: secondaryTextStyle(),textAlign: TextAlign.center),
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
        TotalWidget(title: languages.lblTotalBooking, total: snap.totalBooking.toString(), icon: total_booking).onTap(
          () {
            LiveStream().emit(LIVESTREAM_PROVIDER_ALL_BOOKING, 1);
          },
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
        ),
        TotalWidget(
          title: languages.lblTotalService,
          total: snap.totalService.validate().toString(),
          icon: total_services,
        ).onTap(
          () {
            ServiceListScreen().launch(context);
          },
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
        ),
        if (appStore.earningTypeSubscription && isUserTypeProvider)
          TotalWidget(
            title: languages.lblTotalHandyman,
            total: snap.totalHandyman.validate().toString(),
            icon: handyman,
          ).onTap(
            () {
              HandymanListScreen().launch(context);
            },
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
          ),
        TotalWidget(
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
        Observer(builder: (context) {
          if (appStore.earningTypeCommission)
            return TotalWidget(
              title: languages.lblWallet,
              total: snap.providerWallet != null ? snap.providerWallet!.amount.validate().toPriceFormat().toString() : 0.toPriceFormat().toString(),
              icon: un_fill_wallet,
            ).onTap(
              () {
                WalletHistoryScreen().launch(context);
              },
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
            );

          return Offstage();
        }),
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
          child: Center(child: Text(name,style: secondaryTextStyle(
            color: Colors.white,
          size: 14
          ),)),
        );
  }

  Observer buildRow(String data1,String data2,String data3) {
    return Observer(
      builder: (BuildContext context) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                print('hello');
                appStore.setIndex(1);
              },
              child: Container(
                height: 85,
                width: 85,
                decoration: BoxDecoration(
                    border: Border.all(color: context.dividerColor),
                    borderRadius: BorderRadius.circular(8)
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(data1,style: boldTextStyle(
                        size: 20,
                        color: primaryColor
                    ),),
                    Text('New\n Meeting',style: secondaryTextStyle(),textAlign: TextAlign.center),
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
                    border: Border.all(color: context.dividerColor),
                    borderRadius: BorderRadius.circular(8)
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(data2,style: boldTextStyle(
                        size: 20,
                        color: primaryColor
                    ),),
                    Text('Pending\n Meeting',style: secondaryTextStyle(),textAlign: TextAlign.center),
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
                    border: Border.all(color: context.dividerColor),
                    borderRadius: BorderRadius.circular(8)
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(data3,style: boldTextStyle(
                        size: 20,
                        color: primaryColor
                    ),),
                    Text('Completed\n Meeting',style: secondaryTextStyle(),textAlign: TextAlign.center),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
