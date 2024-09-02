import 'package:flutter/material.dart';

class AnimatedRainbowText extends StatefulWidget {
  final String text;
  final TextStyle style;
  final Duration duration;

  const AnimatedRainbowText({
    Key? key,
    required this.text,
    this.style = const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
    this.duration = const Duration(seconds: 2),
  }) : super(key: key);

  @override
  _AnimatedRainbowTextState createState() => _AnimatedRainbowTextState();
}

class _AnimatedRainbowTextState extends State<AnimatedRainbowText>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    )..repeat(); // Repeat the animation indefinitely
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return ShaderMask(
          shaderCallback: (Rect bounds) {
            return LinearGradient(
              colors: const [
                Colors.red,
                Color.fromARGB(255, 192, 133, 44),
                Color.fromARGB(255, 175, 160, 26),
                Colors.green,
                Colors.blue,
                Colors.indigo,
                Colors.purple,
              ],
              tileMode: TileMode.mirror,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              transform: GradientRotation(_controller.value * 2 * 3.14159),
            ).createShader(bounds);
          },
          child: Text(
            widget.text,
            style: widget.style.copyWith(color: Colors.white),
          ),
        );
      },
    );
  }
}
