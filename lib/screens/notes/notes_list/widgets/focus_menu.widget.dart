import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:focused_menu/modals.dart';

class FocusedMenuHolder extends StatefulWidget {
  final Widget child;
  final double? menuItemExtent;
  final double? menuWidth;
  final List<FocusedMenuItem> menuItems;
  final bool? animateMenuItems;
  final BoxDecoration? menuBoxDecoration;
  final Function onPressed;
  final Duration? duration;
  final double? blurSize;
  final Color? blurBackgroundColor;
  final double? bottomOffsetHeight;
  final double? menuOffset;
  final bool isPaddingChildMain;

  /// Open with tap insted of long press.
  final bool openWithTap;

  const FocusedMenuHolder({
    Key? key,
    required this.child,
    required this.onPressed,
    required this.menuItems,
    this.duration,
    this.menuBoxDecoration,
    this.menuItemExtent,
    this.animateMenuItems,
    this.blurSize,
    this.blurBackgroundColor,
    this.menuWidth,
    this.bottomOffsetHeight,
    this.menuOffset,
    this.openWithTap = false,
    this.isPaddingChildMain = true,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _FocusedMenuHolderState createState() => _FocusedMenuHolderState();
}

class _FocusedMenuHolderState extends State<FocusedMenuHolder> {
  GlobalKey containerKey = GlobalKey();
  Offset childOffset = Offset(20.w, 0);
  Size? childSize;

  getOffset() {
    RenderBox renderBox =
        containerKey.currentContext!.findRenderObject() as RenderBox;
    Size size = renderBox.size;
    Offset offset = renderBox.localToGlobal(const Offset(0, 0));
    setState(() {
      childOffset = Offset(offset.dx, offset.dy);
      childSize = size;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        key: containerKey,
        onTap: () async {
          widget.onPressed();
          if (widget.openWithTap) {
            await openMenu(context);
          }
        },
        onLongPress: () async {
          if (!widget.openWithTap) {
            await openMenu(context);
          }
        },
        child: widget.child);
  }

  Future openMenu(BuildContext context) async {
    getOffset();
    await Navigator.push(
        context,
        PageRouteBuilder(
            transitionDuration:
                widget.duration ?? const Duration(milliseconds: 100),
            pageBuilder: (context, animation, secondaryAnimation) {
              animation = Tween(begin: 0.0, end: 1.0).animate(animation);
              return FadeTransition(
                  opacity: animation,
                  child: FocusedMenuDetails(
                    itemExtent: widget.menuItemExtent,
                    menuBoxDecoration: widget.menuBoxDecoration,
                    childOffset: childOffset,
                    childSize: childSize,
                    menuItems: widget.menuItems,
                    blurSize: widget.blurSize,
                    menuWidth: widget.menuWidth,
                    isPaddingMainParent: widget.isPaddingChildMain,
                    blurBackgroundColor: widget.blurBackgroundColor,
                    animateMenu: widget.animateMenuItems ?? true,
                    bottomOffsetHeight: widget.bottomOffsetHeight ?? 0,
                    menuOffset: widget.menuOffset ?? 0,
                    child: widget.child,
                  ));
            },
            fullscreenDialog: true,
            opaque: false));
  }
}

// ignore: must_be_immutable
class FocusedMenuDetails extends StatelessWidget {
  final List<FocusedMenuItem> menuItems;
  final BoxDecoration? menuBoxDecoration;
  final Offset childOffset;
  final double? itemExtent;
  final Size? childSize;
  final Widget child;
  final bool animateMenu;
  final double? blurSize;
  final double? menuWidth;
  final Color? blurBackgroundColor;
  final double? bottomOffsetHeight;
  final double? menuOffset;
  bool isPaddingMainParent;

  FocusedMenuDetails(
      {Key? key,
      required this.menuItems,
      required this.child,
      required this.childOffset,
      required this.childSize,
      required this.menuBoxDecoration,
      required this.itemExtent,
      required this.animateMenu,
      required this.blurSize,
      required this.blurBackgroundColor,
      required this.menuWidth,
      required this.isPaddingMainParent,
      this.bottomOffsetHeight,
      this.menuOffset})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    final maxMenuHeight = size.height * 0.45;
    final listHeight = menuItems.length * (itemExtent ?? 50.0);

    final maxMenuWidth = menuWidth ?? (size.width * 0.70);
    final menuHeight = listHeight < maxMenuHeight ? listHeight : maxMenuHeight;
    final leftOffset = (childOffset.dx + maxMenuWidth) < size.width
        ? childOffset.dx + 16.w
        : (childOffset.dx - maxMenuWidth + childSize!.width + 16.w);
    final topOffset = (childOffset.dy + menuHeight + childSize!.height) <
            size.height - bottomOffsetHeight!
        ? childOffset.dy + childSize!.height + menuOffset!
        : childOffset.dy - menuHeight - menuOffset!;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: BackdropFilter(
                filter: ImageFilter.blur(
                    sigmaX: blurSize ?? 4, sigmaY: blurSize ?? 4),
                child: Container(
                  color: (blurBackgroundColor ?? Colors.black).withOpacity(0.7),
                ),
              )),
          Positioned(
            top: topOffset,
            left: leftOffset,
            child: TweenAnimationBuilder(
              duration: const Duration(milliseconds: 200),
              builder: (BuildContext context, dynamic value, Widget? child) {
                return Transform.scale(
                  scale: value,
                  alignment: Alignment.center,
                  child: child,
                );
              },
              tween: Tween(begin: 0.0, end: 1.0),
              child: Container(
                width: maxMenuWidth,
                height: menuHeight,
                decoration: menuBoxDecoration ??
                    BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(5.0)),
                        boxShadow: const [
                          BoxShadow(
                              color: Colors.black38,
                              blurRadius: 10,
                              spreadRadius: 1)
                        ]),
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                  child: ListView.builder(
                    itemCount: menuItems.length,
                    padding: EdgeInsets.zero,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      FocusedMenuItem item = menuItems[index];
                      Widget listItem = GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                            item.onPressed();
                          },
                          child: Container(
                              alignment: Alignment.center,
                              margin: const EdgeInsets.only(bottom: 1),
                              color: item.backgroundColor ?? Colors.white,
                              height: itemExtent ?? 50.0,
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: isPaddingMainParent ? 8.0 : 0,
                                    horizontal: isPaddingMainParent ? 14 : 0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    item.title,
                                    if (item.trailingIcon != null) ...[
                                      item.trailingIcon!
                                    ]
                                  ],
                                ),
                              )));
                      if (animateMenu) {
                        return TweenAnimationBuilder(
                            builder: (context, dynamic value, child) {
                              return Transform(
                                transform: Matrix4.rotationX(1.5708 * value),
                                alignment: Alignment.bottomCenter,
                                child: child,
                              );
                            },
                            tween: Tween(begin: 1.0, end: 0.0),
                            duration: Duration(milliseconds: index * 200),
                            child: listItem);
                      } else {
                        return listItem;
                      }
                    },
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: childOffset.dy,
            left: childOffset.dx,
            child: AbsorbPointer(
              absorbing: true,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 8.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.r),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black54,
                      blurRadius: 4.0, // has the effect of softening the shadow
                      offset: Offset(
                        2.0, // horizontal, move right 10
                        5, // vertical, move down 10
                      ),
                    )
                  ],
                ),
                width: childSize!.width - 16.w,
                height: childSize!.height,
                child: child,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
