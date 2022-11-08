import 'package:flutter/material.dart';

import '../../styles/layout.dart';

// Require a StatefulWidget since the Form will change local state.
class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit_product_screen';

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  TextEditingController _imageUrlController = TextEditingController();
  FocusNode _imageUrlFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // This adds a listener to the _imageUrlFocusNode. The void Function _updateImageUrl is called whenever there is a change to _imageUrlFocusNode by Setting the TextFormField() below.
    _imageUrlFocusNode.addListener(_updateImageUrl);
  }

  @override
  void dispose() {
    super.dispose();
    _imageUrlController.dispose();
    // Remove the listener before disposing the actual focusNode.
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _imageUrlFocusNode.dispose();
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final formFieldDecoration = InputDecoration(
      floatingLabelBehavior: FloatingLabelBehavior.always,
      labelStyle: Theme.of(context).textTheme.titleLarge,
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Theme.of(context).colorScheme.onBackground, width: Layout.BORDER_WIDTH),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Theme.of(context).colorScheme.onBackground, width: Layout.BORDER_WIDTH),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Theme.of(context).colorScheme.error, width: Layout.BORDER_WIDTH),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Theme.of(context).colorScheme.error, width: Layout.BORDER_WIDTH),
      ),
    );

    // ADD DISPOSE METHOD

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
            onPressed: () {
              // Navigator.of(context).pushNamed(ProductsScreen.routeName);
            },
            icon: Icon(Icons.add_shopping_cart),
          ),
        ),
      ],
    );
  }

  Widget BuildInputForm(context, formFieldDecoration) {
    return Form(
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
                decoration: formFieldDecoration.copyWith(labelText: 'Title'),
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
              ),
              SizedBox(height: Layout.SPACING * 1.5),
              TextFormField(
                decoration: formFieldDecoration.copyWith(labelText: 'Price'),
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
              ),
              SizedBox(height: Layout.SPACING * 1.5),
              TextFormField(
                decoration: formFieldDecoration.copyWith(labelText: 'Description'),
                keyboardType: TextInputType.multiline,
                maxLines: 3,
                textInputAction: TextInputAction.next,
              ),
              SizedBox(height: Layout.SPACING * 1.5),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(Layout.RADIUS / 2),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.30,
                      height: MediaQuery.of(context).size.width * 0.30,
                      decoration: BoxDecoration(
                          // color: Theme.of(context).colorScheme.secondary,
                          // border: Border.all(width: 1.0),
                          ),
                      child: _imageUrlController.text.isEmpty
                          ? Padding(
                              padding: const EdgeInsets.all(Layout.SPACING / 4),
                              child: Center(
                                child: Text(
                                  'Enter a\nvalid URL',
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
                      decoration: formFieldDecoration.copyWith(labelText: 'Image URL'),
                      keyboardType: TextInputType.url,
                      controller: _imageUrlController,
                      // Can set up a listener of the imageUrlFocusNode.
                      focusNode: _imageUrlFocusNode,
                      onEditingComplete: () {
                        setState(() {});
                      },
                      textInputAction: TextInputAction.done,
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
