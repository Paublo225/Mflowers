import 'package:meta/meta.dart' show required;

class RappiCategory {
  const RappiCategory({
    @required this.name,
    @required this.products,
  });
  final String name;
  final List<RappiProduct> products;
}

class RappiProduct {
  const RappiProduct({
    @required this.name,
    @required this.description,
    @required this.price,
    @required this.image,
  });
  final name;
  final description;
  final price;
  final image;
}

const rappiCategories = [
  RappiCategory(
    name: 'Orden Again',
    products: [
      RappiProduct(
        name: 'Silim Lights',
        description: 'Breef-Bibimbap mits Reis, Bohnen, Spinat, Karotten',
        price: 26.50,
        image:
            "https://images.homedepot-static.com/productImages/f5d04fe4-a2c8-4847-a2f6-8894dbff9434/svn/commercial-electric-recessed-lighting-trims-53808101-64_1000.jpg",
      ),
      RappiProduct(
        name: 'Neewe Kit',
        description: 'Lamparas para grabar videos xd',
        price: 5500,
        image:
            "https://images-na.ssl-images-amazon.com/images/I/71ibO0XJF9L._AC_SL1500_.jpg",
      ),
      RappiProduct(
        name: 'Silim Lights',
        description: 'Breef-Bibimbap mits Reis, Bohnen, Spinat, Karotten',
        price: 26.50,
        image:
            "https://images.homedepot-static.com/productImages/f5d04fe4-a2c8-4847-a2f6-8894dbff9434/svn/commercial-electric-recessed-lighting-trims-53808101-64_1000.jpg",
      ),
      RappiProduct(
        name: 'Neewe Kit',
        description: 'Lamparas para grabar videos xd',
        price: 5500,
        image:
            "https://images-na.ssl-images-amazon.com/images/I/71ibO0XJF9L._AC_SL1500_.jpg",
      ),
    ],
  ),

  RappiCategory(
    name: 'Picker For You',
    products: [
      RappiProduct(
        name: 'xiaomi mi 10t pro',
        description: 'Telefonazo calidad precio mi pana 😳',
        price: 12500.50,
        image:
            "https://www.teknofilo.com/wp-content/uploads/2020/09/Xiaomi-Mi-10T-Pro-render-4.jpg",
      ),
      RappiProduct(
        name: 'Mac mini M1',
        description: 'Lo unico calidad precio de apple xd',
        price: 18500,
        image:
            "https://help.apple.com/assets/5F494C35094622944F3B1EBB/5F494C47094622944F3B1EDA/es_419/d22a8f5456c847d4db6132a978d8c092.png",
      ),
      RappiProduct(
        name: 'xiaomi mi 10t pro',
        description: 'Telefonazo calidad precio mi pana 😳',
        price: 12500.50,
        image:
            "https://www.teknofilo.com/wp-content/uploads/2020/09/Xiaomi-Mi-10T-Pro-render-4.jpg",
      ),
      RappiProduct(
        name: 'Mac mini M1',
        description: 'Lo unico calidad precio de apple xd',
        price: 18500,
        image:
            "https://help.apple.com/assets/5F494C35094622944F3B1EBB/5F494C47094622944F3B1EDA/es_419/d22a8f5456c847d4db6132a978d8c092.png",
      ),
    ],
  ),

  RappiCategory(
    name: 'Starters',
    products: [
      RappiProduct(
        name: 'Calculadora cientifica',
        description:
            'Casio, ideal para estudiantes de preparatoria o algun apuro en la Uni',
        price: 200.50,
        image:
            "https://ae01.alicdn.com/kf/HTB11MWINVXXXXbYaXXXq6xXFXXXw/Calculadora-Cient-fica-para-estudiante-calculadora-de-Funci-n-cient-fica-FX-82ES-PLUS-A.jpg_Q90.jpg_.webp",
      ),
      RappiProduct(
        name: 'Termo Mira',
        description: "Cilindro termico pal lonche",
        price: 320,
        image:
            "https://images-na.ssl-images-amazon.com/images/I/91Bu6%2BulCpL._AC_SX522_.jpg",
      ),
      RappiProduct(
        name: 'Calculadora cientifica',
        description:
            'Casio, ideal para estudiantes de preparatoria o algun apuro en la Uni',
        price: 200.50,
        image:
            "https://ae01.alicdn.com/kf/HTB11MWINVXXXXbYaXXXq6xXFXXXw/Calculadora-Cient-fica-para-estudiante-calculadora-de-Funci-n-cient-fica-FX-82ES-PLUS-A.jpg_Q90.jpg_.webp",
      ),
      RappiProduct(
        name: 'Termo Mira',
        description: "Cilindro termico pal lonche",
        price: 320,
        image:
            "https://images-na.ssl-images-amazon.com/images/I/91Bu6%2BulCpL._AC_SX522_.jpg",
      ),
    ],
  ),

  RappiCategory(
    name: 'Sides',
    products: [
      RappiProduct(
        name: 'Palomitas takis',
        description: 'El mejor festin cinefilo, te extraño palomitas takis 🥺',
        price: 60.50,
        image:
            "https://http2.mlstatic.com/D_NQ_NP_756168-MLM29078702311_122018-O.jpg",
      ),
      RappiProduct(
        name: 'Cafe Taro',
        description: "Extraño ir por un taro :') ",
        price: 34.50,
        image:
            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQuSDfdS696eomysppTjzJaeWxr6xQTVx4kkQ&usqp=CAU",
      ),
      RappiProduct(
        name: 'Palomitas takis',
        description: 'El mejor festin cinefilo, te extraño palomitas takis 🥺',
        price: 60.50,
        image:
            "https://http2.mlstatic.com/D_NQ_NP_756168-MLM29078702311_122018-O.jpg",
      ),
      RappiProduct(
        name: 'Cafe Taro',
        description: "Extraño ir por un taro :') ",
        price: 34.50,
        image:
            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQuSDfdS696eomysppTjzJaeWxr6xQTVx4kkQ&usqp=CAU",
      ),
    ],
  ),

  // replica xd
  RappiCategory(
    name: 'Orden Again 2',
    products: [
      RappiProduct(
        name: 'Silim Lights',
        description: 'Breef-Bibimbap mits Reis, Bohnen, Spinat, Karotten',
        price: 26.50,
        image:
            "https://images.homedepot-static.com/productImages/f5d04fe4-a2c8-4847-a2f6-8894dbff9434/svn/commercial-electric-recessed-lighting-trims-53808101-64_1000.jpg",
      ),
      RappiProduct(
        name: 'Neewe Kit',
        description: 'Lamparas para grabar videos xd',
        price: 5500,
        image:
            "https://images-na.ssl-images-amazon.com/images/I/71ibO0XJF9L._AC_SL1500_.jpg",
      ),
      RappiProduct(
        name: 'Silim Lights',
        description: 'Breef-Bibimbap mits Reis, Bohnen, Spinat, Karotten',
        price: 26.50,
        image:
            "https://images.homedepot-static.com/productImages/f5d04fe4-a2c8-4847-a2f6-8894dbff9434/svn/commercial-electric-recessed-lighting-trims-53808101-64_1000.jpg",
      ),
      RappiProduct(
        name: 'Neewe Kit',
        description: 'Lamparas para grabar videos xd',
        price: 5500,
        image:
            "https://images-na.ssl-images-amazon.com/images/I/71ibO0XJF9L._AC_SL1500_.jpg",
      ),
    ],
  ),

  RappiCategory(
    name: 'Picker For You 2',
    products: [
      RappiProduct(
        name: 'xiaomi mi 10t pro',
        description: 'Telefonazo calidad precio mi pana 😳',
        price: 12500.50,
        image:
            "https://www.teknofilo.com/wp-content/uploads/2020/09/Xiaomi-Mi-10T-Pro-render-4.jpg",
      ),
      RappiProduct(
        name: 'Mac mini M1',
        description: 'Lo unico calidad precio de apple xd',
        price: 18500,
        image:
            "https://help.apple.com/assets/5F494C35094622944F3B1EBB/5F494C47094622944F3B1EDA/es_419/d22a8f5456c847d4db6132a978d8c092.png",
      ),
      RappiProduct(
        name: 'xiaomi mi 10t pro',
        description: 'Telefonazo calidad precio mi pana 😳',
        price: 12500.50,
        image:
            "https://www.teknofilo.com/wp-content/uploads/2020/09/Xiaomi-Mi-10T-Pro-render-4.jpg",
      ),
      RappiProduct(
        name: 'Mac mini M1',
        description: 'Lo unico calidad precio de apple xd',
        price: 18500,
        image:
            "https://help.apple.com/assets/5F494C35094622944F3B1EBB/5F494C47094622944F3B1EDA/es_419/d22a8f5456c847d4db6132a978d8c092.png",
      ),
    ],
  ),

  RappiCategory(
    name: 'Starters 2',
    products: [
      RappiProduct(
        name: 'Calculadora cientifica',
        description:
            'Casio, ideal para estudiantes de preparatoria o algun apuro en la Uni',
        price: 200.50,
        image:
            "https://ae01.alicdn.com/kf/HTB11MWINVXXXXbYaXXXq6xXFXXXw/Calculadora-Cient-fica-para-estudiante-calculadora-de-Funci-n-cient-fica-FX-82ES-PLUS-A.jpg_Q90.jpg_.webp",
      ),
      RappiProduct(
        name: 'Termo Mira',
        description: "Cilindro termico pal lonche",
        price: 320,
        image:
            "https://images-na.ssl-images-amazon.com/images/I/91Bu6%2BulCpL._AC_SX522_.jpg",
      ),
      RappiProduct(
        name: 'Calculadora cientifica',
        description:
            'Casio, ideal para estudiantes de preparatoria o algun apuro en la Uni',
        price: 200.50,
        image:
            "https://ae01.alicdn.com/kf/HTB11MWINVXXXXbYaXXXq6xXFXXXw/Calculadora-Cient-fica-para-estudiante-calculadora-de-Funci-n-cient-fica-FX-82ES-PLUS-A.jpg_Q90.jpg_.webp",
      ),
      RappiProduct(
        name: 'Termo Mira',
        description: "Cilindro termico pal lonche",
        price: 320,
        image:
            "https://images-na.ssl-images-amazon.com/images/I/91Bu6%2BulCpL._AC_SX522_.jpg",
      ),
    ],
  ),

  RappiCategory(
    name: 'Sides 2',
    products: [
      RappiProduct(
        name: 'Palomitas takis',
        description: 'El mejor festin cinefilo, te extraño palomitas takis 🥺',
        price: 60.50,
        image:
            "https://http2.mlstatic.com/D_NQ_NP_756168-MLM29078702311_122018-O.jpg",
      ),
      RappiProduct(
        name: 'Cafe Taro',
        description: "Extraño ir por un taro :') ",
        price: 34.50,
        image:
            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQuSDfdS696eomysppTjzJaeWxr6xQTVx4kkQ&usqp=CAU",
      ),
      RappiProduct(
        name: 'Palomitas takis',
        description: 'El mejor festin cinefilo, te extraño palomitas takis 🥺',
        price: 60.50,
        image:
            "https://http2.mlstatic.com/D_NQ_NP_756168-MLM29078702311_122018-O.jpg",
      ),
      RappiProduct(
        name: 'Cafe Taro',
        description: "Extraño ir por un taro :') ",
        price: 34.50,
        image:
            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQuSDfdS696eomysppTjzJaeWxr6xQTVx4kkQ&usqp=CAU",
      ),
    ],
  ),
];
