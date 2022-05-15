import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class KeyboardActionDetector extends StatelessWidget {
  const KeyboardActionDetector({
    Key? key,
    required this.child,
    required this.onArrowDownCallback,
    required this.onArrowUpCallback,
    required this.onArrowLeftCallback,
    required this.onArrowRightCallback,
  }) : super(key: key);

  final Function onArrowUpCallback;
  final Function onArrowDownCallback;
  final Function onArrowLeftCallback;
  final Function onArrowRightCallback;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return FocusableActionDetector(
      autofocus: true,
      actions: _initActions(),
      shortcuts: _initShortcuts(),
      child: child,
    );
  }

  _initShortcuts() => <LogicalKeySet, Intent>{
        LogicalKeySet(LogicalKeyboardKey.arrowUp): const _XIntent.arrowUp(),
        LogicalKeySet(LogicalKeyboardKey.arrowDown): const _XIntent.arrowDown(),
        LogicalKeySet(LogicalKeyboardKey.arrowLeft): const _XIntent.arrowLeft(),
        LogicalKeySet(LogicalKeyboardKey.arrowRight):
            const _XIntent.arrowRight(),
      };

  _initActions() => <Type, Action<Intent>>{
        _XIntent: CallbackAction<_XIntent>(
          onInvoke: _actionHandler,
        ),
      };

  void _actionHandler(_XIntent intent) {
    switch (intent.type) {
      case _XIntentType.ArrowUp:
        onArrowUpCallback();
        break;
      case _XIntentType.ArrowDown:
        onArrowDownCallback();
        break;
      case _XIntentType.ArrowRight:
        onArrowRightCallback();
        break;
      case _XIntentType.ArrowLeft:
        onArrowLeftCallback();
        break;
    }
  }
}

class _XIntent extends Intent {
  final _XIntentType type;

  const _XIntent({required this.type});

  const _XIntent.arrowUp() : type = _XIntentType.ArrowUp;

  const _XIntent.arrowDown() : type = _XIntentType.ArrowDown;

  const _XIntent.arrowLeft() : type = _XIntentType.ArrowLeft;

  const _XIntent.arrowRight() : type = _XIntentType.ArrowRight;
}

enum _XIntentType {
  ArrowUp,
  ArrowDown,
  ArrowRight,
  ArrowLeft,
}
