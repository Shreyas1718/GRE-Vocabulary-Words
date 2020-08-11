import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import "dart:math";
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tindercard/flutter_tindercard.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return MaterialApp(
      title: 'Dynamic Widget',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: InitState(),
    );
  }
}

class InitState extends StatelessWidget {
  final String assetName = 'assets/undraw_teaching_f1cm.svg';
  TextEditingController textFieldController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Center(
          child: Stack(
        children: [
          Center(
            child: Container(

              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: SvgPicture.asset(
                  assetName,
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 20.0),
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Text('Enter the number of words you want learn Today !!!',
                style: TextStyle(
                    fontSize: 30,
                    color: Color(0xFF101C4A),
                    fontWeight: FontWeight.bold

                ),),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(60.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [

                      TextFormField(
                        style: TextStyle(
                          color: Colors.white,
                        ),
                        cursorColor: Color(0xFFFFFFFF),
                        controller: textFieldController,
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          WhitelistingTextInputFormatter.digitsOnly
                        ],
                        decoration: InputDecoration(
                          labelStyle:  TextStyle(fontSize: 25.0, color: Colors.white),
                            border: InputBorder.none,
                            fillColor:Color(0xFFFFFFFF) ,
                            focusColor: Color(0xFFFFFFFF),
                            hintStyle: TextStyle(fontSize: 15.0, color: Colors.white),
                            hintText: 'Enter Here'),
                        validator: (text) {
                          if (text == null || text.isEmpty) {
                            return 'Enter a number!!!';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
              FlatButton(
                color: Color(0xFF101C4A),
                textColor: Colors.white,
                disabledColor: Colors.grey,
                disabledTextColor: Colors.black,
                padding: EdgeInsets.all(8.0),
                splashColor: Color(0xFF101C4A),
                onPressed: () {
                  if (_formKey.currentState.validate() == true) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              MyHomePage(textFieldController.text),
                        ));
                  }
                },
                child: Text(
                  "Submit",
                  style: TextStyle(fontSize: 20.0),
                ),
              )
            ],
          ),
        ],
      )),
    );
  }
}

CardController controller;

class MyHomePage extends StatefulWidget {
  String number1;
  MyHomePage(this.number1);
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _random = new Random();

  var showData = [];
  var listToShow = [];
  var secondList = [];
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "GRE WordList",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xFF101C4A),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.filter_list,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LeftSwiped(secondList),
                  ));
            },
          )
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: Center(
          child: FutureBuilder(
            future:
                DefaultAssetBundle.of(context).loadString("assets/output.json"),
            builder: (context, snapshot) {
              showData = json.decode(snapshot.data.toString());
              if (snapshot.hasData) {
                listToShow = new List.generate(int.parse(widget.number1),
                    (_) => showData[_random.nextInt(showData.length)]);

                return Center(
                    child: Container(
                  height: MediaQuery.of(context).size.height * 0.6,
                  child: TinderSwapCard(
                    swipeUp: true,
                    swipeDown: true,
                    orientation: AmassOrientation.BOTTOM,
                    totalNum: listToShow.length,
                    stackNum: 3,
                    swipeEdge: 4.0,
                    maxWidth: MediaQuery.of(context).size.width * 0.9,
                    maxHeight: MediaQuery.of(context).size.width * 0.9,
                    minWidth: MediaQuery.of(context).size.width * 0.8,
                    minHeight: MediaQuery.of(context).size.width * 0.8,
                    cardBuilder: (context, index) => Card(

                      elevation: 10,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              child: Text(
                                listToShow[index]['word'].toUpperCase(),
                                style: TextStyle(
                                  fontSize: 30,
                                  color: Color(0xFF101C4A),
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                  top:
                                      MediaQuery.of(context).size.width * 0.05),
                              child: Text(listToShow[index]['meaning'])
                            ),
                          ],
                        ),
                      ),
                    ),
                    cardController: controller = CardController(),
                    swipeUpdateCallback:
                        (DragUpdateDetails details, Alignment align) {
                      /// Get swiping card's alignment
                      if (align.x < 0) {
                      } else if (align.x > 0) {
                        //Card is RIGHT swiping
                      }
                    },
                    swipeCompleteCallback:
                        (CardSwipeOrientation orientation, int index) {
                      /// Get orientation & index of swiped cards
                      if (orientation == CardSwipeOrientation.RIGHT) {}
                      if (orientation == CardSwipeOrientation.LEFT) {
                        secondList.add(listToShow[index]);
                      }
                    },
                  ),
                ));
              }
              return CircularProgressIndicator(
                value: 2,
              );
            },
          ),
        ),
      ),
    );
  }
}

class LeftSwiped extends StatefulWidget {
  List secondList = [];
  LeftSwiped(this.secondList);
  @override
  _LeftSwipedState createState() => _LeftSwipedState();
}

class _LeftSwipedState extends State<LeftSwiped> {
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    widget.secondList.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Learn Again",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xFF101C4A),
      ),
      body: widget.secondList.length == 0
          ? Center(
              child: Text('No Words to learn!!!'),
            )
          : TinderSwapCard(
              swipeUp: true,
              swipeDown: true,
              orientation: AmassOrientation.BOTTOM,
              totalNum: widget.secondList.length,
              stackNum: 3,
              swipeEdge: 4.0,
              maxWidth: MediaQuery.of(context).size.width * 0.9,
              maxHeight: MediaQuery.of(context).size.width * 0.9,
              minWidth: MediaQuery.of(context).size.width * 0.8,
              minHeight: MediaQuery.of(context).size.width * 0.8,
              cardBuilder: (context, index) => Card(
                elevation: 10,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        child: Text(
                          widget.secondList[index]['word'].toUpperCase(),
                          style: TextStyle(
                            fontSize: 30,
                            color: Color(0xFF101C4A),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                            top: MediaQuery.of(context).size.width * 0.05),
                        child: Text(
                          widget.secondList[index]['meaning'],
                          style:
                              TextStyle(fontSize: 15, color: Color(0xFF101C4A)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              cardController: controller = CardController(),
              swipeUpdateCallback:
                  (DragUpdateDetails details, Alignment align) {
                /// Get swiping card's alignment
                if (align.x < 0) {
                } else if (align.x > 0) {
                  //Card is RIGHT swiping
                }
              },
              swipeCompleteCallback:
                  (CardSwipeOrientation orientation, int index) {
                /// Get orientation & index of swiped cards
              },
            ),
    );
  }
}
