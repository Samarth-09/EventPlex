class LoginState{}

class LoginInitialState extends LoginState{
  int i=-1;
}

class LoginRoleSelectedState extends LoginState{
  int i;
  LoginRoleSelectedState(this.i);
}