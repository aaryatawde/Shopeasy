class Product {
  final String name;
  final double price;
  final String description;
  final String imagePath;

  Product(
      {required this.name,
      required this.price,
      required this.description,
      required this.imagePath});
}

//in rupees
String getFormattedPrice() {
  var price;
  return '₹${price.toStringAsFixed(2)}';
}

class ProductDatabase {
  static final Map<String, Product> products = {
    "9781234567897": Product(
      name: "Red-Tshirt",
      price: 199,
      description: "",
      imagePath: 'lib/images/tshirt.jpeg',
    ),
    "8901030865442": Product(
      name: "Ponds moisturizer",
      price: 215,
      description: "",
      imagePath: 'lib/images/ponds.jpg',
    ),
    "8901030920271": Product(
      name: "Vaseline Moisturizer",
      price: 375,
      description: "",
      imagePath: 'lib/images/vaseline.jpeg',
    ),
    "9783127323207": Product(
      name: "Oreo Biscuit",
      price: 10,
      description: "",
      imagePath: 'lib/images/oreo.jpg',
    ),
    "8901063014312": Product(
      name: "Icecream",
      price: 190,
      description: "",
      imagePath: 'lib/images/icecream.jpg',
    ),
    "8901719128462": Product(
      name: "Travel Bag",
      price: 800,
      description: "",
      imagePath: 'lib/images/bag.jpg',
    ),
    "8901719124716": Product(
      name: "Ladies Kurti",
      price: 699,
      description: "",
      imagePath: 'lib/images/ladieskurti.jpg',
    ),
    "8904132914582": Product(
      name: "Amul Milk",
      price: 25,
      description: "",
      imagePath: 'lib/images/milk.jpg',
    ),
    "8906120586795": Product(
      name: "Parle Biscuit",
      price: 10,
      description: "",
      imagePath: 'lib/images/parle.jpg',
    ),
    "8907122008520": Product(
      name: "Cheese Cubes",
      price: 40,
      description: "",
      imagePath: 'lib/images/cheese.jpg',
    ),

    // Add more products as needed
  };
  static Product getProductDetails(String barcode) {
    if (products.containsKey(barcode)) {
      return products[barcode]!;
    } else {
      throw Exception("Product not found");
    }
  }
}
