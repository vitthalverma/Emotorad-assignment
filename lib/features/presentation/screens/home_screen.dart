import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants.dart';
import '../bloc/bloc/reward_bloc.dart';
import '../widgets/scratch_card_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 110), (_) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  // Helper method to determine if scratch is available.
  bool _isScratchAvailable(RewardState state) {
    if (state.lastScratchTime == null) return true;
    return DateTime.now().difference(state.lastScratchTime!) >= scratchInterval;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text(
          'Reward Coins',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.store,
              color: Colors.white,
            ),
            onPressed: () => Navigator.pushNamed(context, '/store'),
          ),
          IconButton(
            icon: const Icon(
              Icons.history,
              color: Colors.white,
            ),
            onPressed: () => Navigator.pushNamed(context, '/history'),
          ),
        ],
      ),
      body: BlocConsumer<RewardBloc, RewardState>(
        listener: (context, state) {
          // If a scratch reward message is available, show a Snackbar.
          if (state.scratchRewardMessage != null &&
              state.scratchRewardMessage!.isNotEmpty) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(state.scratchRewardMessage!),
                  backgroundColor: Colors.green,
                  duration: const Duration(seconds: 2),
                ),
              );
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(0),
            child: Column(
              children: [
                // Header area with coin balance.
                Stack(
                  children: [
                    Container(
                      height: 200,
                      color: Colors.white,
                    ),
                    Container(
                      height: 180,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(60),
                          bottomRight: Radius.circular(60),
                        ),
                        color: Colors.deepPurple,
                      ),
                      child: Column(
                        children: [
                          const SizedBox(height: 20),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Available Balance:',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 19,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),
                          Text(
                            '💵${state.coinBalance}',
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 39,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Scratch card display.
                Expanded(
                  child: Center(
                    child: _isScratchAvailable(state)
                        ? ScratchCardWidget(
                            // When scratching is complete, dispatch the scratch event.
                            onScratchComplete: () {
                              BlocProvider.of<RewardBloc>(context)
                                  .add(ScratchCardTappedEvent());
                            },
                          )
                        : Container(
                            width: 300,
                            height: 200,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              'Next scratch available at:\n${state.lastScratchTime?.add(scratchInterval).toLocal().toString().split(".")[0]}',
                              textAlign: TextAlign.center,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }
}
