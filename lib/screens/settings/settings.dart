import 'package:flutter/material.dart';
import 'package:homework/models/settings_data.dart';
import 'package:provider/provider.dart';
import 'package:homework/components/inputPopup.dart';
import 'package:homework/components/infoPopup.dart';
import 'package:homework/screens/settings/components/switch_setting.dart';
import 'package:homework/screens/settings/components/clickable_setting.dart';

class Settings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final SettingsData data = Provider.of<SettingsData>(context);

    return Scaffold(
        appBar: AppBar(
          title: Text('Settings'),
          centerTitle: true,
        ),
        body: ListView(
          children: [
            SwitchSetting(
              title: 'Dark theme',
              value: data.boolTheme,
              switchValue: (bool value) {
                data.boolTheme = value;
              },
            ),
            Divider(),
            SwitchSetting(
              title: 'Automatic file name',
              value: data.automaticFileName,
              switchValue: (bool value) {
                data.automaticFileName = value;
              },
            ),
            ClickableSetting(
              title: 'Default file name',
              subtitle: data.defaultFileName,
              onClick: () {
                final controller = TextEditingController();
                controller.text = data.defaultFileName;
                inputPopup(context, 'Default name for file', 'Ok', controller,
                    () {
                  data.defaultFileName = controller.text;
                });
              },
            ),
            Divider(),
            SwitchSetting(
              title: 'Custom markup',
              subtitle:
                  'Allows you to insert special markups into for e.g. filenames.',
              value: data.customMarkup,
              switchValue: (bool value) {
                data.customMarkup = value;
              },
            ),
            ClickableSetting(
                title: 'About custom markup',
                onClick: () {
                  infoPopup(
                      context,
                      'About markups',
                      'In for e.g. filenames you can use custom markups like: "##date##" to add in this place current date.',
                      'Ok');
                }),
            Divider(),
            SwitchSetting(
              title: 'Default file template',
              subtitle:
                  'If is enabled every file will be as copy of default file',
              value: data.enabledDefaultFile,
              switchValue: (bool value) {
                data.enabledDefaultFile = value;
              },
            ),
            ClickableSetting(title: 'Edit default file', onClick: () {
              Navigator.pushNamed(context, "/editHomework",
                  arguments: {"homeworkItem": data.defaultFile, "save": data.saveAndRefresh});
            }),
            Divider(),
            ClickableSetting(
              title: 'Date format',
              subtitle: data.dateFormat,
              onClick: () {
                final controller = TextEditingController();
                controller.text = data.dateFormat;
                inputPopup(
                    context, 'Date format (e.g. dd/MM/yyyy)', 'Ok', controller,
                    () {
                  data.dateFormat = controller.text;
                });
              },
            ),
          ],
        ));
  }
}
