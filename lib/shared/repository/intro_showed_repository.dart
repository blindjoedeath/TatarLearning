
enum Screen{
  WhatIsGame
}

class IntroShowedRepository{

  bool get isInited => true;

  void dispose(){
    
  }

  Future<void> init(){
    return Future.microtask(((){
      return;
    }));
  }

  bool isShowed(Screen screen){
    return false;
  }

  void showed(Screen screen){

  }

}