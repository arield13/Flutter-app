import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;
import 'package:shared_preferences/shared_preferences.dart';

/*
class ProfilePageDesign extends StatefulWidget {
  @override
  _ProfilePageDesignState createState() => _ProfilePageDesignState();
}

class _ProfilePageDesignState extends State<ProfilePageDesign> {

  @override
  void initState() {
    super.initState();

    SystemChrome.setEnabledSystemUIOverlays([]);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Profile",
      home: ProfilePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class ProfilePage extends StatelessWidget {

  TextStyle _style(){
    return TextStyle(
        fontWeight: FontWeight.bold
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text("Name"),
            SizedBox(height: 4,),
            Text("Milan Short", style: _style(),),
            SizedBox(height: 16,),

            Text("Email", style: _style(),),
            SizedBox(height: 4,),
            Text("milan@gmail.com"),
            SizedBox(height: 16,),

            Text("Location", style: _style(),),
            SizedBox(height: 4,),
            Text("New York, USA"),
            SizedBox(height: 16,),

            Text("Language", style: _style(),),
            SizedBox(height: 4,),
            Text("English, French"),
            SizedBox(height: 16,),

            Text("Occupation", style: _style(),),
            SizedBox(height: 4,),
            Text("Employee"),
            SizedBox(height: 16,),

            Divider(color: Colors.grey,)
          ],
        ),
      ),
    );
  }
}


final String url = "http://chuteirafc.cartacapital.com.br/wp-content/uploads/2018/12/15347041965884.jpg";

class CustomAppBar extends StatelessWidget
    with PreferredSizeWidget{

  @override
  Size get preferredSize => Size(double.infinity, 320);

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: MyClipper(),
      child: Container(
        padding: EdgeInsets.only(top: 4),
        decoration: BoxDecoration(
            color: Color.fromRGBO(239, 65, 3, 1),
            boxShadow: [
              BoxShadow(
                  color: Color.fromRGBO(239, 65, 3, 1),
                  blurRadius: 20,
                  offset: Offset(0, 0)
              )
            ]
        ),
        child: Column(
          children: <Widget>[
              Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[

                Column(
                  children: <Widget>[
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(url)
                          )
                      ),
                    ),
                    SizedBox(height: 16,),
                    Text("Milan Short", style: TextStyle(
                        color: Colors.white,
                        fontSize: 20
                    ),)
                  ],
                ),

                Column(
                  children: <Widget>[
                    Text("Schedule", style: TextStyle(
                        color: Colors.white
                    ),),
                    Text("8", style: TextStyle(
                        fontSize: 26,
                        color: Colors.white
                    ),)
                  ],
                ),

                Column(
                  children: <Widget>[
                    Text("Events", style: TextStyle(
                        color: Colors.white
                    ),),
                    Text("12", style: TextStyle(
                        fontSize: 26,
                        color: Colors.white
                    ),)
                  ],
                ),


                Column(
                  children: <Widget>[
                    Text("Routines", style: TextStyle(
                        color: Colors.white
                    ),),
                    Text("4", style: TextStyle(
                        fontSize: 26,
                        color: Colors.white
                    ),)
                  ],
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[

                Column(
                  children: <Widget>[
                    Text("Savings", style: TextStyle(
                        color: Colors.white
                    ),),
                    Text("20K", style: TextStyle(
                        color: Colors.white,
                        fontSize: 24
                    ),)
                  ],
                ),

                SizedBox(width: 32,),

                Column(
                  children: <Widget>[
                    Text("July Goals",
                      style: TextStyle(
                          color: Colors.white
                      ),),
                    Text("50K", style: TextStyle(
                        color: Colors.white,
                        fontSize: 24
                    ))
                  ],
                ),

                SizedBox(width: 16,)

              ],
            ),
          ],
        ),
      ),
    );
  }
}

class MyClipper extends CustomClipper<Path>{

  @override
  Path getClip(Size size) {
    Path p = Path();

    p.lineTo(0, size.height-120);
    p.lineTo(size.width, size.height -30);

    p.lineTo(size.width, 0);

    p.close();

    return p;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new ProfilePageDesign(),

    );
  }
}

class ProfilePageDesign extends StatefulWidget {
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<ProfilePageDesign> {

  @override
  void initState() {
    super.initState();
    getClients();
  }

  Future<void> getClients() async {
    Map<String, String> headers = {'Content-Type': 'application/json'};
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var user_type = prefs.getInt('usertype') ?? 0;
    user_type = user_type == 1 ? 2 : 1;
  }
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.white12,
        body: new Stack(

          children: <Widget>[

            ClipPath(

              child: Container(color: Color.fromRGBO(239, 65, 3, 1)),
              clipper: getClipper(),
            ),
            Positioned(
                width: 350.0,
                top: MediaQuery.of(context).size.height / 6,
                child: Column(
                  children: <Widget>[
                    Container(
                        width: 120.0,
                        height: 120.0,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image:   NetworkImage(
                                    'https://pixel.nymag.com/imgs/daily/vulture/2017/06/14/14-tom-cruise.w700.h700.jpg'),
                                fit: BoxFit.cover

                            ),

                            borderRadius: BorderRadius.all(Radius.circular(75.0)),
                            boxShadow: [
                              BoxShadow(blurRadius: 7.0, color: Colors.black)
                            ])),
                    SizedBox(height: 80.0),
                    Text(
                      'Tom Cruise',
                      style: TextStyle(
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Montserrat'),
                    ),
                    SizedBox(height: 15.0),
                    Text(
                      'Subscribe guys',
                      style: TextStyle(
                          fontSize: 17.0,
                          fontStyle: FontStyle.italic,
                          fontFamily: 'Montserrat'),
                    ),
                    SizedBox(height: 25.0),
                    Container(

                      color:  Colors.transparent,
                        height: 30.0,
                        width: 95.0,
                        child: Material(
                          borderRadius: BorderRadius.circular(20.0),
                          shadowColor: Colors.greenAccent,
                          color: Colors.green,
                          elevation: 7.0,
                          child: GestureDetector(
                            onTap: () {},
                            child: Center(
                              child: Text(
                                'Edit Name',
                                style: TextStyle(color: Colors.white, fontFamily: 'Montserrat'),
                              ),
                            ),
                          ),
                        )),
                    SizedBox(height: 25.0),
                    Container(
                        height: 30.0,
                        width: 95.0,
    color: Colors.transparent,
                        child: Material(
                          borderRadius: BorderRadius.circular(20.0),
                          shadowColor: Colors.blue,
                          color: Colors.red,
                          elevation: 7.0,
                          child: GestureDetector(
                            onTap: () {},
                            child: Center(
                              child: Text(
                                'Log out',
                                style: TextStyle(color: Colors.white, fontFamily: 'Montserrat'),
                              ),
                            ),
                          ),
                        ))
                  ],
                ))
          ],
        ));
  }
}

class getClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = new Path();

    path.lineTo(0.0, size.height / 1.9);
    path.lineTo(size.width + 125, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    // TODO: implement shouldReclip
    return true;
  }
}*/





class ProfilePageDesign extends StatefulWidget {
  final String title;
  ProfilePageDesign({Key key, this.title}) : super(key: key);
  _FbCloneProfileState createState() => _FbCloneProfileState();
}

class _FbCloneProfileState extends State<ProfilePageDesign> {
  Widget build(BuildContext cx) {
    return new Scaffold(
      body: new ListView(

        children: <Widget>[
          new Column(

            children: <Widget>[
              Container(
                color:  Colors.black12,
                child: Stack(

                  alignment: Alignment.bottomCenter,
                  overflow: Overflow.visible,
                  children: <Widget>[
                    Row(children: <Widget>[
                      Expanded(child:
                      Container(

                        height: 220.0,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage('https://www.sageisland.com/wp-content/uploads/2017/06/beat-instagram-algorithm.jpg')
                            )
                        ),
                      ),)
                    ],
                    ),
                    Positioned(
                      top: 30.0,
                      child: Container(
                        height: 180.0,
                        width: 180.0,

                        decoration: new BoxDecoration(
                            shape: BoxShape.circle,
                            image: new DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage('http://cdn.ppcorn.com/us/wp-content/uploads/sites/14/2016/01/Mark-Zuckerberg-pop-art-ppcorn.jpg'),
                            ),
                            border: Border.all(
                                color: Colors.white,
                                width: 6.0
                            )
                        ),
                      ),
                    ),
                  ],)
                ,
              ),


              Container(
                color:  Colors.white,
                alignment: Alignment.bottomCenter,
                height: 60.0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('Ariel Diaz', style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 28.0
                    ),),
                    SizedBox(width: 5.0,),
                    Icon(Icons.check_circle, color: Colors.blueAccent,)
                  ],
                ),
              ),

              Container(
                color:  Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        IconButton(
                          icon: Icon(Icons.collections,color: Colors.blueAccent),
                        ),
                        Text('following',style: TextStyle(
                            color: Colors.blueAccent
                        ),)
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        IconButton(
                          icon: Icon(Icons.message,color: Colors.black),
                        ),
                        Text('Message',style: TextStyle(
                            color: Colors.black
                        ),)
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        IconButton(
                          icon: Icon(Icons.more_vert,color: Colors.black),
                          onPressed: (){
                            _showMoreOption(cx);
                          },
                        ),
                        Text('More',style: TextStyle(
                            color: Colors.black
                        ),)
                      ],
                    )
                  ],
                ),
              ),
              Container(
                color:  Colors.white,
                padding: EdgeInsets.only(left: 10.0,right: 10.0, top: 10),
                child: Column(
                  children: <Widget>[
                    Row(children: <Widget>[
                      Icon(Icons.work),
                      SizedBox(width: 5.0,),
                      Text('Founder and CEO at',style: TextStyle(
                          fontSize: 18.0
                      ),),
                      SizedBox(width: 5.0,),
                      Text('SignBox',style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold
                      ),)
                    ],),
                    SizedBox(height: 10.0,),
                    Row(children: <Widget>[
                      Icon(Icons.work),
                      SizedBox(width: 5.0,),
                      Text('Works at',style: TextStyle(
                          fontSize: 18.0
                      ),),
                      SizedBox(width: 5.0,),
                      Text('SignBox',style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold
                      ),)
                    ],),
                    SizedBox(height: 10.0,),
                    Row(children: <Widget>[
                      Icon(Icons.school),
                      SizedBox(width: 5.0,),
                      Text('Studied Computer Science at',style: TextStyle(
                          fontSize: 18.0
                      ),),
                      SizedBox(width: 5.0,),
                    ],),

                  ],
                ),
              )


            ],
          )
        ],
      ),
    );

  }



  _showMoreOption(cx) {

    showModalBottomSheet(
      context: cx,
      builder: (BuildContext bcx) {

        return new Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(10.0),
              child:
              Row(children: <Widget>[
                Icon(Icons.feedback,
                  color: Colors.black,),
                SizedBox(width: 10.0,),
                Text('Give feedback or report this profile',
                  style: TextStyle(
                      fontSize: 18.0
                  ),)
              ],),),


            Container(
              padding: EdgeInsets.all(10.0),
              child:
              Row(children: <Widget>[
                Icon(Icons.block,
                  color: Colors.black,),
                SizedBox(width: 10.0,),
                Text('Block',
                  style: TextStyle(
                      fontSize: 18.0
                  ),)
              ],),),



            Container(
              padding: EdgeInsets.all(10.0),
              child:
              Row(children: <Widget>[
                Icon(Icons.link,
                  color: Colors.black,),
                SizedBox(width: 10.0,),
                Text('Copy link to profile',
                  style: TextStyle(
                      fontSize: 18.0
                  ),)
              ],),),



            Container(
              padding: EdgeInsets.all(10.0),
              child:
              Row(children: <Widget>[
                Icon(Icons.search,
                  color: Colors.black,),
                SizedBox(width: 10.0,),
                Text('Search Profile',
                  style: TextStyle(
                      fontSize: 18.0
                  ),)
              ],),)






          ],
        );

      },


    );


  }
}