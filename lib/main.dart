import 'dart:io';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:firebase_database/firebase_database.dart';


void main() {
  runApp(MaterialApp(
    home: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final HttpLink httpLink = HttpLink(
      uri: 'http://10.0.2.2:5000/graphql',
    );

    ValueNotifier<GraphQLClient> client = ValueNotifier(
      GraphQLClient(
        cache: NormalizedInMemoryCache(
          dataIdFromObject: typenameDataIdFromObject,
        ),
        link: httpLink as Link,
      ),
    );
    return GraphQLProvider(
      client: client,
      child: CacheProvider(
        child: AbsorbHere(),
      ),
    );
  }
}

class AbsorbHere extends StatefulWidget {
  @override
  _AbsorbHereState createState() => _AbsorbHereState();
}

class _AbsorbHereState extends State<AbsorbHere> {
  String queryAuthors = r"""
                        query  GetAuthors{
                          author{
                            patientid
                          }
                      }
                      """;

  @override
  Widget build(BuildContext context) {
    //database referene.
    var recentJobsRef = FirebaseDatabase.instance
        .reference()
        .child('recent')
        .orderByChild('created_at') //order by creation time.
        .limitToFirst(10);
    return Scaffold(
      appBar: AppBar(
        title: Text("THROGUH AT YOU"),
      ),
      body: StreamBuilder(
        stream: recentJobsRef.onValue,
        builder: (context, snap) {
          if (snap.hasData && !snap.hasError &&
              snap.data.snapshot.value != null) {
            DataSnapshot snapshot = snap.data.snapshot;
            List item = [];
            List _list = [];
//it gives all the documents in this list.
            _list = snapshot.value;
//Now we're just checking if document is not null then add it to another list called "item".
//I faced this problem it works fine without null check until you remove a document and then your stream reads data including the removed one with a null value(if you have some better approach let me know).
            _list.forEach((f) {
              if (f != null) {
                item.add(f);
              }
            }
            );
            return snap.data.snapshot.value == null
//return sizedbox if there's nothing in database.
                ? SizedBox()
//otherwise return a list of widgets.
                : ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: item.length,
              itemBuilder: (context, index) {
                return ListTile(
                    title: Text("kenya")
//                return _containerForRecentJobs(
//                    item[index]['title']
                );
              },
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),


//      Query(
//        options: QueryOptions(document: queryAuthors),
//        // Just like in apollo refetch() could be used to manually trigger a refetch
//        builder: (QueryResult result, {VoidCallback refetch}) {
//          if (result.loading) {
//            return CircularProgressIndicator();
//          }
//          if (result.errors != null) {
//            return Text(result.errors.toString());
//          }
//          if (result.data == null) {
//            return Center(child: Text("No Data Found !"));
//          }
//
//          // it can be either Map or List
////          List repositories = result.data['patientid'];
//
//          debugPrint(result.data["author"].length.toString());
//          return ListView.builder(
//            itemBuilder: (BuildContext context, int index) {
//              return ListTile(
//                  title: Text(result.data['author'][index]['patientid']));
//            },
//            itemCount: result.data['author'].length,
//          );
//        },
//      ),
    );
  }
}


