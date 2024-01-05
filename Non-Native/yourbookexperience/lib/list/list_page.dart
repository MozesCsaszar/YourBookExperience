import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yourbookexperience/common/components/action_button.dart';
import 'package:yourbookexperience/details/details_page.dart';
import 'package:yourbookexperience/domain/review.dart';
import 'package:yourbookexperience/domain/review_bloc.dart';
import 'package:yourbookexperience/list/list_item.dart';
import 'package:yourbookexperience/repo/repo.dart';
import 'package:yourbookexperience/common/theme/colors.dart';

class ListPage extends StatefulWidget {
  const ListPage({super.key});
  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  @override
  Widget build(BuildContext context) {
    final myRepository = context.read<Repo>();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Welcome, User",
          style: Theme.of(context).textTheme.headlineMedium,
          textAlign: TextAlign.center,
        ),
        backgroundColor: AppColors.foreground2,
        shape: const RoundedRectangleBorder(
          side: BorderSide(width: 2, color: AppColors.foreground1),
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(12),
              bottomRight: Radius.circular(12)),
        ),
      ),
      body: BlocConsumer<ReviewBloc, ReviewState>(
          listener: (context, state) => {
                if (state is LoadedState)
                  {_updateList()}
                else if (state is ModifyingErrorState)
                  {_displayMessage(state.message)}
              },
          builder: (context, state) {
            switch (state.runtimeType) {
              case LoadedState || ModifyingErrorState:
                return Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(children: [
                      Expanded(
                          child: ListView.separated(
                        itemCount: myRepository.reviews.length,
                        itemBuilder: (context, index) => ListItem(
                            review: myRepository.reviews[index],
                            onListUpdate: _updateList),
                        separatorBuilder: (BuildContext context, int index) {
                          return const Padding(padding: EdgeInsets.all(4));
                        },
                      )),
                      ActionButton(onTap: _onAdd, text: "Share Your Story")
                    ]));
              case LoadingState:
                return const Center(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                      Text("Loading reviews..."),
                      Padding(
                        padding: EdgeInsetsDirectional.symmetric(vertical: 8),
                      ),
                      SizedBox(
                        width: 150,
                        height: 150,
                        child: CircularProgressIndicator(
                          value: null,
                        ),
                      )
                    ]));
              case LoadingErrorState || InitialState:
                return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                          "An error happened whilst loading the database."),
                      ActionButton(
                          onTap: () => BlocProvider.of<ReviewBloc>(context)
                              .add(LoadingEvent()),
                          text: "Retry")
                    ]);
              default:
                return Text("Unexpected error at state ${state.toString()}");
            }
          }),
      backgroundColor: AppColors.background,
    );
  }

  void _onAdd() {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => DetailsPage(
              review: Review(
                  id: -1,
                  userId: 0,
                  bTitle: "",
                  bAuthor: "",
                  description: "",
                  experiences: "",
                  pros: [],
                  cons: [],
                  rating: 0),
              formType: FormType.add,
              onListUpdate: _updateList,
            )));
  }

  void _updateList() {
    setState(() {});
  }

  void _displayMessage(String message) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            // backgroundColor: AppColors.background,
            title: Text(
              'Error',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            content:
                Text(message, style: Theme.of(context).textTheme.titleMedium),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("OK",
                      style: Theme.of(context).textTheme.titleMedium))
            ],
          );
        });
  }
}
