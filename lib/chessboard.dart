import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'chess_game_provider.dart';
import 'chess_piece.dart';
import 'scoreboard.dart';

class Chessboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final game = Provider.of<ChessGameProvider>(context);

    return Column(
      children: [
        Expanded(
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 8,
            ),
            itemBuilder: (context, index) {
              final int row = index ~/ 8;
              final int col = index % 8;
              final piece = game.board[row][col];
              final bool isWhite = (row + col) % 2 == 0;

              return GestureDetector(
                onTap: () => game.selectSquare(row, col),
                child: Container(
                  color: isWhite ? Colors.white : Colors.black,
                  child: piece != null
                      ? Center(
                          child: SvgPicture.asset(
                            'assets/images/${piece.color.name}_${piece.type.name}.svg',
                            width: 40,
                            height: 40,
                          ),
                        )
                      : null,
                ),
              );
            },
            itemCount: 64,
          ),
        ),
        Scoreboard(),
      ],
    );
  }
}
