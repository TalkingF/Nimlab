%{ 
Main file for Nim project. This program simulates a game of nim between
a player & a computer generated response. It has built in options for
gameboard size, turn & difficulty. As the game has been mathematically
solved for playing the theoretical best move in any position, the computer
will make a probability check on whether it sdhould play the correct move
"correcting the nim sum" which is influenced by the difficulty chosen.
%}

% Main function that calls each function and controls game loop 
function Nim()
endGame = false;
playWelcome()
[gameBoard, difficulty, turn] = setOptions();
while endGame == false
    [gameBoard, turn, endGame] = playTurn(gameBoard, turn, difficulty);
end
end

%Plays introductory message and controls playIntstructions()
function playWelcome()

fprintf("=================================================\n" + ...
    "Welcome to nim, a mathematical game of stratergy. \n" + ...
    "Would you like to learn how to play? [y/n] \n" + ...
    "=================================================\n")

isNew = input("", "s");
if strcmpi(isNew, "y")
    playInstructions() %Calls playInstructions() if user answers prompt
end
end

%Provides further instructions and example of a displayed gameboard
function playInstructions() 

fprintf("Nim is a combinatorial game where two players must \n" + ...
    "take turns in removing atleast one object from A heap \n" + ...
    "although multiple can be taken. The goal is to have your \n" + ...
    "opponent pick up the last object. You can only take from one \n" + ...
    "heap at a time and there is a max pickup of 3 objects per turn.\n")

exampleMatix = [ 1,0,0; 1,0,1; 1,1,1];
disp(exampleMatix)
end

%{
This function prompts the user for gameBoard, difficulty & turn order.
Using the confirm variables, the function catches any illegal inputs &
reprompts the user for a valid input. The results are then parsed.
%}
function [gameBoard, difficulty, turn] = setOptions()%set all options false
confirmDimensions = false;
confirmDifficulty = false;
confirmTurn = false;

while confirmDimensions == false%gameBoard setup, promtps user
    fprintf("Please select the dimmensions of the Nim board: \n" + ...
        "[A] 5x2 \n" + ...
        "[B] 7x3 \n" + ...
        "[C] 7x4 \n")
    checkDimensions = input("","s");

    confirmDimensions = true;

    switch checkDimensions%sets board
        case "A"
            gameBoard = ones(5,2,"int8");
        case "B"
            gameBoard = ones(7,3,"int8");
            gameBoard([1 2],2) = 0;
            gameBoard(1:5,3) = 0;
        case "C"
            gameBoard = ones(7,4,"int8");
            gameBoard(1:3,2) = 0;
            gameBoard(1:5,3) = 0;
            gameBoard(1:6,4) = 0;
        otherwise
            confirmDimensions = false;
    end
end

while confirmDifficulty == false %difficulty setup
    fprintf("Please select the difficulty of the computer: \n" + ...
        "[A] Easy \n" + ...
        "[B] Normal \n" + ...
        "[C] Hard \n")
    checkDifficulty = input("","s");

    confirmDifficulty = true;
    switch checkDifficulty %sets difficulty for computer
        case "A"
            difficulty = 0.3;
        case "B"
            difficulty = 0.6;
        case "C"
            difficulty = 1;
        otherwise 
            confirmDifficulty = false;
    end
end

while confirmTurn == false %turn setup 
    fprintf("And finally, would you like to go first? [y/n] \n")
    checkTurn = input("","s");

    confirmTurn = true;  
    if strcmpi(checkTurn,"y")
        turn = 1;
    elseif strcmpi(checkTurn,"n")
        turn = 0;
    else
        confirmTurn = false;
    end
end
end
%{
This function calculates the nimsum of of a gameboard. The nimsum returned 
is an integer which can be used by the computer to determine its next move.
%}
function nimSum = calculateNimSum(gameBoard)
columnValues = sum(gameBoard);%sums the amount of 1's in each column
binaryRepresentation = dec2bin(columnValues, 3);%converts sums to binary
binaryToMatrix = str2num(binaryRepresentation); %converts to int matrix
binaryLadder = sum(binaryToMatrix); %sums amount of 1's in binary form
for i=1:length(binaryLadder) %for sums, returns 0 if even, 1 otherwise
    binaryNimSum(i) = mod(sum(binaryLadder(i)),2);
end
binStringArray = string(binaryNimSum);%converts binary sum to strings
binString = join(binStringArray);%concatenates each string 
nimSum = bin2dec(binString);%converts concatenated string to decimal 
end

function [gameBoard, turn, endGame] = playTurn(gameBoard, turn, difficulty)
gameBoardDepth = sum(gameBoard);

if mod(turn,2) == 1%player turn
    fprintf("Player Turn!\n")
disp(gameBoard)%exposes the gameBoard to the player
columnConfirmation = false;%sets up while loop 
    while columnConfirmation == false
        columnConfirmation = true;%while loop will break if no conditionals
        selectColumn = input("Please select your column: ");%prompts input
        selectAmount = input("PLease select the amount: ");%prompts input
        if selectAmount > gameBoardDepth(selectColumn)%checks legal move
            columnConfirmation = false;
        elseif selectAmount <= 0 || selectAmount >= 4 %checks legal move
            columnConfirmation = false;
        end
    end
    %parses player move
    gameBoard = updateBoard(selectColumn,selectAmount,gameBoard);
else %computer turn
    fprintf("Computer turn!\n")
    copyGameBoard = gameBoard;%copies gameboard
    copyGameBoardDepth = gameBoardDepth;%copies gameboard depth to modify
    copyGameBoardDepth(copyGameBoardDepth>3) = 3;%sets distance to check
    legalMoves = zeros(3,size(copyGameBoardDepth,2));%moves to check
    check = rand();%compares to diffuculty, outcome determines move logic
    for i=1:length(gameBoardDepth)
        switch copyGameBoardDepth(i)%updates matrix based on gamedepth
            case 1
                legalMoves(1,i) = 1;
            case 2
                legalMoves([1 2], i) = 1;
            case 3 
                legalMoves([1 2 3], i) = 1;
        end
    end

%{
checks each legal position on a fake board and gets nim sum. toCompare
will save the minimum nim sum and the relative position under variables
j and i. 
%}
nimMin = -1;
randRollCompare = 0;
for i = 1:size(legalMoves,2)%gets length
    for j = 1:3 %2dimensional loop
        if legalMoves(j,i) == 1
            [newBoard] = updateBoard(i,j,copyGameBoard);%tests move 
            toCompare = [calculateNimSum(newBoard), i, j];%tests nim sum                   
            if rand > randRollCompare%rand move to be played is highest num
            randomMove = toCompare; %sets randMove
            randRollCompare = rand; %rerolls randRoll
            end
            if nimMin(1) == -1 %first time nim min is set to 1st legal move
                nimMin = toCompare;
            elseif toCompare(1) > nimMin(1)%updates if smaller nim sum
                nimMin = toCompare;
            end   
        end
    end
end

    if difficulty > check %correct move
        gameBoard = updateBoard(nimMin(2),nimMin(3),gameBoard);
    else %random move
        gameBoard = updateBoard(randomMove(2),randomMove(3),gameBoard);
        
    end


end
%check if gameBoard is empty, use turn to determine winner if true
if all(gameBoard == 0)
    endGame = true;
    if mod(turn,2) == 1
        fprintf("Computer wins!\n")
    else
        fprintf("Player wins!\n")
    end
else 
    endGame = false;
end
turn = turn + 1; %updates turn
end
%{
This function updates any gameboard parsed to it as long as a column &
amount is specified. This is used for the legitimate board & the ones
tested by rhe computer
%}
function newBoard = updateBoard(selectColumn, selectAmount, gameBoard)
    newBoard = gameBoard;
    gameBoardDepth = sum(gameBoard);%gets height of each column 
    toKeep = gameBoardDepth(selectColumn) - selectAmount;%return x amount 
    newBoard(:,selectColumn) = 0;%removes all 1's from column
    for i=1:toKeep
        newBoard(length(newBoard) - i + 1, selectColumn) = 1;%return tokeep 
    end
end
  










