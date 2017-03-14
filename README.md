This tutorial describes how to write a more or less full-featured [Arkanoid](https://en.wikipedia.org/wiki/Arkanoid) ([Breakout](https://en.wikipedia.org/wiki/Breakout_%28video_game%29)) clone. 

The intended audience are people, who have basic programming experience, but have
trouble structuring their code for projects bigger than "Hello World".
An Arkanoid, while simple, contains many elements found in more elaborate games.
My aim is to introduce a typical code structure,
and to provide a starting point for further modifications.

*Warning: the tutorial is work in progress. Some content may change in the future.*

**Chapter 1** describes how to build a prototype for an Arkanoid-type 
game in the most straightforward way,
without relying too much on any external libraries or advanced language features. 

**Chapter 2** expands the prototype, introducing gamestates, basic graphics and sound.
At the end of this chapter, the general frame of the game is complete. What is left
is to fill it with the details. 

**Chapter 3** proceeds to add functionality to achieve a full-featured game. 
I'm deliberately going to try to make 
articles in this chapter short, only sketching a general idea of what is going on.
*Warning: the code for this chapter is in a working state, but requires some minor corrections.*

**Appendices** - which are not written yet :) - demonstrate some additional topics, such as how to use environments to 
define Lua modules, classes, and so on.

I realize that the length of the tutorial - almost 30 parts -
is probably a bit too much. On the other hand,
the amount of work necessary to write a game is
commonly underestimated and this tutorial 
clearly shows what it actually takes to develop even a simple one.

Lua programming language and [LÖVE](https://love2d.org/) framework are used.
Basic programming experience is assumed.
Familiarity with Lua and LÖVE is beneficial but not necessary.
Some non-obvious Lua idioms are briefly explained.

The code can be downloaded using `git` 
```
cd /your-path/
git clone https://github.com/noooway/love2d_arkanoid_tutorial
```
or by Github's ["Clone or download -> Download ZIP"](https://github.com/noooway/love2d_arkanoid_tutorial/archive/master.zip) button.

Each step can be run with the LÖVE interpreter by issuing a `love` 
command followed by the folder name, for example
```
cd /your-path/love2d_arkanoid_tutorial
love 1-01_TheBallTheBrickThePlatform 
```

One last thing before we start: feedback is crucial.
If you have any critique, suggestions, improvements or just any other ideas, let me know. 

Contents:

**Chapter 1: Building The Prototype**  

1. [The Ball, The Brick, The Platform](https://github.com/noooway/love2d_arkanoid_tutorial/wiki/The-Ball,-The-Brick,-The-Platform)
2. [Bricks and Walls](https://github.com/noooway/love2d_arkanoid_tutorial/wiki/Bricks-and-Walls)
3. [Detecting Collisions](https://github.com/noooway/love2d_arkanoid_tutorial/wiki/Detecting-Collisions)
4. [Resolving Collisions](https://github.com/noooway/love2d_arkanoid_tutorial/wiki/Resolving-Collisions)
5. [Levels](https://github.com/noooway/love2d_arkanoid_tutorial/wiki/Levels)

<!-- -->

**Chapter 2: Common Features**  

1. [Splitting Code into Several Files](https://github.com/noooway/love2d_arkanoid_tutorial/wiki/Splitting-Code-Into-Several-Files)  
2. [Loading Levels from Files](https://github.com/noooway/love2d_arkanoid_tutorial/wiki/Loading-Levels-From-Files)
3. [Straightforward Gamestates](https://github.com/noooway/love2d_arkanoid_tutorial/wiki/Straightforward-Gamestates)
4. [Advanced Gamestates](https://github.com/noooway/love2d_arkanoid_tutorial/wiki/Advanced-Gamestates)    
5. [Basic Tiles](https://github.com/noooway/love2d_arkanoid_tutorial/wiki/Basic-Tiles)
6. [Different Brick Types](https://github.com/noooway/love2d_arkanoid_tutorial/wiki/Different-Brick-Types)  
7. [Basic Sound](https://github.com/noooway/love2d_arkanoid_tutorial/wiki/Basic-Sound)  
8. [Game Over](https://github.com/noooway/love2d_arkanoid_tutorial/wiki/Game-Over)

<!-- -->
 **Chapter 3: Getting to the Finish Line**

1. Better Ball Rebounds ([draft](https://github.com/noooway/love2d_arkanoid_tutorial/wiki/Better-Ball-Rebounds))
2. Ball Launch From Platform (Two Objects Moving Together) ([draft](https://github.com/noooway/love2d_arkanoid_tutorial/wiki/Ball-Launch-From-Platform))
3. Mouse Controls ([draft](https://github.com/noooway/love2d_arkanoid_tutorial/wiki/Mouse-Controls))
4. Spawning Bonuses ([draft](https://github.com/noooway/love2d_arkanoid_tutorial/wiki/Spawning-Bonuses))
5. Bonus Effects ([draft](https://github.com/noooway/love2d_arkanoid_tutorial/wiki/Bonus-effects))
6. Glue Bonus ([draft](https://github.com/noooway/love2d_arkanoid_tutorial/wiki/Glue-Bonus))
7. Add New Ball Bonus ([draft](https://github.com/noooway/love2d_arkanoid_tutorial/wiki/Add-New-Ball-Bonus))
8. Life and Next Level Bonuses ([draft](https://github.com/noooway/love2d_arkanoid_tutorial/wiki/Life-and-Next-Level-Bonuses))  
9. Random Bonuses ([draft](https://github.com/noooway/love2d_arkanoid_tutorial/wiki/Random-Bonuses))
10. Menu Buttons ([draft](https://github.com/noooway/love2d_arkanoid_tutorial/wiki/Menu-Buttons))
11. Wall Tiles ([draft](https://github.com/noooway/love2d_arkanoid_tutorial/wiki/Wall-Tiles))
12. Side Panel ([draft](https://github.com/noooway/love2d_arkanoid_tutorial/wiki/Side-Panel))  
13. Score ([draft](https://github.com/noooway/love2d_arkanoid_tutorial/wiki/Score))
14. Fonts ([draft](https://github.com/noooway/love2d_arkanoid_tutorial/wiki/Fonts))
15. More Sounds ([draft](https://github.com/noooway/love2d_arkanoid_tutorial/wiki/More-Sounds))
16. Final Screen ([draft](https://github.com/noooway/love2d_arkanoid_tutorial/wiki/Final-Screen))
17. Packaging and Distribution ([draft](https://github.com/noooway/love2d_arkanoid_tutorial/wiki/Packaging-and-Distribution))

<!-- -->
**Additional Topics:**

1. Appendix A: Defining Modules Using Environments  
2. Appendix B-1: Intro to Classes 
3. Appendix B-2: Chapter 2 Using Classes.  
TBA

[Acknowledgements](https://github.com/noooway/love2d_arkanoid_tutorial/wiki/Acknowledgements)  
[Archive](https://github.com/noooway/love2d_arkanoid_tutorial/wiki/Archive)  