import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tflite/tflite.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _loading = true;
  File? _image;
  List<dynamic>? _output;
  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    loadModel().then((value) {
      setState(() {
        // Model loaded successfully
      });
    });
  }

  detectImage(File image) async {
    var output = await Tflite.runModelOnImage(
      path: image.path,
      numResults: 12, // Adjusted for 12 classes
      threshold: 0.6,
      imageMean: 127.5,
      imageStd: 127.5,
    );

    setState(() {
      _output = output;
      _loading = false;
    });
  }

  loadModel() async {
    await Tflite.loadModel(
      model: 'assets/flutterml.tflite',
      labels: 'assets/labels.txt',
    );
  }

  @override
  void dispose() {
    Tflite.close(); // Ensure to release resources
    super.dispose();
  }

  pickImage() async {
    var image = await picker.pickImage(source: ImageSource.camera);
    if (image == null) return;

    setState(() {
      _image = File(image.path);
    });

    detectImage(_image!);
  }

  pickGalleryImage() async {
    var image = await picker.pickImage(source: ImageSource.gallery);
    if (image == null) return;

    setState(() {
      _image = File(image.path);
    });

    detectImage(_image!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xffEBE3D6), Color(0xfff39361)],
            stops: [0.0025, 0.7],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          ),
        ),
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 50),
            Container(
              padding: EdgeInsets.only(left: 45),
              child: Text(
                'Sugarcane Classifier',
                style: GoogleFonts.aDLaMDisplay(
                  fontSize: 30,
                  fontWeight: FontWeight.w300,
                  color: Colors.black,
                ),
              ),
            ),
            SizedBox(height: 50),
            Center(
              child: _loading
                  ? Container(
                child: Column(
                  children: <Widget>[
                    Image.asset(
                      'assets/images/sugarcane.png',
                      height: 170,
                      width: 220,
                    ),
                  ],
                ),
              )
                  : Container(
                child: Column(
                  children: <Widget>[
                    Container(
                      height: 250,
                      child: _image != null ? Image.file(_image!) : Container(),
                    ),
                    SizedBox(height: 20),
                    _output != null
                        ? Text(
                      '${_output![0]['label']}',
                      style: TextStyle(color: Colors.black, fontSize: 15),
                    )
                        : Container(),
                    SizedBox(height: 10),
                  ],
                ),
              ),
            ),
            SizedBox(height: 130),
            Container(
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      pickImage();
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width - 212,
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(horizontal: 25, vertical: 18),
                      decoration: BoxDecoration(
                        color: Colors.orangeAccent,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: Colors.black, width: 2),
                      ),
                      child: Text(
                        'Capture a photo',
                        style: GoogleFonts.raleway(fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
                  GestureDetector(
                    onTap: () {
                      pickGalleryImage();
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width - 212,
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(horizontal: 25, vertical: 18),
                      decoration: BoxDecoration(
                        color: Colors.orangeAccent,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: Colors.black, width: 2),
                      ),
                      child: Text(
                        'Select from Gallery',
                        style: GoogleFonts.raleway(fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:tflite/tflite.dart';
// import 'package:image_picker/image_picker.dart';
//
// class HomeScreen extends StatefulWidget {
//
//   const HomeScreen({super.key});
//
//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<HomeScreen> {
//   bool _loading =true;
//   File _image;
//   List _output;
//   final picker = ImagePicker();
//
//   @override
//   void initState(){
//     super.initState();
//     loadModel().then((value){
//         setState(() {
//
//         });
//     })
//   }
//
//   detectImage(File image) async{
//     var output = await Tflite.runModelOnImage(
//         path: image.path,
//         numResults: 2,
//         threshold: 0.6,
//         imageMean: 127.5,
//         imageStd: 127.5);
//
//
//   setState(() {
//     _output = output;
//     _loading =false;
//   });
//   }
//
//   loadModel() async{await Tflite.loadModel(model: 'assets/flutterml.tflite',labels:'assets/labels.txt');}
//   @override
//   void dispose() {
//     // TODO: implement dispose
//     super.dispose();
//   }
//   pickImage() async{
//     var image = await picker.getImage(source:ImageSource.camera)
//         if(image == null) return null;
//         setState(() {
//           _image = File(image.path);
//         });
//
//         detectImage(_image);
//   }
//
//   pickGalleryImage() async{
//     var image = await picker.getImage(source:ImageSource.gallery);
//     if(image == null) return null;
//     setState(() {
//       _image = File(image.path);
//     });
//
//     detectImage(_image);
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//
//       body: Container(
//         // Use MediaQuery to ensure the container covers the entire screen
//         width: MediaQuery.of(context).size.width,
//         height: MediaQuery.of(context).size.height,
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             colors: [Color(0xffEBE3D6), Color(0xfff39361)],
//             stops: [0.0025,0.7],
//             begin: Alignment.topRight,
//             end: Alignment.bottomLeft,
//           ),
//         ),
//         padding: EdgeInsets.symmetric(horizontal: 24),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: <Widget>[
//             SizedBox(height: 50),
//             Container(
//               padding: EdgeInsets.only(left:45),
//               child: Text(
//                 'Sugarcane Classifier',
//                 style: GoogleFonts.aDLaMDisplay(
//                   fontSize: 30,
//                   fontWeight: FontWeight.w300,
//                   color: Colors.black,
//                 ),
//               ),
//             ),
//             SizedBox(height: 50),
//             Center(
//               child: _loading ? Container(child: Column(children:<Widget>[
//                 Image.asset('assets/images/sugarcane.png',height: 170,width: 220,)
//               ]),):Container(
//                 child: Column(children: <Widget>[
//                   Container(
//                     height: 250,
//                     child: Image.file(_image),
//                   ),
//                   SizedBox(height: 20),
//                   _output != null ? Text('${_output[0]['label']}',style: TextStyle(color: Colors.black,fontSize: 15),) : Container(),
//                   SizedBox(height: 10),
//                 ],),
//               )
//             ),
//             SizedBox(height: 130),
//             Container(
//             width: MediaQuery.of(context).size.width,
//               child: Column(children: <Widget>[
//                 GestureDetector(onTap: (){pickImage();},child: Container(
//                   width: MediaQuery.of(context).size.width -212,
//                   alignment: Alignment.center,
//                   padding: EdgeInsets.symmetric(horizontal: 25,vertical: 18),
//                 decoration: BoxDecoration(
//                     color: Colors.orangeAccent,borderRadius: BorderRadius.circular(6),
//                 border: Border.all(color: Colors.black,width: 2))
//                   , child: Text(
//                   'Capture a photo',
//                   style: GoogleFonts.raleway(fontSize: 15,fontWeight: FontWeight.bold),),),),
//                 SizedBox(height: 15),
//                 GestureDetector(onTap: (){pickGalleryImage();},child: Container(
//                   width: MediaQuery.of(context).size.width -212,
//                   alignment: Alignment.center,
//                   padding: EdgeInsets.symmetric(horizontal: 25,vertical: 18),
//                   decoration: BoxDecoration(
//                       color: Colors.orangeAccent,borderRadius: BorderRadius.circular(6),
//                       border: Border.all(color: Colors.black,width: 2))
//                   , child: Text(
//                   'Select from Gallery',
//                   style: GoogleFonts.raleway(fontSize: 15,fontWeight: FontWeight.bold),),),),
//
//               ],),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
