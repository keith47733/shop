import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/product_item.dart';
import '../../providers/products.dart';
import '../../styles/layout.dart';

// Require a StatefulWidget since the Form will change local state.
class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit_product_screen';

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  // Initialize a GlobalKey for the Form and its TextFormFields.
  final _formKey = GlobalKey<FormState>();

  // Initialize TextEditingControllers.
  TextEditingController _titleController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _imageUrlController = TextEditingController();

  // Initialize FocusNode (to automatically load image when imageUrl TextFormField loses focus).
  FocusNode _imageUrlFocusNode = FocusNode();

  // This is essentially an empty ProductItem object (not null, but empty/zero values). productItemId is initially set to 'add'. This will be overwritten in the didChangeDependencies if an actual productItemId is passed as an argument to this screen.
  var _editedProduct = ProductItem(
    productItemId: 'add',
    title: '',
    price: 0.0,
    description: '',
    imageUrl: '',
    isFavourite: false,
  );

  // We'll use this variable so we don't run didChangeDependencies() too often.
  bool _isInit = true;

  @override
  void initState() {
    super.initState();
    // This adds a listener to the _imageUrlFocusNode. The void Function _updateImageUrl is called whenever there is a change to _imageUrlFocusNode by Setting the TextFormField() below.
    _imageUrlFocusNode.addListener(_updateImageUrl);
    // Remember ModalRoute doesn't work in initState(), but it will work in didChangeDependencies after the widget screen has been built.
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      // Extract productItemId argument passed by Navigator.
      final productItemId = ModalRoute.of(context)!.settings.arguments as String;
      // If EditProductScreen is pushNamed() without a productItemId argument, ModalRoute will return null. We only want to continue with setting _editedProduct and _initValues if the productItemId is not null.
      if (productItemId != 'add') {
        // Set _editedProduct (a ProdcutItem object) equal to the product returned by .findProductbyId() accessed through the Provider (with listen: false).
        _editedProduct = Provider.of<Products>(context, listen: false).findProductById(productItemId);
        _titleController.text = _editedProduct.title;
        _descriptionController.text = _editedProduct.description;
        _priceController.text = _editedProduct.price.toString();
        _imageUrlController.text = _editedProduct.imageUrl;
      }
    }
    _isInit = false;
  }

  @override
  void dispose() {
    super.dispose();
    // Must dispose controllers, focus nodes, and focus node listeners to prevent memory leaks.
    _titleController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    _imageUrlController.dispose();

    // Remove the listener before disposing the actual focusNode.
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _imageUrlFocusNode.dispose();
  }

  void _updateImageUrl() {
    final value = _imageUrlController.text;
    if (!_imageUrlFocusNode.hasFocus) {
      if (value == null) {
        return;
      }
      if (value.trim().isEmpty) {
        return;
      }
      if (!value.startsWith('http') || !value.startsWith('https')) {
        return;
      }
      setState(() {});
    }
  }

  void _saveForm() {
    if (_formKey.currentState == null) {
      return;
    }
    // _formKey.currentState!.validate() validates every TextFormField in Form and returns true if there are no errors.
    if (!_formKey.currentState!.validate()) {
      return;
    }
    // _formKey.currentState!.save(); will call the onSaved: for each TextFormField, thus building the _editedProduct object
    _formKey.currentState!.save();
    // We need to check whether we are adding or editing the current Product. One way is to check whether _editedProduct.productItemId == 'add' or an actual ProductItemId.
    if (_editedProduct.productItemId != 'add') {
      // Provider.of<Products>(context, listen: false) gives us access to the Products class .addproduct() method.
      Provider.of<Products>(context, listen: false).updateProduct(_editedProduct.productItemId, _editedProduct);
    } else {
      Provider.of<Products>(context, listen: false).addProduct(_editedProduct);
    }
    // Finally, go back to the UserProductsScreen.
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final formFieldDecoration = InputDecoration(
      floatingLabelBehavior: FloatingLabelBehavior.always,
      labelStyle: Theme.of(context).textTheme.titleLarge,
      errorStyle: Theme.of(context).textTheme.titleMedium!.copyWith(color: Theme.of(context).colorScheme.error),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Theme.of(context).colorScheme.onBackground, width: Layout.BORDER_WIDTH),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Theme.of(context).colorScheme.primary, width: Layout.BORDER_WIDTH),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Theme.of(context).colorScheme.error, width: Layout.BORDER_WIDTH),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Theme.of(context).colorScheme.error, width: Layout.BORDER_WIDTH),
      ),
    );

    return Scaffold(
      appBar: CustomAppBar(context, 'Edit Product'),
      body: BuildInputForm(context, formFieldDecoration),
    );
  }

  PreferredSizeWidget CustomAppBar(context, title) {
    return AppBar(
      title: Text(
        title,
        style: TextStyle(fontFamily: 'Merriweather'),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: Layout.SPACING / 2),
          child: IconButton(
            onPressed: _saveForm,
            icon: Icon(Icons.save),
          ),
        ),
      ],
    );
  }

  Widget BuildInputForm(context, formFieldDecoration) {
    return Form(
      // _formKey defined above is a <FormState> GlobakKey() that will allow us to interact with the state of the Form and its TextFormFields. Form() is actually a StatefulWidget behind the scenes.
      key: _formKey,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: Layout.SPACING * 1.5,
            horizontal: Layout.SPACING,
          ),
          child: Column(
            children: <Widget>[
              TextFormField(
                autofocus: true,
                // initialValue: _initValues['title'],
                decoration: formFieldDecoration.copyWith(labelText: 'Title'),
                keyboardType: TextInputType.text,
                controller: _titleController,
                textInputAction: TextInputAction.next,
                // Validator takes the current value of the input field, executes a function, and returns a string. Returning null indicates the input is acceptable. Returning a text will be your error text.
                // Value is the value in the input field.
                validator: (value) {
                  if (value == null) {
                    return 'Please enter a title';
                  }
                  if (value.trim().isEmpty) {
                    return 'Please enter a title';
                  }
                  if (value.trim().length < 5) {
                    return 'Please enter at least 5 characters for your title';
                  }
                  return null;
                },
                onSaved: (value) {
                  if (value != null) {
                    // Since ProductItem is immutable, ie the values are final in ProductItem class, you can't modify values of an existing object. Instead you have to re-instantiate _editedProduct with all the existing values except the one you want to change.
                    _editedProduct = ProductItem(
                      productItemId: _editedProduct.productItemId,
                      title: value,
                      description: _editedProduct.description,
                      price: _editedProduct.price,
                      imageUrl: _editedProduct.imageUrl,
                      isFavourite: _editedProduct.isFavourite,
                    );
                  }
                },
              ),
              SizedBox(height: Layout.SPACING * 1.5),
              TextFormField(
                // initialValue: _initValues['description'],
                decoration: formFieldDecoration.copyWith(labelText: 'Description'),
                keyboardType: TextInputType.multiline,
                maxLines: 3,
                controller: _descriptionController,
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value == null) {
                    return 'Please enter a description';
                  }
                  if (value.trim().isEmpty) {
                    return 'Please enter a description';
                  }
                  if (value.trim().length < 10) {
                    return 'Please enter at least 10 characters for your description';
                  }
                  return null;
                },
                onSaved: (value) {
                  if (value != null) {
                    _editedProduct = ProductItem(
                      productItemId: _editedProduct.productItemId,
                      title: _editedProduct.title,
                      description: value,
                      price: _editedProduct.price,
                      imageUrl: _editedProduct.imageUrl,
                      isFavourite: _editedProduct.isFavourite,
                    );
                  }
                },
              ),
              SizedBox(height: Layout.SPACING * 1.5),
              TextFormField(
                // initialValue: _initValues['price'],
                decoration: formFieldDecoration.copyWith(labelText: 'Price'),
                keyboardType: TextInputType.number,
                controller: _priceController,
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value == null) {
                    return 'Please enter a price';
                  }
                  if (value.trim().isEmpty) {
                    return 'Please enter a price';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number for the price';
                  }
                  if (double.parse(value) <= 0) {
                    return 'Please enter a price greater than zero';
                  }
                  return null;
                },
                onSaved: (value) {
                  if (value != null) {
                    _editedProduct = ProductItem(
                      productItemId: _editedProduct.productItemId,
                      title: _editedProduct.title,
                      description: _editedProduct.description,
                      price: double.parse(value),
                      imageUrl: _editedProduct.imageUrl,
                      isFavourite: _editedProduct.isFavourite,
                    );
                  }
                },
              ),
              SizedBox(height: Layout.SPACING * 1.5),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(Layout.RADIUS / 2),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.30,
                      height: MediaQuery.of(context).size.width * 0.30,
                      child: _imageUrlController.text.isEmpty
                          ? Padding(
                              padding: const EdgeInsets.all(Layout.SPACING / 4),
                              child: Center(
                                child: Text(
                                  'Please enter\na valid URL',
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            )
                          : FittedBox(
                              child: Image.network(
                                _imageUrlController.text,
                                fit: BoxFit.cover,
                              ),
                            ),
                    ),
                  ),
                  SizedBox(width: Layout.SPACING),
                  // TextFormField() takes all space available and so does the Row(). Need to wrap TextFormField() in Expanded().
                  Expanded(
                    child: TextFormField(
                      // initialValue: _initValues['imageUrl'],
                      decoration: formFieldDecoration.copyWith(labelText: 'Image URL'),
                      keyboardType: TextInputType.url,
                      controller: _imageUrlController,
                      // Can set up a listener of the imageUrlFocusNode.
                      focusNode: _imageUrlFocusNode,
                      onEditingComplete: () {
                        setState(() {});
                      },
                      textInputAction: TextInputAction.done,
                      validator: (value) {
                        if (value == null) {
                          return 'Please enter a URL for your product\'s image';
                        }
                        if (value.trim().isEmpty) {
                          return 'Please enter a URL for your product\'s image';
                        }
                        if (!value.startsWith('http') || !value.startsWith('https')) {
                          return 'Please enter a valid URL';
                        }
                        // Can improve the validator for the imageURL. eg, check it ends with jpg, jpeg, png.
                        return null;
                      },
                      onFieldSubmitted: (_) => _saveForm(),
                      onSaved: (value) {
                        if (value != null) {
                          _editedProduct = ProductItem(
                            productItemId: _editedProduct.productItemId,
                            title: _editedProduct.title,
                            description: _editedProduct.description,
                            price: _editedProduct.price,
                            imageUrl: value,
                            isFavourite: _editedProduct.isFavourite,
                          );
                        }
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
