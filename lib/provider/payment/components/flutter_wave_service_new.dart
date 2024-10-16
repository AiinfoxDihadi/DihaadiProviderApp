// import 'package:flutterwave_standard/flutterwave.dart';
// import 'package:nb_utils/nb_utils.dart';
// import 'package:uuid/uuid.dart';

// import '../../../main.dart';
// import '../../../networks/rest_apis.dart';
// import '../../../utils/app_configuration.dart';
// import '../../../utils/configs.dart';
// import '../../../utils/images.dart';

// class FlutterWaveServiceNew {
//   final Customer customer = Customer(
//     name: appStore.userName,
//     phoneNumber: appStore.userContactNumber,
//     email: appStore.userEmail,
//   );

//   void checkout({
//     required PaymentSetting paymentSetting,
//     required num totalAmount,
//     required Function(Map) onComplete,
//   }) async {
//     String transactionId = Uuid().v1();
//     String flutterWavePublicKey = '';
//     String flutterWaveSecretKey = '';

//     if (paymentSetting.isTest == 1) {
//       flutterWavePublicKey = paymentSetting.testValue!.flutterwavePublic!;
//       flutterWaveSecretKey = paymentSetting.testValue!.flutterwaveSecret!;
//     } else {
//       flutterWavePublicKey = paymentSetting.liveValue!.flutterwavePublic!;
//       flutterWaveSecretKey = paymentSetting.liveValue!.flutterwaveSecret!;
//     }

//     Flutterwave flutterWave = Flutterwave(
//       context: getContext,
//       publicKey: flutterWavePublicKey,
//       currency: appConfigurationStore.currencyCode,
//       redirectUrl: BASE_URL,
//       txRef: transactionId,
//       amount: totalAmount.validate().toStringAsFixed(appConfigurationStore.priceDecimalPoint),
//       customer: customer,
//       paymentOptions: "card, payattitude, barter",
//       customization: Customization(title: "Pay With Flutterwave", logo: appLogo),
//       isTestMode: paymentSetting.isTest == 1,
//     );

//     await flutterWave.charge().then((value) {
//       if (value.status == "successful") {
//         appStore.setLoading(true);

//         verifyPayment(transactionId: value.transactionId.validate(), flutterWaveSecretKey: flutterWaveSecretKey).then((v) {
//           if (v.status == "success") {
//             onComplete.call({
//               'transaction_id': value.transactionId.validate(),
//             });
//           } else {
//             appStore.setLoading(false);
//             toast(languages.lblTransactionFailed);
//           }
//         }).catchError((e) {
//           appStore.setLoading(false);

//           toast(e.toString());
//         });
//       } else {
//         toast(languages.lblTransactionCancelled);
//         appStore.setLoading(false);
//       }
//     });
//   }
// }
