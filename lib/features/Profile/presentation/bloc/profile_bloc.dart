import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:secondproject/features/Profile/domain/usecases/get_user_profile.dart';
import 'package:secondproject/features/Profile/presentation/bloc/profile_event.dart';
import 'package:secondproject/features/Profile/presentation/bloc/profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetUserProfile getUserProfile;

  ProfileBloc(this.getUserProfile) : super(ProfileInitial()){
    on<LoadProfile>((event, emit) async{
      emit(ProfileLoaded());try {
        final userProfile=await getUserProfile(event.userId);
        emit(ProfileLoaded(userProfile));
      } catch (e) {
        emit(ProfileError(e.toString()));
      }
    },);
  }

  @override
  Stream<ProfileState> mapEventToState(ProfileEvent event) async* {
    if (event is LoadProfile) {
      yield ProfileLoading();
      try {
        final userProfile = await getUserProfile(event.userId);
        yield ProfileLoaded(userProfile);
      } catch (e) {
        yield ProfileError( e.toString());
      }
    }
  }
}
