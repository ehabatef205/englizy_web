abstract class LoginStates {}

class LoginInitialState extends LoginStates {}

class ChangeState extends LoginStates {}
class LoginLoadingState extends LoginStates {}
class LoginSuccessState extends LoginStates {}
class LoginErrorState extends LoginStates {}

class RegisterChangeState extends LoginStates {}
class RegisterLoadingState extends LoginStates {}
class RegisterSuccessState extends LoginStates {}
class RegisterErrorState extends LoginStates {}

class CreateUserLoadingState extends LoginStates {}
class CreateUserSuccessState extends LoginStates {}
class CreateUserErrorState extends LoginStates {}
