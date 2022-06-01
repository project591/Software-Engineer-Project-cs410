// This will be the movie page
// It contains a list of all the movies.
import 'package:at_client_mobile/at_client_mobile.dart';
import 'package:chefcookbook/components/dish_widget.dart';
import 'package:chefcookbook/components/rounded_button.dart';
import 'package:at_commons/at_commons.dart';
import 'package:flutter/cupertino.dart';
import 'home_screen.dart';
import 'share_screen.dart';
import 'package:flutter/material.dart';

class DishPage extends StatelessWidget {
  final DishWidget? dishWidget;

  DishPage({@required this.dishWidget});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          dishWidget!.title!,
        ),
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 6,
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Card(
                  color: Colors.white70,
                  child: Center(
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                dishWidget!.title!,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 36,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                            Expanded(
                              child: CircleAvatar(
                                radius: 80.0,
                                backgroundImage: dishWidget!.imageURL == null
                                    ? const AssetImage(
                                    'assets/question_mark.png')
                                    : NetworkImage(dishWidget!.imageURL!)
                                as ImageProvider,
                              ),
                            ),
                          ],
                        ),
                        const Padding(
                          padding:
                          EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                          child: Divider(
                            color: Colors.black87,
                            thickness: 1,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              dishWidget!.description!,
                              style: const TextStyle(
                                color: Colors.black87,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Rating: ' + dishWidget!.ratings!,
                              style: const TextStyle(
                                color: Colors.black87,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            dishWidget!.prevScreen == HomeScreen.id
                ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                RoundedButton(
                  path: () {
                    _delete(context);
                  },
                  text: 'Remove',
                  width: 180,
                  color: Colors.redAccent,
                ),
                RoundedButton(
                  path: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute<dynamic>(
                        builder: (BuildContext context) =>
                            ShareScreen(dishWidget: dishWidget),
                      ),
                    );
                  },
                  text: 'Share',
                  width: 180,
                  color: const Color(0XFF039BE5),
                ),
              ],
            )
                : Container(),
          ],
        ),
      ),
    );
  }

  Future<void> _delete(BuildContext context) async {
    String? atSign = AtClientManager.getInstance().atClient.getCurrentAtSign();

    if (dishWidget!.title != null) {
      AtKey atKey = AtKey();
      Map metaJson = Metadata().toJson();
      Metadata metadata = Metadata.fromJson(metaJson);
      atKey.key = dishWidget!.title;
      atKey.metadata = metadata;
      atKey.sharedWith = atSign;

      bool isDeleted =
      await AtClientManager.getInstance().atClient.delete(atKey);
      print(isDeleted);
      isDeleted
          ? await Navigator.of(context).pushNamedAndRemoveUntil(
          dishWidget!.prevScreen!, (Route<dynamic> route) => false,
          arguments: true)
          : ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Failed to delete data',
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
  }
}