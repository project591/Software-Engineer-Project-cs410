import 'package:chefcookbook/screens/movie_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DishWidget extends StatelessWidget {
  final String? title;
  final String? ratings;
  final String? description;
  final String? imageURL;
  final String? prevScreen;

  DishWidget({
    @required this.title, // this variable will hold the name of the movie.
    @required this.ratings, // this will be for the movie ratings
    @required this.description, // this will be for the movie description
    @required this.imageURL, // this will be for the movie URL
    @required this.prevScreen, // this code will be for the previous screen
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: ListTile(
          leading: SizedBox(
            child: imageURL == null
                ? Image.asset('assets/question_mark.png')
                : Image.network(imageURL!), // change
            height: 80,
            width: 80,
          ),
          title: Text(
            title!,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            description!.length >= 20
                ? description!.substring(0, 20) + '...'
                : description!.substring(0, description!.length),
            style: const TextStyle(color: Colors.grey),
          ),
          trailing: IconButton(
            icon: const Icon(Icons.arrow_forward),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute<dynamic>(builder: (BuildContext context) {
                    return DishPage(dishWidget: this);
                  }));
            },
          ),
        ),
      ),
    );
  }
}