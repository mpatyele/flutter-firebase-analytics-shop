import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MiniShopApp());
}

class MiniShopApp extends StatefulWidget {
  const MiniShopApp({super.key});

  @override
  State<MiniShopApp> createState() => _MiniShopAppState();
}

class _MiniShopAppState extends State<MiniShopApp> {
  final List<Product> cartItems = [];
  bool isLoggedIn = false;

  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  void login() {
    analytics.logLogin(loginMethod: 'demo_button');
    logScreen('home_screen');

    setState(() {
      isLoggedIn = true;
    });
  }

  void signUp() {
    analytics.logSignUp(signUpMethod: 'demo_button');
    logScreen('home_screen');

    setState(() {
      isLoggedIn = true;
    });
  }

  void addToCart(Product product) {
    analytics.logAddToCart(
      currency: 'USD',
      value: product.price,
      items: [
        AnalyticsEventItem(
          itemId: product.id,
          itemName: product.name,
          itemCategory: product.category,
          price: product.price,
          quantity: 1,
        ),
      ],
    );

    setState(() {
      cartItems.add(product);
    });
  }

  void removeFromCart(Product product) {
    setState(() {
      cartItems.remove(product);
    });
  }

  void clearCart() {
    setState(() {
      cartItems.clear();
    });
  }

  AnalyticsEventItem analyticsItemFromProduct(Product product) {
    return AnalyticsEventItem(
      itemId: product.id,
      itemName: product.name,
      itemCategory: product.category,
      price: product.price,
      quantity: 1,
    );
  }

  void logScreen(String screenName) {
    analytics.logScreenView(screenName: screenName);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mini Shop',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: isLoggedIn
          ? HomeScreen(
              cartItems: cartItems,
              onAddToCart: addToCart,
              onRemoveFromCart: removeFromCart,
              onClearCart: clearCart,
            )
          : AuthScreen(onLogin: login, onSignUp: signUp),
    );
  }
}

class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final IconData icon;
  final String category;

  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.icon,
    required this.category,
  });
}

const List<Product> products = [
  Product(
    id: 'p001',
    name: 'Wireless Headphones',
    description: 'Noise-cancelling headphones with premium sound quality.',
    price: 89.99,
    icon: Icons.headphones,
    category: 'Electronics',
  ),
  Product(
    id: 'p002',
    name: 'Smart Watch',
    description: 'Track workouts, notifications, and daily activity.',
    price: 129.99,
    icon: Icons.watch,
    category: 'Wearables',
  ),
  Product(
    id: 'p003',
    name: 'Travel Backpack',
    description: 'Minimal, durable backpack for work, school, and travel.',
    price: 74.99,
    icon: Icons.backpack,
    category: 'Accessories',
  ),
  Product(
    id: 'p004',
    name: 'Desk Lamp',
    description: 'Modern LED desk lamp with adjustable brightness.',
    price: 39.99,
    icon: Icons.light,
    category: 'Home Office',
  ),
];

class AuthScreen extends StatelessWidget {
  final VoidCallback onLogin;
  final VoidCallback onSignUp;

  const AuthScreen({super.key, required this.onLogin, required this.onSignUp});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F4FB),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Spacer(),
              Container(
                height: 130,
                width: 130,
                decoration: BoxDecoration(
                  color: Colors.deepPurple,
                  borderRadius: BorderRadius.circular(36),
                ),
                child: const Icon(
                  Icons.shopping_bag,
                  color: Colors.white,
                  size: 76,
                ),
              ),
              const SizedBox(height: 32),
              const Text(
                'Mini Shop',
                style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              const Text(
                'A Flutter e-commerce demo app built to showcase Firebase Analytics event tracking.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, height: 1.5),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: FilledButton(
                  onPressed: onLogin,
                  child: const Text('Login', style: TextStyle(fontSize: 16)),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: OutlinedButton(
                  onPressed: onSignUp,
                  child: const Text(
                    'Create Account',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Demo app for analytics implementation',
                style: TextStyle(color: Colors.black54),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  final List<Product> cartItems;
  final void Function(Product product) onAddToCart;
  final void Function(Product product) onRemoveFromCart;
  final VoidCallback onClearCart;

  const HomeScreen({
    super.key,
    required this.cartItems,
    required this.onAddToCart,
    required this.onRemoveFromCart,
    required this.onClearCart,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F4FB),
      appBar: AppBar(
        title: const Text(
          'Mini Shop',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart_outlined),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CartScreen(
                        cartItems: cartItems,
                        onAddToCart: onAddToCart,
                        onRemoveFromCart: onRemoveFromCart,
                        onClearCart: onClearCart,
                      ),
                    ),
                  );
                },
              ),
              if (cartItems.isNotEmpty)
                Positioned(
                  right: 6,
                  top: 6,
                  child: CircleAvatar(
                    radius: 10,
                    backgroundColor: Colors.deepPurple,
                    child: Text(
                      cartItems.length.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Featured Products',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            const Text(
              'Browse products and complete a sample checkout flow.',
              style: TextStyle(color: Colors.black54),
            ),
            const SizedBox(height: 18),
            Expanded(
              child: GridView.builder(
                itemCount: products.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: MediaQuery.of(context).size.width > 900
                      ? 4
                      : 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: MediaQuery.of(context).size.width > 900
                      ? 0.9
                      : 0.72,
                ),
                itemBuilder: (context, index) {
                  final product = products[index];

                  return ProductCard(
                    product: product,
                    onAddToCart: onAddToCart,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final Product product;
  final void Function(Product product) onAddToCart;

  const ProductCard({
    super.key,
    required this.product,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shadowColor: Colors.black26,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: () {
          FirebaseAnalytics.instance.logViewItem(
            currency: 'USD',
            value: product.price,
            items: [
              AnalyticsEventItem(
                itemId: product.id,
                itemName: product.name,
                itemCategory: product.category,
                price: product.price,
                quantity: 1,
              ),
            ],
          );

          FirebaseAnalytics.instance.logScreenView(
            screenName: 'product_detail_screen',
          );

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ProductDetailScreen(
                product: product,
                onAddToCart: onAddToCart,
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Center(
                  child: Icon(product.icon, size: 60, color: Colors.deepPurple),
                ),
              ),
              Text(
                product.category,
                style: const TextStyle(color: Colors.black45, fontSize: 12),
              ),
              const SizedBox(height: 4),
              Text(
                product.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                '\$${product.price.toStringAsFixed(2)}',
                style: const TextStyle(
                  color: Colors.deepPurple,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () {
                    onAddToCart(product);

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${product.name} added to cart'),
                        duration: const Duration(seconds: 1),
                      ),
                    );
                  },
                  child: const Text('Add'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProductDetailScreen extends StatelessWidget {
  final Product product;
  final void Function(Product product) onAddToCart;

  const ProductDetailScreen({
    super.key,
    required this.product,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F4FB),
      appBar: AppBar(title: const Text('Product Details')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Container(
              height: 220,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(28),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 18,
                    offset: Offset(0, 8),
                  ),
                ],
              ),
              child: Icon(product.icon, size: 110, color: Colors.deepPurple),
            ),
            const SizedBox(height: 28),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                product.category,
                style: const TextStyle(color: Colors.black45, fontSize: 14),
              ),
            ),
            const SizedBox(height: 6),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                product.name,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '\$${product.price.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 22,
                  color: Colors.deepPurple,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              product.description,
              style: const TextStyle(fontSize: 16, height: 1.5),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 54,
              child: FilledButton.icon(
                icon: const Icon(Icons.add_shopping_cart),
                label: const Text(
                  'Add to Cart',
                  style: TextStyle(fontSize: 16),
                ),
                onPressed: () {
                  onAddToCart(product);

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${product.name} added to cart')),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CartScreen extends StatelessWidget {
  final List<Product> cartItems;
  final void Function(Product product) onAddToCart;
  final void Function(Product product) onRemoveFromCart;
  final VoidCallback onClearCart;

  const CartScreen({
    super.key,
    required this.cartItems,
    required this.onAddToCart,
    required this.onRemoveFromCart,
    required this.onClearCart,
  });

    double get subtotal {
    return cartItems.fold(0, (total, product) => total + product.price);
  }

  Map<Product, int> get groupedCartItems {
    final Map<Product, int> groupedItems = {};

    for (final product in cartItems) {
      groupedItems[product] = (groupedItems[product] ?? 0) + 1;
    }

    return groupedItems;
  }

  @override
  Widget build(BuildContext context) {
    final bool isCartEmpty = cartItems.isEmpty;
    final groupedItems = groupedCartItems.entries.toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF7F4FB),
      appBar: AppBar(title: const Text('Cart')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: isCartEmpty
            ? const EmptyCartView()
            : Column(
                children: [
                  Expanded(
                    child: ListView.separated(
                      itemCount: groupedItems.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final product = groupedItems[index].key;
                        final quantity = groupedItems[index].value;
                        final itemTotal = product.price * quantity;

                        return Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 26,
                                  backgroundColor: const Color(0xFFEDE7F6),
                                  child: Icon(
                                    product.icon,
                                    color: Colors.deepPurple,
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        product.name,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        product.category,
                                        style: const TextStyle(
                                          color: Colors.black54,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '\$${itemTotal.toStringAsFixed(2)}',
                                        style: const TextStyle(
                                          color: Colors.deepPurple,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(
                                        Icons.remove_circle_outline,
                                      ),
                                      onPressed: () {
                                        onRemoveFromCart(product);
                                      },
                                    ),
                                    Text(
                                      quantity.toString(),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.add_circle_outline,
                                      ),
                                      onPressed: () {
                                        onAddToCart(product);
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(18),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Items',
                                style: TextStyle(fontSize: 16),
                              ),
                              Text(
                                cartItems.length.toString(),
                                style: const TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Subtotal',
                                style: TextStyle(fontSize: 18),
                              ),
                              Text(
                                '\$${subtotal.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: FilledButton(
                      child: const Text(
                        'Begin Checkout',
                        style: TextStyle(fontSize: 16),
                      ),
                      onPressed: () {
                        final analyticsItems = groupedItems.map((entry) {
                          final product = entry.key;
                          final quantity = entry.value;

                          return AnalyticsEventItem(
                            itemId: product.id,
                            itemName: product.name,
                            itemCategory: product.category,
                            price: product.price,
                            quantity: quantity,
                          );
                        }).toList();

                        FirebaseAnalytics.instance.logBeginCheckout(
                          currency: 'USD',
                          value: subtotal,
                          items: analyticsItems,
                        );

                        FirebaseAnalytics.instance.logPurchase(
                          currency: 'USD',
                          value: subtotal,
                          transactionId: DateTime.now()
                              .millisecondsSinceEpoch
                              .toString(),
                          items: analyticsItems,
                        );

                        FirebaseAnalytics.instance.logScreenView(
                          screenName: 'checkout_success_screen',
                        );

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => CheckoutSuccessScreen(
                              total: subtotal,
                              onClearCart: onClearCart,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

class EmptyCartView extends StatelessWidget {
  const EmptyCartView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_bag_outlined, size: 90, color: Colors.deepPurple),
          SizedBox(height: 24),
          Text(
            'Your cart is empty',
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 12),
          Text(
            'Add a product to begin the checkout flow.',
            textAlign: TextAlign.center,
            style: TextStyle(height: 1.5),
          ),
        ],
      ),
    );
  }
}

class CheckoutSuccessScreen extends StatelessWidget {
  final double total;
  final VoidCallback onClearCart;

  const CheckoutSuccessScreen({
    super.key,
    required this.total,
    required this.onClearCart,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F4FB),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Spacer(),
              Container(
                height: 130,
                width: 130,
                decoration: const BoxDecoration(
                  color: Colors.deepPurple,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check, color: Colors.white, size: 80),
              ),
              const SizedBox(height: 32),
              const Text(
                'Purchase Complete',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Text(
                'Your order total was \$${total.toStringAsFixed(2)}.',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16, height: 1.5),
              ),
              const SizedBox(height: 12),
              const Text(
                'This screen represents the final purchase event in the analytics funnel.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black54, height: 1.5),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: FilledButton(
                  child: const Text('Back to Home'),
                  onPressed: () {
                    onClearCart();
                    Navigator.popUntil(context, (route) => route.isFirst);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
