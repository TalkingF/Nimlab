%Final stage driver and testing
playWelcome() %prompts user for more info
[gameBoard, difficulty, turn] = setOptions() %vars should be user input

A = ones(5,2,"int8");
B = ones(7,3,"int8");
B([1 2],2) = 0;
B(1:5,3) = 0;
C = ones(7,4,"int8");
C(1:3,2) = 0;
C(1:5,4) = 0;
C(1:6,4) = 0;

nim1 = calculateNimSum(A) %zero
nim2 = calculateNimSum(B) %zero
nim3 = calculateNimSum(C) %one

%tests board will update with paramaters
uBoard1 = updateBoard(1,2,A)
uBoard2 = updateBoard(3,3,B)
uBoard3 = updateBoard(4,1,C)

%tests turn order will be memorised and that I/O +updateBoard works
pTurn1 = playTurn(A,1,0.3)
pTurn2 = playTurn(B,2,0.6)
pTurn3 = playTurn(C,3,1.0)

%winner check
D = zeros(1,2);
D(1,1) = 1;
computerWin = playTurn(D,1,0.6)
D(1,1) = 1;
playerTurn = playTurn(D,2,0.6)
