import 'package:equatable/equatable.dart';
import '../../domain/entities/navigation_tab.dart';

class NavigationState extends Equatable {
  final NavigationTab selectedTab;

  const NavigationState({required this.selectedTab});

  @override
  List<Object?> get props => [selectedTab];
}
