import 'package:flutter/material.dart';
import 'package:flutter_palindrome_name/view_models/user_viewmodel.dart';
import 'package:provider/provider.dart';
import '../widgets/user_tile.dart';

class ThirdScreen extends StatefulWidget {
  const ThirdScreen({super.key});

  @override
  State<ThirdScreen> createState() => _ThirdScreenState();
}

class _ThirdScreenState extends State<ThirdScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    final vm = Provider.of<UserViewModel>(context, listen: false);
    vm.fetchUsers();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        vm.fetchUsers();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Third Screen",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Image.asset(
            "assets/images/ic_back.png",
            width: 48,
            height: 48,
            color: Colors.purple,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: Colors.grey.shade300, height: 1),
        ),
      ),
      body: Consumer<UserViewModel>(
        builder: (context, vm, _) {
          if (vm.isLoading && vm.users.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (vm.isEmpty && vm.users.isEmpty) {
            return const Center(child: Text("No users available."));
          }

          return RefreshIndicator(
            onRefresh: () async {
              await vm.fetchUsers(refresh: true);
            },
            child: ListView.separated(
              controller: _scrollController,
              shrinkWrap: true,
              itemCount: vm.users.length + (vm.hasMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index < vm.users.length) {
                  final user = vm.users[index];
                  return Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: UserTile(
                        user: user,
                        onTap: () {
                          vm.selectUser(user.fullName);
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  );
                } else {
                  return const Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
              },
              separatorBuilder: (context, index) {
                if (index < vm.users.length - 1) {
                  return Divider(
                    height: 1,
                    color: Colors.grey.shade300,
                    thickness: 1,
                  );
                } else {
                  return const SizedBox.shrink();
                }
              },
            ),
          );
        },
      ),
    );
  }
}
