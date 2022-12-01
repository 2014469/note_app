import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_quill/extensions.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;
import 'package:flutter_quill_extensions/flutter_quill_extensions.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
// ignore: depend_on_referenced_packages
import 'package:tuple/tuple.dart';

import '../../../resources/colors/colors.dart';
import '../../../widgets/app_bar.dart';

enum _SelectionType {
  none,
  word,
  // line,
}

class EditNoteScreen extends StatefulWidget {
  const EditNoteScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _EditNoteScreenState createState() => _EditNoteScreenState();
}

class _EditNoteScreenState extends State<EditNoteScreen> {
  late QuillController _controller;
  String title = "";
  late final FocusNode _focusNode = FocusNode();
  Timer? _selectAllTimer;
  bool isShowKeyboard = true;
  _SelectionType _selectionType = _SelectionType.none;

  @override
  void dispose() {
    _selectAllTimer?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    _controller = QuillController.basic();

    _loadFromAssets();
    super.initState();
  }

  Future<void> _loadFromAssets() async {
    try {
      final result = await rootBundle.loadString(isDesktop()
          ? 'assets/sample_data_nomedia.json'
          : 'assets/sample_data.json');
      final doc = Document.fromJson(jsonDecode(result));
      setState(() {
        _controller = QuillController(
            document: doc, selection: const TextSelection.collapsed(offset: 0));
      });
    } catch (error) {
      final doc = Document()..insert(0, '');
      setState(() {
        _controller = QuillController(
            document: doc, selection: const TextSelection.collapsed(offset: 0));
      });
    }
  }

  Widget quillToolbar(QuillController controller) {
    return QuillToolbar.basic(
      locale: const Locale('vi'),
      multiRowsDisplay: false,
      controller: controller,
      embedButtons: FlutterQuillEmbeds.buttons(
        onImagePickCallback: _onImagePickCallback,
        onVideoPickCallback: _onVideoPickCallback,
        // uncomment to provide a custom "pick from" dialog.
        mediaPickSettingSelector: _selectMediaPickSetting,
        // uncomment to provide a custom "pick from" dialog.
        cameraPickSettingSelector: _selectCameraPickSetting,
      ),
      showAlignmentButtons: true,
      showSearchButton: true,
      showDirection: true,
      afterButtonPressed: _focusNode.requestFocus,
    );
  }

  @override
  Widget build(BuildContext context) {
    _controller.formatText(0, title.length, Attribute.h1);
    _controller.formatText(0, title.length, Attribute.bold);

    return Theme(
      data: ThemeData.light().copyWith(
        bottomSheetTheme:
            const BottomSheetThemeData(backgroundColor: Colors.transparent),
      ),
      child: Scaffold(
        appBar: CustomAppbar(
          handleBackBtn: () {
            log("Back btn");

            log(_controller.document
                .toPlainText()
                .trim()
                .split("\n")[0]
                .toString());
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

  bool onTripleClickSelection() {
    final controller = _controller;

    setState(() {
      log("set state");
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

      // _selectionType = _SelectionType.line;

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

  Widget _buildWelcomeEditor(BuildContext context) {
    Widget quillEditor = QuillEditor(
      // locale: const Locale('vi'),
      controller: _controller,
      scrollController: ScrollController(),
      scrollable: true,
      focusNode: _focusNode,
      autoFocus: true,
      readOnly: false,
      placeholder: 'Add content',
      // enableSelectionToolbar: isMobile(),
      expands: true,
      padding: EdgeInsets.zero,
      onImagePaste: _onImagePaste,
      onTapUp: (details, p1) {
        return onTripleClickSelection();
      },
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
      // embedBuilders: [
      //   ...FlutterQuillEmbeds.builders(),
      // ],
    );
    return SafeArea(
      child: Container(
        color: Colors.white,
        padding: EdgeInsets.only(
            left: 16.w, right: 16.w, bottom: kDefaultIconSize * 3),
        child: quillEditor,
      ),
    );
  }

  // Future<String?> openFileSystemPickerForDesktop(BuildContext context) async {
  //   return await FilesystemPicker.open(
  //     context: context,
  //     rootDirectory: await getApplicationDocumentsDirectory(),
  //     fsType: FilesystemType.file,
  //     fileTileSelectMode: FileTileSelectMode.wholeTile,
  //   );
  // }

  // Renders the image picked by imagePicker from local file storage
  // You can also upload the picked image to any server (eg : AWS s3
  // or Firebase) and then return the uploaded image URL.
  Future<String> _onImagePickCallback(File file) async {
    // Copies the picked file from temporary cache to applications directory
    final appDocDir = await getApplicationDocumentsDirectory();
    final copiedFile =
        await file.copy('${appDocDir.path}/${basename(file.path)}');
    return copiedFile.path.toString();
  }

  // Renders the video picked by imagePicker from local file storage
  // You can also upload the picked video to any server (eg : AWS s3
  // or Firebase) and then return the uploaded video URL.
  Future<String> _onVideoPickCallback(File file) async {
    // Copies the picked file from temporary cache to applications directory
    final appDocDir = await getApplicationDocumentsDirectory();
    final copiedFile =
        await file.copy('${appDocDir.path}/${basename(file.path)}');
    return copiedFile.path.toString();
  }

  // ignore: unused_element
  Future<MediaPickSetting?> _selectMediaPickSetting(BuildContext context) =>
      showDialog<MediaPickSetting>(
        context: context,
        builder: (ctx) => AlertDialog(
          contentPadding: EdgeInsets.zero,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              textButtonDialog(
                () {
                  Navigator.pop(ctx, MediaPickSetting.Gallery);
                },
                Icons.collections,
                "Gallery",
              ),
              textButtonDialog(
                () {
                  Navigator.pop(ctx, MediaPickSetting.Link);
                },
                Icons.link,
                "Link",
              ),
            ],
          ),
        ),
      );

  Widget textButtonDialog(VoidCallback onPress, IconData icon, String title) {
    return TextButton.icon(
      onPressed: onPress,
      icon: Icon(
        icon,
        color: AppColors.primary,
      ),
      label: Text(
        title,
        style: TextStyle(color: AppColors.gray[80]),
      ),
    );
  }

  Future<MediaPickSetting?> _selectCameraPickSetting(BuildContext context) =>
      showDialog<MediaPickSetting>(
        context: context,
        builder: (ctx) => AlertDialog(
          contentPadding: EdgeInsets.zero,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              textButtonDialog(
                () {
                  Navigator.pop(ctx, MediaPickSetting.Camera);
                },
                Icons.camera,
                "Capture a photo",
              ),
              textButtonDialog(
                () {
                  Navigator.pop(ctx, MediaPickSetting.Video);
                },
                Icons.video_call,
                "Capture a video",
              ),
            ],
          ),
        ),
      );

  Future<String> _onImagePaste(Uint8List imageBytes) async {
    // Saves the image to applications directory
    final appDocDir = await getApplicationDocumentsDirectory();
    final file = await File(
            '${appDocDir.path}/${basename('${DateTime.now().millisecondsSinceEpoch}.png')}')
        .writeAsBytes(imageBytes, flush: true);
    return file.path.toString();
  }
}
