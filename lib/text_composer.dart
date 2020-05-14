
import 'package:flutter/material.dart';

class TextComposer extends StatefulWidget {
  TextComposer(this.sendMessage);
  final Function(String) sendMessage;

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
            onPressed: () {

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
                widget.sendMessage(text);
                _reset();
              },
            ),
          ),

          IconButton(
            icon: Icon(Icons.send), 
            onPressed: _isComposing
            ? () {
              widget.sendMessage(_sendMessageTEController.text);
              _reset();
            }
            : null
          ),
        ],
      ),
    );
  }

}