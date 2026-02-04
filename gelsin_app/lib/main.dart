
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';

// --- BASİT VERİ YÖNETİMİ (STATE MANAGEMENT) ---
class CartItemModel {
  final String id;
  final String name;
  final double price;
  final String imageUrl;
  final String options;
  int quantity;

  CartItemModel({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.options,
    this.quantity = 1,
  });
}

class CartService {
  static final List<CartItemModel> _items = [];

  static List<CartItemModel> get items => _items;

  static void addItem(CartItemModel item) {
    final index = _items.indexWhere((element) => element.name == item.name && element.options == item.options);
    if (index != -1) {
      _items[index].quantity += item.quantity;
    } else {
      _items.add(item);
    }
  }

  static void removeItem(CartItemModel item) {
    _items.remove(item);
  }

  static void clearCart() {
    _items.clear();
  }

  static double get subTotal => _items.fold(0, (sum, item) => sum + (item.price * item.quantity));
  static double get deliveryFee => subTotal > 0 ? 29.90 : 0;
  static double get total => subTotal + deliveryFee;
}

// --- UYGULAMA BAŞLANGICI ---
void main() {
  runApp(const GelsinApp());
}

class GelsinApp extends StatelessWidget {
  const GelsinApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gelsin',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        primaryColor: const Color(0xFF0F766E),
        scaffoldBackgroundColor: const Color(0xFFF0FDFA), // Ice Water
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0F766E),
          primary: const Color(0xFF0F766E), // Teal Ocean
          secondary: const Color(0xFFF97316), // Hot Orange
          surface: const Color(0xFFF0FDFA),
          onSurface: const Color(0xFF134E4A),
        ),
        textTheme: GoogleFonts.plusJakartaSansTextTheme(
          Theme.of(context).textTheme.apply(
            bodyColor: const Color(0xFF134E4A), // Deep Sea
            displayColor: const Color(0xFF134E4A),
          ),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          iconTheme: IconThemeData(color: Color(0xFF134E4A)),
        ),
      ),
      builder: (context, child) {
        return Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: child,
          ),
        );
      },
      home: const SplashScreen(),
    );
  }
}

// --- EKRAN 1: AÇILIŞ (SPLASH) ---
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F766E),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(40),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 30,
                    offset: const Offset(0, 10),
                  )
                ],
              ),
              child: const Icon(
                Icons.location_on_rounded,
                size: 80,
                color: Color(0xFF0F766E),
              ),
            )
                .animate()
                .scale(duration: 600.ms, curve: Curves.easeOutBack)
                .then()
                .shimmer(duration: 1200.ms),
            const SizedBox(height: 32),
            Text(
              "Gelsin",
              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w800,
              ),
            ).animate().fadeIn(delay: 400.ms).moveY(begin: 20, end: 0),
          ],
        ),
      ),
    );
  }
}

// --- EKRAN 2: GİRİŞ (LOGIN) ---
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phoneController = TextEditingController();

  void _login() {
    if (_phoneController.text.length < 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Lütfen geçerli bir telefon numarası giriniz.")),
      );
      return;
    }
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomeScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF0F766E).withOpacity(0.15),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: const Icon(Icons.shopping_basket_rounded, color: Color(0xFFF97316), size: 32),
              ),
              const SizedBox(height: 24),
              RichText(
                text: TextSpan(
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF134E4A),
                  ),
                  children: const [
                    TextSpan(text: "Gelsin", style: TextStyle(color: Color(0xFF0F766E))),
                    TextSpan(text: "'e Hoş Geldiniz"),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Text(
                "Telefon numaranızı aşağıya girin. Hesabınızı güvene almak için size 4 haneli bir doğrulama kodu göndereceğiz.",
                style: TextStyle(color: const Color(0xFF134E4A).withOpacity(0.7), fontSize: 16),
              ),
              const SizedBox(height: 32),
              Row(
                children: [
                  Container(
                    width: 80,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.transparent),
                      boxShadow: [
                        BoxShadow(color: const Color(0xFF134E4A).withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
                      ],
                    ),
                    child: const Center(child: Text("+90", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(color: const Color(0xFF134E4A).withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
                        ],
                      ),
                      child: TextField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                          hintText: "(555) 000 00 00",
                          hintStyle: TextStyle(color: Colors.grey, fontSize: 16),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 16),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0F766E),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 4,
                    shadowColor: const Color(0xFF0F766E).withOpacity(0.4),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Doğrulama Kodu Gönder", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                      SizedBox(width: 8),
                      Icon(Icons.arrow_forward_rounded, color: Colors.white),
                    ],
                  ),
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}

// --- EKRAN 3: ANASAYFA (HOME) ---
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedAddress = "Evim, Bandırma";

  void _showAddressSelector() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Adres Seçin", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.home, color: Color(0xFF0F766E)),
                title: const Text("Evim"),
                subtitle: const Text("Bandırma, 10200"),
                onTap: () {
                  setState(() => selectedAddress = "Evim, Bandırma");
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.work, color: Colors.grey),
                title: const Text("Ofis"),
                subtitle: const Text("Levent, İstanbul"),
                onTap: () {
                  setState(() => selectedAddress = "Ofis, Levent");
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0FDFA),
      body: CustomScrollView(
        slivers: [
          // Header
          SliverAppBar(
            backgroundColor: const Color(0xFF0F766E),
            expandedHeight: 180,
            floating: false,
            pinned: true,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Padding(
                padding: const EdgeInsets.fromLTRB(24, 60, 24, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: _showAddressSelector,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("TESLİMAT ADRESİ", style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 10, letterSpacing: 1.2)),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Text(selectedAddress, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                                  const Icon(Icons.keyboard_arrow_down, color: Colors.white),
                                ],
                              )
                            ],
                          ),
                        ),
                        // --- GÜNCELLENEN PROFİL İKONU ---
                        InkWell(
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfileScreen())),
                          child: Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white.withOpacity(0.3), width: 1.5),
                            ),
                            child: const Icon(Icons.person_rounded, color: Colors.white, size: 28),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(80),
              child: Container(
                height: 56,
                margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(color: const Color(0xFF0F766E).withOpacity(0.1), blurRadius: 20, offset: const Offset(0, 10)),
                  ],
                ),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Yemek veya restoran ara",
                    hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
                    prefixIcon: const Icon(Icons.search, color: Color(0xFF0F766E)),
                    suffixIcon: Container(
                      margin: const EdgeInsets.all(8),
                      decoration: BoxDecoration(color: const Color(0xFF0F766E).withOpacity(0.1), shape: BoxShape.circle),
                      child: const Icon(Icons.tune, color: Color(0xFF0F766E), size: 20),
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  ),
                ),
              ),
            ),
          ),

          // Categories
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Kategoriler", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF134E4A))),
                  Text("Tümü", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: const Color(0xFF0F766E).withOpacity(0.8))),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 110,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: const [
                  _CategoryItem(name: "Burger", iconUrl: "https://lh3.googleusercontent.com/aida-public/AB6AXuAARAp_DAFrXN4rqOEGHFVTp7idGkHHM2RVdZdNTxARNgj7srpYNNOGySp1-Q_yZMHGKQ5NSys3CcIHjbZ43Ryt8m6JSPogac1KujRE2Wp-O-5q4Iv_rSK_SOk1a1m_fqQ-f-N4grdC3I3I2qY_kQUEPD6O25h35EquM-ZwX0LovvihWd75dcheD5y-J0mbwk0UmrujKRIIH_ccrP5HFF_X7r819F7lNwcN5QGmn3g34gdudX1JICcjflwTIx7a9MF5ncrohODLAAqs"),
                  _CategoryItem(name: "Asya", iconUrl: "https://lh3.googleusercontent.com/aida-public/AB6AXuA_hNnGt10QnLV4s_63Pj9y-Ad1ILIutXbyVFmqvIWogJZCCecIqog3c9drUD3SAsvM5zSX_5d6ZDYW0TgXBJjFFpTOlifQYUjMKmUVBWMiSGgiPar7AsDfozMcl8sWMIQNXa2fs0L_5a-AOzyxdBxD1GLcDfk9CIAWJX3_HyAOsukZcE2x1TimVznHzJm6q9Vkijdf1p7TjGjMY4a29FYUNXOZOUTaZxWVmQ2-WL4RqV45Oq0_XsiB6Lh3B2sXnlvOkPmFXdBqk9JP"),
                  _CategoryItem(name: "Pizza", iconUrl: "https://lh3.googleusercontent.com/aida-public/AB6AXuCzzCcYOP6NWiHW1S4_qh8Z5ll3cwGkliVJfieWdv2uY4WqDM3Zy9usooFKdrJoWr3IgE4j0GDSlBAapbJ8QrLOlIfQVxXiL6jYM6_j58rYJsMAGGQhzqgvsyR7fava9-u1gEGRAB-19KYrMzVIdzJ2gwSyTguCrcnZf0sm-Go6A-ym5oqwgFgJDPfW34xoqdNnCK_tln4bJSTzeZJOtOdMcdvw92zYCQaJ3Lc9U--9rcVlJ5rmz6EMaKZxCwZGEUJRK6ebWrbVi3Qn"),
                  _CategoryItem(name: "Sağlıklı", iconUrl: "https://lh3.googleusercontent.com/aida-public/AB6AXuBkpr0XxqeHNIX0kfbiibTKrs3-yQE19uC4-l9nnM_YWEvi3vuNlIW1TQ-_kPp4HUByLNzlPKDAU2zlkh-18BVAN-s10yYLnYiZ6-or12pQ6zRZXqmZcvOd951IicT82Z4RIDaTVMDPpr_cNNNbQc1cb6gbVxq9O6ZwKzdcEqr1igKR_59EJxfOBPh1cd9tJ1vEkoQH5936PCKjNFbrIjzR4lP23IGBea9MAQDxzvACHIxhZsFVD4UtF5gNY5-ddeK4sRXIAO2FjBBd"),
                ],
              ),
            ),
          ),

          // Popular Restaurants
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 12),
              child: Text("Popüler Restoranlar", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: const Color(0xFF134E4A))),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              const _RestaurantCard(
                name: "Burger Lab",
                rating: "4.8",
                tags: "Amerikan • Burger • \$\$",
                time: "20-30 dk",
                delivery: "3.99₺ Teslimat",
                imageUrl: "https://lh3.googleusercontent.com/aida-public/AB6AXuCoC1PZ1XCAtrv60CNNQzvAvGLElyoDRl2EiwbY3kJX_mRWHdHneBvs_-X838r2_r3aWT3jbNr7POJhl8AyN47-PamgyTwTQaGFLD8WUs_Z1pF3R9voGhDzYbXKJ-Hx2UAITTj0ATIgueIqjDXfu41XRrGpw4JIruRT2Skr-VIK24RGi5CQRBQZ6Bsxkr0ujW0CORDaaTXMnIExQwXa-Kpds-mNTik8O0RLUpuJrgqZbsCHwoFyoyWOS5T6gtRaS0-QFkpf42Q1Qvgh",
              ),
              const _RestaurantCard(
                name: "Tokyo Sushi House",
                rating: "4.6",
                tags: "Asya • Sushi • \$\$\$",
                time: "35-45 dk",
                delivery: "Ücretsiz Teslimat",
                imageUrl: "https://lh3.googleusercontent.com/aida-public/AB6AXuCuS3xoFoWr-c8hTrkBkHoYWJb2eJHZO45dT40mOZUF6APpoUPjjX4bVTtJb14y2TwLmfnvmdKqvz1ASFJmHaFJrJPUstW2AJT7iPC8QOlcmMOw0U9bJY7xrm1Fs-ipM7yhRKQeKfp2qqyGWVT9nDH4BRRd2LTrQ0bu4Ldsu4Uh_pmBP_5mwfVCDsvAZOOJlZhqMtP6fQZTpuKPTSLGO9MizT5j6QBtXvNCwR9tDUo3-VoIQTlkdC1jc-eLJk-baJaq7NKmyokj7K1w",
                isNew: false,
                discount: "%20 İndirim",
              ),
              const _RestaurantCard(
                name: "Green Bowl",
                rating: "4.9",
                tags: "Sağlıklı • Vegan • \$\$",
                time: "15-25 dk",
                delivery: "1.99₺ Teslimat",
                imageUrl: "https://lh3.googleusercontent.com/aida-public/AB6AXuBog9AC2_wLaI4gUTs0hYxdymwV1nXJuD2ki-0OPT6uj0KY1oU4Z0MkJoaNyW8H14SciwZnZa91BZejv3CEELJbhFoVnTYmYQ-74mBp1GBN2GmAm6VghHkq-DNGK1ZJBbUVcHr_pSAshr84KnVC-rBySngRhF_jLE7TbNSrw0oIpTtKpsCC6kKp4pvZJ0dbPwRlQcFraOskkvNHvcW3cgvpDemyLKo_ykaaX8dFELQ9c9SFgyJvUgbxKfj-oo6jQvHlluMuovKj7QaI",
                isNew: true,
              ),
              const SizedBox(height: 100),
            ]),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: _BottomNavBar(),
    );
  }
}

class _CategoryItem extends StatelessWidget {
  final String name;
  final String iconUrl;
  const _CategoryItem({required this.name, required this.iconUrl});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        children: [
          Container(
            width: 72,
            height: 72,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(color: const Color(0xFF0F766E).withOpacity(0.08), blurRadius: 10, offset: const Offset(0, 4)),
              ],
            ),
            child: Image.network(iconUrl, fit: BoxFit.contain),
          ),
          const SizedBox(height: 8),
          Text(name, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: Color(0xFF134E4A))),
        ],
      ),
    );
  }
}

class _RestaurantCard extends StatelessWidget {
  final String name;
  final String rating;
  final String tags;
  final String time;
  final String delivery;
  final String imageUrl;
  final bool isNew;
  final String? discount;

  const _RestaurantCard({
    required this.name,
    required this.rating,
    required this.tags,
    required this.time,
    required this.delivery,
    required this.imageUrl,
    this.isNew = false,
    this.discount,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => const RestaurantDetailScreen()));
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(color: const Color(0xFF0F766E).withOpacity(0.08), blurRadius: 15, offset: const Offset(0, 5)),
          ],
        ),
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  height: 160,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    image: DecorationImage(image: NetworkImage(imageUrl), fit: BoxFit.cover),
                  ),
                ),
                if (isNew)
                  Positioned(
                    top: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(color: const Color(0xFF0F766E), borderRadius: BorderRadius.circular(8)),
                      child: const Text("YENİ", style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                    ),
                  ),
                if (discount != null)
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(color: const Color(0xFFF97316), borderRadius: BorderRadius.circular(8)),
                      child: Text(discount!, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                    ),
                  ),
                Positioned(
                  bottom: 12,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(color: Colors.white.withOpacity(0.9), borderRadius: BorderRadius.circular(12)),
                    child: Row(
                      children: [
                        const Icon(Icons.star_rounded, color: Color(0xFFF97316), size: 16),
                        const SizedBox(width: 4),
                        Text(rating, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                    child: Text(time, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF134E4A))),
                  ),
                )
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF134E4A))),
                    Text(tags, style: const TextStyle(fontSize: 13, color: Colors.grey)),
                  ],
                ),
                Text(delivery, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF0F766E))),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class _BottomNavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      height: 72,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(40),
        boxShadow: [
          BoxShadow(color: const Color(0xFF0F766E).withOpacity(0.15), blurRadius: 20, offset: const Offset(0, 5)),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(onPressed: (){}, icon: const Icon(Icons.home_rounded, color: Color(0xFF0F766E), size: 28)),
          IconButton(onPressed: (){}, icon: const Icon(Icons.favorite_outline_rounded, color: Colors.grey, size: 28)),
          GestureDetector(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CartScreen())),
            child: Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: const Color(0xFF0F766E),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(color: const Color(0xFF0F766E).withOpacity(0.4), blurRadius: 10, offset: const Offset(0, 5)),
                ],
              ),
              child: const Icon(Icons.shopping_basket_rounded, color: Colors.white),
            ),
          ),
          IconButton(onPressed: (){}, icon: const Icon(Icons.receipt_long_rounded, color: Colors.grey, size: 28)),
          IconButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfileScreen()));
          }, icon: const Icon(Icons.person_outline_rounded, color: Colors.grey, size: 28)),
        ],
      ),
    );
  }
}

// --- EKRAN 4: RESTORAN DETAY (RESTAURANT DETAIL) ---
class RestaurantDetailScreen extends StatelessWidget {
  const RestaurantDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0FDFA),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundColor: Colors.white.withOpacity(0.4),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(
                "https://lh3.googleusercontent.com/aida-public/AB6AXuBAc0kMcv6LrWiXI7dRvfYimudZj0rqYdfr9gjcqQWN0iI8s5-ypEn6ol6Z003iyp1F0p6hQNf19p1CrUI8y-twaMI0z-RELtKGW6v6jJnUbSrvaAn6X9vZeJ0Fenp1iCiP9mUEF1Zb8NJFGRL4vLPi8R-TPFBl_T68zSzYzIoHD-pxz345QkBfhuKAC_MUhOyIMqtBw-azxggSPi4boH9-8bpPMDQQci9ZMvIaetHMla-h4s63OGxjlxt9cpWnK2NmOpw-xRrK8wOZ",
                fit: BoxFit.cover,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Neon Suşi", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF134E4A))),
                          SizedBox(height: 4),
                          Text("Japon Mutfağı • Suşi • ₺₺", style: TextStyle(color: Colors.grey)),
                        ],
                      ),
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          image: const DecorationImage(image: NetworkImage("https://lh3.googleusercontent.com/aida-public/AB6AXuDC81ML3XF0w5U9uRRPbl5eLYgIprwbmIFR48uUbNDFeOo_r52OACveLjSzJ04KOpDSVD4EfAB_A-WNTHCiygLdH_b7XEKrC6qM9jHni2TUfcKH7DYQgiUQ7P5qyN2LdXrOeYE4tCH4nyzWdIgJwFMBAwmoYc4X-7aMpRHLnSf4Y4o90rBiI867dAkxAIuEmEzPP6s30b1LfZMIUXB44RivYW-F7n_D5nvbSUJ9aPrEuar1m3QYwE8uncsNZ4I1YzD84BOntdIgWIbq")),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _InfoBadge(icon: Icons.star_rounded, text: "9.8 (500+)", color: Color(0xFFF97316)),
                      _InfoBadge(icon: Icons.schedule_rounded, text: "20-30 dk", color: Color(0xFF0F766E)),
                      _InfoBadge(icon: Icons.local_shipping_outlined, text: "Ücretsiz", color: Color(0xFF0F766E)),
                    ],
                  ),
                  const Divider(height: 40),
                  // Menu Tabs
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _MenuTab("Popüler", isActive: true),
                        _MenuTab("Başlangıçlar"),
                        _MenuTab("Ana Yemekler"),
                        _MenuTab("Suşi"),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text("Popüler 🔥", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF134E4A))),
                  const SizedBox(height: 16),
                  const _MenuItem(
                    name: "Acılı Ton Balığı Volkanı",
                    desc: "Susam ve çıtır soğan ile kaplanmış, acı mayonezli taze ton balığı tartarı.",
                    price: "₺360,00",
                    rawPrice: 360.00,
                    imageUrl: "https://lh3.googleusercontent.com/aida-public/AB6AXuCRSCzsbRxioMA5cYDPNJeSTFpu1XZfetompSc3T-dG4LhKW7KmyMobaTcLM_VFm5FOMtw32y86QaLIKRJtz_Z13mNAD_eAs6Pr9aORcDFXcJ021VWX1ycdA8RhlaJHHb09bLlfMvcv5hKAmzFZtCsw_R-el9zuu2M5BsLzYxYRKSHhbrlNfarTC9BPjHDqWtrCctflsbcZ4uhd75jPt3d6KPh3r1O303auIzIQIlalGE5-AAD_vCmPxcUYDB7idRjVoIldBieY7mX9",
                    tag: "ACI",
                  ),
                  const _MenuItem(
                    name: "Neon Ejderha Rulosu",
                    desc: "İçinde yılan balığı ve salatalık, üzerinde avokado dilimleri.",
                    price: "₺400,00",
                    rawPrice: 400.00,
                    imageUrl: "https://lh3.googleusercontent.com/aida-public/AB6AXuAnNwV_-VCBK_FeNECAFP9Z46HuCV6K1kEpF6fTTDYHru20IUpCWv2nQL_Lz8LEC9hmY8PlEONMK2EA2-EzVkJ2sXd3qqns8LlgNVTIBr8xNdrgHHbdzacZaJLLSggFYEQuvHj5sg87o5iG-qKmeMmrM7anOftzklU_NMXn2fHLoGyV5U4fh-5dr_L8rIA2e-QcyIgfr8P1M1VHSmVh4kdBA-7PT0mKcvAujA1-h7K5I5FasC4n2pTXOlkj6HJ_CMTORrWc4HXNbEyp",
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoBadge extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;
  const _InfoBadge({required this.icon, required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 4),
        Text(text, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF134E4A))),
      ],
    );
  }
}

class _MenuTab extends StatelessWidget {
  final String text;
  final bool isActive;
  const _MenuTab(this.text, {this.isActive = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFF0F766E) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: isActive ? null : Border.all(color: const Color(0xFF0F766E).withOpacity(0.1)),
      ),
      child: Text(text, style: TextStyle(color: isActive ? Colors.white : const Color(0xFF134E4A), fontWeight: FontWeight.bold)),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final String name;
  final String desc;
  final String price;
  final double rawPrice;
  final String imageUrl;
  final String? tag;

  const _MenuItem({required this.name, required this.desc, required this.price, required this.rawPrice, required this.imageUrl, this.tag});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => ProductDetailScreen(
          name: name,
          price: rawPrice,
          imageUrl: imageUrl,
          desc: desc,
        )));
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF134E4A))),
                      if(tag != null)
                        Container(
                          margin: const EdgeInsets.only(left: 8),
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(color: const Color(0xFFF97316).withOpacity(0.1), borderRadius: BorderRadius.circular(4)),
                          child: Text(tag!, style: const TextStyle(fontSize: 10, color: Color(0xFFF97316), fontWeight: FontWeight.bold)),
                        )
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(desc, style: TextStyle(fontSize: 13, color: const Color(0xFF134E4A).withOpacity(0.7))),
                  const SizedBox(height: 8),
                  Text(price, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF0F766E))),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    image: DecorationImage(image: NetworkImage(imageUrl), fit: BoxFit.cover),
                  ),
                ),
                Positioned(
                  bottom: -8,
                  right: -8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle, boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4)]),
                    child: const Icon(Icons.add, color: Color(0xFF0F766E), size: 20),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

// --- EKRAN 5: ÜRÜN DETAY (PRODUCT DETAIL) ---
class ProductDetailScreen extends StatefulWidget {
  final String name;
  final double price;
  final String imageUrl;
  final String desc;

  const ProductDetailScreen({
    super.key,
    this.name = "Çift Smash Burger",
    this.price = 245.0,
    this.imageUrl = "https://lh3.googleusercontent.com/aida-public/AB6AXuAiVVKvhEAU9GtyoWffMyWtWXh1FQiRAPUEMUBXcThPyJqsO8u0S84ty7MrZ6AjBvoC21JGNtKCqjrzScPM4Von3GYYQb6twmOZsGMyTO18rMUd59ELE4sCVbrlfEcBca-hOr8j1TC8ceW-hS_qPBAG7V7jhsvLHEMY6684HDCz1obwH3gFU7kKMii33B1U3sLgmIJ-V5IPtO2zlT4a_6gTzkBvWGg3s_0GutS6w4wru57ODyiPfrrhCDt_dU2y0yJEAF2ctBLktYTn",
    this.desc = "Mükemmel kıvamda ezilmiş iki adet dinlendirilmiş dana köfte...",
  });

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int quantity = 1;
  double extrasPrice = 0;
  // Seçeneklerin seçili olup olmadığını takip etmek için (Demo amaçlı basit map)
  Map<String, double> selectedOptions = {};

  void _toggleOption(String name, double price, bool isSelected) {
    setState(() {
      if (isSelected) {
        selectedOptions[name] = price;
        extrasPrice += price;
      } else {
        selectedOptions.remove(name);
        extrasPrice -= price;
      }
    });
  }

  double get totalPrice => (widget.price + extrasPrice) * quantity;

  void _addToCart() {
    CartService.addItem(CartItemModel(
      id: DateTime.now().toString(), // Basit ID
      name: widget.name,
      price: widget.price + extrasPrice,
      imageUrl: widget.imageUrl,
      options: selectedOptions.keys.join(", "),
      quantity: quantity,
    ));
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Sepete eklendi!")));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Arkaplan Resmi
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: MediaQuery.of(context).size.height * 0.45,
            child: Image.network(
              widget.imageUrl,
              fit: BoxFit.cover,
            ),
          ),

          // Geri butonu
          Positioned(
            top: 50,
            left: 20,
            child: CircleAvatar(
              backgroundColor: Colors.white.withOpacity(0.3),
              child: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.white), onPressed: () => Navigator.pop(context)),
            ),
          ),

          // İçerik Kartı
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.6,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 12),
                  Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2))),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(color: const Color(0xFF0F766E).withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                                child: const Text("POPÜLER", style: TextStyle(color: Color(0xFF0F766E), fontSize: 10, fontWeight: FontWeight.bold)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Text(widget.name, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF134E4A))),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("${widget.price.toStringAsFixed(2)} ₺", style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF0F766E))),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(8)),
                                child: const Row(children: [Icon(Icons.star_rounded, color: Color(0xFFF97316), size: 18), SizedBox(width: 4), Text("4.8 (200+)", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))]),
                              )
                            ],
                          ),
                          const SizedBox(height: 16),
                          Text(widget.desc, style: TextStyle(color: const Color(0xFF134E4A).withOpacity(0.7), height: 1.5)),
                          const Divider(height: 40),
                          const Text("Siparişini Özelleştir", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF134E4A))),
                          const SizedBox(height: 16),
                          _OptionRow(text: "Ekstra Peynir Ekle", price: 20, onUpdate: _toggleOption),
                          _OptionRow(text: "Menü Yap", price: 80, onUpdate: _toggleOption),
                          _OptionRow(text: "Glutensiz Ekmek", price: 35, onUpdate: _toggleOption),
                        ],
                      ),
                    ),
                  ),

                  // Bottom Action
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border(top: BorderSide(color: Colors.grey[100]!)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(color: const Color(0xFF0F766E).withOpacity(0.1), borderRadius: BorderRadius.circular(30)),
                          child: Row(
                            children: [
                              IconButton(
                                  icon: const Icon(Icons.remove, size: 20),
                                  onPressed: quantity > 1 ? () => setState(() => quantity--) : null,
                                  color: const Color(0xFF0F766E)
                              ),
                              Text("$quantity", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0F766E))),
                              IconButton(
                                  icon: const Icon(Icons.add, size: 20),
                                  onPressed: () => setState(() => quantity++),
                                  color: const Color(0xFF0F766E)
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _addToCart,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF0F766E),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text("Sepete Ekle", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                                const SizedBox(width: 8),
                                const CircleAvatar(radius: 2, backgroundColor: Colors.white),
                                const SizedBox(width: 8),
                                Text("${totalPrice.toStringAsFixed(2)} ₺", style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class _OptionRow extends StatefulWidget {
  final String text;
  final double price;
  final Function(String, double, bool) onUpdate;
  const _OptionRow({required this.text, required this.price, required this.onUpdate});

  @override
  State<_OptionRow> createState() => _OptionRowState();
}

class _OptionRowState extends State<_OptionRow> {
  bool isChecked = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF0FDFA),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isChecked ? const Color(0xFF0F766E) : Colors.transparent),
      ),
      child: Row(
        children: [
          Checkbox(
            value: isChecked,
            activeColor: const Color(0xFF0F766E),
            onChanged: (v) {
              setState(() => isChecked = v!);
              widget.onUpdate(widget.text, widget.price, isChecked);
            },
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          ),
          Text(widget.text, style: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF134E4A))),
          const Spacer(),
          Text("+ ${widget.price} ₺", style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0F766E))),
        ],
      ),
    );
  }
}

// --- EKRAN 6: SEPET (CART) ---
class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  void _refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final items = CartService.items;

    return Scaffold(
      backgroundColor: const Color(0xFFF0FDFA),
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new, size: 20), onPressed: () => Navigator.pop(context)),
        title: Text("Sepetim (${items.length})", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color(0xFF134E4A))),
        actions: [
          IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.red),
              onPressed: (){
                CartService.clearCart();
                _refresh();
              }
          )
        ],
      ),
      body: items.isEmpty ?
      Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.shopping_cart_outlined, size: 80, color: Colors.grey[300]),
            const SizedBox(height: 16),
            const Text("Sepetin boş", style: TextStyle(fontSize: 18, color: Colors.grey, fontWeight: FontWeight.bold)),
          ],
        ),
      )
          : Column(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.swipe_left, size: 16, color: Color(0xFF0F766E)),
                SizedBox(width: 4),
                Text("Silmek için sola kaydırın", style: TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: items.length + 1, // +1 for summary
              itemBuilder: (context, index) {
                if (index == items.length) {
                  return Column(
                    children: [
                      const SizedBox(height: 16),
                      const _PromoCodeInput(),
                      const SizedBox(height: 24),
                      _SummaryRow("Ara Toplam", "${CartService.subTotal.toStringAsFixed(2)} ₺"),
                      _SummaryRow("Teslimat Ücreti", "${CartService.deliveryFee.toStringAsFixed(2)} ₺"),
                      const _SummaryRow("Vergiler", "1.85 ₺"), // Sabit şimdilik
                      const SizedBox(height: 16),
                      _SummaryRow("Toplam", "${(CartService.total + 1.85).toStringAsFixed(2)} ₺", isTotal: true),
                    ],
                  );
                }

                final item = items[index];
                return Dismissible(
                  key: UniqueKey(),
                  direction: DismissDirection.endToStart,
                  onDismissed: (_) {
                    CartService.removeItem(item);
                    _refresh();
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Ürün silindi")));
                  },
                  background: Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(color: Colors.red.withOpacity(0.2), borderRadius: BorderRadius.circular(16)),
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    child: const Icon(Icons.delete, color: Colors.red),
                  ),
                  child: _CartItem(
                    item: item,
                    onUpdate: _refresh,
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 20, offset: Offset(0, -5))],
            ),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Ödenecek Tutar", style: TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.bold)),
                    Text("${(CartService.total + 1.85).toStringAsFixed(2)} ₺", style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF134E4A))),
                  ],
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const CheckoutScreen()));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0F766E),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Sepeti Onayla", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                        SizedBox(width: 8),
                        Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 20),
                      ],
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _CartItem extends StatelessWidget {
  final CartItemModel item;
  final VoidCallback onUpdate;
  const _CartItem({required this.item, required this.onUpdate});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: const Color(0xFF0F766E).withOpacity(0.05), blurRadius: 20)],
      ),
      child: Row(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              image: DecorationImage(image: NetworkImage(item.imageUrl), fit: BoxFit.cover),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF134E4A))),
                    Text("${(item.price * item.quantity).toStringAsFixed(2)} ₺", style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0F766E))),
                  ],
                ),
                if(item.options.isNotEmpty)
                  Text(item.options, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    InkWell(
                      onTap: () {
                        if (item.quantity > 1) {
                          item.quantity--;
                          onUpdate();
                        }
                      },
                      child: const _QtyBtn(icon: Icons.remove),
                    ),
                    Padding(padding: const EdgeInsets.symmetric(horizontal: 12), child: Text("${item.quantity}", style: const TextStyle(fontWeight: FontWeight.bold))),
                    InkWell(
                      onTap: () {
                        item.quantity++;
                        onUpdate();
                      },
                      child: const _QtyBtn(icon: Icons.add, isDark: true),
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _QtyBtn extends StatelessWidget {
  final IconData icon;
  final bool isDark;
  const _QtyBtn({required this.icon, this.isDark = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F766E) : Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: isDark ? null : Border.all(color: Colors.grey[200]!),
      ),
      child: Icon(icon, size: 16, color: isDark ? Colors.white : const Color(0xFF134E4A)),
    );
  }
}

class _PromoCodeInput extends StatelessWidget {
  const _PromoCodeInput({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFF0F766E).withOpacity(0.2))),
      child: Row(
        children: [
          const Icon(Icons.sell_outlined, color: Color(0xFF0F766E)),
          const SizedBox(width: 12),
          const Expanded(child: TextField(decoration: InputDecoration(hintText: "Promosyon Kodu", border: InputBorder.none))),
          TextButton(onPressed: (){}, child: const Text("Uygula", style: TextStyle(color: Color(0xFF0F766E), fontWeight: FontWeight.bold)))
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label, value;
  final bool isTotal;
  const _SummaryRow(this.label, this.value, {this.isTotal = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontWeight: isTotal ? FontWeight.bold : FontWeight.normal, fontSize: isTotal ? 18 : 14, color: isTotal ? const Color(0xFF134E4A) : Colors.grey)),
          Text(value, style: TextStyle(fontWeight: FontWeight.bold, fontSize: isTotal ? 22 : 14, color: isTotal ? const Color(0xFF0F766E) : const Color(0xFF134E4A))),
        ],
      ),
    );
  }
}

// --- EKRAN 7: ÖDEME (CHECKOUT) ---
class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Toplam tutarı servis üzerinden alalım
    final totalAmount = CartService.total + 1.85;

    return Scaffold(
      backgroundColor: const Color(0xFFF0FDFA),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: const Text("Ödeme", style: TextStyle(color: Color(0xFF134E4A), fontWeight: FontWeight.bold)),
            centerTitle: true,
            leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context)),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Map Preview
                  Container(
                    height: 200,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(32),
                      image: const DecorationImage(
                        image: NetworkImage("https://lh3.googleusercontent.com/aida-public/AB6AXuArrUW2HF-8GLqmG43UXXy6Q2cXkegLq0gEfEz0JBfVtizusK1nMBXRWznIgaBkU6O2Fi4rtBkeWKlRE2v87dXaRWiAHD5kiOO8ErMBHYraQjz3ok3pLQAEOb1HB-KihnzhrEE9iDYOH06voFFVfSUY5l7MIiIPgUhsjhGC2oxzRauskZ_yWMuWAa0m12oyBI_m8isPCNVTkFWi_SKefcrXE7y9dE2JqXfTYgLBVHtTMGzBrjkbtmw-dnLBVs1sow25RM7GRWaoEeMA"),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                          bottom: 16,
                          left: 16,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10)]),
                            child: const Row(children: [Icon(Icons.electric_moped, color: Color(0xFF0F766E), size: 20), SizedBox(width: 8), Text("15-20 dk", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF134E4A)))]),
                          ),
                        )
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),
                  const Text("Teslimat Adresi", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0F766E))),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 10)]),
                    child: Row(
                      children: [
                        const CircleAvatar(backgroundColor: Color(0xFFE0F2F1), child: Icon(Icons.home, color: Color(0xFF0F766E))),
                        const SizedBox(width: 16),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Ev", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                              Text("Bağdat Cad. No: 123, Daire 4B", style: TextStyle(color: Colors.grey, fontSize: 13)),
                            ],
                          ),
                        ),
                        const Icon(Icons.edit, color: Color(0xFFF97316)),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),
                  const Text("Ödeme Yöntemi", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0F766E))),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 100,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        Container(
                          width: 160,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), border: Border.all(color: const Color(0xFF0F766E), width: 2)),
                          child: const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Icon(Icons.credit_card, size: 32, color: Color(0xFF134E4A)),
                              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text("MASTERCARD", style: TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold)), Text("•••• 4242", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF134E4A)))])
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          width: 160,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(24)),
                          child: const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Icon(Icons.account_balance_wallet, size: 32, color: Colors.grey),
                              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text("APPLE PAY", style: TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold)), Text("Apple Pay", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey))])
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          )
        ],
      ),
      bottomSheet: Container(
        color: const Color(0xFFF0FDFA),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(32)), boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 20)]),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text("Toplam Tutar", style: TextStyle(color: Colors.grey)), Text("${totalAmount.toStringAsFixed(2)} ₺", style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF134E4A)))]),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    // Sepeti temizle ve takibe geç
                    CartService.clearCart();
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const TrackingScreen()));
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0F766E), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
                  child: const Text("Siparişi Tamamla", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

// --- EKRAN 8: TAKİP (TRACKING) ---
class TrackingScreen extends StatelessWidget {
  const TrackingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Map Background
          Positioned.fill(
            child: Image.network(
              "https://lh3.googleusercontent.com/aida-public/AB6AXuArrUW2HF-8GLqmG43UXXy6Q2cXkegLq0gEfEz0JBfVtizusK1nMBXRWznIgaBkU6O2Fi4rtBkeWKlRE2v87dXaRWiAHD5kiOO8ErMBHYraQjz3ok3pLQAEOb1HB-KihnzhrEE9iDYOH06voFFVfSUY5l7MIiIPgUhsjhGC2oxzRauskZ_yWMuWAa0m12oyBI_m8isPCNVTkFWi_SKefcrXE7y9dE2JqXfTYgLBVHtTMGzBrjkbtmw-dnLBVs1sow25RM7GRWaoEeMA",
              fit: BoxFit.cover,
            ),
          ),

          // Top Buttons
          Positioned(
            top: 50,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CircleAvatar(backgroundColor: Colors.white, child: IconButton(icon: const Icon(Icons.home, color: Colors.black), onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const HomeScreen()), (Route<dynamic> route) => false);
                })),
                const CircleAvatar(backgroundColor: Colors.white, child: Icon(Icons.support_agent, color: Colors.black)),
              ],
            ),
          ),

          // Courier Marker (Simulated)
          Positioned(
            top: 300,
            left: MediaQuery.of(context).size.width / 2 - 30,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 4), boxShadow: [BoxShadow(color: const Color(0xFF0F766E).withOpacity(0.4), blurRadius: 20)]),
              child: const Icon(Icons.two_wheeler, color: Color(0xFFF97316), size: 32),
            ),
          ),

          // Bottom Info Card
          Positioned(
            bottom: 30,
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(32),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 20)],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2))),
                  const SizedBox(height: 16),
                  const Text("12-15 dk", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF134E4A))),
                  const Text("Siparişin yolda!", style: TextStyle(color: Colors.grey, fontSize: 16)),
                  const SizedBox(height: 24),

                  // Progress Bar
                  Row(
                    children: [
                      Expanded(child: Container(height: 6, decoration: BoxDecoration(color: const Color(0xFF0F766E).withOpacity(0.3), borderRadius: BorderRadius.circular(3)))),
                      const SizedBox(width: 4),
                      Expanded(child: Container(height: 6, decoration: BoxDecoration(color: const Color(0xFF0F766E).withOpacity(0.3), borderRadius: BorderRadius.circular(3)))),
                      const SizedBox(width: 4),
                      Expanded(child: Container(height: 6, decoration: BoxDecoration(color: const Color(0xFF0F766E), borderRadius: BorderRadius.circular(3)))),
                      const SizedBox(width: 4),
                      Expanded(child: Container(height: 6, decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(3)))),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Divider(),
                  const SizedBox(height: 16),

                  // Courier Info
                  Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: const DecorationImage(image: NetworkImage("https://lh3.googleusercontent.com/aida-public/AB6AXuAv9FefgYmlrJkWRHlggK97_QuVRUGBylw_rDKzR0U8z82VnAoB_4_d423uaIvc-96LZfoQmcxKLS3xX02xFAx_7HJZJ4S63FCqflHvmnB8SiH5IGG7LwDPUANxK-Qyn0KiMSU0NLaV7kZNHqVagINw1FBBwfJtf0UdNni_3IgX7BT33Eaw6vOhlKHbfBJfR9hWxy7sYXMUDutzrTXAF4Db14yIlBtLVf3bwnFY8Mli9PWDeBkE0wurmpbnIaFmK45Lh9UXTpT3iCFO"), fit: BoxFit.cover),
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Mehmet Y.", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            Text("İndigo Motor • ID-842", style: TextStyle(color: Colors.grey, fontSize: 13)),
                          ],
                        ),
                      ),
                      CircleAvatar(backgroundColor: Colors.grey[100], child: const Icon(Icons.chat_bubble_outline, color: Colors.black)),
                      const SizedBox(width: 8),
                      const CircleAvatar(backgroundColor: Color(0xFF0F766E), child: Icon(Icons.call, color: Colors.white)),
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

// --- EKRAN 9: PROFİL (PROFILE) ---
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0FDFA),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 50),
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleAvatar(backgroundColor: Colors.white, child: IconButton(icon: const Icon(Icons.arrow_back, color: Color(0xFF134E4A)), onPressed: () => Navigator.pop(context))),
                  const Text("Profilim", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color(0xFF134E4A))),
                  // Düzenle butonu da aktif edilebilir
                  TextButton(
                    onPressed: (){},
                    child: const Text("Düzenle", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFF97316))),
                  )
                ],
              ),
            ),
            const SizedBox(height: 30),
            // Avatar
            Stack(
              children: [
                Container(
                  width: 110,
                  height: 110,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 4),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10)],
                    image: const DecorationImage(image: NetworkImage("https://lh3.googleusercontent.com/aida-public/AB6AXuC2JZaS3F6HAPhAO2ILbLdv27pcc8hoiwy2URnOeedjUVwsmiRZuZGJiXoUPrBLNYl2K1BYt_ayak5Oh-3PX6yDXICrGSSqnFjvWQt-58J-ZHHQI9hJat9UQ4IWr6rbAE6JnbOWW659THwQelL1_Lx-GuK8xhtYfOnb_EL8_RGWLMQ5bbL3P88yOvJUQzYSpBUgelzj9WC_VxCWWiWpI8mtLH4_1dDP676gILU-2Kp2f2pvU_VA8UAY4SNZ9oX1E-4ifP_j1zb4drK4"), fit: BoxFit.cover),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(color: const Color(0xFFF97316), shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2)),
                    child: const Icon(Icons.edit, size: 14, color: Colors.white),
                  ),
                )
              ],
            ),
            const SizedBox(height: 16),
            const Text("Alex Johnson", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF134E4A))),
            Text("+90 (555) 019-2834", style: TextStyle(fontSize: 14, color: const Color(0xFF134E4A).withOpacity(0.6))),
            const SizedBox(height: 30),

            // Wallet Card
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: const LinearGradient(colors: [Color(0xFF0F766E), Color(0xFF134E4A)], begin: Alignment.topLeft, end: Alignment.bottomRight),
                boxShadow: [BoxShadow(color: const Color(0xFF0F766E).withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 10))],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("CÜZDAN BAKİYESİ", style: TextStyle(color: Colors.white70, fontSize: 12, letterSpacing: 1.2)),
                          SizedBox(height: 4),
                          Text("₺124,50", style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(12)), child: const Icon(Icons.account_balance_wallet, color: Colors.white)),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Row(children: [CircleAvatar(radius: 4, backgroundColor: Colors.greenAccent), SizedBox(width: 6), Text("Aktif", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))]),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(color: const Color(0xFFF97316), borderRadius: BorderRadius.circular(20)),
                        child: const Row(children: [Icon(Icons.add, size: 16, color: Colors.white), SizedBox(width: 4), Text("Bakiye Yükle", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))]),
                      )
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(height: 30),

            // --- GÜNCELLENEN MENÜ BUTONLARI ---
            _ProfileMenuItem(
              icon: Icons.location_on,
              title: "Adreslerim",
              subtitle: "Ev, İş, Annemler",
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AddressesScreen())),
            ),
            _ProfileMenuItem(
              icon: Icons.credit_card,
              title: "Ödeme Yöntemleri",
              subtitle: "Visa ...4242 ile biten",
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PaymentMethodsScreen())),
            ),
            _ProfileMenuItem(
              icon: Icons.receipt_long,
              title: "Geçmiş Siparişler",
              subtitle: "Favorilerini tekrar sipariş et",
              isHighlight: true,
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PastOrdersScreen())),
            ),
            _ProfileMenuItem(
              icon: Icons.support_agent,
              title: "Destek",
              subtitle: "SSS, İletişim",
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SupportScreen())),
            ),
            // --- YENİ EKLENEN AYARLAR BUTONU ---
            _ProfileMenuItem(
              icon: Icons.settings,
              title: "Uygulama Ayarları",
              subtitle: "Bildirimler, Dil, Tema",
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen())),
            ),

            const SizedBox(height: 30),
            TextButton.icon(
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const LoginScreen()), (route) => false);
              },
              icon: const Icon(Icons.logout, size: 18),
              label: const Text("Çıkış Yap"),
              style: TextButton.styleFrom(foregroundColor: Colors.grey),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

class _ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool isHighlight;
  final VoidCallback? onTap; // Tıklama özelliği eklendi

  const _ProfileMenuItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.isHighlight = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: const Color(0xFFF97316).withOpacity(0.1), shape: BoxShape.circle),
              child: isHighlight
                  ? Badge(backgroundColor: const Color(0xFFF97316), smallSize: 8, child: Icon(icon, color: const Color(0xFFF97316)))
                  : Icon(icon, color: const Color(0xFFF97316)),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF134E4A))),
                  Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}

// --- YENİ EKLENEN PROFİL ALT SAYFALARI ---

class AddressesScreen extends StatelessWidget {
  const AddressesScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Adreslerim", style: TextStyle(fontWeight: FontWeight.bold))),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _AddressCard(title: "Evim", address: "Bandırma, 10200", icon: Icons.home),
          _AddressCard(title: "Ofis", address: "Levent, İstanbul", icon: Icons.work),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){},
        backgroundColor: const Color(0xFF0F766E),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

class _AddressCard extends StatelessWidget {
  final String title;
  final String address;
  final IconData icon;
  const _AddressCard({required this.title, required this.address, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFF0F766E)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(address),
        trailing: const Icon(Icons.more_vert),
      ),
    );
  }
}

class PaymentMethodsScreen extends StatelessWidget {
  const PaymentMethodsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Ödeme Yöntemleri", style: TextStyle(fontWeight: FontWeight.bold))),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          ListTile(leading: Icon(Icons.credit_card), title: Text("Mastercard •••• 4242"), trailing: Icon(Icons.check_circle, color: Colors.green)),
          Divider(),
          ListTile(leading: Icon(Icons.credit_card), title: Text("Visa •••• 1234")),
        ],
      ),
    );
  }
}

class PastOrdersScreen extends StatelessWidget {
  const PastOrdersScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Geçmiş Siparişler", style: TextStyle(fontWeight: FontWeight.bold))),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 5,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(8)),
                child: const Icon(Icons.fastfood, color: Colors.grey),
              ),
              title: Text("Sipariş #${4920 + index}"),
              subtitle: Text("${12 + index} Mayıs 2024 • Teslim Edildi"),
              trailing: const Text("₺245.00", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0F766E))),
            ),
          );
        },
      ),
    );
  }
}

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Destek", style: TextStyle(fontWeight: FontWeight.bold))),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          ListTile(leading: Icon(Icons.question_answer), title: Text("Sıkça Sorulan Sorular")),
          Divider(),
          ListTile(leading: Icon(Icons.chat), title: Text("Canlı Destek")),
          Divider(),
          ListTile(leading: Icon(Icons.email), title: Text("Bize Ulaşın")),
        ],
      ),
    );
  }
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Ayarlar", style: TextStyle(fontWeight: FontWeight.bold))),
      body: ListView(
        children: [
          SwitchListTile(
            value: true,
            onChanged: (v){},
            title: const Text("Bildirimler"),
            activeColor: const Color(0xFF0F766E),
          ),
          SwitchListTile(
            value: false,
            onChanged: (v){},
            title: const Text("Karanlık Mod"),
            activeColor: const Color(0xFF0F766E),
          ),
          const ListTile(title: Text("Dil"), subtitle: Text("Türkçe"), trailing: Icon(Icons.arrow_forward_ios, size: 16)),
          const ListTile(title: Text("Sürüm"), subtitle: Text("1.0.0"), trailing: Icon(Icons.info_outline)),
          const Divider(),
          ListTile(
            title: const Text("Hesabımı Sil", style: TextStyle(color: Colors.red)),
            onTap: (){},
          ),
        ],
      ),
    );
  }
}
