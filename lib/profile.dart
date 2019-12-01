import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePageDesign extends StatefulWidget {
  final String title;
  ProfilePageDesign({Key key, this.title}) : super(key: key);
  _FbCloneProfileState createState() => _FbCloneProfileState();
}

class _FbCloneProfileState extends State<ProfilePageDesign> {

  String user;
  String email;
  String profile;

  @override
  void initState() {
    super.initState();

    getUserInfo();
  }

  Future<void> getUserInfo() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var type = prefs.getInt('usertype') ?? 0;
    email = prefs.getString('userEmail') ?? null;
    user = prefs.getString('fullname') ?? null;
    profile = type == 1 ? "Cliente" : "Negocio";
    setState(() {
      email = email;
      user = user;
      profile = profile;
    });
  }

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
                        color: Colors.white70,
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
                              fit: BoxFit.contain,
                              image: AssetImage('images/user_icon.png'),

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
                    Text(user != null? user : "" , style: TextStyle(
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
                        Text('Seguir',style: TextStyle(
                            color: Colors.blueAccent
                        ),)
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        IconButton(
                          icon: Icon(Icons.message,color: Colors.black),
                        ),
                        Text('Citas',style: TextStyle(
                            color: Colors.black
                        ),)
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        IconButton(
                          icon: Icon(Icons.more_vert,color: Colors.black),
                          onPressed: (){
                           // _showMoreOption(cx);
                          },
                        ),
                        Text('Mas',style: TextStyle(
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
                      Icon(Icons.email),
                      SizedBox(width: 5.0,),
                      Text(email != null ? email : "",style: TextStyle(
                          fontSize: 18.0
                      ),),
                      SizedBox(width: 5.0,),

                    ],),
                   /* SizedBox(height: 10.0,),
                    Row(children: <Widget>[
                      Icon(Icons.location_on),
                      SizedBox(width: 5.0,),
                      Text(address,style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold
                      ),)
                    ],),*/
                    SizedBox(height: 10.0,),
                    Row(children: <Widget>[
                      Icon(Icons.person),
                      SizedBox(width: 5.0,),
                      Text(profile != null ? profile : "",style: TextStyle(
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
              padding: EdgeInsets.all(5.0),
              child:
              Row(children: <Widget>[
                Icon(Icons.feedback,
                  color: Colors.black,),
                SizedBox(width: 10.0,),
                Text('Menu usuario.',
                  style: TextStyle(
                      fontSize: 18.0
                  ),)
              ],),),


            Container(
              padding: EdgeInsets.all(10.0),
              child:
              Row(children: <Widget>[
                Icon(Icons.close,
                  color: Colors.black,),
                SizedBox(width: 10.0,),
                Text('Salir',
                  style: TextStyle(
                      fontSize: 18.0
                  ),)
              ],),),



          /*  Container(
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
              ],),)*/






          ],
        );

      },


    );


  }
}