abstract class SignupEvent {}

class SignupRequested extends SignupEvent {
  final String email;
  final String password;
  final String username;

  SignupRequested(this.email, this.password,this.username);
}
