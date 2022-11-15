import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/product_item.dart';
import '../../providers/products.dart';
import '../../styles/layout.dart';
import '../../widgets/my_app_bar.dart';
import '../../widgets/my_snack_bar.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit_product_screen';

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  bool _isLoading = false;

  final _formKey = GlobalKey<FormState>();

  TextEditingController _titleController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _imageUrlController = TextEditingController();

  FocusNode _imageUrlFocusNode = FocusNode();

  var _editedProduct = ProductItem(
    productItemId: 'add',
    title: '',
    price: 0.0,
    description: '',
    imageUrl: '',
    isFavourite: false,
  );

  bool _isInit = true;

  @override
  void initState() {
    super.initState();
    _imageUrlFocusNode.addListener(_updateImageUrl);
  }

  @override
  void didChangeDependencies() {
		super.didChangeDependencies();
    if (_isInit) {
      final productItemId = ModalRoute.of(context)!.settings.arguments as String;
      if (productItemId != 'add') {
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
    _titleController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    _imageUrlController.dispose();

    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _imageUrlFocusNode.dispose();
  }

  void _updateImageUrl() {
    final value = _imageUrlController.text;
    if (!_imageUrlFocusNode.hasFocus) {
      if (value.trim().isEmpty) {
        return;
      }
      if (!value.startsWith('http') || !value.startsWith('https')) {
        return;
      }
      setState(() {});
    }
  }

  Future<void> _saveForm() async {
    FocusScope.of(context).unfocus();
    await Future.delayed(Duration(milliseconds: 500));

    if (_formKey.currentState == null) {
      return;
    }
    if (!_formKey.currentState!.validate()) {
      return;
    }

    _formKey.currentState!.save();

    setState(() {
      _isLoading = true;
    });

    if (_editedProduct.productItemId == 'add') {
      bool isError = false;
      try {
        await Provider.of<Products>(context, listen: false).addProduct(_editedProduct);
      } catch (error) {
        isError = true;
        await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('Error'),
            content: Text("Something went wrong"),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
                child: Text('Okay'),
              ),
            ],
          ),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
        Navigator.of(context).pop();
        if (!isError) {
          MySnackBar(context, '${_editedProduct.title} added to Your Products');
        }
      }
    } else {
      await Provider.of<Products>(context, listen: false).updateProduct(_editedProduct.productItemId, _editedProduct);
      setState(() {
        _isLoading = false;
      });
      Navigator.of(context).pop();
      MySnackBar(context, 'Updated ${_editedProduct.title}');
    }
  }

  @override
  Widget build(BuildContext context) {
    _imageUrlController.text = 'https://usa.yamaha.com/files/FGX5_f_0001_e000fdbd6d63dc6bc6c8f28e44819bf7.jpg';
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
      appBar: _editedProduct.productItemId == 'add'
          ? MyAppBar('Add Product', Icon(Icons.save), _saveForm)
          : MyAppBar('Edit Product', Icon(Icons.save), _saveForm),
      body: _isLoading ? Center(child: CircularProgressIndicator()) : BuildInputForm(context, formFieldDecoration),
    );
  }

  Widget BuildInputForm(context, formFieldDecoration) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: Layout.SPACING * 1.5,
            horizontal: Layout.SPACING,
          ),
          child: Column(
            children: <Widget>[
              TitleFormField(formFieldDecoration),
              SizedBox(height: Layout.SPACING * 1.5),
              DescriptionFormField(formFieldDecoration),
              SizedBox(height: Layout.SPACING * 1.5),
              PriceFormField(formFieldDecoration),
              SizedBox(height: Layout.SPACING * 1.5),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  ImagePreview(),
                  SizedBox(width: Layout.SPACING),
                  ImageUrlFormField(formFieldDecoration),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget TitleFormField(formFieldDecoration) {
    return TextFormField(
      autofocus: true,
      decoration: formFieldDecoration.copyWith(labelText: 'Title'),
      keyboardType: TextInputType.text,
      controller: _titleController,
      textInputAction: TextInputAction.next,
      validator: (value) {
        if (value == null) {
          return 'Please enter a title';
        }
        if (value.trim().isEmpty) {
          return 'Please enter a title';
        }
        if (value.trim().length < 5) {
          return 'Please enter at least 5 characters';
        }
        return null;
      },
      onSaved: (value) {
        if (value != null) {
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
    );
  }

  Widget DescriptionFormField(formFieldDecoration) {
    return TextFormField(
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
          return 'Please enter at least 10 characters';
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
    );
  }

  Widget PriceFormField(formFieldDecoration) {
    return TextFormField(
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
    );
  }

  Widget ImagePreview() {
    return ClipRRect(
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
    );
  }

  Widget ImageUrlFormField(formFieldDecoration) {
    return Expanded(
      child: TextFormField(
        decoration: formFieldDecoration.copyWith(labelText: 'Image URL'),
        keyboardType: TextInputType.url,
        controller: _imageUrlController,
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
    );
  }
}
