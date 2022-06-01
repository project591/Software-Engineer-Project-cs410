// This file helps in adding a movie to the app.
// This file contains several textboxes that helps
// the user in filling the new information for the
// movie that they are going to add to the application.
import 'dart:convert';

import 'package:at_client_mobile/at_client_mobile.dart';
import 'package:chefcookbook/components/rounded_button.dart';
import 'package:at_commons/at_commons.dart';
import 'package:flutter/cupertino.dart';
import 'package:chefcookbook/constants.dart' as constant;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
//import 'dart:convert';

// will this even work at all
// how will this communicate at all with
// what is above.
Future<DishScreen> fetchAlbum() async {
  String name = "inception";
  final response = await http
      .get(Uri.parse("http://www.omdbapi.com/?t=" + name + "&apikey=19b5baac"));

  if (response.statusCode == 200) {
    // print("goof");
    return DishScreen.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}

// so extend? the fetch album class here?
class DishScreen extends StatelessWidget {
  static final String id = 'add_dish';
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? _title; // will hold the movie name
  String? _ratings; // string will only accept numerical value
  String? _description; // will hold the description of the movie, many lines
  String? imageURL;

  // a getter for the title of
  // the movie.
  String? get name => _title;
  String? get image => imageURL;

   DishScreen({this.imageURL}
  );

  factory DishScreen.fromJson(Map<String, dynamic> json) {
    return DishScreen(
      imageURL: json['Poster'],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add a Movie'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: <Widget>[
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Hero(
                          tag: 'choice chef',
                          child: SizedBox(
                            height: 120,
                            child: Image.asset(
                              'assets/icons8-movie-50.png',
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField( // textbox for the movie name
                        decoration: const InputDecoration(
                          icon: Icon(Icons.approval),
                          hintText: 'Name of the Movie',
                          labelText: 'Name of Movie',
                        ),
                        validator: (String? value) =>
                        value!.isEmpty ? 'Specify name of the Movie' : null,
                        onChanged: (String value) {
                          _title = value;
                        },
                      ),
                      TextFormField( // textbox for description
                        decoration: const InputDecoration(
                          icon: Icon(Icons.approval),
                          hintText: 'How did you feel about this?',
                          labelText: 'Comments',
                        ),
                        maxLines: 3,
                        validator: (String? value) =>
                        value!.isEmpty ? 'Provide a description' : null,
                        onChanged: (String value) {
                          _description = value;
                        },
                      ),
                      // https://fluttercorner.com/how-to-create-a-number-input-field-in-flutter/
                      // This should now only accept characters that are numbers.
                      TextFormField(

                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ], // Textbox for the movie rating. Only accept number.
                        decoration: const InputDecoration(
                          icon: Icon(Icons.approval),
                          hintText: 'Ratings of Movie',
                          labelText: 'Ratings',
                        ),
                        validator: (String? value) =>
                        value!.isEmpty ? 'Add ratings' : null,
                        onChanged: (String value) {
                          _ratings = value;
                        },
                      ),
                      /*TextFormField( // This will contain the URL for the movie poster.
                        decoration: const InputDecoration(
                          icon: Icon(Icons.approval),
                          hintText: 'Optional: link to an image of the movie',
                          labelText: 'Image',
                        ),
                        onChanged: (String value) {
                          _imageURL = value;
                        },
                      ),*/
                      const SizedBox(
                        height: 50,
                      ),
                        RoundedButton(
                        text: 'Add a Rating',
                        color: const Color(0XFF039BE5),
                        path: () => _update(context),
                      )
                    ],
                  ),
                )),
          ),
        ),
      ),
    );
  }


  Future<void> _update(BuildContext context) async {
    String? atSign = AtClientManager
        .getInstance()
        .atClient
        .getCurrentAtSign();

    FormState? form = _formKey.currentState;
    if (form!.validate()) {
      String _values = _description! + constant.splitter + _ratings!;


      // could you hardcode the image here
      // that would solve most of this mess.
      // comment out the section where the user
      // needs to put in something for the movie image
      // original code below
      //if (_imageURL != null) {
      //  _values += constant.splitter + _imageURL!;
      //}

      // manual works. Now get the key to somehow splice into a URL.
      // find a pattern in url for omdb
      if (imageURL != null) {
        _values += constant.splitter + imageURL!;
      }
      AtKey atKey = AtKey();
      atKey.key = _title;
      atKey.sharedWith = atSign;

      bool successPut =
      await AtClientManager
          .getInstance()
          .atClient
          .put(atKey, _values);

      successPut
          ? Navigator.pop(context)
          : ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Failed to put data',
            textAlign: TextAlign.center,
          ),
        ),
      );
    } else {
      print('Not all text fields have been completed!');
    }
  }
}

