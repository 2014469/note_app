import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;
import 'package:flutter_quill_extensions/flutter_quill_extensions.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:note_app/screens/notes/edit/widget/show_image_pick.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
// ignore: depend_on_referenced_packages
import 'package:tuple/tuple.dart';
import 'package:uuid/uuid.dart';

import '../../../models/note.dart';
import '../../../providers/note.provider.dart';
import '../../../resources/colors/colors.dart';
import '../../../utils/customLog/debug_log.dart';
import '../../../widgets/bar/app_bar.dart';
import '../type.dart';

enum _SelectionType {
  none,
  word,
  image,
  // line,
}

class EditNoteScreen extends StatefulWidget {
  const EditNoteScreen({super.key});

  @override
  State<EditNoteScreen> createState() => _EditNoteScreenState();
}

class _EditNoteScreenState extends State<EditNoteScreen> {
  late QuillController _controller;
  String title = "";
  late final FocusNode _focusNode = FocusNode();
  Timer? _selectAllTimer;
  bool isShowKeyboard = true;
  _SelectionType _selectionType = _SelectionType.none;

  late final String folderId;
  late final NoteType type;
  Note? note;

  late NoteProvider noteProvider;

  UploadTask? uploadTask;

  @override
  void initState() {
    _controller = QuillController.basic();

    // todo: lay gia tri truyen tu folder
    Future.delayed(Duration.zero, () {
      final argruments = (ModalRoute.of(context)!.settings.arguments ??
          <String, dynamic>{}) as Map;
      folderId = argruments["folderId"];
      type = argruments["type"];
      note = argruments["note"];
      _loadFromAssets();
    });

    super.initState();
  }

  @override
  void dispose() {
    _selectAllTimer?.cancel();
    super.dispose();
  }

  Future<void> _loadFromAssets() async {
    try {
      // final result = await rootBundle.loadString(isDesktop()
      //     ? 'assets/sample_data_nomedia.json'
      //     : 'assets/sample_data.json');
      // final doc = Document.fromJson(jsonDecode(result));
      // setState(() {
      //   _controller = QuillController(
      //       document: doc, selection: const TextSelection.collapsed(offset: 0));
      // });
      switch (type) {
        case NoteType.newNote:
          {
            final doc = Document()..insert(0, '');
            setState(() {
              _controller = QuillController(
                  document: doc,
                  selection: const TextSelection.collapsed(offset: 0));

              note = Note.fromId(
                  noteId: const Uuid().v1(), ownerFolderId: folderId);
            });
            break;
          }
        case NoteType.editNote:
          {
            //  : 'assets/sample_data.json');
            final doc = Document.fromJson(jsonDecode(note!.content!));
            // final doc = jsonDecode(note!.content!);
            setState(() {
              log(doc.toDelta().toString());
              _controller = QuillController(
                  document: doc,
                  selection: const TextSelection.collapsed(offset: 0));
            });
            break;
          }
      }
    } catch (error) {
      log(error.toString());
    }
  }

  Future<String> _onImagePaste(Uint8List imageBytes) async {
    // Saves the image to applications directory
    final appDocDir = await getApplicationDocumentsDirectory();
    final file = await File(
            '${appDocDir.path}/${path.basename('${DateTime.now().millisecondsSinceEpoch}.png')}')
        .writeAsBytes(imageBytes, flush: true);
    return file.path.toString();
  }

  Widget quillToolbar(QuillController controller) {
    return QuillToolbar.basic(
      locale: const Locale('vi'),
      multiRowsDisplay: false,
      iconTheme: QuillIconTheme(
        iconUnselectedColor: AppColors.gray[70],
        iconUnselectedFillColor: Colors.white,
        iconSelectedFillColor: AppColors.primary,
      ),
      controller: controller,
      embedButtons: FlutterQuillEmbeds.buttons(
        showVideoButton: false,
        showCameraButton: false,
        onImagePickCallback: _onImagePickCallback,
        mediaPickSettingSelector: selectMediaPickSetting,
        // cameraPickSettingSelector: selectCameraPickSetting,
      ),
      showAlignmentButtons: true,
      showSearchButton: true,
      showDirection: true,
      afterButtonPressed: _focusNode.requestFocus,
    );
  }

  Widget _buildWelcomeEditor(BuildContext context) {
    Widget quillEditor = QuillEditor(
      controller: _controller,
      scrollController: ScrollController(),
      scrollable: true,
      focusNode: _focusNode,
      autoFocus: true,
      readOnly: false,
      placeholder: 'Add content',
      expands: true,
      padding: EdgeInsets.zero,
      onImagePaste: _onImagePaste,
      onTapUp: (details, p1) {
        return onTripleClickSelection();
      },
      enableSelectionToolbar: true,
      customStyles: DefaultStyles(
        h1: DefaultTextBlockStyle(
            TextStyle(
              fontSize: 32.sp,
              color: Colors.black,
              height: 1.15,
              fontWeight: FontWeight.w300,
            ),
            const Tuple2(16, 0),
            const Tuple2(0, 0),
            null),
        sizeSmall: TextStyle(fontSize: 9.sp),
      ),
      embedBuilders: [
        ...FlutterQuillEmbeds.builders(),
      ],
    );
    return SafeArea(
      child: Stack(
        children: [
          Container(
            color: Colors.white,
            padding: EdgeInsets.only(
                left: 16.w, right: 16.w, bottom: kDefaultIconSize * 3),
            child: quillEditor,
          ),
        ],
      ),
    );
  }

  bool onTripleClickSelection() {
    final controller = _controller;

    setState(() {
      log("set state");
      DebugLog.w("Hello world${controller.selection.start}");
    });

    _selectAllTimer?.cancel();

    _selectAllTimer = null;

    // If you want to select all text after paragraph, uncomment this line
    if (_selectionType == _SelectionType.word) {
      final selection = TextSelection(
        baseOffset: 0,
        extentOffset: controller.document.length,
      );

      controller.updateSelection(selection, ChangeSource.REMOTE);

      _selectionType = _SelectionType.none;

      return true;
    }

    if (controller.selection.isCollapsed) {
      _selectionType = _SelectionType.none;
    }

    if (_selectionType == _SelectionType.none) {
      _selectionType = _SelectionType.word;
      _startTripleClickTimer();
      return false;
    }

    if (_selectionType == _SelectionType.word) {
      final child = controller.document.queryChild(
        controller.selection.baseOffset,
      );
      final offset = child.node?.documentOffset ?? 0;
      final length = child.node?.length ?? 0;

      final selection = TextSelection(
        baseOffset: offset,
        extentOffset: offset + length,
      );

      controller.updateSelection(selection, ChangeSource.REMOTE);

      _selectionType = _SelectionType.none;

      _startTripleClickTimer();

      return true;
    }

    return false;
  }

  void _startTripleClickTimer() {
    _selectAllTimer = Timer(const Duration(milliseconds: 900), () {
      _selectionType = _SelectionType.none;
    });
  }

  void saveToLocal(File file) {}

  Future<String> _onImagePickCallback(File file) async {
    // Copies the picked file from temporary cache to applicafinaltions directory
    String urlDownload = "";
    final appDocDir = await getApplicationDocumentsDirectory();
    final File copiedFile =
        await file.copy('${appDocDir.path}/${path.basename(file.path)}');

    // await file.copy('${appDocDir.path}/${path.basename(file.path)}');
    log(note!.noteId);
    if (FirebaseAuth.instance.currentUser != null) {
      String copiedPath =
          "${FirebaseAuth.instance.currentUser!.uid}/$folderId / ${note!.noteId}/${copiedFile.path.split("/").last}";
      log(copiedPath);

      final ref = FirebaseStorage.instance.ref().child(copiedPath);

      setState(() {
        uploadTask = ref.putFile(copiedFile);
      });

      final snapshot = await uploadTask!.whenComplete(() => {});
      urlDownload = await snapshot.ref.getDownloadURL().whenComplete(
            () => Navigator.of(context).pop(),
          );
      log(urlDownload);
      setState(() {
        uploadTask = null;
      });
    } else {
      final String duplicateFilePath = appDocDir.path;
      String copiedPath =
          "$folderId / ${note!.noteId}/${copiedFile.path.split("/").last}";
    }
    return urlDownload;
  }

  void saveFile(String fildePath) async {
    File file = File(fildePath); // 1
    file.writeAsString(
        "This is my demo text that will be saved to : demoTextFile.txt"); // 2
  }

  void readFile(String filePath) async {
    File file = File(filePath); // 1
    String fileContent = await file.readAsString(); // 2

    print('File Content: $fileContent');
  }

  void replacesLinkFromController(
      QuillController controller, String imageName) {
    var json = jsonEncode(controller.document.toDelta());
    List<dynamic> delta = jsonDecode(json);

// Loop over the delta list and search for insert
    for (Map<String, dynamic> line in delta) {
      // Each line represents a Map -> line to insert
      for (var key in line.keys) {
        var value = line[key];

        // Check if the key is insert
        if (key == "insert") {
          // Check if the value is a map
          if (value is Map<String, dynamic>) {
            // If it is a map then check if there is a image -> link pair
            for (var newKey in value.keys) {
              if (newKey == "image") {
                // value == local storage
                // Replaces the value
                // Get the new value from the url map
                String storageUrl = "";
                // getUrlFromImageName(imageName);
                String localUrl = "";
                //  getLocalUrlFromImageName(imageName);
                if (storageUrl != "") {
                  value[newKey] = storageUrl;

                  var delta = controller.document.toDelta();
                  int position = 0;
                  int length = 0;
                  for (var operation in delta.toList()) {
                    position = position + operation.length!;
                    if (operation.key == 'insert') {
                      if (operation.data is Map) {
                        Map compare = operation.data as Map;
                        if (compare.containsKey('image')) {
                          if (compare['image'] == localUrl) {
                            length = operation.length!;
                            break;
                          }
                        }
                      }
                    }
                  }
                  Embeddable newImageWithUrl = Embeddable('image', storageUrl);
                  controller.document
                      .replace(position - 1, length, newImageWithUrl);
                }
              }
            }
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
//  todo: create provider

    noteProvider = Provider.of<NoteProvider>(context);

// todo: format tieu de
    _controller.formatText(0, title.length, Attribute.h1);
    _controller.formatText(0, title.length, Attribute.bold);

    return Theme(
      data: ThemeData.light().copyWith(
        bottomSheetTheme:
            const BottomSheetThemeData(backgroundColor: Colors.transparent),
      ),
      child: Scaffold(
        appBar: CustomAppbar(
          handleBackBtn: () async {
            switch (type) {
              case NoteType.newNote:
                {
                  if (_controller.document.toPlainText().isNotEmpty) {
                    var json =
                        jsonEncode(_controller.document.toDelta().toJson());
                    Note newNote = await noteProvider.createNewNote(
                      noteId: note!.noteId,
                      ownerFolderId: folderId,
                      titleNote: _controller.document
                          .toPlainText()
                          .trim()
                          .split("\n")[0]
                          .toString(),
                      bodyNote: _controller.document
                          .toPlainText()
                          .trim()
                          .split("\n")[1]
                          .toString(),
                      content: json,
                    );

                    setState(() {
                      note = newNote;
                    });
                    note!.printInfo();

                    log("Uploaded");
                  }
                  Future.delayed(const Duration(seconds: 0), () {
                    Navigator.of(context).pop();
                  });
                  break;
                }
              case NoteType.editNote:
                {
                  log("eidt note");
                  Future.delayed(const Duration(seconds: 0), () {
                    Navigator.of(context).pop();
                  });
                }
            }

            //   log(_controller.document
            //       .toPlainText()
            //       .trim()
            //       .split("\n")[0]
            //       .toString());
          },
        ),
        body: _buildWelcomeEditor(context),
        bottomSheet: SingleChildScrollView(
          child: quillToolbar(_controller),
        ),
        resizeToAvoidBottomInset: true,
      ),
    );
  }
}
