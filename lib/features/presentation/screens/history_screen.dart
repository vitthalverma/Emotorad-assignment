import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entites/reward_transaction.dart';
import '../bloc/bloc/reward_bloc.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  TransactionType? _selectedType;
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void initState() {
    super.initState();
    // Dispatch a filter event with no filters so that filteredTransactions == all transactions.
    BlocProvider.of<RewardBloc>(context).add(FilterTransactionsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Transaction History')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                // Dropdown for filtering by transaction type.
                DropdownButton<TransactionType?>(
                  value: _selectedType,
                  hint: const Text('Select Type'),
                  items: const [
                    DropdownMenuItem(
                      value: null,
                      child: Text('All'),
                    ),
                    DropdownMenuItem(
                      value: TransactionType.scratchReward,
                      child: Text('Scratch Reward'),
                    ),
                    DropdownMenuItem(
                      value: TransactionType.redemption,
                      child: Text('Redemption'),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedType = value;
                    });
                    _applyFilter();
                  },
                ),
                // You can add date pickers for _startDate and _endDate here.
              ],
            ),
          ),
          Expanded(
            child: BlocBuilder<RewardBloc, RewardState>(
              builder: (context, state) {
                final transactions = state.filteredTransactions;
                if (transactions.isEmpty) {
                  return const Center(child: Text('No transactions found.'));
                }
                return ListView.builder(
                  itemCount: transactions.length,
                  itemBuilder: (context, index) {
                    final tx = transactions[index];
                    return ListTile(
                      title: Text(tx.description),
                      subtitle:
                          Text(tx.date.toLocal().toString().split('.')[0]),
                      trailing: Text(
                        tx.amount > 0 ? '+${tx.amount}' : '${tx.amount}',
                        style: TextStyle(
                          color: tx.amount > 0 ? Colors.green : Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _applyFilter() {
    // Dispatch the filter event with the current filter parameters.
    BlocProvider.of<RewardBloc>(context).add(
      FilterTransactionsEvent(
        startDate: _startDate,
        endDate: _endDate,
        type: _selectedType,
      ),
    );
  }
}
