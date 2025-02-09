import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'features/data/repository/reward_repository_impl.dart';
import 'features/presentation/bloc/bloc/reward_bloc.dart';
import 'features/presentation/screens/history_screen.dart';
import 'features/presentation/screens/home_screen.dart';
import 'features/presentation/screens/redemption_store_screen.dart';

void main() {
  // Initialize the mock repository (data layer)
  final rewardRepository = RewardRepositoryImpl();

  runApp(MyApp(repository: rewardRepository));
}

class MyApp extends StatelessWidget {
  final RewardRepositoryImpl repository;

  const MyApp({super.key, required this.repository});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => RewardBloc(repository: repository)..add(AppStartedEvent()),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Reward Coins App',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: const HomeScreen(),
        routes: {
          '/store': (_) => const RedemptionStoreScreen(),
          '/history': (_) => const HistoryScreen(),
        },
      ),
    );
  }
}
