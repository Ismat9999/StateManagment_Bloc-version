import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smbloc/core/models/log_service.dart';
import 'package:smbloc/presantion/bloc/home_bloc.dart';
import 'package:smbloc/presantion/bloc/home_event.dart';
import 'package:smbloc/presantion/bloc/home_state.dart';
import '../../data/models/random_user_list_res.dart';
import '../views/view_error.dart';
import '../views/view_of_loading.dart';
import '../widgets/item_of_random_user.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late HomeBloc homeBloc;
  ScrollController scrollController= ScrollController();


  @override
  void initState() {
    super.initState();
homeBloc= BlocProvider.of<HomeBloc>(context);
homeBloc.add(LoadRandomUserListEvent());

    scrollController.addListener((){
      if (scrollController.position.maxScrollExtent <= scrollController.offset){
        LogService.i(homeBloc.currentPage.toString());
        homeBloc.add(LoadRandomUserListEvent());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(232,232, 232, 1),
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title:  const Text("Bloc Provider"),
      ),
      body: BlocBuilder<HomeBloc, HomeState>(
        buildWhen: (previous, current){
          return current is HomeRandomUserListState;
        },
        builder: (context, state){
          if(state is HomeErrorState){
            return viewError(state.errorMessage);
          }
          if(state is HomeRandomUserListState){
            var userList= state.userList;
            return viewOfRandomUserList(userList);
          }
          return viewOfLoading();
        },
      ),
    );
  }
  Widget viewOfRandomUserList(List<RandomUser> userList){
    return ListView.builder(
      controller: scrollController,
      itemCount: userList.length,
      itemBuilder: (ctx, index){
        return itemOfRandomUser(userList[index], index);
      },
    );
  }
}
