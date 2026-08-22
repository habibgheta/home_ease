import 'package:flutter/material.dart';
import 'package:home_ease/models/service_provider.dart';
import 'package:home_ease/services/favorite_service.dart';

class ProviderCard extends StatefulWidget {
  const ProviderCard({super.key, required this.provider, this.onTap});

  final ServiceProvider provider;
  final VoidCallback? onTap;

  @override
  State<ProviderCard> createState() => _ProviderCardState();
}

class _ProviderCardState extends State<ProviderCard> {
  bool isFavorite = false;
  bool isLoadingFavorite = true;

  @override
  void initState() {
    super.initState();
    loadFavoriteStatus();
  }

  Future<void> loadFavoriteStatus() async {
    try {
      final result = await FavoriteService.isFavorite(widget.provider);

      if (!mounted) return;

      setState(() {
        isFavorite = result;
        isLoadingFavorite = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoadingFavorite = false;
      });

      debugPrint("Favorite status error: $e");
    }
  }

  Future<void> toggleFavorite() async {
    if (isLoadingFavorite) return;

    setState(() {
      isLoadingFavorite = true;
    });

    try {
      if (isFavorite) {
        await FavoriteService.removeFavorite(widget.provider);
      } else {
        await FavoriteService.addFavorite(widget.provider);
      }

      if (!mounted) return;

      setState(() {
        isFavorite = !isFavorite;
        isLoadingFavorite = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoadingFavorite = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Unable to update favorites. Please try again."),
        ),
      );

      debugPrint("Favorite update error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: widget.onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: Offset(5, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundImage: widget.provider.imageUrl.isNotEmpty
                  ? NetworkImage(widget.provider.imageUrl)
                  : null,
              child: widget.provider.imageUrl.isEmpty
                  ? const Icon(Icons.person)
                  : null,
            ),

            const SizedBox(width: 14),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.provider.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 2),

                  Text(
                    "Employee ID: ${widget.provider.employeeCode}",
                    style: const TextStyle(fontSize: 13),
                  ),

                  const SizedBox(height: 4),

                  Text(widget.provider.services.join(", ")),

                  const SizedBox(height: 4),

                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 18),
                      const SizedBox(width: 4),
                      Text(
                        "${widget.provider.rating} "
                        "(${widget.provider.reviews} Reviews)",
                      ),
                    ],
                  ),
                ],
              ),
            ),

            Column(
              children: [
                IconButton(
                  onPressed: toggleFavorite,
                  icon: isLoadingFavorite
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: Colors.red,
                        ),
                ),

                Text(
                  "₹${widget.provider.chargesPerHour}/hr",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.indigo,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
