import '../entites/reward_item.dart';
import '../entites/reward_transaction.dart';

abstract class RewardRepository {
  /// Returns the current coin balance.
  int getCoinBalance();

  /// Returns the DateTime when the last scratch occurred (if any).
  DateTime? getLastScratchTime();

  /// Attempts a scratch card action.
  /// Returns the coin reward if successful.
  Future<int> scratchCardReward();

  /// Redeems the given item.
  /// Returns true if redemption is successful.
  Future<bool> redeemItem(RewardItem item);

  /// Returns the list of reward transactions.
  List<RewardTransaction> getTransactionHistory();
}
