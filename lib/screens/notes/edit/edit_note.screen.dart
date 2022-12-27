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
import '../../../utils/show_snack_bar.dart';
import '../../../widgets/bar/app_bar.dart';
import '../type.dart';

enum _SelectionType {
  none,
  word,
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

  List<String> oldLinkImages = [];

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
            setState(() {
              log(doc.toDelta().toString());
              _controller = QuillController(
                  document: doc,
                  selection: const TextSelection.collapsed(offset: 0));
            });

            oldLinkImages = getLinkImages(_controller);

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
    final appDocDir = await getApplicationDocumentsDirectory();
    final File copiedFile =
        await file.copy('${appDocDir.path}/${path.basename(file.path)}');

    return copiedFile.path;
  }

  File getFileFromPath(String path) {
    return File(path);
  }

  List<String> getLinkImages(QuillController controller) {
    List<String> results = [];
    var json = jsonEncode(controller.document.toDelta());
    List<dynamic> delta = jsonDecode(json);
    for (Map<String, dynamic> line in delta) {
      // Each line represents a Map -> line to insert
      for (var key in line.keys) {
        var value = line[key];
        // Check if the key is insert
        if (key == "insert") {
          if (value is Map<String, dynamic>) {
            for (var newKey in value.keys) {
              var valueNewKey = value[newKey];
              if (newKey == "image") {
                results.add(valueNewKey);
              }
            }
          }
        }
      }
    }

    return results;
  }

  void deleteImageInFirebase(String url) {
    FirebaseStorage.instance.refFromURL(url).delete();
  }

  Future<String> getAndUploadImageToFirebase(File file) async {
    // await file.copy('${appDocDir.path}/${path.basename(file.path)}');
    String urlDownload = "";
    log(note!.noteId);
    if (FirebaseAuth.instance.currentUser != null) {
      String copiedPath =
          "${FirebaseAuth.instance.currentUser!.uid}/$folderId / ${note!.noteId}/${file.path.split("/").last}";
      log(copiedPath);

      final ref = FirebaseStorage.instance.ref().child(copiedPath);

      try {
        urlDownload = await ref.getDownloadURL();
      } catch (e) {
        setState(() {
          uploadTask = ref.putFile(file);
        });
        final snapshot = await uploadTask!.whenComplete(() => {});
        urlDownload = await snapshot.ref.getDownloadURL();
      }

      log(urlDownload);
      setState(() {
        uploadTask = null;
      });
    }
    return urlDownload;
  }

  Future<void> replacesLinkFromController(QuillController controller) async {
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
            for (var newKey in value.keys) {
              var valueNewKey = value[newKey];
              if (newKey == "image") {
                File imageFile = getFileFromPath(valueNewKey);
                String localUrl = valueNewKey;
                String storageUrl = "";
                if (localUrl.split('/')[0] == "https:") {
                  storageUrl = localUrl;
                } else {
                  storageUrl = await getAndUploadImageToFirebase(imageFile);
                }

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
                    await replacesLinkFromController(_controller);
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
                  await replacesLinkFromController(_controller);

                  List<String> newUrlImages = getLinkImages(_controller);

                  for (var element in oldLinkImages) {
                    if (!newUrlImages.contains(element)) {
                      deleteImageInFirebase(element);
                    }
                  }
                  var json =
                      jsonEncode(_controller.document.toDelta().toJson());

                  note!.title = _controller.document
                      .toPlainText()
                      .trim()
                      .split("\n")[0]
                      .toString();
                  note!.body = _controller.document
                      .toPlainText()
                      .trim()
                      .split("\n")[1]
                      .toString();
                  note!.content = json;

                  noteProvider.updateNote(note!.ownerFolderId, note!);

                  Future.delayed(const Duration(seconds: 0), () {
                    showSnackBarSuccess(context, "Edit note success");
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
