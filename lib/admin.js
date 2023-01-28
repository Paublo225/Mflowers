

var zakaz = [{id: "123", price:44,quantity:890},{id: "221", price:544,quantity:761}];
var result = zakaz.map(order => ({id:order.id, price: order.price,quantity:order.quantity}));
result.forEach( function( currentValue, index, arr ) {
    console.log(arr[index]);
}); 
