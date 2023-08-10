import 'package:flutter/material.dart';

class EventItem extends StatelessWidget {
  final dynamic item;
  final VoidCallback onDecrease;
  final VoidCallback onIncrease;

  const EventItem({
    Key? key,
    required this.item,
    required this.onDecrease,
    required this.onIncrease,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isSoldOut = item['soldOut'] == 1;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: isSoldOut ? Colors.grey[100] : Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['name'],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${item['currencySymbol']} ${item['price']}',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                if (item['description'] != null)
                  Text(
                    item['description'],
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
              ],
            ),
          ),
          // const SizedBox(width: 16),
          if (!isSoldOut)
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: onDecrease,
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(8),
                    backgroundColor: Colors.white60,
                    elevation: 1.0,
                  ),
                  child: const Icon(Icons.remove, color: Colors.black87),
                ),
                const SizedBox(width: 1),
                Text(item['quantity'].toString(),
                    style: const TextStyle(fontSize: 16)),
                const SizedBox(width: 1),
                ElevatedButton(
                  onPressed: onIncrease,
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(8),
                    backgroundColor: Colors.white60,
                    elevation: 1.0,
                  ),
                  child: const Icon(Icons.add, color: Colors.black87),
                ),
              ],
            ),
          if (isSoldOut)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Text(
                'Agotadas',
                style: TextStyle(color: Colors.black87),
              ),
            ),
        ],
      ),
    );
  }
}
