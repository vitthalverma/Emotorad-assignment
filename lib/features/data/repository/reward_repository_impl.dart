import 'dart:math';
import '../../../core/constants.dart';
import '../../domain/entites/reward_item.dart';
import '../../domain/entites/reward_transaction.dart';
import '../../domain/repository/reward_repository.dart';

class RewardRepositoryImpl implements RewardRepository {
  // Starting coin balance is 1000.
  int _coinBalance = 1000;

  // Holds the last scratch time to enforce the one-hour interval.
  DateTime? _lastScratchTime;

  // In-memory transaction history.
  final List<RewardTransaction> _transactions = [];

  final Random _random = Random();

  @override
  int getCoinBalance() => _coinBalance;

  @override
  DateTime? getLastScratchTime() => _lastScratchTime;

  @override
  Future<int> scratchCardReward() async {
    final now = DateTime.now();

    // Check if the user scratched within the last hour.
    if (_lastScratchTime != null &&
        now.difference(_lastScratchTime!) < scratchInterval) {
      // Not allowed – throw an error.
      throw Exception(
          'Scratch card is available only every ${scratchInterval.inSeconds} seconds.');
    }

    // Generate a random reward between 50 and 500.
    final reward = 50 + _random.nextInt(451); // 451 gives range 0 to 450.
    _coinBalance += reward;
    _lastScratchTime = now;

    // Add a transaction record.
    _transactions.add(RewardTransaction(
      date: now,
      type: TransactionType.scratchReward,
      amount: reward,
      description: 'Scratch Card Reward',
    ));

    return reward;
  }

  @override
  Future<bool> redeemItem(RewardItem item) async {
    // Check if the user has sufficient coins.
    if (_coinBalance < item.cost) {
      return false;
    }
    _coinBalance -= item.cost;
    final now = DateTime.now();

    // Record the redemption.
    _transactions.add(RewardTransaction(
      date: now,
      type: TransactionType.redemption,
      amount: -item.cost,
      description: 'Redeemed ${item.name}',
    ));

    return true;
  }

  @override
  List<RewardTransaction> getTransactionHistory() =>
      List.unmodifiable(_transactions.reversed.toList());
}
