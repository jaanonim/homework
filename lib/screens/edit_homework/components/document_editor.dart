import 'dart:io';

import 'package:homework/models/homework_item.dart';
import 'package:homework/models/pdf_creator.dart';
import 'package:share/share.dart';

class DocumentEditor {
  var items = [];
  var title;

  DocumentEditor(FileItem homework) {
    items = homework.pathImages;
    title = homework.title;
  }

  List<String> getPages() {
    return items;
  }

  void removePage(String i) {
    if (items.contains(i)) items.remove(i);
  }

  swapPages(var object, bool isUp) {
    int oldIndex = items.indexOf(object);
    int newIndex = oldIndex + (isUp ? -1 : 1);
    if (newIndex < 0 || newIndex >= items.length) return;
    var temp = items[oldIndex];
    items.removeAt(oldIndex);
    items.insert(newIndex, temp);
  }

  addNewImage(String path) {
    items.add(path);
  }

  Future<String> generatePDF() async {
    var pdf = new PdfCreator();

    for (var src in items) {
      pdf.createNewPageSrc(src);
    }
    return await pdf.save(title);
  }

  Future<void> sharePDF() async {
    String path = await generatePDF();

    Share.shareFile(File(path), subject: 'Homework Generator-' + title);
  }
}