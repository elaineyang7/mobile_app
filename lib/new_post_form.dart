
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:elaine_app/post_model.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';



class AddPostFormPage extends StatefulWidget {
  @override
  _AddPostFormPageState createState() => new _AddPostFormPageState();
}

class _AddPostFormPageState extends State<AddPostFormPage> {
  TextEditingController titleController = new TextEditingController();
  TextEditingController priceController = new TextEditingController();
  TextEditingController descriptionController = new TextEditingController();

  PermissionStatus _status;

  File _imageFile;

  var flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();


  @override
  void initState() {
    super.initState();
    PermissionHandler()
        .checkPermissionStatus(PermissionGroup.camera)
        .then(_updateStatus);

    super.initState();
    // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    var initializationSettingsAndroid =
    AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = IOSInitializationSettings();
    var initializationSettings = InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
  }

  void submitPup(context) {
    if (titleController.text.isEmpty) {
      Scaffold.of(context).showSnackBar(
        new SnackBar(
          backgroundColor: Colors.redAccent,
          content: new Text('Pups neeed title!'),
        ),
      );
    } else {
      var newPost = new Post(titleController.text, priceController.text,
          descriptionController.text);
      Navigator.of(context).pop(newPost);
    }
  }

  @override
  Widget build(BuildContext context) {

    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Add a new Post'),
        backgroundColor: Colors.deepPurpleAccent,
        actions: <Widget>[

        ],
      ),


      body: new Container(
        color: Colors.deepPurple[200],
        child: new Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 8.0,
            horizontal: 32.0,
          ),
          child: new Column(
            children: [
              new Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: new TextField(
                    controller: titleController,
                    decoration: new InputDecoration(
                      labelText: 'Title: ',
                    )),
              ),
              new Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: new TextField(
                    controller: priceController,
                    decoration: new InputDecoration(
                      labelText: "Price: ",
                    )),
              ),
              new Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: new TextField(
                    controller: descriptionController,
                    keyboardType: TextInputType.multiline,
                    maxLines: 4,
                    decoration: new InputDecoration(
                      labelText: 'Description: ',
                    )),
              ),

              new Row(
                //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new FlatButton.icon(
                    icon: Icon(Icons.add_a_photo),
                    label: Text('Add a Photo'),
                    onPressed: () {
                      _displayOptionsDialog();
                      //_buildImage();
                    },

                  ),
                  new FlatButton.icon(
                    icon: Icon(Icons.add_a_photo),
                    label: Text('Add a Photo'),
                    onPressed: () {
                      _displayOptionsDialog();
                    },
                  ),
                ],

              ),

              new Column(
                //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[

                  _imageFile == null
                      ? new Text('No photo selected.')
                      : new Image.file(
                        _imageFile//, width: 200, height: 100, fit: BoxFit.cover
                      ),
                  /*
                  _imageFile == null
                      ? new Text('No image selected.')
                      : new Image.file(
                        _imageFile//, width: 200, height: 100, fit: BoxFit.cover
                      ),

                   */

                ],
              ),

              new Padding(
                padding: const EdgeInsets.all(16.0),
                child: new Builder(
                  builder: (context) {
                    return new RaisedButton(
                      color: Colors.deepPurpleAccent,
                      child: new Text('Submit Pup'),
                      onPressed: () {
                        submitPup(context);
                        _showNotification;
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _displayOptionsDialog() async {
    await _optionsDialogBox();
  }

  Future<void> _optionsDialogBox() {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            content: new SingleChildScrollView(
              child: new ListBody(
                children: <Widget>[
                  GestureDetector(
                    child: new Text('Take Photo'),
                    onTap: _askPermission,
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                  ),
                  GestureDetector(
                    child: new Text('Select Image From Gallery'),
                    onTap: imageSelectorGallery,
                  ),
                ],
              ),
            ),
          );
        });
  }

  void _askPermission() {
    PermissionHandler()
        .requestPermissions([PermissionGroup.camera]).then(_onStatusRequested);
  }

  void _onStatusRequested(Map<PermissionGroup, PermissionStatus> value) {
    final status = value[PermissionGroup.camera];
    if (status == PermissionStatus.granted) {
      imageSelectorCamera();
    } else {
      _updateStatus(status);
    }
  }

  _updateStatus(PermissionStatus value) {
    if (value != _status) {
      setState(() {
        _status = value;
      });
    }
  }

  void imageSelectorCamera() async {
    Navigator.pop(context);
    var imageFile = await ImagePicker.pickImage(
      source: ImageSource.camera,
    );
    setState(() {
      _imageFile = imageFile;
    });
  }

  void imageSelectorGallery() async {
    Navigator.pop(context);
    var imageFile = await ImagePicker.pickImage(
    //var imageFile1 = await ImagePicker.pickImage(
      source: ImageSource.gallery,
    );
    setState(() {
      _imageFile = imageFile;
    });
  }


  Future<void> captureImage(ImageSource imageSource) async {
    try {
      final imageFile = await ImagePicker.pickImage(source: imageSource);
      setState(() {
        _imageFile = imageFile;
      });
    } catch (e) {
      print(e);
    }
  }

  Widget _buildImage() {
    if (_imageFile != null) {
      return Image.file(_imageFile);
    } else {
      return Text('Take an image to start', style: TextStyle(fontSize: 18.0));
    }
  }

  Future onSelectNotification(String payload) async {
    if (payload != null) {
      print('notification payload: ' + payload);
    }

    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SecondScreen(payload)),
    );
  }

  Future _showNotification() async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'your channel id', 'your channel name', 'your channel description',
        importance: Importance.Max, priority: Priority.High);
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);

//    await flutterLocalNotificationsPlugin.show(
//        0, 'plain title', 'plain body', platformChannelSpecifics,
//        payload: 'item x');

    String trendingNewsId = '1';
    await flutterLocalNotificationsPlugin.show(
        0, 'Trending News', 'Donald trump says windmill cause cancer. ', platformChannelSpecifics,
        payload: trendingNewsId);
  }
}

class SecondScreen extends StatefulWidget {
  final String payload;
  SecondScreen(this.payload);
  @override
  State<StatefulWidget> createState() => SecondScreenState();
}

class SecondScreenState extends State<SecondScreen> {
  String _payload;
  @override
  void initState() {
    super.initState();
    _payload = widget.payload;
  }

  var newsList = {
    1:"Anand Mahindra gets note from 11 year girl to curb noise pollution",
    2:"26 yr old engineer brings 10 pons back to life",
    5:"Donald trump says windmill cause cancer."
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Second Screen with payload"),
      ),
      body: Center(
        child: Center(
          child: Text(
            newsList[int.parse(_payload)],
            textDirection: TextDirection.ltr,
            style: TextStyle(
              fontSize: 17,
              color: Colors.black87,
            ),
          ),
        ),
      ),
    );
  }
}