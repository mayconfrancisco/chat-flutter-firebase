
import 'package:flutter/material.dart';

class ChatMessage extends StatelessWidget {

  final Map<String, dynamic> data;
  final bool mine;

  ChatMessage(this.data, this.mine);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Column(
        children: <Widget>[
          
          Row(
            children: <Widget>[
              mine 
                ? CircleAvatar(backgroundImage: NetworkImage(data['senderPhotoUrl']),)
                : Container(),
              
              Expanded(
                child: Container(
                  alignment: mine ? Alignment.centerLeft : Alignment.centerRight,
                  margin: EdgeInsets.symmetric(horizontal: 8),
                  // color: Colors.blue,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: mine ? Colors.blueGrey : Colors.black26),
                      color: mine ? Colors.blue : Colors.black12,
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                    ),
                    padding: EdgeInsets.all(8),
                    width: MediaQuery.of(context).size.width * 0.75,
                    child: data['text'] != null
                      ? Text(data['text'] != null ? data['text'] : '---')
                      : Image.network(data['imgUrl'])
                    ),
                )
              ),
              
              !mine 
                ? CircleAvatar(backgroundImage: NetworkImage(data['senderPhotoUrl']),)
                : Container(),
            ],
          ),

          Container(
            alignment: mine ? Alignment.centerLeft : Alignment.centerRight,
            margin: EdgeInsets.symmetric(horizontal: 48),
            child: Text(
              data['senderName'],
              style: TextStyle(
                fontSize: 12,
                color: Colors.black38,
              ),
            )
          )
        ],
      ),
    );
  }

}