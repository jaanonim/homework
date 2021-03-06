import 'package:drag_and_drop_gridview/devdrag.dart';
import 'package:drag_and_drop_gridview/drag.dart';
import 'package:flutter/material.dart';
import 'package:Homework/components/inputPopup.dart';
import 'package:Homework/models/hierarchy.dart';
import 'package:Homework/models/homework_item.dart';
import 'package:Homework/screens/home/components/item.dart';
import 'package:Homework/screens/home/components/item_feedback.dart';
import 'package:provider/provider.dart';

class Body extends StatelessWidget {
  final controller = TextEditingController();

  Widget getItem(int index, bool isDragged, Hierarchy hierarchy, bool isHome) {
    if (!isHome) {
      index--;
      if (index < 0) {
        return DragItem(
          isDraggable: false,
          child: Card(
            child: InkWell(
              onTap: () {
                hierarchy.removeFromHierarchy(hierarchy.now.parent);
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(hierarchy.now.parent.title),
                      ),
                    ),
                    FittedBox(
                      fit: BoxFit.contain,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 15),
                        child: Icon(
                          Icons.reply,
                          size: 60,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }
    }

    Widget item = Item(
      homeworkItem: hierarchy.now.children[index],
    );

    if (isDragged) {
      return Opacity(
        opacity: 0.5,
        child: item,
      );
    } else {
      return item;
    }
  }

  @override
  Widget build(BuildContext context) {
    final Hierarchy hierarchy = Provider.of<Hierarchy>(context);

    if(!hierarchy.isLoaded){
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("We are loading your files ...", style: Theme.of(context).textTheme.headline6,),
            SizedBox(height: 10,),
            Text("Please be patient."),
          ],
        ),
      );
    }

    if (hierarchy.now.children.length == 0 && hierarchy.isHome) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("There's nothing here yet ...", style: Theme.of(context).textTheme.headline6,),
            SizedBox(height: 10,),
            Text("Click plus button to create your first homework."),
          ],
        ),
      );
    }

    return DragAndDropGridView(
      controller: ScrollController(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 0.7,
      ),
      padding: EdgeInsets.all(20),
      itemBuilder: (context, index) =>
          getItem(index, false, hierarchy, hierarchy.isHome),
      itemCount: hierarchy.isHome
          ? hierarchy.now.children.length
          : hierarchy.now.children.length + 1,
      isCustomChildWhenDragging: true,
      childWhenDragging: (index) =>
          getItem(index, true, hierarchy, hierarchy.isHome),
      isCustomFeedback: true,
      feedback: (index) => ItemFeedback(
          homeworkItem:
              hierarchy.now.children[(hierarchy.isHome) ? index : index - 1]),
      onWillAccept: (oldIndex, newIndex) {
        if (oldIndex == newIndex) {
          return false;
        }
        return true;
      },
      onReorder: (oldIndex, newIndex) {
        if (!hierarchy.isHome) {
          oldIndex--;
          newIndex--;
        }
        if (newIndex < 0) {
          hierarchy.moveToFolder(
              hierarchy.now.parent, hierarchy.now.children[oldIndex]);
        } else {
          if (hierarchy.now.children[newIndex] is FolderItem) {
            hierarchy.moveToFolder(hierarchy.now.children[newIndex],
                hierarchy.now.children[oldIndex]);
          } else {
            inputPopup(context, "Create new folder:", "Create", controller, () {
              Navigator.pop(context);
              hierarchy.createFolder(controller.text, [
                hierarchy.now.children[newIndex],
                hierarchy.now.children[oldIndex],
              ]);
            });
          }
        }
      },
    );
  }
}
