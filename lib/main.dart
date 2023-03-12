import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'chuck.dart';

// URL for load background IMG
const urlBackgroundIMG =
    'https://d50-a.sdn.cz/d_50/c_img_E_G/Q18EK/chuck-norris.jpeg';
//'https://i.imgflip.com/13wqid.jpg';
//'http://pngimg.com/uploads/chuck_norris/chuck_norris_PNG17.png';

// API URL
const url = 'https://api.chucknorris.io/jokes/random';

void main() async => {
      // Hide Android Status Bar in Flutter app
      WidgetsFlutterBinding.ensureInitialized(),
      SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
          statusBarColor:
              Colors.transparent, // Hide Android Status Bar in Flutter app
          systemNavigationBarColor: Colors.orange, //NavBar
          systemNavigationBarDividerColor: Colors.black,
          systemNavigationBarIconBrightness: Brightness.dark)),
      // Run the Application
      runApp(const MyApp()),
    };

/* Stateful widgets will allow us to detect changes in parts of the user 
interface such as buttons, calls to an API, ... 
Providing dynamism to our application*/
class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<void> futureChuckResponse;

  // API Call
  Future<Chuck> chuckApiCall() async {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return Chuck.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      if (response.statusCode.isEven && response.body.isNotEmpty) {
        throw Exception('Error, failed to load request!' +
            response.statusCode.toString() +
            ' ' +
            response.body);
      } else {
        throw Exception('Error, failed to load resquest!');
      }
    }
  }

  @override
  void initState() {
    super.initState();

    // DeviceOrientation Settings: To turn off landscape mode
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
    ]);

    // Call API
    futureChuckResponse = chuckApiCall();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false, // Remove Debug Banner in App
        home: SafeArea(
            top: false, // for you can hide the notification toolbar
            child: Scaffold(
              backgroundColor: Colors.white,
              body: Container(
                child: FutureBuilder<Chuck>(
                    future: chuckApiCall(),
                    builder: (context, snapshot) {
                      CircularProgressIndicator(); // By default, show a loading spinner.
                      if (snapshot.hasData) {
                        // here put the interface
                        return Stack(children: <Widget>[
                          Container(
                              decoration: const BoxDecoration(
                                  image: DecorationImage(
                            image: NetworkImage(
                                urlBackgroundIMG), //Load the IMG in the App Background
                            fit: BoxFit.cover,
                            //Align the source within the target box (by default, centering) and, if necessary, scale the source down to ensure that the source fits within the box.
                          ))),
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                Container(
                                    margin: const EdgeInsets.fromLTRB(
                                        20, 30, 35, 150),
                                    alignment: Alignment.topRight,
                                    // Widget for save the future phare of the API
                                    child: Text(snapshot.data!.value + " 👊",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 20,
                                          backgroundColor: Colors.white,
                                        ))),
                                // Button for refresh de App
                                Container(
                                    alignment: Alignment.centerRight,
                                    margin:
                                        const EdgeInsets.fromLTRB(0, 0, 35, 0),
                                    child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                        child: ElevatedButton(
                                            onPressed: () {
                                              // Future Action on click button
                                              print("No Click, I'm Chuck!");
                                              setState(() => _MyAppState());
                                            },
                                            style: ElevatedButton.styleFrom(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 40.0,
                                                      vertical: 20.0),
                                              primary: Colors
                                                  .orange[600], // button color
                                              side: const BorderSide(
                                                  width: 0.85, // border width
                                                  color: Colors
                                                      .black), // border color
                                              shape: RoundedRectangleBorder(
                                                  //to set border radius to button
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          30)),
                                            ),
                                            child: const Text(
                                              "🤠 Load other phrase! 🤠", // button text message
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12),
                                            )))),
                              ])
                        ]);
                      } else if (snapshot.hasError) {
                        // Show error message
                        return Center(
                            child: Text('${snapshot.error}',
                                textAlign: TextAlign.center));
                      }
                      return Container(
                          child: Center(child: CircularProgressIndicator()));
                    }),
              ),
            )));
  }
}
