import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:handyman_provider_flutter/main.dart';
import 'package:handyman_provider_flutter/models/dashboard_response.dart';
import 'package:handyman_provider_flutter/provider/components/total_widget.dart';
import 'package:handyman_provider_flutter/provider/handyman_list_screen.dart';
import 'package:handyman_provider_flutter/provider/services/service_list_screen.dart';
import 'package:handyman_provider_flutter/provider/wallet/wallet_history_screen.dart';
import 'package:handyman_provider_flutter/screens/total_earning_screen.dart';
import 'package:handyman_provider_flutter/utils/common.dart';
import 'package:handyman_provider_flutter/utils/constant.dart';
import 'package:handyman_provider_flutter/utils/extensions/num_extenstions.dart';
import 'package:handyman_provider_flutter/utils/images.dart';
import 'package:nb_utils/nb_utils.dart';

class TotalComponent extends StatelessWidget {
  final DashboardResponse snap;

  TotalComponent({required this.snap});

  @override
  Widget build(BuildContext context) {
    return Wrap(
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
}
