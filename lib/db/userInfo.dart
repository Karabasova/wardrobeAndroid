import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:flutter_advanced_networkimage/transition.dart';
import 'package:flutter_app/db/FirestoreManager.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class UserInfoList extends StatelessWidget{
  DocumentSnapshot userInfo;
  DocumentSnapshot itemInfo;
  double _imageHeight = 248.0;

  UserInfoList({@required this.userInfo, this.itemInfo});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('items').where("userId", isEqualTo: userInfo.data['uid']).snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) return new Text('Error: ${snapshot.error}');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Scaffold(body: new Text('Loading...'));
          default:
            return Scaffold(
              appBar: AppBar(
                title: Text(userInfo['name']),
              ),
                 body: new Center(
                   child: Column(
                      children: <Widget>[
//              Image.network(userInfo['photo'],
//    //                  height: 150,
//    //                  width: 150,
//                    ),
                        new Stack(
                          children: <Widget>[
                            _buildIamge(),
                            new Padding(
                              padding: new EdgeInsets.only(left: 16.0, top: _imageHeight / 3.5),
                              child: Column(
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Text(
                                        "User name: ",
                                        style: new TextStyle(
                                          //  fontSize: 30.0,
                                            color: Colors.black,
                                            fontFamily: 'DancingScript-Bold', //neberie
                                            fontWeight: FontWeight.w400
                                        ),
                                      ),
                                      Padding(padding: EdgeInsets.only(right: 10.0),),
                                      Text(
                                        userInfo.data['name'],
                                        style: new TextStyle(
                                            fontSize: 20.0,
                                            color: Colors.black,
                                            fontFamily: 'DancingScript-Bold', //neberie
                                            fontWeight: FontWeight.w400
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Text(
                                        "User email: ",
                                        textAlign: TextAlign.left,
                                        style: new TextStyle(
                                          //  fontSize: 30.0,
                                            color: Colors.black,
                                            fontFamily: 'DancingScript-Bold', //neberie
                                            fontWeight: FontWeight.w400
                                        ),
                                      ),
                                      Padding(padding: EdgeInsets.only(right: 10.0),),
                                      Text(
                                        userInfo.data['email'],
                                        textAlign: TextAlign.left,
                                        style: new TextStyle(
                                            fontSize: 15.0,
                                            color: Colors.black,
                                            fontFamily: 'DancingScript-Bold', //neberie
                                            fontWeight: FontWeight.w400
                                        ),
                                      ),]
                                  ),
                                      Row(
                                        children: <Widget>[
                                          Text(
                                            "Item: ",
                                            textAlign: TextAlign.left,
                                            style: new TextStyle(
                                              //  fontSize: 30.0,
                                                color: Colors.black,
                                                fontFamily: 'DancingScript-Bold', //neberie
                                                fontWeight: FontWeight.w400
                                            ),
                                          ),
                                          Padding(padding: EdgeInsets.only(right: 10.0),),
                                          Text(
                                            itemInfo.data['name'],
                                            textAlign: TextAlign.left,
                                            style: new TextStyle(
                                                fontSize: 15.0,
                                                color: Colors.black,
                                                fontFamily: 'DancingScript-Bold', //neberie
                                                fontWeight: FontWeight.w400
                                            ),
                                          ),
                                        ],
                                      ),
                                  Container(
                                    margin: EdgeInsets.only(left: 270.0,top: 30.0,right: 20.0),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(30.0),
                                      child: Material(
                                        color: Colors.pink,
                                        shape:  _DiamondBorder(),
                                    child: InkWell(
                                      onTap: (){
                                        if (itemInfo.data['borrowedTo'] == ""  || itemInfo.data['borrowedTo'] == null) {
                                          itemInfo.data['borrowedTo'] = userInfo.data['uid'];
                                          itemInfo.data['borrowName'] = userInfo.data['name'];
                                          Firestore.instance.collection('items')
                                              .document(itemInfo.documentID)
                                              .updateData({
                                            "borrowedTo": itemInfo.data['borrowedTo'],
                                            "borrowName": itemInfo.data['borrowName']
                                          });
                                          debugPrint(itemInfo.data['borrowedTo']);
                                          debugPrint(itemInfo.data['borrowName']);
                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                        }
                                        else {
                                          Firestore.instance.collection('items')
                                              .document(itemInfo.documentID)
                                              .updateData({
                                            "borrowedTo": "",
                                            "borrowName": ""
                                          });
                                          Navigator.pop(context);
                                        }
                                      },
                                      child: Container(
                                        height: 90.0,
                                        alignment: Alignment.center,
                                        padding: EdgeInsets.symmetric(vertical: 30.0),
                                        child: Text(
                                            itemInfo.data['borrowedTo'] == ""  || itemInfo.data['borrowedTo'] == null ?
                                            'Choose' : 'Return',style: TextStyle(color: Colors.white),),
                                    ),
                                  ),),),)
                                    ],
                                  ),),
                                ],
                              ),
                        Text('User\'s items: '),
                        Expanded(
                          child: Container(
                            height: 200.0,
                            child: ListView(
                                children:
                                snapshot.data.documents.map((DocumentSnapshot document){
                                  return Slidable(
                                    delegate: SlidableDrawerDelegate(),
                                    actionExtentRatio: 0.25,
                                    child: ExpansionTile(
                                      leading: Container(
                                          width: 46.0,
                                          height: 46.0,
                                          child: document['photo_url'] == null || document['photo_url'] == ""
                                              ? Icon(Icons.broken_image)
                                              : TransitionToImage(
                                            image: AdvancedNetworkImage(
                                              document['photo_url'],
                                              useDiskCache: true,
                                              cacheRule:
                                              CacheRule(maxAge: const Duration(days: 7)),
                                            ),
                                          )
                                      ),
                                      title: Text(document['name']),
                                      children: <Widget>[
                                        Text('Name: ${document['name']}'),
                                        Text('Color: ${document['color']}'),
                                        Text('Size: ${document['size']}'),
                                        Text('Length: ${document['length']}'),
                                      ],
                                    ),
                                  );
                                }).toList()
                            ),
                          ),
                        ),
                          ],
                        ),
                 ),
            );
      }});
  }
  Widget _buildIamge() {
    return new ClipPath(
      clipper: new DialogonalClipper(),
      child: new Image.asset(
        'assets/images/pinkB.jpg',
        fit: BoxFit.fitWidth,
//        height: _imageHeight,
      ),
    );
  }


}
class _DiamondBorder extends ShapeBorder {
  const _DiamondBorder();

  @override
  EdgeInsetsGeometry get dimensions {
    return const EdgeInsets.only();
  }

  @override
  Path getInnerPath(Rect rect, { TextDirection textDirection }) {
    return getOuterPath(rect, textDirection: textDirection);
  }

  @override
  Path getOuterPath(Rect rect, { TextDirection textDirection }) {
    return Path()
      ..moveTo(rect.left + rect.width / 2.0, rect.top)
      ..lineTo(rect.right, rect.top + rect.height / 2.0)
      ..lineTo(rect.left + rect.width  / 2.0, rect.bottom)
      ..lineTo(rect.left, rect.top + rect.height / 2.0)
      ..close();
  }

  @override
  void paint(Canvas canvas, Rect rect, { TextDirection textDirection }) {}

  // This border doesn't support scaling.
  @override
  ShapeBorder scale(double t) {
    return null;
  }
}



class UserInfoList2 extends StatelessWidget{
  DocumentSnapshot userInfo;
  double _imageHeight = 248.0;

  UserInfoList2({@required this.userInfo});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection('items').where("userId", isEqualTo: userInfo.data['uid']).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) return new Text('Error: ${snapshot.error}');
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Scaffold(body: new Text('Loading...'));
            default:
              return Scaffold(
                appBar: AppBar(
                  title: Text(userInfo['name']),
                ),
                body:
               new Center(
                 child: new Column(
                   children: <Widget>[
                   new Stack(
                       children: <Widget>[
                         _buildIamge(),
                         new Padding(
                           padding: new EdgeInsets.only(left: 16.0, top: _imageHeight / 2.5),
                           child: Column(
                                 children: <Widget>[
                                   Row(
                                     children: <Widget>[
                                       Text(
                                           "User name: ",
                                           style: new TextStyle(
                                             //  fontSize: 30.0,
                                               color: Colors.black,
                                               fontFamily: 'DancingScript-Bold', //neberie
                                               fontWeight: FontWeight.w400
                                           ),
                                         ),
                                       Padding(padding: EdgeInsets.only(right: 10.0),),
                                       Text(
                                           userInfo.data['name'],
                                           style: new TextStyle(
                                             fontSize: 20.0,
                                               color: Colors.black,
                                               fontFamily: 'DancingScript-Bold', //neberie
                                               fontWeight: FontWeight.w400
                                           ),
                                         ),
                                     ],
                                   ),
                                   Row(
                                     children: <Widget>[
                                        Text(
                                           "User email: ",
                                       textAlign: TextAlign.left,
                                           style: new TextStyle(
                                             //  fontSize: 30.0,
                                               color: Colors.black,
                                               fontFamily: 'DancingScript-Bold', //neberie
                                               fontWeight: FontWeight.w400
                                           ),
                                         ),
                                        Padding(padding: EdgeInsets.only(right: 10.0),),
                                        Text(
                                           userInfo.data['email'],
                                           textAlign: TextAlign.left,
                                           style: new TextStyle(
                                                 fontSize: 15.0,
                                               color: Colors.black,
                                               fontFamily: 'DancingScript-Bold', //neberie
                                               fontWeight: FontWeight.w400
                                           ),
                                         ),
                                     ],
                                   ),
                                 ],
                               ),
                           ),
                       ],
                     ),
                     Text('User\'s items: '),
                     Container(
                       height: 250,
                         child: ListView(
                             children:
                             snapshot.data.documents.map((DocumentSnapshot document){
                               return Slidable(
                                 delegate: SlidableDrawerDelegate(),
                                 actionExtentRatio: 0.25,
                                 child: ExpansionTile(
                                   leading: Container(
                                       width: 46.0,
                                       height: 46.0,
                                       child: document['photo_url'] == null || document['photo_url'] == ""
                                           ? Icon(Icons.broken_image)
                                           : TransitionToImage(
                                         image: AdvancedNetworkImage(
                                           document['photo_url'],
                                           useDiskCache: true,
                                           cacheRule:
                                           CacheRule(maxAge: const Duration(days: 7)),
                                         ),
                                       )
                                   ),
                                   title: Text(document['name']),
                                   children: <Widget>[
                                     Text('Name: ${document['name']}'),
                                     Text('Color: ${document['color']}'),
                                     Text('Size: ${document['size']}'),
                                     Text('Length: ${document['length']}'),
                                   ],
                                 ),
                               );
                             }).toList()
                         ),
                       ),
                   ],
                 ),
               ),);
          }});
  }
  Widget _buildIamge() {
    return new ClipPath(
      clipper: new DialogonalClipper(),
      child: new Image.asset(
        'assets/images/pinkB.jpg',
        fit: BoxFit.fitWidth,
//        height: _imageHeight,
      ),
    );
  }
}



class DialogonalClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = new Path();
    path.lineTo(0.0, size.height - 60.0);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}



