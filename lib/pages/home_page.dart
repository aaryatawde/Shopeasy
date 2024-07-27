import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:shopeasy_app/category/category.dart';
import 'package:shopeasy_app/category/product.dart';
import 'package:shopeasy_app/login/login_page.dart';

class ShoppingApp extends StatefulWidget {
  const ShoppingApp({Key? key}) : super(key: key);

  @override
  _ShoppingAppState createState() => _ShoppingAppState();
}

class _ShoppingAppState extends State<ShoppingApp> {
  List<Product> cartItems = [];

  void addToCart(Product item) {
    if (mounted) {
      setState(() {
        cartItems.add(item);
      });
    }
  }

  void removeFromCart(int index) {
    if (mounted) {
      setState(() {
        cartItems.removeAt(index);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(
        addToCart: addToCart,
        cartItems: cartItems,
        removeFromCart: removeFromCart,
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  final Function(Product) addToCart;
  final List<Product> cartItems;
  final Function(int) removeFromCart;

  const HomePage({
    Key? key,
    required this.addToCart,
    required this.cartItems,
    required this.removeFromCart,
  }) : super(key: key);

  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: CurvedNavigationBar(
          backgroundColor: const Color.fromARGB(255, 201, 255, 203),
          color: const Color.fromARGB(255, 107, 219, 111),
          items: const [
            Icon(Icons.home),
            Icon(Icons.scanner),
            Icon(Icons.account_circle_sharp),
          ],
          onTap: (index) {
            if (index == 0) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HomePage(
                    cartItems: cartItems, // Pass cart items
                    addToCart: addToCart,
                    removeFromCart: removeFromCart,
                  ),
                ),
              );
            } else if (index == 1) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BarcodeScanPage(
                    cartItems: cartItems, // Pass cart items
                    addToCart: addToCart,
                    removeFromCart: removeFromCart,
                  ),
                ),
              );
            }
          },
        ),
        backgroundColor: const Color.fromARGB(255, 201, 255, 203),
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 107, 219, 111),
          title: const Text('Home Page'),
          actions: [
            IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CartPage(
                      cartItems: cartItems,
                      removeFromCart: removeFromCart,
                      addToCart: addToCart,
                      catalogueProducts: [],
                    ),
                  ),
                );
              },
            )
          ],
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 107, 219, 111),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Icon(
                      Icons.account_circle,
                      color: Colors.white,
                      size: 68,
                    ),
                    SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Profile',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          user != null
                              ? user.email ?? ''
                              : 'Email not available',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              ListTile(
                leading: const Icon(Icons.shopping_cart),
                title: const Text('Purchase History'),
                onTap: () {
                  Navigator.pop(context); // Close the drawer
                  // Navigate to purchase history page
                  // Add your navigation logic here
                },
              ),
              ListTile(
                leading: const Icon(Icons.exit_to_app),
                title: const Text('Logout'),
                onTap: () async {
                  Navigator.pop(context);
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => LoginPage(onTap: () {}),
                    ),
                    (Route<dynamic> route) => false,
                  );
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginPage(
                        onTap: () {}, // Dummy function
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Text(
                'Welcome',
                style: TextStyle(
                  fontSize: 60,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                ),
              ),
              SizedBox(height: 10),
              CategoryPage(),
            ],
          ),
        ),
      ),
    );
  }
}

class BarcodeScanPage extends StatelessWidget {
  final Function(Product) addToCart;
  final List<Product> cartItems;
  final Function(int) removeFromCart;

  const BarcodeScanPage({
    Key? key,
    required this.addToCart,
    required this.cartItems,
    required this.removeFromCart,
  }) : super(key: key);

  Future<void> scanBarcode(BuildContext context) async {
    try {
      String barcodeResult = await FlutterBarcodeScanner.scanBarcode(
        "#ff6666", // Color for the scan button
        "Cancel", // Text for the cancel button
        true, // Enable flash
        ScanMode.BARCODE, // Scan mode: BARCODE or QR
      );
      // Fetch product details based on the scanned barcode
      try {
        Product scannedProduct =
            await ProductDatabase.getProductDetails(barcodeResult);

        // Show confirmation dialog
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(
                  "Do you want to add ${scannedProduct.name} to the cart?"),
              content: Text(
                  "Do you want to add ${scannedProduct.name} to the cart?"),
              actions: [
                TextButton(
                  onPressed: () {
                    // Add the scanned product to cart
                    addToCart(scannedProduct);

                    // Close dialog
                    Navigator.of(context).pop();
                    // Navigate to the cart page
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CartPage(
                          cartItems: cartItems,
                          removeFromCart: removeFromCart,
                          addToCart: addToCart,
                          catalogueProducts: [],
                        ),
                      ),
                    );
                  },
                  child: const Text("Add"),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close dialog
                  },
                  child: const Text("Cancel"),
                )
              ],
            );
          },
        );
      } catch (e) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Error"),
              content:
                  Text("Barcode $barcodeResult doesn't exist in the database"),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close dialog
                  },
                  child: Text("OK"),
                )
              ],
            );
          },
        );
      }
    } catch (e) {
      print('Error scanning barcode: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error scanning barcode: $e'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 201, 255, 203),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 107, 219, 111),
        title: const Text('Barcode Scanner'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Scan the Barcode by clicking on the button below',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: ElevatedButton(
                onPressed: () => scanBarcode(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 107, 219, 111),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(20),
                  child: Icon(
                    Icons.qr_code_scanner_rounded,
                    size: 50,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ),
          CurvedNavigationBar(
            backgroundColor: const Color.fromARGB(255, 201, 255, 203),
            color: Color.fromARGB(255, 107, 219, 111),
            items: const [
              Icon(Icons.home),
              Icon(Icons.scanner),
              Icon(Icons.account_circle_sharp),
            ],
            onTap: (index) {
              if (index == 0) {
                Navigator.pop(
                    context); // Navigate back to ShoppingApp (Home Page)
              } else if (index == 2) {
                // Navigate to map page
              }
            },
          ),
        ],
      ),
    );
  }
}

class CartPage extends StatelessWidget {
  final Function(Product) addToCart;
  final List<Product> cartItems;
  final Function(int) removeFromCart;
  final List<Product> catalogueProducts;

  const CartPage({
    Key? key,
    required this.addToCart,
    required this.cartItems,
    required this.removeFromCart,
    required this.catalogueProducts,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    double totalAmount = 0.0;
    for (var item in cartItems) {
      totalAmount += item.price;
    }
    List<Product> allProducts = [...cartItems, ...catalogueProducts];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 107, 219, 111),
        title: const Text('Cart'),
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.payment))],
      ),
      body: ListView.builder(
        itemCount: allProducts.length,
        itemBuilder: (context, index) {
          return CartItemWidget(context, allProducts[index]);
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromARGB(255, 199, 241, 11),
        onPressed: () => _scanBarcode(context), // Call _scanBarcode function
        child: const Icon(Icons.qr_code_2),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total Amount:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                '₹${totalAmount.toStringAsFixed(2)}',
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /* Future<void>*/ void _scanBarcode(BuildContext context) async {
    try {
      String barcodeResult = await FlutterBarcodeScanner.scanBarcode(
        "#ff6666", // Color for the scan button
        "Cancel", // Text for the cancel button
        true, // Enable flash
        ScanMode.BARCODE, // Scan mode: BARCODE or QR
      );

      // Fetch product details based on the scanned barcode
      Product scannedProduct =
          await ProductDatabase.getProductDetails(barcodeResult);

      // Show confirmation dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Add Item to Cart"),
            content:
                Text("Do you want to add ${scannedProduct.name}to the cart?"),
            actions: [
              TextButton(
                onPressed: () {
                  // Add the scanned product to cart
                  addToCart(scannedProduct);

                  // Close dialog
                  Navigator.of(context).pop();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CartPage(
                        cartItems: [...cartItems, scannedProduct],
                        removeFromCart: removeFromCart,
                        addToCart: addToCart,
                        catalogueProducts: [],
                      ),
                    ),
                  );
                },
                child: const Text("Add"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close dialog
                },
                child: const Text("Cancel"),
              )
            ],
          );
        },
      );
    } catch (e) {
      print('Error scanning barcode: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error scanning barcode: $e'),
        ),
      );
    }
  }
/*
  void addProductFromCatalogueScreen(Product product) {
    addToCart(product);
  }

  void removeProductFromCart(int index) {
    removeFromCart(index);
  }*/

  Widget CartItemWidget(BuildContext context, Product product) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 107, 219, 111),
          borderRadius: BorderRadius.circular(10),
        ),
        child: ListTile(
          leading: Image.asset(
            product.imagePath,
            width: 70,
            height: 100,
            fit: BoxFit.cover,
          ),
          title: Text(
            product.name,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.white,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 5,
              ),
              Text(
                "Price: ${product.price}",
                style: TextStyle(color: Colors.black),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                "Description: ${product.description}",
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
          trailing: IconButton(
            icon: const Icon(
              Icons.delete,
              color: Colors.red,
            ),
            onPressed: () {
              ;
            },
          ),
        ),
      ),
    );
  }
}
