import 'package:flutter/material.dart'; //basic UI components
import 'package:audioplayers/audioplayers.dart';//sounds for warning,alert
import 'package:google_fonts/google_fonts.dart'; //to get various nicer font


void main() {
  runApp(const DeadlineCheckerApp());
}

class DeadlineCheckerApp extends StatelessWidget { //no changing state, so stateless widget is used
  const DeadlineCheckerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp( //main app container
      title: 'Deadline Checker',
      debugShowCheckedModeBanner: false, //removes debug banner,
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal), useMaterial3: true),
      home: DeadlinePage(), //homepage
    );
  }
}

class DeadlinePage extends StatefulWidget { //stateful widget for dynamic content
  const DeadlinePage({super.key});

  @override
  _DeadlinePageState createState() => _DeadlinePageState();
}

class _DeadlinePageState extends State<DeadlinePage> {
  TextEditingController daysController = TextEditingController(); //this is where we get user input
  String result = ''; //this is where we store output text
  String imagePath = 'assets/images/deadline.png'; // this part controls which image that shows

  final AudioPlayer audioPlayer = AudioPlayer(); //audio playing

  void checkDeadline() async {
    int days = int.tryParse(daysController.text) ?? 0;
    
    if (days > 5) {
      setState(() {
        result = 'You can still relax, PHEW!';
        imagePath = 'assets/images/relax.png'; //future image
      });
      await audioPlayer.play(AssetSource('sounds/phew.mp3')); //play relax sound
    } else if (days >= 3) {
      setState(() {
        result = 'You should start clicking on that keyboard, buddy!!';
        imagePath = 'assets/images/start.png'; //today image
      });
      await audioPlayer.play(AssetSource('sounds/alert.mp3')); //play alert sound
    } else {
      setState(() {
        result = 'Oh boy, what are you still doing? Catch that deadline!!';
        imagePath = 'assets/images/catch.png'; //passed image
      });
      await audioPlayer.play(AssetSource('sounds/warning.mp3')); //play warning sound
    } 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.teal,
        title: Text(
          'Deadline Checker',
          style: GoogleFonts.lato(),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              imagePath,
              width: 300,
              height: 300,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 20),

            Text('Enter days left until your deadline:', style: GoogleFonts.lato(fontSize: 18)),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
              child: TextField(
                controller: daysController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Days Left', //label for the input field
                ), 
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: checkDeadline,
                  child: Text('Check Deadline', style: GoogleFonts.lato()),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      daysController.clear(); //clear input
                      result = ''; //clear result
                      imagePath = 'assets/images/deadline.png'; //reset image
                    });
                  },
                  child: Text('Reset', style: GoogleFonts.lato()),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(result, style: GoogleFonts.lato(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  } 
}