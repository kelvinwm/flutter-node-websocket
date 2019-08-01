import 'dart:io';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
//import 'package:firebase_database/firebase_database.dart';

void main() {
  runApp(MaterialApp(
    home: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final HttpLink httpLink = HttpLink(
//      uri: 'http://10.10.154.39:5000/graphql',// Get Laptop Ip address
      uri: 'https://knhsystem.herokuapp.com/graphql', // Get Laptop Ip address
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
                           allusers {
                            email
                            hospitalName
                            hospitalPin
                            role
                            userFrom
                            password
                          }
                      }
                      """;

  @override
  Widget build(BuildContext context) {
    //database referene.
    return Scaffold(
      appBar: AppBar(
        title: Text("THROGUH AT YOU"),
      ),
      body: Query(
        options: QueryOptions(document: queryAuthors),
        // Just like in apollo refetch() could be used to manually trigger a refetch
        builder: (QueryResult result, {VoidCallback refetch}) {
          if (result.loading) {
            return CircularProgressIndicator();
          }
          if (result.errors != null) {
            return Text(result.errors.toString());
          }
          if (result.data == null) {
            return Center(child: Text("No Data Found !"));
          }

          // it can be either Map or List
//          List repositories = result.data['patientid'];

          debugPrint(result.data["allusers"].length.toString());
          return ListView.builder(
            itemBuilder: (BuildContext context, int index) {
              if (result.data['allusers'][index]['email'] == null) {
                result.data['allusers'][index]['email'] = '';
              }
              return ListTile(
                  title: Text(result.data['allusers'][index]['email']));
            },
            itemCount: result.data['allusers'].length,
          );
        },
      ),
    );
  }
}
