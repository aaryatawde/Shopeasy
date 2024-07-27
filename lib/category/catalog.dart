import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:shopeasy_app/category/product.dart';
import 'package:shopeasy_app/pages/home_page.dart';

class CatalogueScreen extends StatelessWidget {
  final String category;
  final Function(Product) addToCart;
  final List<Product> cartItems;
  final Function(int) removeFromCart;

  const CatalogueScreen({
    Key? key,
    required this.category,
    required this.addToCart,
    required this.cartItems,
    required this.removeFromCart,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Product> products = getDummyProductsByCategory(category);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 107, 219, 111),
        title: Text('Catalogue - $category'),
      ),
      backgroundColor: const Color.fromARGB(255, 201, 255, 203),
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Color.fromARGB(255, 201, 255, 203),
        color: const Color.fromARGB(255, 107, 219, 111),
        items: const [
          Icon(Icons.home),
          Icon(Icons.scanner),
          Icon(Icons.map),
        ],
        onTap: (index) {
          if (index == 0) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => HomePage(
                        addToCart: addToCart,
                        cartItems: cartItems,
                        removeFromCart: removeFromCart)));
          } else if (index == 1) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => BarcodeScanPage(
                        addToCart: addToCart,
                        cartItems: cartItems,
                        removeFromCart: removeFromCart)));
          }
        },
      ),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          return buildProductItem(context, products[index]);
        },
      ),
    );
  }

  Widget buildProductItem(BuildContext context, Product product) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Color.fromARGB(255, 107, 219, 111),
          boxShadow: const [
            BoxShadow(
              color: Color.fromARGB(255, 107, 219, 111),
              spreadRadius: 2,
              blurRadius: 3,
              offset: Offset(0, 2),
            )
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.transparent,
              backgroundImage: AssetImage(product.imagePath),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      '₹${product.price.toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: Color.fromARGB(255, 5, 101, 10),
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Add the product to the cart
                        addToCart(product);
                        /* Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CartPage(
                              cartItems: cartItems,
                              addToCart: addToCart,
                              removeFromCart: removeFromCart,
                              catalogueProducts: [],
                            ),
                          ),
                        );*/
                      },
                      child: const Text('Add to Cart'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Product> getDummyProductsByCategory(String category) {
    List<Product> dummyProducts = [];
    if (category == 'Fashion') {
      dummyProducts = [
        Product(
            name: 'BLUE SHIRT',
            price: 599,
            imagePath: 'lib/images/shirt.jpg',
            description: ''),
        Product(
            name: 'Travel Bag',
            price: 639,
            imagePath: 'lib/images/bag.jpg',
            description: ''),
        Product(
            name: 'Sports Shoes',
            price: 799,
            imagePath: 'lib/images/shoes.jpeg',
            description: ''),
        Product(
            name: 'T-Shirt',
            price: 199,
            imagePath: 'lib/images/tshirt.jpeg',
            description: ''),
        Product(
            name: 'Blue Jeans',
            price: 899,
            imagePath: 'lib/images/pant.jpg',
            description: ''),
        Product(
            name: 'Ladies Green Kurti',
            price: 999,
            imagePath: 'lib/images/ladieskurti.jpg',
            description: ''),
        Product(
            name: 'Yellow Cargo',
            price: 699,
            imagePath: 'lib/images/cargo.jpg',
            description: ''),
      ];
    } else if (category == 'Vegetables & Fruits') {
      dummyProducts = [
        Product(
            name: 'Cauliflower per kg',
            price: 30,
            imagePath: 'lib/images/cauliflower.jpg',
            description: ''),
        Product(
            name: 'Onion per 10kgs',
            price: 123,
            imagePath: 'lib/images/onion.jpg',
            description: ''),
        Product(
            name: 'Mango per kgs',
            price: 140,
            imagePath: 'lib/images/mango.jpg',
            description: ''),
        Product(
            name: 'Potato',
            price: 34,
            imagePath: 'lib/images/potato.jpg',
            description: ''),
        Product(
            name: 'Carrot',
            price: 50,
            imagePath: 'lib/images/carrot.jpg',
            description: ''),
        Product(
            name: 'Banana',
            price: 35,
            imagePath: 'lib/images/banana.jpg',
            description: ''),
        Product(
            name: 'Apple',
            price: 145,
            imagePath: 'lib/images/apple.jpeg',
            description: ''),
      ];
    } else if (category == 'Dairy') {
      dummyProducts = [
        Product(
            name: 'Milk',
            price: 20,
            imagePath: 'lib/images/milk.jpg',
            description: ''),
        Product(
            name: 'BUTTER',
            price: 30,
            imagePath: 'lib/images/butter.jpeg',
            description: ''),
        Product(
            name: 'Yogurt',
            price: 45,
            imagePath: 'lib/images/yoghurt.jpg',
            description: ''),
        Product(
            name: 'Cheese',
            price: 25,
            imagePath: 'lib/images/cheese.jpg',
            description: ''),
        Product(
            name: 'Eggs',
            price: 23,
            imagePath: 'lib/images/egg.jpg',
            description: ''),
        Product(
            name: 'FRESH CREAM',
            price: 80,
            imagePath: 'lib/images/cream.jpg',
            description: ''),
        Product(
            name: 'ICE CREAM',
            price: 100,
            imagePath: 'lib/images/icecream.jpg',
            description: ''),
      ];
    } else if (category == 'Biscuits') {
      dummyProducts = [
        Product(
            name: 'Treat',
            price: 10,
            imagePath: 'lib/images/treat.png',
            description: ''),
        Product(
            name: 'Americano',
            price: 60,
            imagePath: 'lib/images/americana.jpg',
            description: ''),
        Product(
            name: 'Milano',
            price: 40,
            imagePath: 'lib/images/Milano.jpg',
            description: ''),
        Product(
            name: 'Bourborn',
            price: 10,
            imagePath: 'lib/images/bourbon.jpg',
            description: ''),
        Product(
            name: 'Oreo',
            price: 10,
            imagePath: 'lib/images/oreo.jpg',
            description: ''),
        Product(
            name: 'Parle',
            price: 12,
            imagePath: 'lib/images/parle.jpg',
            description: ''),
        Product(
            name: 'Marie',
            price: 10,
            imagePath: 'lib/images/marie.jpg',
            description: ''),
      ];
    }
    return dummyProducts;
  }
}
