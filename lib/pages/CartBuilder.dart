import 'package:flutter/material.dart';
import 'package:flutter_ecom/models/cart_item.dart';
import 'package:flutter_ecom/provider/app.dart';
import 'package:flutter_ecom/provider/user.dart';
import 'package:flutter_ecom/widgets/loading.dart';
import 'package:provider/provider.dart';

class CartBuilder extends StatefulWidget {
  final List<CartItemModel> cart;
  CartBuilder(this.cart);
  @override
  _CartBuilderState createState() => _CartBuilderState();
}

class _CartBuilderState extends State<CartBuilder> {
  List<CartItemModel> cart;


  final _key = GlobalKey<ScaffoldState>();

  @override
  void initState(){
    super.initState();
    cart = widget.cart;
    print(cart);
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final appProvider = Provider.of<AppProvider>(context);


    return  appProvider.isLoading ? Loading() :ListView.builder(
        itemCount: userProvider.userModel?.cart?.length ?? 0,
        itemBuilder: (_, index) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              height: 120,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.red.withOpacity(0.2),
                        offset: Offset(3, 2),
                        blurRadius: 30)
                  ]),
              child: Row(
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      topLeft: Radius.circular(20),
                    ),
                    child: Image.network(
                      userProvider.userModel.cart[index].image,
                      height: 120,
                      width: 140,
                      fit: BoxFit.fill,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        RichText(
                          text: TextSpan(children: [
                            TextSpan(
                                text: userProvider
                                    .userModel.cart[index].name +
                                    "\n",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold)),
                            TextSpan(
                                text:
                                "\$${userProvider.userModel.cart[index].price /
                                    100} \n\n",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w300)),
                          ]),
                        ),
                        IconButton(
                            icon: Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                            onPressed: () async {
                              appProvider.changeIsLoading();
                              bool value =
                              await userProvider.removeFromCart(
                                  cartItem: userProvider
                                      .userModel.cart[index]);
                              if (value) {
                                userProvider.reloadUserModel();
                                print("Item added to cart");
                                _key.currentState.showSnackBar(SnackBar(
                                    content: Text("Removed from Cart!")));
                                appProvider.changeIsLoading();
                                return;
                              } else {
                                appProvider.changeIsLoading();
                              }
                            })
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }
}
