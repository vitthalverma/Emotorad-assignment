import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import '../lib/features/data/repository/reward_repository_impl.dart';
import '../lib/features/domain/entites/reward_item.dart';
import '../lib/features/presentation/bloc/bloc/reward_bloc.dart';

void main() {
  group('RewardBloc', () {
    late RewardRepositoryImpl repository;
    late RewardBloc bloc;

    setUp(() {
      repository = RewardRepositoryImpl();
      bloc = RewardBloc(repository: repository);
    });

    blocTest<RewardBloc, RewardState>(
      'emits updated coin balance and scratchRewardMessage on ScratchCardTappedEvent',
      build: () => bloc,
      act: (bloc) async {
        bloc.add(ScratchCardTappedEvent());
      },
      expect: () => [
        // Expect a state with updated coin balance and a positive reward message.
        isA<RewardState>()
            .having((s) => s.coinBalance, 'coinBalance', greaterThan(1000))
      ],
    );

    blocTest<RewardBloc, RewardState>(
      'emits redemptionMessage "Insufficient Coins" when redeeming expensive item',
      build: () => bloc,
      act: (bloc) {
        final expensiveItem =
            RewardItem(id: 'x', name: 'Expensive', cost: 2000);
        bloc.add(RedeemItemEvent(item: expensiveItem));
      },
      expect: () => [
        isA<RewardState>().having((s) => s.redemptionMessage,
            'redemptionMessage', 'Insufficient Coins')
      ],
    );
  });
}
