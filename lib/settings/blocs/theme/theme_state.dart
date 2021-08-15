part of 'theme_bloc.dart';

class ThemeState extends Equatable {
  const ThemeState({
    required this.themeMode,
    required this.accentColor,
  });
  final ThemeMode themeMode;
  final Color accentColor;

  factory ThemeState.initial() {
    return ThemeState(
      themeMode: ThemeMode.system,
      accentColor: Colors.blue,
    );
  }

  @override
  List<Object> get props => [themeMode, accentColor];

  ThemeState copyWith({
    ThemeMode? themeMode,
    Color? accentColor,
  }) {
    return ThemeState(
      themeMode: themeMode ?? this.themeMode,
      accentColor: accentColor ?? this.accentColor,
    );
  }

  List<Color> get availableAccentColors => [
        Colors.blue,
        Colors.green,
        Colors.red,
        Colors.purple,
        Colors.orange,
        Colors.redAccent,
        Colors.indigoAccent,
      ];

  bool isAccentColorSelected(Color color) => color == this.accentColor;
}
