class CategoryScreen {}

class Category {
  final String name;
  final String imagePath;

  const Category({
    required this.name,
    required this.imagePath,
  });
}

Future<List<Category>> fetchCategories() async {
  // Returning mock data
  return [
    Category(name: "Animals", imagePath: "assets/images/animals.png"),
    Category(name: "Movies", imagePath: "assets/images/movies.png"),
    Category(name: "Sports", imagePath: "assets/images/sports.png"),
    Category(name: "Technology", imagePath: "assets/images/technology.png"),
    Category(name: "History", imagePath: "assets/images/history.png"),
    Category(name: "Geography", imagePath: "assets/images/geography.png"),
  ];
}
