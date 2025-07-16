include "../lib/circomlib/circuits/comparators.circom";
// check if input x is a valid rock-paper-scissors value (0,1,2)
/**
@dev Since it's not possible to write conditional expressions in constraints, you need to resort to math-based tricks.
**/
template AssertIsRPS() {
    // Declaration ofsignal s.
    signal input x;
    signal isRP <== (x-0) * (x-1);
    // Constraints.
    isRP * (x-2) === 0;
}

/**
@dev Returns the score of a single round, given the plays by x and y.
**/


/*
Rock = 0
Paper = 1
Scissors = 2


when y wins give 2 , if draw 1  else 0
x | y | out
-----------
0 | 2 | 0
0 | 0 | 1
0 | 1 | 2
1 | 0 | 0
1 | 1 | 1
1 | 2 | 2
2 | 1 | 0
2 | 2 | 1
2 | 0 | 2
*/
template Round() {

    // Declaration ofsignal s.
    signal input x,y;
    signal output out;

    // Ensure that each input is within 0,1,2
    AssertIsRPS()(x);
    AssertIsRPS()(y);

    // Check if match was a draw.
    signal isDraw <== IsEqual()([x,y]);

    signal diffYX <== (y+3)-x; // can't be a negative number so adding y + 3 rist then subtracting
    // y wins if diffYX = 1,4
    signal yWins1 <== (diffYX - 1) * (diffYX - 4);
    signal yWins <== IsZero()(yWins1);
    // x wins if diffYX is 2,5
    signal xWins1 <== (diffYX - 2) * (diffYX - 5);
    signal xWins <== IsZero()(xWins1);

    //Constraints
    // check if exactly one witns either xWins or yWins or isDraw is true
    signal xOrYWins <== (xWins - 1) * (yWins - 1);
    xOrYWins * (isDraw - 1) === 0;
    xWins  + yWins + isDraw === 1; // [ Underconstrained computation bugs ] just make sure that only one condition is possible it cannot be more than 1

    // score is 6 if y wins , 3 if it is draw and 0 if x wins.
    out <== yWins * 6 + isDraw * 3 + y + 1;

}
// Returns the score over all matches in a game with n rounds
// Inputs are the plays by x and y
template Game(n) {
    signal input xs[n];
    signal input ys[n];
    signal scores[n];
    signal output out;

    var score = 0;
    for (var i = 0; i < n; i++) {
        scores[i] <== Round()(xs[i], ys[i]);
        score += scores[i];
    }

    out <== score;
}

component main = Game(3);
