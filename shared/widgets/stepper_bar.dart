import 'package:flutter/material.dart';

class StepperBar extends StatelessWidget {
  final int currentStep;
  const StepperBar({super.key, required this.currentStep});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final outline = theme.colorScheme.outlineVariant;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: List.generate(4, (index) {
          final isActive = index < currentStep;
          return Expanded(
            child: Row(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: isActive ? primary : Colors.transparent,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isActive ? primary : outline,
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      "${index + 1}",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: isActive ? Colors.white : outline,
                      ),
                    ),
                  ),
                ),
                if (index < 3)
                  Expanded(
                    child: Container(
                      height: 2,
                      color: index < currentStep - 1 ? primary : outline,
                    ),
                  ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
