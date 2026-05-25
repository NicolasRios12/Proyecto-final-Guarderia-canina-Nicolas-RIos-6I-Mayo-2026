# WIDGETS.md — Widgets Reutilizables

Todos los widgets deben estar en `lib/presentation/widgets/`.
Cada widget es un `StatelessWidget` o `StatefulWidget` según corresponda.
Usar siempre la paleta de colores definida en `AppColors`.

---

## 1. PrimaryButton — `primary_button.dart`

```dart
class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;   // null = deshabilitado
  final bool isLoading;
  final double? width;             // null = full width

  const PrimaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: onPressed != null
            ? const Color(0xFF1E40AF)
            : const Color(0xFF94A3B8),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          elevation: 0,
        ),
        child: isLoading
          ? const SizedBox(
              width: 20, height: 20,
              child: CircularProgressIndicator(
                color: Colors.white, strokeWidth: 2),
            )
          : Text(label,
              style: const TextStyle(
                fontSize: 16, fontWeight: FontWeight.w600)),
      ),
    );
  }
}
```

---

## 2. AppOutlinedButton — `outlined_button.dart`

```dart
class AppOutlinedButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;

  const AppOutlinedButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: const Color(0xFF1E40AF),
          side: const BorderSide(color: Color(0xFF1E40AF), width: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
        child: icon != null
          ? Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(icon, size: 18),
              const SizedBox(width: 8),
              Text(label, style: const TextStyle(
                fontSize: 16, fontWeight: FontWeight.w600)),
            ])
          : Text(label, style: const TextStyle(
              fontSize: 16, fontWeight: FontWeight.w600)),
      ),
    );
  }
}
```

---

## 3. ServiceCard — `service_card.dart`

Muestra un cuidador en la lista de servicios.

```dart
class ServiceCard extends StatelessWidget {
  final UserModel caregiver;
  final double rating;
  final int reviewCount;
  final double precio;
  final String unidadPrecio;    // "día", "noche", "hora"
  final List<String> ofrece;   // máx 3 items
  final VoidCallback onReservar;

  @override
  Widget build(BuildContext context) => Card(
    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    elevation: 2,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Fila superior: avatar + info + precio
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar circular 56px
              CircleAvatar(
                radius: 28,
                backgroundImage: caregiver.fotoUrl.isNotEmpty
                  ? NetworkImage(caregiver.fotoUrl) : null,
                backgroundColor: const Color(0xFFEFF6FF),
                child: caregiver.fotoUrl.isEmpty
                  ? Text(caregiver.nombre[0].toUpperCase(),
                      style: const TextStyle(
                        color: Color(0xFF1E40AF), fontWeight: FontWeight.bold))
                  : null,
              ),
              const SizedBox(width: 12),
              // Nombre + ubicación + ofrece
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(caregiver.nombreCompleto,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16)),
                    Text("Juárez, Chih",
                      style: const TextStyle(
                        color: Color(0xFF475569), fontSize: 13)),
                    const SizedBox(height: 4),
                    ...ofrece.take(3).map((item) => Text(
                      "- $item",
                      style: const TextStyle(
                        color: Color(0xFF475569), fontSize: 12),
                    )),
                  ],
                ),
              ),
              // Precio alineado derecha
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text("\$${precio.toStringAsFixed(0)}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Color(0xFF1E40AF))),
                  Text("/$unidadPrecio",
                    style: const TextStyle(
                      fontSize: 12, color: Color(0xFF475569))),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Fila inferior: rating + botón
          Row(
            children: [
              RatingStars(rating: rating, reviewCount: reviewCount),
              const Spacer(),
              ElevatedButton(
                onPressed: onReservar,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E40AF),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20, vertical: 8),
                ),
                child: const Text("Reservar"),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
```

---

## 4. BookingCard — `booking_card.dart`

Usada en RequestsScreen (cuidador) y en historial de reservas.

```dart
class BookingCard extends StatelessWidget {
  final BookingModel booking;
  final VoidCallback? onAceptar;   // null = no muestra botones de acción
  final VoidCallback? onRechazar;

  @override
  Widget build(BuildContext context) => Card(
    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: mascota + servicio
          Row(children: [
            const Icon(Icons.pets, color: Color(0xFF1E40AF)),
            const SizedBox(width: 8),
            Expanded(child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(booking.mascotaNombre ?? 'Mascota',
                  style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(booking.servicioNombre ?? 'Servicio',
                  style: const TextStyle(
                    color: Color(0xFF475569), fontSize: 13)),
              ],
            )),
            StatusBadge(status: booking.estado),
          ]),
          const Divider(height: 20),
          // Fecha y precio
          Row(children: [
            const Icon(Icons.calendar_today, size: 16, color: Color(0xFF475569)),
            const SizedBox(width: 4),
            Text(DateHelper.formatDateTime(booking.fechaInicio),
              style: const TextStyle(color: Color(0xFF475569), fontSize: 13)),
            const Spacer(),
            Text("\$${booking.precioFinal.toStringAsFixed(0)}",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E40AF), fontSize: 16)),
          ]),
          // Botones de acción (solo para cuidador en solicitudes pendientes)
          if (onAceptar != null || onRechazar != null) ...[
            const SizedBox(height: 12),
            Row(children: [
              if (onRechazar != null)
                Expanded(child: OutlinedButton.icon(
                  onPressed: onRechazar,
                  icon: const Icon(Icons.close, size: 16),
                  label: const Text("Rechazar"),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFFEF4444),
                    side: const BorderSide(color: Color(0xFFEF4444)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  ),
                )),
              if (onAceptar != null && onRechazar != null)
                const SizedBox(width: 12),
              if (onAceptar != null)
                Expanded(child: ElevatedButton.icon(
                  onPressed: onAceptar,
                  icon: const Icon(Icons.check, size: 16),
                  label: const Text("Aceptar"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF10B981),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  ),
                )),
            ]),
          ],
        ],
      ),
    ),
  );
}
```

---

## 5. StatusBadge — `status_badge.dart`

```dart
class StatusBadge extends StatelessWidget {
  final BookingStatus status;

  const StatusBadge({super.key, required this.status});

  Color get _bgColor {
    switch (status) {
      case BookingStatus.pendiente:  return const Color(0xFFFEF3C7);
      case BookingStatus.confirmada: return const Color(0xFFDBEAFE);
      case BookingStatus.enCurso:    return const Color(0xFFDDEEFF);
      case BookingStatus.completada: return const Color(0xFFD1FAE5);
      case BookingStatus.cancelada:  return const Color(0xFFFEE2E2);
    }
  }

  Color get _textColor {
    switch (status) {
      case BookingStatus.pendiente:  return const Color(0xFFB45309);
      case BookingStatus.confirmada: return const Color(0xFF1D4ED8);
      case BookingStatus.enCurso:    return const Color(0xFF1E40AF);
      case BookingStatus.completada: return const Color(0xFF065F46);
      case BookingStatus.cancelada:  return const Color(0xFFB91C1C);
    }
  }

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    decoration: BoxDecoration(
      color: _bgColor,
      borderRadius: BorderRadius.circular(50),
    ),
    child: Text(
      status.label,
      style: TextStyle(
        color: _textColor,
        fontSize: 12,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}
```

---

## 6. RatingStars — `rating_stars.dart`

```dart
class RatingStars extends StatelessWidget {
  final double rating;
  final int? reviewCount;
  final double size;

  const RatingStars({
    super.key,
    required this.rating,
    this.reviewCount,
    this.size = 16,
  });

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      RatingBarIndicator(
        rating: rating,
        itemBuilder: (_, __) => const Icon(
          Icons.star, color: Color(0xFFF59E0B)),
        itemCount: 5,
        itemSize: size,
      ),
      const SizedBox(width: 4),
      Text(
        rating.toStringAsFixed(1),
        style: TextStyle(
          fontSize: size * 0.875,
          fontWeight: FontWeight.bold,
          color: const Color(0xFF0F172A)),
      ),
      if (reviewCount != null)
        Text(
          " ($reviewCount)",
          style: TextStyle(
            fontSize: size * 0.875,
            color: const Color(0xFF475569)),
        ),
    ],
  );
}
```

---

## 7. EmptyState — `empty_state.dart`

```dart
class EmptyState extends StatelessWidget {
  final String message;
  final String? subtitle;
  final IconData icon;
  final String? ctaLabel;
  final VoidCallback? onCta;

  const EmptyState({
    super.key,
    required this.message,
    this.subtitle,
    this.icon = Icons.inbox_outlined,
    this.ctaLabel,
    this.onCta,
  });

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 72, color: const Color(0xFFCBD5E1)),
          const SizedBox(height: 16),
          Text(message,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF475569)),
            textAlign: TextAlign.center),
          if (subtitle != null) ...[
            const SizedBox(height: 8),
            Text(subtitle!,
              style: const TextStyle(
                color: Color(0xFF94A3B8), fontSize: 14),
              textAlign: TextAlign.center),
          ],
          if (ctaLabel != null && onCta != null) ...[
            const SizedBox(height: 24),
            PrimaryButton(label: ctaLabel!, onPressed: onCta, width: 200),
          ],
        ],
      ),
    ),
  );
}
```

---

## 8. LoadingShimmer — `loading_shimmer.dart`

```dart
class LoadingShimmer extends StatelessWidget {
  final int itemCount;

  const LoadingShimmer({super.key, this.itemCount = 5});

  @override
  Widget build(BuildContext context) => ListView.builder(
    physics: const NeverScrollableScrollPhysics(),
    shrinkWrap: true,
    itemCount: itemCount,
    itemBuilder: (_, __) => Shimmer.fromColors(
      baseColor: const Color(0xFFE2E8F0),
      highlightColor: const Color(0xFFF8FAFC),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Container(
          height: 100,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    ),
  );
}
```

---

## 9. CustomDrawer — `custom_drawer.dart`

```dart
class CustomDrawer extends StatelessWidget {
  final String activeRoute;

  const CustomDrawer({super.key, required this.activeRoute});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16),
              color: const Color(0xFF1E40AF),
              child: Row(
                children: [
                  const Icon(Icons.pets, color: Colors.white, size: 32),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text("Dog Club",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold)),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            // Items
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  _DrawerItem(
                    icon: Icons.home_outlined,
                    label: "Inicio",
                    isActive: activeRoute == '/home',
                    onTap: () { Navigator.pop(context); context.go('/home'); },
                  ),
                  _DrawerItem(
                    icon: Icons.chat_bubble_outline,
                    label: "Chats",
                    isActive: activeRoute == '/home/chats',
                    onTap: () { Navigator.pop(context); context.push('/home/chats'); },
                  ),
                  // Servicios expandibles
                  ExpansionTile(
                    leading: const Icon(Icons.pets_outlined),
                    title: const Text("Servicios"),
                    children: [
                      _DrawerItem(icon: Icons.hotel, label: "Hospedaje",
                        isActive: false,
                        onTap: () { Navigator.pop(context);
                          context.push('/home/services/hospedaje'); }),
                      _DrawerItem(icon: Icons.groups, label: "Guardería",
                        isActive: false,
                        onTap: () { Navigator.pop(context);
                          context.push('/home/services/guarderia'); }),
                      _DrawerItem(icon: Icons.directions_walk, label: "Paseos",
                        isActive: false,
                        onTap: () { Navigator.pop(context);
                          context.push('/home/services/paseo'); }),
                    ],
                  ),
                  _DrawerItem(
                    icon: Icons.person_outline,
                    label: "Perfil",
                    isActive: activeRoute == '/home/profile',
                    onTap: () { Navigator.pop(context); context.push('/home/profile'); },
                  ),
                ],
              ),
            ),
            // Cerrar sesión al fondo
            const Divider(),
            _DrawerItem(
              icon: Icons.logout,
              label: "Cerrar Sesión",
              isActive: false,
              textColor: const Color(0xFFEF4444),
              iconColor: const Color(0xFFEF4444),
              onTap: () async {
                Navigator.pop(context);
                await auth.logout();
                if (context.mounted) context.go('/login');
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;
  final Color? textColor;
  final Color? iconColor;

  const _DrawerItem({
    required this.icon, required this.label,
    required this.isActive, required this.onTap,
    this.textColor, this.iconColor,
  });

  @override
  Widget build(BuildContext context) => ListTile(
    leading: Icon(icon,
      color: iconColor ?? (isActive
        ? const Color(0xFF1E40AF) : const Color(0xFF475569))),
    title: Text(label,
      style: TextStyle(
        color: textColor ?? (isActive
          ? const Color(0xFF1E40AF) : const Color(0xFF0F172A)),
        fontWeight: isActive ? FontWeight.bold : FontWeight.normal)),
    tileColor: isActive ? const Color(0xFFEFF6FF) : null,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    onTap: onTap,
  );
}
```

---

## 10. CustomAppBar — `custom_appbar.dart`

```dart
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final bool showLogo;
  final List<Widget>? actions;
  final VoidCallback? onMenuTap;

  const CustomAppBar({
    super.key,
    this.title,
    this.showLogo = false,
    this.actions,
    this.onMenuTap,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) => AppBar(
    backgroundColor: const Color(0xFF1E40AF),
    foregroundColor: Colors.white,
    leading: onMenuTap != null
      ? IconButton(
          icon: const Icon(Icons.menu),
          onPressed: onMenuTap ?? () => Scaffold.of(context).openDrawer(),
        )
      : null,
    title: showLogo
      ? const Row(children: [
          Icon(Icons.pets, color: Colors.white),
          SizedBox(width: 8),
          Text("Dog Club",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold)),
        ])
      : title != null
        ? Text(title!, style: const TextStyle(color: Colors.white))
        : null,
    actions: actions,
    elevation: 0,
  );
}
```
