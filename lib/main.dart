import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/bloc/listTileColorBloc.dart';
import 'bloc/cartlistBloc.dart';
import 'cart.dart';
import 'const/themeColor.dart';
import 'model/food_item.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'authservice.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

dynamic db = FirebaseFirestore.instance;
// Create a new user with a first and last name
var product = <String, dynamic>{
  "name": "Chilly Cheeze Burger",
  "price": 14.49,
  "image": "https://hips.hearstapps.com/pop.h-cdn.co/assets/cm/15/05/480x240/54ca71fb94ad3_-_5summer_skills_burger_470_0808-de.jpg",
};
//var listProducts;


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      blocs: [
        //add yours BLoCs controlles
        Bloc((i) => CartListBloc()),
        Bloc((i) => ColorBloc()),
      ],
      child: MaterialApp(
        title: "Food Delivery",
        home: Home(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class Home extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child:signup()
    ));
  }
}


class Home3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            child:addNewItem()
        ));
  }
}


class Home4 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            child:login()
        ));
  }
}


class Home2 extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Container(
            child: ListView(
              children: <Widget>[
                FirstHalf(),
                SizedBox(height: 45),
                for (var foodItem in listProduct)
                  Builder(
                    builder: (context) {
                      return ItemContainer(foodItem: FoodItem(
                        title:foodItem["name"],
                        hotel:foodItem["name"],
                        price:140,
                        imgUrl:foodItem["image"],
                        quantity:1,
                         id:4));
                    },
                  ),
              ],
            ),
          )),
    );
  }
}


class ItemContainer extends StatelessWidget {
  
  ItemContainer({
    @required this.foodItem,
  });

  final FoodItem foodItem;
  final CartListBloc bloc = BlocProvider.getBloc<CartListBloc>();

  
  addToCart(FoodItem foodItem) {
    bloc.addToList(foodItem);
  }

  removeFromList(FoodItem foodItem) {
    bloc.removeFromList(foodItem);
  }


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        addToCart(foodItem);
        final snackBar = SnackBar(
          content: Text('Rs.{foodItem.title} added to Cart'),
          duration: Duration(milliseconds: 550),
        );

       // Scaffold.of(context).showSnackBar(snackBar);
      },
      child: Items(
        hotel: foodItem.hotel,
        itemName: foodItem.title,
        itemPrice: foodItem.price,
        imgUrl: foodItem.imgUrl,
        leftAligned: (foodItem.id % 2) == 0 ? true : false,
      ),
    );
  }
}

class FirstHalf extends StatelessWidget {
  const FirstHalf({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(35, 25, 0, 0),
      child: Column(
        children: <Widget>[
          CustomAppBar(),
          //you could also use the spacer widget to give uneven distances, i just decided to go with a sizebox
          SizedBox(height: 30),
          title(),
          SizedBox(height: 30),
          searchBar(),
          SizedBox(height: 45),
          categories(),
        ],
      ),
    );
  }
}

Widget categories() {
  return Container(
    height: 185,
    child: ListView(
      scrollDirection: Axis.horizontal,
      children: <Widget>[
        CategoryListItem(
          categoryIcon: Icons.bug_report,
          categoryName: "Burgers",
          availability: 7,
          selected: true,
        ),
        CategoryListItem(
          categoryIcon: Icons.bug_report,
          categoryName: "Pizza",
          availability: 4,
          selected: false,
        ),
        CategoryListItem(
          categoryIcon: Icons.bug_report,
          categoryName: "Rolls",
          availability: 3,
          selected: false,
        ),
      ],
    ),
  );
}

class Items extends StatelessWidget {
  Items({
    @required this.leftAligned,
    @required this.imgUrl,
    @required this.itemName,
    @required this.itemPrice,
    @required this.hotel,
  });

  final bool leftAligned;
  final String imgUrl;
  final String itemName;
  final double itemPrice;
  final String hotel;

  @override
  Widget build(BuildContext context) {
    double containerPadding = 45;
    double containerBorderRadius = 10;

    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(
            left: leftAligned ? 0 : containerPadding,
            right: leftAligned ? containerPadding : 0,
          ),
          child: Column(
            children: <Widget>[
              Container(
                width: double.infinity,
                height: 200,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(10)),
                child: ClipRRect(
                  borderRadius: BorderRadius.horizontal(
                    left: leftAligned
                        ? Radius.circular(0)
                        : Radius.circular(containerBorderRadius),
                    right: leftAligned
                        ? Radius.circular(containerBorderRadius)
                        : Radius.circular(0),
                  ),
                  child: Image.network(
                    imgUrl,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Container(
                  padding: EdgeInsets.only(
                    left: leftAligned ? 20 : 0,
                    right: leftAligned ? 0 : 20,
                  ),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Text(itemName,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 18,
                                  )),
                            ),
                            Text(("\R\s\."+(itemPrice).toString()),
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 18,
                                )),
                          ],
                        ),
                        SizedBox(height: 10),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: RichText(
                            text: TextSpan(
                                style: TextStyle(
                                    color: Colors.black45, fontSize: 15),
                                children: [
                                  TextSpan(text: "by "),
                                  TextSpan(
                                      text: "Burger Club",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700))
                                ]),
                          ),
                        ),
                        SizedBox(height: containerPadding),
                      ])),
            ],
          ),
        )
      ],
    );
  }
}

class CategoryListItem extends StatelessWidget {
  const CategoryListItem({
    Key key,
    @required this.categoryIcon,
    @required this.categoryName,
    @required this.availability,
    @required this.selected,
  }) : super(key: key);

  final IconData categoryIcon;
  final String categoryName;
  final int availability;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 20),
      padding: EdgeInsets.fromLTRB(10, 10, 10, 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: selected ? Themes.color : Colors.white,
        border: Border.all(
            color: selected ? Colors.transparent : Colors.grey[200],
            width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.grey[100],
            blurRadius: 15,
            offset: Offset(15, 0),
            spreadRadius: 5,
          )
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(50),
                border: Border.all(
                    color: selected ? Colors.transparent : Colors.grey[200],
                    width: 1.5)),
            child: Icon(
              categoryIcon,
              color: Colors.black,
              size: 30,
            ),
          ),
          SizedBox(height: 10),
          Text(
            categoryName,
            style: TextStyle(
                fontWeight: FontWeight.w700, color: Colors.black, fontSize: 15),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(0, 6, 0, 10),
            width: 1.5,
            height: 15,
            color: Colors.black26,
          ),
          Text(
            availability.toString(),
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          )
        ],
      ),
    );
  }
}

Widget searchBar() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: <Widget>[
      Icon(
        Icons.search,
        color: Colors.black45,
      ),
      SizedBox(width: 20),
      Expanded(
        child: TextField(
          decoration: InputDecoration(
              hintText: "Search....",
              contentPadding: EdgeInsets.symmetric(vertical: 10),
              hintStyle: TextStyle(
                color: Colors.black87,
              ),
              border: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.red))),
        ),
      ),
    ],
  );
}

Widget title() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: <Widget>[
      SizedBox(width: 45),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Food",
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 30,
            ),
          ),
          Text(
            "Delivery",
            style: TextStyle(
              fontWeight: FontWeight.w200,
              fontSize: 30,
            ),
          ),
        ],
      )
    ],
  );
}

class CustomAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final CartListBloc bloc = BlocProvider.getBloc<CartListBloc>();
    // TODO: implement build
    return Container(
      margin: EdgeInsets.only(bottom: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[

          ElevatedButton(
            child:Icon(Icons.menu),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Home3()),
              );
            },
          ),
          StreamBuilder(
            stream: bloc.listStream,
            builder: (context, snapshot) {
              List<FoodItem> foodItems = snapshot.data;
              int length = foodItems != null ? foodItems.length : 0;

              return buildGestureDetector(length, context, foodItems);
            },
          )
        ],
      ),
    );
  }

  GestureDetector buildGestureDetector(
      int length, BuildContext context, List<FoodItem> foodItems) {
    return GestureDetector(
      onTap: () {
        if (length > 0) {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => Cart()));
        } else {
          return;
        }
      },
      child: Container(
        margin: EdgeInsets.only(right: 30),
        child: Text(length.toString()),
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
            color: Colors.yellow[800], borderRadius: BorderRadius.circular(50)),
      ),
    );
  }
}

var pwd = "";
var mail = "";
List listProduct=[];
class signup extends StatelessWidget {
@override
Widget build(BuildContext context) {
  {
    return Center(
        child: SizedBox(
            width: 200, // set this
            height: 700, // set this
            child: Column(
              children: <Widget>[
                Text(
                  'REGISTER',
                  style: TextStyle(fontSize: 24.0),
                ),
                Icon(
                  Icons.email,
                  color: Colors.black45,
                ),
                SizedBox(width: 50),
                Expanded(
                  child: TextField(
                    onChanged: (value) {
                      mail = value;
                    },
                    decoration: InputDecoration(
                        hintText: "Enter email....",
                        contentPadding: EdgeInsets.symmetric(vertical: 10),
                        hintStyle: TextStyle(
                          color: Colors.black87,
                        ),
                        border: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.red))),
                  ),
                ),
                Icon(
                  Icons.password,
                  color: Colors.black45,
                ),
                SizedBox(width: 20),
                Expanded(
                  child: TextField(
                    onChanged: (value) async{
                      pwd = value;
                    },
                    decoration: InputDecoration(
                        hintText: "Enter password....",
                        contentPadding: EdgeInsets.symmetric(vertical: 10),
                        hintStyle: TextStyle(
                          color: Colors.black87,
                        ),
                        border: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.red))),
                  ),
                ),

                Icon(
                  Icons.password,
                  color: Colors.black45,
                ),
                SizedBox(width: 20),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                        hintText: "Confirm Password....",
                        contentPadding: EdgeInsets.symmetric(vertical: 10),
                        hintStyle: TextStyle(
                          color: Colors.black87,
                        ),
                        border: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.red))),
                  ),
                ),

                ElevatedButton(
                  child: const Text(
                    'Register',
                    style: TextStyle(fontSize: 24.0),
                  ),
                  onPressed: () async{
                    // Add a new document with a generated ID
                   // var res = await mailRegister(mail, pwd);
                    await FirebaseAuth.instance
                        .createUserWithEmailAndPassword(email: mail, password: pwd);

                    await db.collection("products").get().then((event) {
                       for (var doc in event.docs) {
                         print("\G\O\T\F\I\R\E\B\A\S\E ${doc.id} => ${doc.data()}");
                       //  print("\G\O\T\F\I\R\E\B\A\S\E ${listProduct}");
                         listProduct.add(doc.data());
                       }

                       Navigator.push(
                         context,
                         MaterialPageRoute(builder: (context) => Home2()),
                       );
                    });
                  },
                ),
                ElevatedButton(
                  child: const Text(
                    'Have an account?LOGIN ',
                    style: TextStyle(fontSize: 15.0),
                  ),
                  onPressed: () async{
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Home4()),
                    );
                  },
                ),
              ],
            )
        )
    );
  }
}
}


class addNewItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    {
      return Center(
          child: SizedBox(
              width: 200, // set this
              height: 700, // set this
              child: Column(
                children: <Widget>[
                  Text(
                    'Add new item',
                    style: TextStyle(fontSize: 24.0),
                  ),
                  SizedBox(height: 50),
                  Expanded(
                    child: TextField(
                      onChanged: (value) {
                        product["name"] = value;
                      },
                      decoration: InputDecoration(
                          hintText: "Enter name....",
                          contentPadding: EdgeInsets.symmetric(vertical: 10),
                          hintStyle: TextStyle(
                            color: Colors.black87,
                          ),
                          border: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.red))),
                    ),
                  ),
                  SizedBox(height: 20),
                  Expanded(
                    child: TextField(
                      onChanged: (value) {
                        product["price"] = value;
                      },
                      decoration: InputDecoration(
                          hintText: "Enter price....",
                          contentPadding: EdgeInsets.symmetric(vertical: 10),
                          hintStyle: TextStyle(
                            color: Colors.black87,
                          ),
                          border: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.red))),
                    ),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                          hintText: "Confirm price....",
                          contentPadding: EdgeInsets.symmetric(vertical: 10),
                          hintStyle: TextStyle(
                            color: Colors.black87,
                          ),
                          border: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.red))),
                    ),
                  ),
                  SizedBox(width: 50),
                  Expanded(
                    child: TextField(
                      onChanged: (value) {
                        product["image"] = value;
                      },
                      decoration: InputDecoration(
                          hintText: "Enter image url....",
                          contentPadding: EdgeInsets.symmetric(vertical: 10),
                          hintStyle: TextStyle(
                            color: Colors.black87,
                          ),
                          border: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.red))),
                    ),

                  ),
                  ElevatedButton(
                    child: const Text(
                      'Add new item',
                      style: TextStyle(fontSize: 24.0),
                    ),

                    onPressed: () async{
                      db.collection("products").add(product).then((DocumentReference doc) =>print('DocumentSnapshot added with ID: ${doc.id}'));
                      await db.collection("products").get().then((event) {
                        for (var doc in event.docs) {
                          print("\G\O\T\F\I\R\E\B\A\S\E ${doc.id} => ${doc.data()}");
                          //  print("\G\O\T\F\I\R\E\B\A\S\E ${listProduct}");
                          listProduct.add(doc.data());
                        }

                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Home2()),
                        );
                      });
                    },
                  ),
                ],
              )
          )
      );
    }
  }
}


class successfulCheckout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    {
      return Center(
          child: SizedBox(
              width: 1000, // set this
              height: 700, // set this
              child: Column(
                children: <Widget>[
                  ElevatedButton(
                    child: const Text(
                      'Order Successful ... Continue',
                      style: TextStyle(fontSize: 24.0),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Home2()),
                      );
                    },
                  ),
                ],
              )
          )
      );
    }
  }
}



class login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    {
      return Center(
          child: SizedBox(
              width: 200, // set this
              height: 700, // set this
              child: Column(
                children: <Widget>[
                  const Text(
                    'LOGIN',
                    style: TextStyle(fontSize: 24.0),
                  ),
                  Icon(
                    Icons.email,
                    color: Colors.black45,
                  ),
                  SizedBox(width: 50),
                  Expanded(
                    child: TextField(
                      onChanged: (value) {
                        mail = value;
                      },
                      decoration: InputDecoration(
                          hintText: "Enter email....",
                          contentPadding: EdgeInsets.symmetric(vertical: 10),
                          hintStyle: TextStyle(
                            color: Colors.black87,
                          ),
                          border: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.red))),
                    ),
                  ),
                  Icon(
                    Icons.face,
                    color: Colors.black45,
                  ),
                  SizedBox(width: 50),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                          hintText: "Enter name....",
                          contentPadding: EdgeInsets.symmetric(vertical: 10),
                          hintStyle: TextStyle(
                            color: Colors.black87,
                          ),
                          border: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.red))),
                    ),
                  ),
                  Icon(
                    Icons.password,
                    color: Colors.black45,
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: TextField(
                      onChanged: (value) async{
                        pwd = value;
                      },
                      decoration: InputDecoration(
                          hintText: "Enter password....",
                          contentPadding: EdgeInsets.symmetric(vertical: 10),
                          hintStyle: TextStyle(
                            color: Colors.black87,
                          ),
                          border: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.red))),
                    ),
                  ),
                  ElevatedButton(
                    child: const Text(
                      'Login',
                      style: TextStyle(fontSize: 24.0),
                    ),
                    onPressed: () async{
                      // Add a new document with a generated ID
                      // var res = await mailRegister(mail, pwd);
                      await
                      await FirebaseAuth.instance
                          .signInWithEmailAndPassword(email: mail, password: pwd);

                      await db.collection("products").get().then((event) {
                        for (var doc in event.docs) {
                          print("\G\O\T\F\I\R\E\B\A\S\E ${doc.id} => ${doc.data()}");
                          //  print("\G\O\T\F\I\R\E\B\A\S\E ${listProduct}");
                          listProduct.add(doc.data());
                        }

                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Home2()),
                        );
                      });
                    },
                  ),
                ],
              )
          )
      );
    }
  }
}
