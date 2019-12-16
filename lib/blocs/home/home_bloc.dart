import 'home_event.dart';
import 'home_state.dart';
import 'package:bloc/bloc.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState>{

  HomeState get initialState => null;

  @override
  Stream<HomeState> mapEventToState(HomeEvent event) async* {
  }

}
			