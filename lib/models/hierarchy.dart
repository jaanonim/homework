import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:homework/models/homework_item.dart';
import 'package:homework/services/file_service.dart';

class Hierarchy with ChangeNotifier {
  List<FolderItem> hierarchy = [FolderItem(title: "home")];

  FolderItem get home => hierarchy.first;
  FolderItem get now => hierarchy.last;

  Hierarchy() {
    readItem().then((h) {
      if (h != null) {
        hierarchy.first = h;
      } else {
        print("Cannot read file!");
      }
    });
  }

  void updateHierarchy(Function function) {
    function();
    notifyListeners();
  }

  void SaveAndRefres() {
    writeItem(this.home);
    notifyListeners();
  }

  void removeFromHierarchy(FolderItem folder) {
    for (int i = hierarchy.length - 1; i > 0; i--) {
      if (hierarchy[i] == folder) {
        break;
      }
      hierarchy.removeAt(i);
    }
    notifyListeners();
  }

  void addToHierarchy(FolderItem folder) {
    hierarchy.add(folder);
    notifyListeners();
  }

  HomeworkItem createFile(String title) {
    HomeworkItem homeworkItem = FileItem(title: title);
    hierarchy.last.moveToFolder([homeworkItem]);
    SaveAndRefres();
    return homeworkItem;
  }

  void createFolder(String title, List<HomeworkItem> items) {
    FolderItem newFolder = FolderItem(title: title);
    hierarchy.last.moveToFolder([
      newFolder,
    ]);
    newFolder.moveToFolder(items);
    SaveAndRefres();
  }

  void moveToFolder(FolderItem folder, HomeworkItem item) {
    folder.moveToFolder([item]);
    SaveAndRefres();
  }

  void renameItem(HomeworkItem item, String title) {
    item.title = title;
    SaveAndRefres();
  }

  void deleteItem(HomeworkItem item) {
    item.deleteItem();
    SaveAndRefres();
  }
}