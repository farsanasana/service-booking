import 'package:equatable/equatable.dart';
import '../../domain/entities/navigation_tab.dart';

abstract class NavigationEvent extends Equatable {
  const NavigationEvent();

  @override
  List<Object?> get props => [];
}

class TabChanged extends NavigationEvent {
  final NavigationTab tab;

  const TabChanged(this.tab);

  @override
  List<Object?> get props => [tab];
}
