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
  @override
  Widget build(BuildContext context) {
    final isFavorite = FavoriteService.isFavorite(widget.provider);

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: widget.onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
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
                  ? const Icon(Icons.person, size: 30)
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

                  const SizedBox(height: 4),

                  Text(
                    widget.provider.services.join(", "),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

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

                  const SizedBox(height: 4),

                  Text(
                    widget.provider.status,
                    style: TextStyle(
                      color: widget.provider.status == "Available"
                          ? Colors.green
                          : Colors.red,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            Column(
              children: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      if (FavoriteService.isFavorite(widget.provider)) {
                        FavoriteService.removeFavorite(widget.provider);
                      } else {
                        FavoriteService.addFavorite(widget.provider);
                      }
                    });
                  },
                  icon: Icon(
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
