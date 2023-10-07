import 'package:app_fleet/config/assets/app_icons.dart';
import 'package:app_fleet/config/theme/app_theme.dart';
import 'package:app_fleet/utils/app_tooltip_builder.dart';
import 'package:app_fleet/utils/utils.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../app/config/domain/workspace_entity.dart';

void showAppDialog({
  required App app,
  required BuildContext context,
  required void Function(App? app) onClose,
}) {
  app = App.clone(app);
  TextEditingController nameController = TextEditingController(text: app.name);
  TextEditingController exeController = TextEditingController(text: app.exe);
  TextEditingController waitTimeController =
      TextEditingController(text: app.waitTime.toString());
  Color tileColor =
      accentColorMap[app.name.isNotEmpty ? app.name[0].toUpperCase() : 'A']!;
  String? errorText;
  showDialog(
    context: context,
    barrierColor: Colors.transparent,
    builder: (context) {
      return Scaffold(
        backgroundColor: Colors.transparent,
        body: MoveWindow(
          onDoubleTap: () {
            // this will prevent maximize operation
          },
          child: Align(
            child: FittedBox(
              child: StatefulBuilder(
                builder: (context, setModalState) {
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    width: 450,
                    height: 350,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blueGrey.withOpacity(0.4),
                          blurRadius: 16,
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.topCenter,
                          child: Column(
                            children: [
                              const SizedBox(height: 10),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16.0,
                                ),
                                child: SizedBox(
                                  height: 50,
                                  child: Row(
                                    children: [
                                      Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "App Details",
                                            style: AppTheme.fontSize(16)
                                                .makeBold(),
                                          ),
                                          Text(
                                            "Generate/Modify App Entries",
                                            style: AppTheme.fontSize(14),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        GestureDetector(
                                          onTap: () async {
                                            if (app.internallyGenerated) {
                                              return;
                                            }
                                            FilePickerResult? result =
                                                await FilePicker.platform
                                                    .pickFiles(
                                              type: FileType.image,
                                            );
                                            if (result != null) {
                                              setModalState(() {
                                                app.iconPath =
                                                    result.files.first.path!;
                                              });
                                            }
                                          },
                                          child: FittedBox(
                                            child: AnimatedContainer(
                                              width: 128,
                                              height: 128,
                                              duration: const Duration(
                                                  milliseconds: 500),
                                              decoration: BoxDecoration(
                                                color: tileColor,
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(16.0),
                                                child: app.iconPath.isEmpty
                                                    ? AppTooltipBuilder.wrap(
                                                        text:
                                                            "Click to select app icon",
                                                        child: Image.asset(
                                                          AppIcons.unknown,
                                                          filterQuality:
                                                              FilterQuality
                                                                  .high,
                                                        ),
                                                      )
                                                    : (app.iconPath
                                                            .endsWith('.svg')
                                                        ? SvgPicture.asset(
                                                            app.appIconPath,
                                                            placeholderBuilder:
                                                                (context) =>
                                                                    Image.asset(
                                                              AppIcons.unknown,
                                                              fit: BoxFit
                                                                  .fitWidth,
                                                            ),
                                                          )
                                                        : Image.asset(
                                                            app.appIconPath,
                                                            filterQuality:
                                                                FilterQuality
                                                                    .high,
                                                          )),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        Text(
                                          "Wait Time",
                                          style:
                                              AppTheme.fontSize(14).makeBold(),
                                        ),
                                        SizedBox(
                                          width: 100,
                                          height: 45,
                                          child: TextField(
                                            controller: waitTimeController,
                                            textAlign: TextAlign.center,
                                            decoration: InputDecoration(
                                              enabledBorder:
                                                  UnderlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                borderSide: const BorderSide(
                                                    color: Colors.grey,
                                                    width: 2),
                                              ),
                                              focusedBorder:
                                                  UnderlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                borderSide: const BorderSide(
                                                    color: Colors.green,
                                                    width: 4),
                                              ),
                                              disabledBorder:
                                                  UnderlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                borderSide: const BorderSide(
                                                    color: Colors.white,
                                                    width: 2),
                                              ),
                                              border: UnderlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                borderSide: const BorderSide(
                                                    color: Colors.blue,
                                                    width: 2),
                                              ),
                                              suffixText: "ms",
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(width: 10),
                                    Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Name",
                                                style: AppTheme.fontSize(14)
                                                    .makeBold(),
                                              ),
                                              SizedBox(
                                                width: 200,
                                                height: 45,
                                                child: TextField(
                                                  controller: nameController,
                                                  style: AppTheme.fontSize(15),
                                                  onChanged: (value) {
                                                    setModalState(() {
                                                      app.name = value;
                                                      tileColor =
                                                          accentColorMap[app
                                                                  .name
                                                                  .isNotEmpty
                                                              ? app.name[0]
                                                                  .toUpperCase()
                                                              : 'A']!;
                                                    });
                                                  },
                                                  decoration: InputDecoration(
                                                    enabledBorder:
                                                        UnderlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      borderSide:
                                                          const BorderSide(
                                                              color:
                                                                  Colors.grey,
                                                              width: 2),
                                                    ),
                                                    focusedBorder:
                                                        UnderlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      borderSide:
                                                          const BorderSide(
                                                              color:
                                                                  Colors.green,
                                                              width: 4),
                                                    ),
                                                    disabledBorder:
                                                        UnderlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      borderSide:
                                                          const BorderSide(
                                                              color:
                                                                  Colors.white,
                                                              width: 2),
                                                    ),
                                                    border:
                                                        UnderlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      borderSide:
                                                          const BorderSide(
                                                              color:
                                                                  Colors.blue,
                                                              width: 2),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Execution Point",
                                                style: AppTheme.fontSize(14)
                                                    .makeBold(),
                                              ),
                                              SizedBox(
                                                width: 200,
                                                height: 45,
                                                child: TextField(
                                                  controller: exeController,
                                                  style: AppTheme.fontSize(15),
                                                  onChanged: (value) {
                                                    setModalState(() {
                                                      app.exe = value;
                                                    });
                                                  },
                                                  decoration: InputDecoration(
                                                    enabledBorder:
                                                        UnderlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      borderSide:
                                                          const BorderSide(
                                                              color:
                                                                  Colors.grey,
                                                              width: 2),
                                                    ),
                                                    focusedBorder:
                                                        UnderlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      borderSide:
                                                          const BorderSide(
                                                              color:
                                                                  Colors.green,
                                                              width: 4),
                                                    ),
                                                    disabledBorder:
                                                        UnderlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      borderSide:
                                                          const BorderSide(
                                                              color:
                                                                  Colors.white,
                                                              width: 2),
                                                    ),
                                                    border:
                                                        UnderlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      borderSide:
                                                          const BorderSide(
                                                              color:
                                                                  Colors.blue,
                                                              width: 2),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (errorText != null)
                          Align(
                            alignment: Alignment.bottomLeft,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.error,
                                    color: Colors.red,
                                  ),
                                  const SizedBox(
                                    width: 5.0,
                                  ),
                                  Text(
                                    errorText!,
                                    style: AppTheme.fontSize(14)
                                        .withColor(Colors.red.shade700),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    if (app.name.isEmpty) {
                                      setModalState(() {
                                        errorText = "App name is required";
                                      });
                                      return;
                                    }
                                    if (app.exe.isEmpty) {
                                      setModalState(() {
                                        errorText =
                                            "Execution Point is required";
                                      });
                                      return;
                                    }
                                    if (int.tryParse(waitTimeController.text) ==
                                        null) {
                                      setModalState(() {
                                        errorText =
                                            "Wait time should be a positive integer";
                                      });
                                      return;
                                    }
                                    Navigator.pop(context);
                                    onClose(app
                                      ..exe = exeController.text
                                      ..waitTime =
                                          int.parse(waitTimeController.text));
                                  },
                                  style: TextButton.styleFrom(
                                    backgroundColor: Colors.blueAccent,
                                  ),
                                  child: Text(
                                    "Save",
                                    style: AppTheme.fontSize(14)
                                        .withColor(Colors.white),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                TextButton(
                                  onPressed: () {
                                    onClose(null);
                                    Navigator.pop(context);
                                  },
                                  style: TextButton.styleFrom(
                                    backgroundColor: Colors.redAccent,
                                  ),
                                  child: Text(
                                    "Cancel",
                                    style: AppTheme.fontSize(14)
                                        .withColor(Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      );
    },
  );
}
