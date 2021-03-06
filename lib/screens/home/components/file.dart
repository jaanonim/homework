import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:Homework/components/yesNoPopup.dart';
import 'package:Homework/models/document_editor.dart';
import 'package:Homework/models/hierarchy.dart';
import 'package:Homework/models/homework_item.dart';
import 'package:provider/provider.dart';

class File extends StatelessWidget {
  final HomeworkItem homeworkItem;

  File({this.homeworkItem});

  @override
  Widget build(BuildContext context) {
    final Hierarchy hierarchy = Provider.of<Hierarchy>(context);

    DocumentEditor _editor =
        DocumentEditor(homeworkItem, hierarchy.saveAndRefresh);

    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, "/editHomework", arguments: {
          "homeworkItem": homeworkItem,
          "save": hierarchy.saveAndRefresh
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 7),
        child: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  homeworkItem.title,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyText2,
                ),
              ),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Icon(
                  Icons.insert_drive_file,
                  size: 60,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: MaterialButton(
                      onPressed: () {
                        yesNoPopup(context,
                            "Are you sure you want to delete this homework?",
                            () {
                          hierarchy.deleteItem(homeworkItem);
                        });
                      },
                      child: Icon(
                        Icons.delete,
                        size: 15,
                      ),
                      height: 25,
                      minWidth: 40,
                    ),
                  ),
                  Expanded(
                    child: MaterialButton(
                      onPressed: () async {
                        Flushbar(
                          message: 'Sharing...',
                          duration: Duration(seconds: 3),
                          backgroundColor: Theme.of(context).accentColor,
                          leftBarIndicatorColor: Theme.of(context).primaryColor,
                        )..show(context);
                        await Future.delayed(Duration(seconds: 1), () {
                          _editor.sharePDF();
                        });
                      },
                      child: Icon(
                        Icons.share,
                        size: 15,
                      ),
                      height: 25,
                      minWidth: 40,
                    ),
                  )
                ],
              )
            ])),
      ),
    );
  }
}
