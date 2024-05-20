import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'chess_game_provider.dart';
import 'chessboard.dart';
import 'scoreboard.dart';

class PlayerNameInput extends StatefulWidget {
  @override
  _PlayerNameInputState createState() => _PlayerNameInputState();
}

class _PlayerNameInputState extends State<PlayerNameInput> {
  final TextEditingController _player1Controller = TextEditingController();
  final TextEditingController _player2Controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Enter Player Names'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _player1Controller,
              decoration: InputDecoration(labelText: 'Player 1'),
            ),
            TextField(
              controller: _player2Controller,
              decoration: InputDecoration(labelText: 'Player 2'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Provider.of<ChessGameProvider>(context, listen: false).setPlayerNames(
                  _player1Controller.text,
                  _player2Controller.text,
                );
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ChessGameScreen()),
                );
              },
              child: Text('Start Game'),
            ),
          ],
        ),
      ),
    );
  }
}

class ChessGameScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Consumer<ChessGameProvider>(
          builder: (context, game, child) {
            return Text('${game.player1} vs ${game.player2}');
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(child: Chessboard()),
          Scoreboard(),
        ],
      ),
    );
  }
}
