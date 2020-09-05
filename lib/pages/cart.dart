import 'package:flutter/material.dart';
import 'package:flutter_ecom/db/order.dart';
import 'package:flutter_ecom/models/cart_item.dart';
import 'package:flutter_ecom/provider/app.dart';
import 'package:flutter_ecom/provider/user.dart';
import 'package:flutter_ecom/widgets/custom_text.dart';
import 'package:flutter_ecom/widgets/loading.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import 'CartBuilder.dart';

class CartScreen extends StatefulWidget {
  final List<CartItemModel> cart;

  const CartScreen({this.cart});
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  void initState(){
    super.initState();
    print(widget.cart);
  }

  final _key = GlobalKey<ScaffoldState>();
  OrderServices _orderServices = OrderServices();

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final appProvider = Provider.of<AppProvider>(context);

    return Scaffold(
      key: _key,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0.0,
        title: CustomText(text: "Shopping Cart"),
        leading: IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      backgroundColor: Colors.white,
      body: CartBuilder(widget.cart),
      bottomNavigationBar: Container(
        height: 70,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              RichText(
                text: TextSpan(children: [
                  TextSpan(
                      text: "Total: ",
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 22,
                          fontWeight: FontWeight.w400)),
                  TextSpan(
                      text: " \$${userProvider?.userModel?.totalCartPrice ?? 0}",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 22,
                          fontWeight: FontWeight.normal)),
                ]),
              ),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20), color: Colors.black),
                child: FlatButton(
                    onPressed: () {
                      if (userProvider?.userModel?.totalCartPrice ?? 0 != null) {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return Dialog(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0)),
                                //this right here
                                child: Container(
                                  height: 200,
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Column(
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          children: <Widget>[
                                            Text(
                                              'Your cart is empty',
                                              textAlign: TextAlign.center,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            });
                        return;
                      }
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return Dialog(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0)),
                              //this right here
                              child: Container(
                                height: 200,
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'You will be charged \$${userProvider?.userModel?.totalCartPrice ?? 0} upon delivery!',
                                        textAlign: TextAlign.center,
                                      ),
                                      SizedBox(
                                        width: 320.0,
                                        child: RaisedButton(
                                          onPressed: () async {
                                            var uuid = Uuid();
                                            String id = uuid.v4();
                                            _orderServices.createOrder(
                                                userId: userProvider.user.uid,
                                                id: id,
                                                description:
                                                "Some random description",
                                                status: "complete",
                                                totalPrice: userProvider?.userModel?.totalCartPrice ?? 0,
                                                cart: userProvider
                                                    .userModel.cart);
                                            for (CartItemModel cartItem
                                            in userProvider
                                                .userModel.cart) {
                                              bool value = await userProvider
                                                  .removeFromCart(
                                                  cartItem: cartItem);
                                              if (value) {
                                                userProvider.reloadUserModel();
                                                print("Item added to cart");
                                                _key.currentState.showSnackBar(
                                                    SnackBar(
                                                        content: Text(
                                                            "Removed from Cart!")));
                                              } else {
                                                print("ITEM WAS NOT REMOVED");
                                              }
                                            }
                                            _key.currentState.showSnackBar(
                                                SnackBar(
                                                    content: Text(
                                                        "Order created!")));
                                            Navigator.pop(context);
                                          },
                                          child: Text(
                                            "Accept",
                                            style:
                                            TextStyle(color: Colors.white),
                                          ),
                                          color: const Color(0xFF1BC0C5),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 320.0,
                                        child: RaisedButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text(
                                              "Reject",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                            color: Colors.red),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          });
                    },
                    child: CustomText(
                      text: "Check out",
                      size: 20,
                      color: Colors.white,
                      weight: FontWeight.normal,
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}