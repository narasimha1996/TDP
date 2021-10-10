import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatefulWidget {
  QuerySnapshot ress;
  HomePage({Key key, this.ress}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextStyle defaultStyle = TextStyle(fontSize: 15, color: Colors.black);
  TextEditingController textFieldController = TextEditingController();
  bool loader = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Card(
                    child: Padding(
                      padding: EdgeInsets.only(left: 10, right: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Your Post',
                            style: TextStyle(fontSize: 20),
                          ),
                          TextField(
                            controller: textFieldController,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              hintText: "Enter your post",
                              labelText: 'Enter your post',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: BorderSide(
                                  color: Colors.amber,
                                  style: BorderStyle.solid,
                                ),
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: loader
                                ? Container(
                                    height: 45,
                                    width: 45,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: CircularProgressIndicator(),
                                    ))
                                : RaisedButton(
                                    color: Colors.blue,
                                    child: Text(
                                      'Post',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    onPressed: () async {
                                      FocusScope.of(context)
                                          .requestFocus(new FocusNode());
                                      setState(() {
                                        loader = true;
                                      });
                                      var responce = await Firestore.instance
                                          .collection('Feed')
                                          .add({
                                        "post": textFieldController.text,
                                        'date': new DateTime.now().toString(),
                                        'userid':
                                            widget.ress.documents[0].documentID,
                                        'username': widget
                                            .ress.documents[0].data['name']
                                      });
                                      setState(() {
                                        loader = false;
                                      });
                                      print(responce);
                                      textFieldController.clear();
                                    }),
                          )
                        ],
                      ),
                    ),
                  ),
                  StreamBuilder<QuerySnapshot>(
                      stream: Firestore.instance
                          .collection("Feed")
                          .orderBy("date", descending: true)
                          .snapshots(),
                      builder: (context, snapshot) {
                        return !snapshot.hasData
                            ? Center(child: CircularProgressIndicator())
                            : snapshot.data.documents.length == 0
                                ? Center(child: Text('No feed'))
                                : ListView.builder(
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: snapshot.data.documents.length,
                                    itemBuilder: (context, index) {
                                      DocumentSnapshot data =
                                          snapshot.data.documents[index];
                                      print(snapshot.data.documents.length);
                                      print(data.documentID.length);
                                      return Card(
                                        child: Container(
                                          height: 100,
                                          child: Column(
                                            children: <Widget>[
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    left: 5, right: 5, top: 5),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: <Widget>[
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: <Widget>[
                                                          Text(
                                                            snapshot
                                                                    .data
                                                                    .documents[
                                                                        index]
                                                                    .data[
                                                                'username'],
                                                            style: TextStyle(
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                          Text(
                                                            snapshot
                                                                .data
                                                                .documents[
                                                                    index]
                                                                .data['date'],
                                                            style: TextStyle(
                                                                fontSize: 12,
                                                                color: Colors
                                                                    .black38,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    widget.ress.documents[0]
                                                                .documentID ==
                                                            snapshot
                                                                .data
                                                                .documents[
                                                                    index]
                                                                .data['userid']
                                                        ? IconButton(
                                                            icon: Icon(
                                                              Icons
                                                                  .delete_outline,
                                                              size: 18,
                                                            ),
                                                            onPressed:
                                                                () async {
                                                              var responce = await Firestore
                                                                  .instance
                                                                  .collection(
                                                                      'Feed')
                                                                  .document(snapshot
                                                                      .data
                                                                      .documents[
                                                                          index]
                                                                      .documentID)
                                                                  .delete();
                                                            })
                                                        : Container()
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Container(
                                                  child: RichText(
                                                      text: TextSpan(
                                                          style: defaultStyle,
                                                          children: <TextSpan>[
                                                        TextSpan(
                                                            text: snapshot.data
                                                                    .documents[
                                                                index]['post'])
                                                      ])),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  );
                      })
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
