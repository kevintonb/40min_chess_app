import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'chessboard.dart';
import 'chess_game_provider.dart';

void main() {
  runApp(ChessApp());
}

class ChessApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ChessGameProvider(),
      child: MaterialApp(
        home: PlayerNamesScreen(),
      ),
    );
  }
}

class PlayerNamesScreen extends StatelessWidget {
  final TextEditingController whitePlayerController = TextEditingController();
  final TextEditingController blackPlayerController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Enter Player Names',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 30),
              _buildTextField(controller: whitePlayerController, label: 'White Player Name'),
              SizedBox(height: 20),
              _buildTextField(controller: blackPlayerController, label: 'Black Player Name'),
              SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  Provider.of<ChessGameProvider>(context, listen: false)
                      .setPlayerNames(whitePlayerController.text, blackPlayerController.text);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ChessboardScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.deepPurple,
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text(
                  'Start Game',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({required TextEditingController controller, required String label}) {
    return TextField(
      controller: controller,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.white),
        filled: true,
        fillColor: Colors.deepPurple[200],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.white),
        ),
      ),
    );
  }
}

class ChessboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chess Game'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Chessboard(),
    );
  }
}
