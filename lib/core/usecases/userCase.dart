abstract class Use_case<Type, Params> {
  Future<Type> call(Params params);
}

class NoParams {}
