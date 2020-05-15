import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class TextComposer extends StatefulWidget {
  TextComposer(this.sendMessage);
  final Function({String text, File imgFile}) sendMessage;

  @override
  State<StatefulWidget> createState() => _TextComposerState();
}

/*
 * State class
 */
class _TextComposerState extends State<TextComposer> {
  bool _isComposing = false;
  TextEditingController _sendMessageTEController = TextEditingController();

  _reset() {
    _sendMessageTEController.clear();
    setState(() {
      _isComposing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Row(
        children: <Widget>[
          
          IconButton(
            icon: Icon(Icons.photo_camera),
            onPressed: () async {
              File imgFile = await ImagePicker.pickImage(source: ImageSource.camera);
              if (imgFile == null) return;
              widget.sendMessage(imgFile: imgFile);
            }
          ),

          Expanded(
            child: TextField(
              controller: _sendMessageTEController,
              decoration: InputDecoration.collapsed(hintText: 'Enviar uma mensagem'),
              onChanged: (text) {
                setState(() {
                  _isComposing = text.isNotEmpty;
                });
              },
              onSubmitted: (text) {
                widget.sendMessage(text: text);
                _reset();
              },
            ),
          ),

          IconButton(
            icon: Icon(Icons.send), 
            onPressed: _isComposing
            ? () {
              widget.sendMessage(text: _sendMessageTEController.text);
              _reset();
            }
            : null
          ),
        ],
      ),
    );
  }

}