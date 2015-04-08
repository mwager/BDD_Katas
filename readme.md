# BDD Katas

I created this project to learn BDD by doing. The idea is based on the book [Behaviour Driven Development with JavaScript](http://developerpress.com/BehaviourDrivenDevelopmentwithJavaScript-175419) by Marco Emrich. I made this public because I think this should keep my motivation high and makes me focus more on quality.

The repo contains my implementation of the exercises from the book as well as an implementation of a TicTacToe game.

The code is written in CoffeeScript, for the specs I use mocha, chai and sinon. Code coverage via karma-coverage - look in the folder `/coverage` after running the tests.


## Install

1. Clone the repo
2. Install dependencies: `$ npm install`


## Running the tests

`$ npm test`

Then open a browser at http://localhost:9876/debug.html


## Playing the game

The game may be played [here](https://mwager.github.io/BDD_Katas/). See `index.html`.


## Specification

* TicTacToe is a board game, so the game is played on a board
* A board has 3 rows with each 3 columns (9 fields)
* Two players can play a game (X and O)
* The player who succeeds in placing three respective marks
  in a horizontal, vertical, or diagonal row wins the game.
* A player can place marks on a board
* A "Game" holds logic for a game to be played, it should hold two players and a board
* Each player should have a name and points
* A player gets one point if he wins


## TODOs

* make it modular, extra file for each class
* make a ConsoleGame, playable as node.js app from the command line
* make a HTMLGame, playable as web app
