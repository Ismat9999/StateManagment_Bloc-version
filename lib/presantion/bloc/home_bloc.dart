
import 'package:bloc/bloc.dart';
import 'package:smbloc/data/datasources/remote/http_service.dart';

import '../../data/models/random_user_list_res.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  List<RandomUser> userList= [];
  int currentPage = 1;

  HomeBloc(): super (HomeInitialState()){
    on<LoadRandomUserListEvent>(_onLoadRandomUserList);
  }

  Future<void> _onLoadRandomUserList(LoadRandomUserListEvent event, Emitter<HomeState> emit)async{
    emit(HomeLoadingState());
    var response= await Network.GET(Network.API_RANDOM_USER_LIST, Network.paramsRandomUserList(currentPage));
    if (response!= null){
      var results= Network.parseRandomUserList(response).results;
      userList.addAll(results);
      currentPage++;
      emit(HomeRandomUserListState(userList));
    }else{
      emit(HomeErrorState("Couldn't fetch posts"));
    }
  }
}
