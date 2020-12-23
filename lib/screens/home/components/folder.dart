import 'package:flutter/material.dart';
import 'package:homework/models/homeworkItem.dart';

class Folder extends StatelessWidget {
  final HomeworkItem homeworkItem;
  final Function del;
  final Function update;

  Folder({this.homeworkItem, this.del, this.update});

  @override
  Widget build(BuildContext context) {
    return Card(
        child: InkWell(
          onTap: () {
            // TODO: Dodac akcje po klikniecu
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 7),
            child: Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(homeworkItem.title),
                  ),
                  Icon(
                    Icons.folder,
                    size: 72,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      MaterialButton(
                        onPressed: () {
                          del(
                              context,
                              "Are you sure you want to delete this folder and everything in it?",
                              (){homeworkItem.DeleteItem();update();});
                        },
                        child: Icon(
                          Icons.delete,
                          size: 15,
                        ),
                        height: 25,
                        minWidth: 40,
                      ),
                    ],
                  )
                ]),
      ),
          ),
        ),

    );
  }
}
