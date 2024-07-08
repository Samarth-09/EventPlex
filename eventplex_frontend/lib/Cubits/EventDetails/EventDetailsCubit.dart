import 'package:dio/dio.dart';
import 'package:eventplex_frontend/Cubits/EventDetails/EventDetailsState.dart';
import 'package:eventplex_frontend/Model/Event.dart';
import 'package:eventplex_frontend/Services/Api.dart';
import 'package:eventplex_frontend/Services/GraphQLService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

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

  void callLoadEventDetailsFunction(id) {
    emit(EventDetailsState());
    loadEventDetails(id);
  }

  Future<void> makePayment(int amount) async {
    try {
      // print(amount);
      String amt = "${(amount * 100).toInt()}";
      //  int amountInPaise = (double.parse(amount.toString()) * 100).toInt();
      // print(amt);
      Map<String, dynamic> paymentIntent =
          await createPaymentIntent(amt, 'INR');
      // print(2);
      var gpay = const PaymentSheetGooglePay(
          merchantCountryCode: "IN", currencyCode: "INR", testEnv: true);
      // print(gpay);
      //STEP 2: Initialize Payment Sheet
      await Stripe.instance
          .initPaymentSheet(
              paymentSheetParameters: SetupPaymentSheetParameters(
                  paymentIntentClientSecret: paymentIntent[
                      'client_secret'], //Gotten from payment intent
                  style: ThemeMode.light,
                  merchantDisplayName: 'Samarth',
                  googlePay: gpay))
          .then((value) {});
      // print(4);
      //STEP 3: Display Payment sheet
      displayPaymentSheet();
    } catch (err) {
      print(err);
    }
  }

  displayPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet().then((value) {
        print("Payment Successfully");
      });
    } catch (e) {
      print('$e');
    }
  }

  createPaymentIntent(String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': amount,
        'currency': currency,
      };
      print(6);
      var response = await Dio().post(
        'https://api.stripe.com/v1/payment_intents',
        options: Options(headers: {
          'Authorization':
              'Bearer sk_test_51PRwQIRr4jj2botnFOKBYuYtvVPwuNnuaklTB6Yo6sXZEEPsNptAtqxSdw2UI75isExWtvwBp6k1daJfPeO3h6BA001I1SeogL',
          'Content-Type': 'application/x-www-form-urlencoded'
        }),
        data: body,
      );
      print(7);
      return response.data;
    } catch (err) {
      print(err);
    }
  }

  void changeRating(Event e, double v) async {
    double x = double.parse(e.rating);
    x = (x + v) / 2.0;
    print(x);
    e.rating = x.toString();
    String query = '''mutation(\$data: ratingInput){
    changeRating(data: \$data)
    }''';
    var result = await gqs.performMutation(query, {
      'data': {"_id": e.id, "rating": double.parse(e.rating).toStringAsFixed(2)}
    });
    if (result.data!['changeRating'] == 1) {
      emit(EventDetailsStateLoaded(e));
    }
    return;
  }

  void updateUi(Event e) {
    emit(EventDetailsStateLoaded(e));
  }
}
