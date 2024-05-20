import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'chess_game_provider.dart';
import 'chess_piece.dart';

class Scoreboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final game = Provider.of<ChessGameProvider>(context);

    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.deepPurple,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Scoreboard',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          _buildPlayerInfo(game.whitePlayer, game.whiteCaptured, Colors.white, game.playerTimes[Player.white],
              game.currentPlayer == Player.white),
          SizedBox(height: 20),
          _buildPlayerInfo(game.blackPlayer, game.blackCaptured, Colors.black, game.playerTimes[Player.black],
              game.currentPlayer == Player.black),
        ],
      ),
    );
  }

  Widget _buildPlayerInfo(
      String playerName, List<ChessPiece> captured, Color color, Duration? playerTime, bool isCurrentPlayer) {
    return Column(
      children: [
        Text(
          playerName,
          style: TextStyle(
            color: color,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 5),
        Text(
          'Time Left: ${_formatDuration(playerTime ?? Duration.zero)}',
          style: TextStyle(
            color: color,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10),
        Wrap(
          alignment: WrapAlignment.center,
          children: captured
              .map((piece) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: SvgPicture.asset(
                      'assets/images/${piece.color.name}_${piece.type.name}.svg',
                      width: 24,
                      height: 24,
                    ),
                  ))
              .toList(),
        ),
      ],
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }
}
