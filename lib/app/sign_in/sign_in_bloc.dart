import 'dart:async';

class SignInBloc {
  final StreamController<bool> _isLoadingController = StreamController<bool>();
  //getter for the block
  Stream<bool> get isLoadingStream => _isLoadingController.stream;

  //dispose
void dispose(){
  _isLoadingController.close();
}

//add to the sink of the controller/ setter
void setIsLoading(bool isLoading) => _isLoadingController.add(isLoading);
}
