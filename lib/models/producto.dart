class Producto {
  int id;
  String codigo_barras;
  String descripcion;
  String categoria;
  double precio_compra;
  double precio_venta;
  double existencia;
  String unidad_medida;
  String imagen;

  Producto(
    this.id, 
    this.codigo_barras, 
    this.descripcion, 
    this.categoria, 
    this.precio_compra,
    this.precio_venta, 
    this.existencia, 
    this.unidad_medida, 
    this.imagen
  );
}