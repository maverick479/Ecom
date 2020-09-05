import 'package:cloud_firestore/cloud_firestore.dart';

import 'cart_item.dart';

class UserModel {
//  static const ID = "uid";
//  static const NAME = "name";
//  static const EMAIL = "email";
//  static const STRIPE_ID = "stripeId";
//  static const CART = "cart";


  String _name;
  String _email;
  String _id;
  String _stripeId;
  int _priceSum = 0;


//  getters
  String get name => _name;

  String get email => _email;

  String get id => _id;

  String get stripeId => _stripeId;

  // public variables
  List<CartItemModel> cart = [];
  int totalCartPrice = 1;



  UserModel.fromSnapshot(DocumentSnapshot snapshot) {
    _name = snapshot.data["name"] ?? " ";
    _email = snapshot.data["email"];
    _id = snapshot.data["uid"];
    _stripeId = snapshot.data["stripeId"];
    cart = _convertCartItems(snapshot.data["cart"] ?? []);
    totalCartPrice = snapshot.data["cart"] == null ? 0 :getTotalPrice(cart: snapshot.data["Cart"]);

  }

  List<CartItemModel> _convertCartItems(List cart){
    List<CartItemModel> convertedCart = [];
    for(Map cartItem in cart){
      convertedCart.add(CartItemModel.fromMap(cartItem));
    }
    return convertedCart;
  }

  int getTotalPrice({List cart}){
    if(cart == null){
      return 0;
    }
    for(Map cartItem in cart){
      _priceSum += cartItem["price"];
    }

    int total = _priceSum;
    return total;
  }
}