import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/bloc/reward_bloc.dart';

class RedemptionStoreScreen extends StatelessWidget {
  const RedemptionStoreScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Access the RewardBloc instance.

    return Scaffold(
      appBar: AppBar(title: const Text('Redemption Store')),
      // Wrap the body with a BlocListener to listen for redemption messages.
      body: BlocListener<RewardBloc, RewardState>(
        listener: (context, state) {
          if (state.redemptionMessage != null) {
            // Hide any current SnackBars before showing a new one.
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(state.redemptionMessage!),
                  backgroundColor:
                      state.redemptionMessage == 'Insufficient Coins'
                          ? Colors.red
                          : Colors.green,
                  duration: const Duration(seconds: 2),
                ),
              );
          }
        },
        child: BlocBuilder<RewardBloc, RewardState>(
          builder: (context, state) {
            return ListView.builder(
              itemCount: state.redeemableItems.length,
              itemBuilder: (context, index) {
                final item = state.redeemableItems[index];
                return ListTile(
                  title: Text(item.name),
                  subtitle: Text('${item.cost} coins'),
                  trailing: ElevatedButton(
                    child: const Text('Redeem'),
                    onPressed: () {
                      // Dispatch the redemption event when the button is pressed.
                      context
                          .read<RewardBloc>()
                          .add(RedeemItemEvent(item: item));
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
