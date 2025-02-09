import 'package:flutter_test/flutter_test.dart';
import '../lib/features/data/repository/reward_repository_impl.dart';
import '../lib/features/domain/entites/reward_item.dart';

void main() {
  group('RewardRepository', () {
    late RewardRepositoryImpl repository;

    setUp(() {
      repository = RewardRepositoryImpl();
    });

    test('Initial coin balance is 1000', () {
      expect(repository.getCoinBalance(), 1000);
    });

    test('Scratch card reward adds coins and updates lastScratchTime',
        () async {
      final reward = await repository.scratchCardReward();
      expect(reward, inInclusiveRange(50, 500));
      expect(repository.getCoinBalance(), 1000 + reward);
      expect(repository.getLastScratchTime(), isNotNull);
    });

    test('Redeem item succeeds when sufficient coins exist', () async {
      final item = RewardItem(id: '1', name: 'Test Item', cost: 500);
      final success = await repository.redeemItem(item);
      expect(success, true);
      expect(repository.getCoinBalance(), 1000 - 500);
    });

    test('Redeem item fails when insufficient coins exist', () async {
      final item = RewardItem(id: '2', name: 'Expensive Item', cost: 2000);
      final success = await repository.redeemItem(item);
      expect(success, false);
      expect(repository.getCoinBalance(), 1000);
    });

    test('Scratch card cannot be used more than once per hour', () async {
      await repository.scratchCardReward();
      expect(() async => await repository.scratchCardReward(), throwsException);
    });
  });
}
