import 'package:app_fleet/config/theme/app_theme.dart';
import 'package:flutter/material.dart';

class CreateButton extends StatefulWidget {
  const CreateButton({
    super.key,
    required this.onPressed,
  });

  final VoidCallback onPressed;

  @override
  State<CreateButton> createState() => _CreateButtonState();
}

class _CreateButtonState extends State<CreateButton> {
  bool hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (event) => setState(() => hover = true),
      onExit: (event) => setState(() => hover = false),
      child: GestureDetector(
        onTap: widget.onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          decoration: BoxDecoration(
            color: Colors.blueAccent.withOpacity(0.2),
            borderRadius: BorderRadius.circular(25),
            border: Border.all(
              color: hover ? Colors.blueAccent : Colors.transparent,
              width: 2,
            ),
          ),
          width: 200,
          height: 40,
          child: Center(
            child: Text(
              "Create Now",
              style: AppTheme.fontSize(18).withColor(Colors.blue),
            ),
          ),
        ),
      ),
    );
  }
}
