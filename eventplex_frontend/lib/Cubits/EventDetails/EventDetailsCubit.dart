import 'package:eventplex_frontend/Cubits/EventDetails/EventDetailsState.dart';
import 'package:eventplex_frontend/Model/Event.dart';
import 'package:eventplex_frontend/Services/Api.dart';
import 'package:eventplex_frontend/Services/GraphQLService.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EventDetailsCubit extends Cubit<EventDetailsState> {
  GraphQLService gqs = GraphQLService();
  Api api = Api();
  EventDetailsCubit() : super(EventDetailsState()) {
    // loadEventDetails(id);
  }
  void loadEventDetails(id) async {
    Event e = await api.getEventById(id);
    emit(EventDetailsStateLoaded(e));
  }
  // Future<void> makePayment() async {
  //   try {
  //     paymentIntent = await createPaymentIntent('10000', 'GBP');

  //     var gpay = PaymentSheetGooglePay(merchantCountryCode: "GB",
  //         currencyCode: "GBP",
  //         testEnv: true);

  //     //STEP 2: Initialize Payment Sheet
  //     await Stripe.instance
  //         .initPaymentSheet(
  //         paymentSheetParameters: SetupPaymentSheetParameters(
  //             paymentIntentClientSecret: paymentIntent![
  //             'client_secret'], //Gotten from payment intent
  //             style: ThemeMode.light,
  //             merchantDisplayName: 'Abhi',
  //             googlePay: gpay))
  //         .then((value) {});

  //     //STEP 3: Display Payment sheet
  //     displayPaymentSheet();
  //   } catch (err) {
  //     print(err);
  //   }
  // }

  // displayPaymentSheet() async {
  //   try {
  //     await Stripe.instance.presentPaymentSheet().then((value) {
  //       print("Payment Successfully");
  //     });
  //   } catch (e) {
  //     print('$e');
  //   }
  // }

  // createPaymentIntent(String amount, String currency) async {
  //   try {
  //     Map<String, dynamic> body = {
  //       'amount': amount, 
  //       'currency': currency,
  //     };

  //     var response = await http.post(
  //       Uri.parse('https://api.stripe.com/v1/payment_intents'),
  //       headers: {
  //         'Authorization': 'Bearer sk_test_51MWx8OAVMyklfe3C3gP4wKOhTsRdF6r1PYhhg1PqupXDITMrV3asj5Mmf0G5F9moPL6zNfG3juK8KHgV9XNzFPlq00wmjWwZYA',
  //         'Content-Type': 'application/x-www-form-urlencoded'
  //       },
  //       body: body,
  //     );
  //     return json.decode(response.body);
  //   } catch (err) {
  //     throw Exception(err.toString());
  //   }
  // }
}
