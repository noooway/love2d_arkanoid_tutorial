This tutorial describes how to write a more or less full-featured [Arkanoid](https://en.wikipedia.org/wiki/Arkanoid) ([Breakout](https://en.wikipedia.org/wiki/Breakout_%28video_game%29)) clone. 
While simple, it contains many elements found in more elaborate games.

The intended audience are people, who know how to program, but don't
know how to structure the code to make a full-featured game.
My aim is to introduce some common constructs,
used in game programming, and
to provide a starting point for further modifications.

The code structure discussed in parts from 1 to 11 and the 26
can be transfered to almost any game you are going to write.
The rest is mostly specific for this project.
I realise that the length of the tutorial - almost 30 parts -
is probably a bit too much. On the other hand,
the amount of work necessary to write a game is
commonly underestimated and this tutorial 
clearly shows what it actually takes to develop a game.
Mind though, that only programming is discussed; the graphics and the 
sound are just taken for granted.

Lua programming language and [LÖVE](https://love2d.org/) framework are used.
Basic programming experience is assumed.
Familiarity with Lua and Love2D is beneficial but not necessary.
Some non-obvious Lua idioms are briefly explained.

Each step can be run with the `love` interpreter by issuing a `love` 
command followed by the folder name, for example

    cd /your-path/love2d_arkanoid_tutorial
    love 01_TheBallTheBrickThePlatform 

One last thing before we start: feedback is crucial.
If you have any critique, suggestions, improvements or just any other ideas, let me know. 

Contents:

1. [The Ball, The Brick, The Platform](https://github.com/noooway/love2d_arkanoid_tutorial/wiki/1-The-Ball,-The-Brick,-The-Platform)
2. [Splitting Code into Several Files (Lua Modules)](https://github.com/noooway/love2d_arkanoid_tutorial/wiki/2-Modules)
3. [Classes](https://github.com/noooway/love2d_arkanoid_tutorial/wiki/3-Classes)
4. [Other Bricks and The Walls (Container Classes)](https://github.com/noooway/love2d_arkanoid_tutorial/wiki/4-Container-Classes)
5. [Detecting Collisions](https://github.com/noooway/love2d_arkanoid_tutorial/wiki/5-Detecting-Collisions)
6. [Resolving Collisions](https://github.com/noooway/love2d_arkanoid_tutorial/wiki/6-Resolving-Collisions)
7. [Loading Level From External File](https://github.com/noooway/love2d_arkanoid_tutorial/wiki/7-Loading-Level-From-External-File)
8. [Changing Levels](https://github.com/noooway/love2d_arkanoid_tutorial/wiki/8-Changing-Levels)
9. [Basic Gamestates: Game and Menu](https://github.com/noooway/love2d_arkanoid_tutorial/wiki/9-Basic-Gamestates:-Game-and-Menu)
10. [More Gamestates: Gamepaused and Gamefinished](https://github.com/noooway/love2d_arkanoid_tutorial/wiki/10-More-Gamestates:-Gamepaused-and-Gamefinished)
11. [Basic Tiles](https://github.com/noooway/love2d_arkanoid_tutorial/wiki/Basic-Tiles)
12. [Different Brick Types](https://github.com/noooway/love2d_arkanoid_tutorial/wiki/Different-Brick-Types)
13. [Spawning Bonuses](https://github.com/noooway/love2d_arkanoid_tutorial/wiki/Spawning-Bonuses)
14. [Bonus Effects](https://github.com/noooway/love2d_arkanoid_tutorial/wiki/Bonus-effects)
15. [Details: Add-New-Ball Bonus](https://github.com/noooway/love2d_arkanoid_tutorial/wiki/Details:-Add-New-Ball-Bonus)
16. [Ball Launch From Platform (Two Objects Moving Together)](https://github.com/noooway/love2d_arkanoid_tutorial/wiki/Ball-Launch-From-Platform-%28Two-Objects-Moving-Together%29)
17. [Details: Better Ball Rebounds](https://github.com/noooway/love2d_arkanoid_tutorial/wiki/Details:-Better-Ball-Rebounds)
18. [Details: Glue Bonus](https://github.com/noooway/love2d_arkanoid_tutorial/wiki/Details:-Glue-Bonus)
19. [Menu Buttons](https://github.com/noooway/love2d_arkanoid_tutorial/wiki/Menu-Buttons)
20. [Lives and Score](https://github.com/noooway/love2d_arkanoid_tutorial/wiki/Lives-and-Score)
21. [Wall Tiles](https://github.com/noooway/love2d_arkanoid_tutorial/wiki/Wall-Tiles)
22. [Side Panel Background](https://github.com/noooway/love2d_arkanoid_tutorial/wiki/Side-Panel-Background)
23. [Fonts in Lives and Score](https://github.com/noooway/love2d_arkanoid_tutorial/wiki/Fonts-in-Lives-and-Score)
24. [Mouse Controls](https://github.com/noooway/love2d_arkanoid_tutorial/wiki/Mouse-Controls)
25. [Details: Random Bonuses](https://github.com/noooway/love2d_arkanoid_tutorial/wiki/Details:-Random-Bonuses)
26. [Sound](https://github.com/noooway/love2d_arkanoid_tutorial/wiki/Sound)
27. [Final Screen](https://github.com/noooway/love2d_arkanoid_tutorial/wiki/Final-Screen)
28. [Game Over](https://github.com/noooway/love2d_arkanoid_tutorial/wiki/Game-Over)
29. [Packaging and Distribution](https://github.com/noooway/love2d_arkanoid_tutorial/wiki/Packaging-and-Distribution)