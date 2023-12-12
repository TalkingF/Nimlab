%{ 
Main file for Nim project. This program simulates a game of nim between
a player & a computer generated response. It has built in options for
gameboard size, turn & difficulty. As the game has been mathematically
solved for playing the theoretical best move in any position, the computer
will make a probability check on whether it sdhould play the correct move
"correcting the nim sum" which is influenced by the difficulty chosen.
%}

% Main function that calls each function and controls game loop 
function nimMain()
endGame = false;
playWelcome()
[gameBoard, difficulty, turn] = setOptions();
while endGame == false
    [gameBoard, turn, endGame] = playTurn(gameBoard, turn, difficulty);
end
end