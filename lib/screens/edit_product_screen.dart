import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/product.dart';
import 'package:shop_app/providers/products.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-product';
  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  var _editedProduct =
      Product(title: '', price: 0, description: '', imageUrl: '', id: null);
  var _initValues = {
    'title': '',
    'price': '',
    'description': '',
  };
  var _isInit = true;
  var _isLoading = false;

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final id = ModalRoute.of(context).settings.arguments as String;
      if (id != null) {
        _editedProduct = Provider.of<Products>(context).productById(id);
        _initValues['title'] = _editedProduct.title;
        _initValues['price'] = _editedProduct.price.toString();
        _initValues['description'] = _editedProduct.description;
        _imageUrlController.text = _editedProduct.imageUrl;
      }
      _isInit = false;
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _imageUrlFocusNode.dispose();
    _imageUrlController.dispose();

    super.dispose();
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      if ((!_imageUrlController.text.startsWith('http') &&
              !_imageUrlController.text.startsWith('https')) ||
          (!_imageUrlController.text.endsWith('.png') &&
              !_imageUrlController.text.endsWith('.jpg') &&
              !_imageUrlController.text.endsWith('.jpeg'))) {
        return;
      }
      setState(() {});
    }
  }

  Future<void> _saveForm() async {
    if (!_formKey.currentState.validate()) return;
    _formKey.currentState.save();
    if (_editedProduct.id == null) {
      setState(() {
        _isLoading = true;
      });

      var products = Provider.of<Products>(context, listen: false);
      try {
        await products.addProducts(_editedProduct);
      } catch (_) {
        await showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: Text('An Error Occurred'),
                  content: Text('Something Went Wrong'),
                  actions: <Widget>[
                    FlatButton(
                      child: Text('Ok'),
                      onPressed: () => Navigator.pop(ctx),
                    )
                  ],
                ));
      }
//
    } else {
      setState(() {
        _isLoading = true;
      });

      await Provider.of<Products>(context, listen: false)
          .updateProducts(_editedProduct.id, _editedProduct);
//      setState(() {
//        _isLoading = false;
//      });
//      Navigator.pop(context);
    }
    setState(() {
      _isLoading = false;
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Product'),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.save), onPressed: () => _saveForm())
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: <Widget>[
                    TextFormField(
                      initialValue: _initValues['title'],
                      decoration: InputDecoration(
                        labelText: 'Title',
                      ),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) =>
                          FocusScope.of(context).requestFocus(_priceFocusNode),
                      onSaved: (val) => _editedProduct = Product(
                        id: _editedProduct.id,
                        imageUrl: _editedProduct.imageUrl,
                        price: _editedProduct.price,
                        description: _editedProduct.description,
                        title: val,
                        isFavorite: _editedProduct.isFavorite,
                      ),
                      validator: (val) {
                        if (val.isEmpty) return 'Please Provide a Name';
                        return null;
                      },
                    ),
                    TextFormField(
                      initialValue: _initValues['price'],
                      decoration: InputDecoration(
                        labelText: 'Price',
                      ),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      focusNode: _priceFocusNode,
                      onFieldSubmitted: (_) => FocusScope.of(context)
                          .requestFocus(_descriptionFocusNode),
                      onSaved: (val) => _editedProduct = Product(
                        id: _editedProduct.id,
                        imageUrl: _editedProduct.imageUrl,
                        price: double.parse(val),
                        description: _editedProduct.description,
                        title: _editedProduct.title,
                        isFavorite: _editedProduct.isFavorite,
                      ),
                      validator: (val) {
                        if (val.isEmpty) return 'Price Must Not Be Empty';
                        if (double.tryParse(val) == null)
                          return 'It Must be Valid Number';
                        if (double.parse(val) <= 0)
                          return 'Enter Price GraterThan 0';
                        return null;
                      },
                    ),
                    TextFormField(
                      initialValue: _initValues['description'],
                      decoration: InputDecoration(
                        labelText: 'Description',
                      ),
                      maxLines: 3,
                      keyboardType: TextInputType.multiline,
                      focusNode: _descriptionFocusNode,
                      onSaved: (val) => _editedProduct = Product(
                        id: _editedProduct.id,
                        imageUrl: _editedProduct.imageUrl,
                        price: _editedProduct.price,
                        description: val,
                        title: _editedProduct.title,
                        isFavorite: _editedProduct.isFavorite,
                      ),
                      validator: (val) {
                        if (val.isEmpty) return 'Description Must Not be Empty';
                        if (val.length < 15)
                          return 'Description must be Grater than 15 characters';
                        return null;
                      },
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Container(
                          height: 100,
                          width: 100,
                          margin: EdgeInsets.only(top: 8, right: 10),
                          decoration: BoxDecoration(
                            border: Border.all(width: 1, color: Colors.grey),
                          ),
                          child: _imageUrlController.text.isEmpty
                              ? Text('Enter Url')
                              : FittedBox(
                                  child: Image.network(
                                  _imageUrlController.text,
                                  fit: BoxFit.cover,
                                )),
                        ),
                        Expanded(
                          child: TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Image Url',
                            ),
                            textInputAction: TextInputAction.done,
                            controller: _imageUrlController,
                            focusNode: _imageUrlFocusNode,
                            keyboardType: TextInputType.url,
                            onFieldSubmitted: (_) => _saveForm(),
                            onSaved: (val) => _editedProduct = Product(
                              id: _editedProduct.id,
                              imageUrl: val,
                              price: _editedProduct.price,
                              description: _editedProduct.description,
                              title: _editedProduct.title,
                              isFavorite: _editedProduct.isFavorite,
                            ),
                            validator: (v) {
                              if (v.isEmpty) return 'Enter Img Url';
                              if (!v.startsWith('http') &&
                                  !v.startsWith('https'))
                                return 'Enter a Valid Url';
                              if (!v.endsWith('.png') &&
                                  !v.endsWith('.jpg') &&
                                  !v.endsWith('.jpeg'))
                                return 'Enter a Valid Image url';
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
