import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/user/authentication_bloc.dart';

class LogoutButton extends StatelessWidget {

  const LogoutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: (){
        context.read<AuthenticationBloc>().logout();
      }, child: const Text("logout"),
    );
  }
}