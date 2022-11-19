import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/http_exception.dart';
import '../../providers/inventory.dart';
import '../../providers/product.dart';
import '../../styles/form_field_decoration.dart';
import '../../styles/layout.dart';
import '../../widgets/my_snack_bar.dart';
import '../../widgets/show_error_dialog.dart';
import '../../widgets/sub_appbar.dart';

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

  var _editedProduct = Product(
    productId: 'add',
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
        _editedProduct = Provider.of<Inventory>(context, listen: false).findProductById(productItemId);
        _titleController.text = _editedProduct.title;
        _descriptionController.text = _editedProduct.description;
        _priceController.text = _editedProduct.price.toStringAsFixed(2);
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
    final tempImageUrl = _imageUrlController.text;
    if (!_imageUrlFocusNode.hasFocus) {
      if (tempImageUrl.trim().isEmpty) {
        return;
      }
      if (!tempImageUrl.startsWith('http') || !tempImageUrl.startsWith('https')) {
        return;
      }
      setState(() {});
    }
  }

  void _saveForm() async {
    FocusScope.of(context).unfocus();

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

    if (_editedProduct.productId == 'add') {
      try {
        await Provider.of<Inventory>(context, listen: false).addProduct(_editedProduct);
        setState(() {
          _isLoading = false;
        });
        Navigator.of(context).pop();
        MySnackBar(context, '${_editedProduct.title} was added to Your Products');
      } on HttpException catch (httpError) {
        Navigator.of(context).pop();
        showErrorDialog(context, 'Authentication error', 'Unable to add product to your inventory. Please try again later.');
      } catch (error) {
        Navigator.of(context).pop();
        showErrorDialog(context, 'Server error', 'Unable to add product to your inventory. Please try again later.');
      }
    }

    if (_editedProduct.productId != 'add') {
      try {
        await Provider.of<Inventory>(context, listen: false).updateProduct(_editedProduct.productId, _editedProduct);
        setState(() {
          _isLoading = false;
        });
        Navigator.of(context).pop();
        MySnackBar(context, 'Updated ${_editedProduct.title}');
      } on HttpException catch (httpError) {
        Navigator.of(context).pop();
        showErrorDialog(context, 'Authentication error', 'Unable to update ${_editedProduct.title}. Please try again later.');
      } catch (error) {
        Navigator.of(context).pop();
        showErrorDialog(context, 'Server error', 'Unable to update ${_editedProduct.title}. Please try again later.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _editedProduct.productId == 'add'
          ? SubAppbar('Add Product', Icon(Icons.save), _saveForm)
          : SubAppbar('Edit Product', Icon(Icons.save), _saveForm),
      body: _isLoading ? Center(child: CircularProgressIndicator()) : BuildInputForm(context),
    );
  }

  Widget BuildInputForm(context) {
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
              TitleFormField(),
              SizedBox(height: Layout.SPACING * 1.5),
              DescriptionFormField(),
              SizedBox(height: Layout.SPACING * 1.5),
              PriceFormField(),
              SizedBox(height: Layout.SPACING * 1.5),
              ImagePreview(),
              SizedBox(height: Layout.SPACING * 1.5),
              ImageUrlFormField(),
            ],
          ),
        ),
      ),
    );
  }

  Widget TitleFormField() {
    return TextFormField(
      autofocus: true,
      decoration: formFieldDecoration(context).copyWith(labelText: 'Title'),
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
          _editedProduct = Product(
            productId: _editedProduct.productId,
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

  Widget DescriptionFormField() {
    return TextFormField(
      decoration: formFieldDecoration(context).copyWith(labelText: 'Description'),
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
          _editedProduct = Product(
            productId: _editedProduct.productId,
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

  Widget PriceFormField() {
    return TextFormField(
      decoration: formFieldDecoration(context).copyWith(labelText: 'Price'),
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
          _editedProduct = Product(
            productId: _editedProduct.productId,
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

  Widget ImageUrlFormField() {
    return TextFormField(
      decoration: formFieldDecoration(context).copyWith(labelText: 'Image Url'),
      keyboardType: TextInputType.url,
      controller: _imageUrlController,
      focusNode: _imageUrlFocusNode,
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
      onSaved: (value) {
        if (value != null) {
          _editedProduct = Product(
            productId: _editedProduct.productId,
            title: _editedProduct.title,
            description: _editedProduct.description,
            price: _editedProduct.price,
            imageUrl: value,
            isFavourite: _editedProduct.isFavourite,
          );
        }
      },
    );
  }

  Widget ImagePreview() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(Layout.RADIUS / 2),
      child: SizedBox(
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
            : Image.network(
              _imageUrlController.text,
              fit: BoxFit.cover,
            ),
      ),
    );
  }
}
