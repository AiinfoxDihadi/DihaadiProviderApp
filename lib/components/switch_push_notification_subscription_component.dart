import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:handyman_provider_flutter/utils/extensions/string_extension.dart';
import 'package:nb_utils/nb_utils.dart';

import '../main.dart';
import '../utils/firebase_messaging_utils.dart';
import '../utils/images.dart';

class SwitchPushNotificationSubscriptionComponent extends StatefulWidget {
  const SwitchPushNotificationSubscriptionComponent({Key? key}) : super(key: key);

  @override
  State<SwitchPushNotificationSubscriptionComponent> createState() => _SwitchPushNotificationSubscriptionComponentState();
}

class _SwitchPushNotificationSubscriptionComponentState extends State<SwitchPushNotificationSubscriptionComponent> {
  @override
  void initState() {
    init();
    super.initState();
  }

  void init() async {
    //
  }

  @override
  Widget build(BuildContext context) {
    return SettingItemWidget(
      leading: ic_notification.iconImage(size: 18),
      title: languages.pushNotification,
      titleTextStyle: primaryTextStyle(),
      trailing: Transform.scale(
        scale: 0.7,
        child: Observer(builder: (context) {
          return Switch.adaptive(
            value: FirebaseAuth.instance.currentUser != null && appStore.isSubscribedForPushNotification,
            onChanged: (v) async {
              if (appStore.isLoading) return;
              appStore.setLoading(true);
              if (v) {
                await subscribeToFirebaseTopic();
              } else {
                await unsubscribeFirebaseTopic(appStore.userId);
              }
              appStore.setLoading(false);
              setState(() {});
            },
          ).withHeight(18);
        }),
      ),
    );
  }
}
