# 🪨📄✂️ Zero-Knowledge Rock-Paper-Scissors (ZK-RPS) with Circom

This project implements a **Rock-Paper-Scissors scoring circuit** using the Circom DSL for zero-knowledge proofs. It allows a player to prove that their opponent received a certain total score **without revealing their own moves** — enabling **verifiable game fairness with privacy**.

---

## 🎯 What Are We Trying to Prove?

We want to prove that:

> Given my (secret) moves and your (public) moves, the total score you got from playing Rock-Paper-Scissors is **accurate and fairly computed**, without revealing anything about my strategy.

This can be useful for:

- Verifiable tournaments
- On-chain games
- Score tracking with player privacy
- ZK learning exercises

---

## 🧠 Game Logic

Each move is encoded as:

| Move     | Value |
| -------- | ----- |
| Rock     | `0`   |
| Paper    | `1`   |
| Scissors | `2`   |

### Round Result Scoring:

For each round:

- If Y wins: 6 points
- If Draw: 3 points
- If X wins: 0 points
  Then we **add `y + 1`** to make every round uniquely identifiable. score dependent on challanger move y input.

| X   | Y   | Result | Score (`out`)   |
| --- | --- | ------ | --------------- |
| 0   | 2   | X wins | `0 + 2 + 1 = 3` |
| 0   | 1   | Y wins | `6 + 1 + 1 = 8` |
| 1   | 1   | Draw   | `3 + 1 + 1 = 5` |

... and so on.

> This way, the verifier can check if the opponent's score is correct while keeping the prover’s moves private.

---

## 🛠 Circuit Overview

- `AssertIsRPS()`: Ensures that inputs are 0, 1, or 2
- `Round()`: Computes the outcome and score of a single RPS round
- `Game(n)`: Computes the total score over `n` rounds

```circom
component main = Game(3);
```
