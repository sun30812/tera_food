import 'package:flutter/material.dart';

/// 누를 시 크기가 확대/축소 되는 Heart 모양의 버튼.
///
/// [initialActivated]가 true로 설정되면 초기 상태가 활성화된 즐겨찾기 버튼으로 시작한다.
/// [onPressed] 콜백이 제공되면 버튼을 누를 수 있으며,
/// 누를 때마다 애니메이션이 재생된다. 콜백이 null이면 버튼은 비활성화된다.
class BeatingHeartIconButton extends StatefulWidget {
  /// 버튼의 초기 활성화 상태.
  ///
  /// true인 경우 즐겨찾기 상태 활성화, false인 경우 비활성화된 상태로 시작한다. 기본값은 false이다.
  final bool initialActivated;
  /// 버튼이 눌렸을 때 호출되는 콜백 함수.
  ///
  /// 버튼이 눌릴 경우 수행할 동작을 정의할 수 있다. 눌린 경우 즐겨찾기 상태가 활성화 되며, 활성화 여부를 [isEnabled] 변수를 통해 전달한다. 콜백이 null인 경우 버튼은 비활성화된다.
  final void Function(bool isEnabled)? onPressed;
  const BeatingHeartIconButton({super.key, required this.onPressed, this.initialActivated = false});

  @override
  State<BeatingHeartIconButton> createState() => _BeatingHeartIconButtonState();
}

class _BeatingHeartIconButtonState extends State<BeatingHeartIconButton>
    with SingleTickerProviderStateMixin {
  // 애니메이션 동작을 제어하는 컨트롤러
  late final AnimationController _controller;
  // 애니메이션 동작을 정의하는 객체
  late final Animation<double> _animation;

  // 즐겨찾기 활성화 여부
  late bool _isEnabled = widget.initialActivated;

  @override
  void initState() {
    super.initState();
    _isEnabled = widget.initialActivated;
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animation = Tween<double>(
      begin: 1.0,
      end: 1.5,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: widget.onPressed != null ? () {
        _controller.forward(from: 0.0).then((_) => _controller.reverse());
        setState(() {
          _isEnabled = !_isEnabled;
        });
        widget.onPressed!(_isEnabled);
      } : null,
      icon: ScaleTransition(
        scale: _animation,
        child: (_isEnabled)
            ? const Icon(Icons.favorite, color: Colors.redAccent)
            : const Icon(Icons.favorite_border),
      ),
    );
  }
}
