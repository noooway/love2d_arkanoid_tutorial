This tutorial describes how to write a more or less full-featured [Arkanoid](https://en.wikipedia.org/wiki/Arkanoid) ([Breakout](https://en.wikipedia.org/wiki/Breakout_%28video_game%29)) clone. 
While simple, it contains many elements found in more elaborate games.

My aim is to introduce some common constructs, used in game programming, 
and to provide a starting point for further modifications.  

Lua programming language and [LÖVE](https://love2d.org/) framework are used.
Basic programming experience is assumed.
Familiarity with Lua and Love2D is beneficial but not necessary.
Some non-obvious Lua idioms and briefly explained.

Each step can be run with `love` interpreter by issuing a `love` 
command followed by a folder name, for example

    cd /your-path/love2d_arkanoid_tutorial
    love 01_TheBallTheBrickThePlatform 

One last thing before we start: feedback is crucial.
If you have any critique, suggestions, improvements or just any other ideas, let me know. 

An explanation of each step can be found on
[github wiki](https://github.com/noooway/love2d_arkanoid_tutorial/wiki).

Contents:

1. [The Ball, The Brick, The Platform](https://github.com/noooway/love2d_arkanoid_tutorial/wiki/1-The-Ball,-The-Brick,-The-Platform)
2. [Modules](https://github.com/noooway/love2d_arkanoid_tutorial/wiki/2-Modules)
3. [Classes](https://github.com/noooway/love2d_arkanoid_tutorial/wiki/3-Classes)
4. [Container Classes](https://github.com/noooway/love2d_arkanoid_tutorial/wiki/4-Container-Classes)
5. [Detecting Collisions](https://github.com/noooway/love2d_arkanoid_tutorial/wiki/5-Detecting-Collisions)
6. [Resolving Collisions](https://github.com/noooway/love2d_arkanoid_tutorial/wiki/6-Resolving-Collisions)
7. [Loading Level From External File](https://github.com/noooway/love2d_arkanoid_tutorial/wiki/7-Loading-Level-From-External-File)
8. [Changing Levels](https://github.com/noooway/love2d_arkanoid_tutorial/wiki/8-Changing-Levels)
9. [Basic Gamestates: Game and Menu](https://github.com/noooway/love2d_arkanoid_tutorial/wiki/9-Basic-Gamestates:-Game-and-Menu)
10. [More Gamestates: Gamepaused and Gamefinished](https://github.com/noooway/love2d_arkanoid_tutorial/wiki/10-More-Gamestates:-Gamepaused-and-Gamefinished)
11. Tiles
12. Bonuses
13. Menu Buttons
14. Scores and Lives and Fonts
15. Sound
16. Animation
17. Finishing Touches
18. Packaging and Distribution
