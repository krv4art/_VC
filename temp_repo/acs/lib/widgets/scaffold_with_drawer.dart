import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider_v2.dart';
import 'modern_drawer.dart';

// InheritedWidget to provide drawer toggle function to descendants
class DrawerToggleProvider extends InheritedWidget {
  final VoidCallback toggleDrawer;

  const DrawerToggleProvider({
    super.key,
    required this.toggleDrawer,
    required super.child,
  });

  static DrawerToggleProvider? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<DrawerToggleProvider>();
  }

  @override
  bool updateShouldNotify(DrawerToggleProvider oldWidget) {
    return toggleDrawer != oldWidget.toggleDrawer;
  }
}

class ScaffoldWithDrawer extends StatefulWidget {
  final Widget body;
  final PreferredSizeWidget? appBar;
  final Widget? floatingActionButton;
  final bool extendBodyBehindAppBar;
  final Color? backgroundColor;
  final bool? resizeToAvoidBottomInset;

  const ScaffoldWithDrawer({
    super.key,
    required this.body,
    this.appBar,
    this.floatingActionButton,
    this.extendBodyBehindAppBar = false,
    this.backgroundColor,
    this.resizeToAvoidBottomInset,
  });

  @override
  State<ScaffoldWithDrawer> createState() => _ScaffoldWithDrawerState();
}

class _ScaffoldWithDrawerState extends State<ScaffoldWithDrawer>
    with SingleTickerProviderStateMixin {
  bool _isDrawerOpen = false;

  void _toggleDrawer() {
    setState(() {
      _isDrawerOpen = !_isDrawerOpen;
    });
  }

  void _closeDrawer() {
    if (_isDrawerOpen) {
      setState(() {
        _isDrawerOpen = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Watch theme changes to trigger rebuild
    context.watch<ThemeProviderV2>();

    return DrawerToggleProvider(
      toggleDrawer: _toggleDrawer,
      child: Scaffold(
        key: const Key('scaffold_with_drawer'),
        backgroundColor: widget.backgroundColor,
        extendBodyBehindAppBar: widget.extendBodyBehindAppBar,
        resizeToAvoidBottomInset: widget.resizeToAvoidBottomInset,
        appBar: widget.appBar,
        body: Stack(
          children: [
            // Main body
            widget.body,

            // Overlay when drawer is open
            if (_isDrawerOpen)
              GestureDetector(
                onTap: _closeDrawer,
                child: Container(color: Colors.black.withValues(alpha: 0.5)),
              ),

            // Fake drawer
            AnimatedPositioned(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              left: _isDrawerOpen
                  ? 0
                  : -MediaQuery.of(context).size.width * 0.75,
              top: 0,
              bottom: 0,
              width: MediaQuery.of(context).size.width * 0.75,
              child: ModernDrawer(onClose: _closeDrawer),
            ),
          ],
        ),
        floatingActionButton: widget.floatingActionButton,
      ),
    );
  }
}
