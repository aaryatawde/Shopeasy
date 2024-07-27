import 'package:flutter/material.dart';
import 'catalog.dart';

class CategoryPage extends StatelessWidget {
  CategoryPage({Key? key}) : super(key: key);

  void navigateToCatalogue(BuildContext context, String category) {
    //  navigate to the CatalogueScreen with the category name
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CatalogueScreen(
          category: category,
          addToCart: (Product) {},
          cartItems: [],
          removeFromCart: (int) {},
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 10), // Add some spacing
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20), // Add padding
            child: Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceEvenly, // Adjust alignment
              children: [
                Expanded(
                  child: CategoryCard(
                    title: 'Fashion',
                    imagePath: 'lib/images/fashion1.jpg',
                    onTap: () => navigateToCatalogue(context, 'Fashion'),
                  ),
                ),
                const SizedBox(
                    width: 20), // Add some spacing between categories
                Expanded(
                  child: CategoryCard(
                    title: 'Vegetables & Fruits',
                    imagePath: 'lib/images/vegetables.jpg',
                    onTap: () =>
                        navigateToCatalogue(context, 'Vegetables & Fruits'),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20), // Add some spacing
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20), // Add padding
            child: Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceEvenly, // Adjust alignment
              children: [
                Expanded(
                  child: CategoryCard(
                    title: 'Dairy',
                    imagePath: 'lib/images/dairyproduct.jpeg',
                    onTap: () => navigateToCatalogue(context, 'Dairy'),
                  ),
                ),
                const SizedBox(
                    width: 20), // Add some spacing between categories
                Expanded(
                  child: CategoryCard(
                    title: 'Biscuits',
                    imagePath: 'lib/images/biscuit.jpeg',
                    onTap: () => navigateToCatalogue(context, 'Biscuits'),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20), // Add some spacing
        ],
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  final String title;
  final String imagePath;
  final VoidCallback? onTap;

  const CategoryCard({
    Key? key,
    required this.title,
    required this.imagePath,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 243, // Fixed height for all category containers
        padding: EdgeInsets.all(10), // Adjust padding as needed
        decoration: BoxDecoration(
          color: const Color.fromARGB(
              255, 107, 219, 111), // Set the background color to green
          borderRadius: BorderRadius.circular(
              15), // Apply border radius for rounded corners
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 150, // Adjust width as needed
              height: 150, // Adjust height as needed
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white, // Set the background color for the circle
              ),
              child: CircleAvatar(
                radius: 10, // Adjust the radius as needed
                backgroundImage: AssetImage(imagePath),
              ),
            ),
            SizedBox(height: 10), // Add spacing between image and text
            Text(
              title,
              style: const TextStyle(
                fontSize: 18, // Set the font size for all category titles
                fontWeight: FontWeight.bold,
                color: Colors.white, // Set text color to white
              ),
            ),
          ],
        ),
      ),
    );
  }
}
