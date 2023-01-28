/*import 'package:flowers0/model/data.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

const categoryHeight = 55.0;
const productHeight = 110.0;

class RappiBLoC with ChangeNotifier {
  List<RappiTabCategory> tabs =
      []; //Inicializamos la lista de tipo RappiTabCategory
  List<RappiItem> items = []; //El arreglo de items
  TabController tabController;
  ScrollController scrollController = ScrollController();
  bool _listen = true; //para quitar el glitch del scroll horizontal

  void init(TickerProvider ticker) {
    tabController = TabController(
        length: rappiCategories.length,
        vsync: ticker //Se le asigna el vsync del widget de la pantalla
        );

    double offsetFrom = 0.0; //al entrar a la pagina empieza en 0
    double offsetTo = 0.0;

    for (int i = 0; i < rappiCategories.length; i++) {
      final category = rappiCategories[i];

      if (i > 0) {
        offsetFrom +=
            rappiCategories[i - 1].products.length.toDouble() * productHeight;
        //Se le asigna la altura de los productos totales por categoria que hay que recorrer 👀
      }

      if (i < rappiCategories.length - 1) {
        //Se trae el ofset del que sigue
        offsetTo = offsetFrom +
            rappiCategories[i + 1].products.length.toDouble() * productHeight;
      } else {
        //Si es el ultimo
        offsetTo = double.infinity; //lo dirige al ultimo
      }

      tabs.add(RappiTabCategory(
        category: category,
        selected: (i == 0)
            ? true
            : false, //Si es el primer elemento por defecto es true
        offsetFrom: (categoryHeight * i) +
            offsetFrom, //Se le agrega el valor propios de las categorias
        offsetTo: offsetTo,
      )); //add

      items.add(RappiItem(category: category)); //Se agrega la categoria
      for (int j = 0; j < category.products.length; j++) {
        final product = category.products[j];
        items.add(RappiItem(product: product)); //Ahora los productos
      }
    } //ciclo de asignacion

    scrollController.addListener(_onScrollListener);
  } //init

  void _onScrollListener() {
    //para el SELECCIONAR el Tab horizontal en base al scroll horizontal
    if (_listen) {
      //Si tienes que escuchar, haz esto
      for (int i = 0; i < tabs.length; i++) {
        final tab = tabs[i]; //El tab actual
        if ((scrollController.offset >= tab.offsetFrom) &&
            (scrollController.offset <=
                tab.offsetTo) && //Si estoy en cierta categoria vertical
            (!tab.selected)) {
          // de la cual no tengo seleccionado su tab

          onCategorySelected(i,
              animationRequired:
                  false); //le paso la categoria en la que esta para que se acomode solo
          tabController.animateTo(
              i); //Para que lo podamos ver si estamos en un tab lejano

          break;
        }
      }
    } // if (_listen)
  }

  void onCategorySelected(int index, {bool animationRequired = true}) async {
    final selected = tabs[index];
    for (int i = 0; i < tabs.length; i++) {
      tabs[i] = tabs[i].copyWith(tabs[i] == selected);
      //Si la tabCategory es la que se selecciono en el tabController
      //Se reemplazan los objetos cuando son seleccionados
    }
    notifyListeners(); //Se notifica al listener para que se haga el cambio al clonado xd

    if (animationRequired) {
      _listen =
          false; //se bloquea esta animacion para no hacer un glich con 2 en el horizontal
      await scrollController.animateTo(
          selected.offsetFrom, // desde que altura o elemento se hara el scroll
          duration: const Duration(milliseconds: 500),
          curve: Curves.linear);
      _listen = true;
    }
  }

  @override
  void dispose() {
    scrollController.removeListener(
        _onScrollListener); //Para el Scroll automatico horizontal de tabs
    scrollController.dispose(); //para el scroll automatico vertical
    tabController.dispose();
    super.dispose();
  }
} //class RappiBLoC

class RappiTabCategory {
  const RappiTabCategory(
      {@required this.category,
      @required this.selected,
      @required this.offsetFrom,
      @required this.offsetTo});

  RappiTabCategory copyWith(bool selected) => RappiTabCategory(
      category: category,
      selected: selected,
      offsetFrom: offsetFrom,
      offsetTo: offsetTo);
  //Se clona el objeto Solo Si es seleccionado y, se pone su elevation y opaciodad para crear la animacion

  final RappiCategory category;
  final bool selected; //Estado de seleccionado o no la categoria

  final double
      offsetFrom; //para poder definir cuanto hacer scroll (desde donde se hará)
  final double offsetTo;
}

class RappiItem {
  const RappiItem({this.category, this.product});

  final RappiCategory category;
  final RappiProduct product;
  bool get isCategory => category != null; //Si no es nulo es true el isCategory

}
*/