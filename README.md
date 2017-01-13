This tutorial describes how to write a more or less full-featured [Arkanoid](https://en.wikipedia.org/wiki/Arkanoid) ([Breakout](https://en.wikipedia.org/wiki/Breakout_%28video_game%29)) clone. 

The intended audience are people, who have basic programming experience, but have
trouble structuring their code for projects bigger than 'Hello World'.
An Arkanoid, while simple, contains many elements found in more elaborate games.
My aim is to introduce a typical code structure,
and to provide a starting point for further modifications.

*Warning: the tutorial is work in progress. Some content may change in the future.*

**Chapter 1** describes how to build a prototype for an Arkanoid-type 
game in the most straightforward way,
without relying too much on any external libraries or advanced language features. 

**Chapter 2** expands the prototype, introducing simple gamestates, basic graphics and sound.

**Deprecated Chapter 2** is the initial version of the first two chapters of the tutorial.  
Classes are introduced early on, [HardonCollider (HC)](https://github.com/vrld/HC) is used for collision detection
and [hump.gamestate](https://github.com/vrld/hump) for the gamestates.
After some discussion I've been convinced that classes should be postponed for later chapters or avoided altogether in such a simple game. HC is overkill and should be replaced either with [Bump](https://github.com/kikito/bump.lua) or with a manually written collision detection.  
After Chapter 2 is ready, this material will be accessible only from the [Archive page](https://github.com/noooway/love2d_arkanoid_tutorial/wiki/Archive).

**Chapter 3** proceeds to add details to achieve a full-featured game. 
I'm deliberately going to try to make 
articles in this chapter short, only sketching a general idea of what is going on.

**Appendix** demonstrates how to rewrite the code in the Chapter 2 using classes.

I realize that the length of the tutorial - almost 30 parts -
is probably a bit too much. On the other hand,
the amount of work necessary to write a game is
commonly underestimated and this tutorial 
clearly shows what it actually takes to develop even a simple one.

Lua programming language and [LÖVE](https://love2d.org/) framework are used.
Basic programming experience is assumed.
Familiarity with Lua and LÖVE is beneficial but not necessary.
Some non-obvious Lua idioms are briefly explained.

Each step can be run with the LÖVE interpreter by issuing a `love` 
command followed by the folder name, for example

    cd /your-path/love2d_arkanoid_tutorial
    love 1-01_TheBallTheBrickThePlatform 

One last thing before we start: feedback is crucial.
If you have any critique, suggestions, improvements or just any other ideas, let me know. 

Contents:

**Chapter 1: Building The Prototype**  

1. [The Ball, The Brick, The Platform](https://github.com/noooway/love2d_arkanoid_tutorial/wiki/1-The-Ball,-The-Brick,-The-Platform)
2. [Bricks and Walls](https://github.com/noooway/love2d_arkanoid_tutorial/wiki/Bricks-and-Walls)
3. [Detecting Collisions](https://github.com/noooway/love2d_arkanoid_tutorial/wiki/Collision-Detection)
4. [Resolving Collisions](https://github.com/noooway/love2d_arkanoid_tutorial/wiki/Resolving-Collisions)
5. [Levels](https://github.com/noooway/love2d_arkanoid_tutorial/wiki/Levels)

<!-- -->

**Chapter 2: Common Features**  

1. Splitting Code into Several Files ([draft](https://github.com/noooway/love2d_arkanoid_tutorial/wiki/2-01a:-Splitting-Code-Into-Different-Files))  
2. Loading Levels from Files ([draft](https://github.com/noooway/love2d_arkanoid_tutorial/wiki/2-02a:-LoadingLevelsFromFiles))
3. Straightforward Gamestates ([draft](https://github.com/noooway/love2d_arkanoid_tutorial/wiki/2-03a:-Straightforward-Gamestates))  
4. Basic Tiles([draft](https://github.com/noooway/love2d_arkanoid_tutorial/wiki/Basic-Tiles))
5. Different Brick Types([draft](https://github.com/noooway/love2d_arkanoid_tutorial/wiki/Different-Brick-Types))  
6. Basic Sound([draft](https://github.com/noooway/love2d_arkanoid_tutorial/wiki/Basic-Sound))
7. Game Over([draft](https://github.com/noooway/love2d_arkanoid_tutorial/wiki/Game-Over-1))

<!-- -->

**Deprecated** *Chapter 2: Maintainable Code*  
Material in this chapter is considered deprecated.
After the "Chapter 2: Common Features" is finished, it will be removed from the TOC and will be accessible 
only from the [Archive page](https://github.com/noooway/love2d_arkanoid_tutorial/wiki/Archive).

1. [The Ball, The Brick, The Platform](https://github.com/noooway/love2d_arkanoid_tutorial/wiki/1-The-Ball,-The-Brick,-The-Platform)
2. [Splitting Code into Several Files](https://github.com/noooway/love2d_arkanoid_tutorial/wiki/2-Modules)
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
13. [Basic Sound](https://github.com/noooway/love2d_arkanoid_tutorial/wiki/Basic-Sound)
14. [Game Over](https://github.com/noooway/love2d_arkanoid_tutorial/wiki/Game-Over-1)

<!-- -->
 **Chapter 3: Getting to the Finish Line**

1. Spawning Bonuses ([draft](https://github.com/noooway/love2d_arkanoid_tutorial/wiki/Spawning-Bonuses))
2. Bonus Effects ([draft](https://github.com/noooway/love2d_arkanoid_tutorial/wiki/Bonus-effects))
3. Details: Add-New-Ball Bonus ([draft](https://github.com/noooway/love2d_arkanoid_tutorial/wiki/Details:-Add-New-Ball-Bonus))
4. Ball Launch From Platform (Two Objects Moving Together) ([draft](https://github.com/noooway/love2d_arkanoid_tutorial/wiki/Ball-Launch-From-Platform-%28Two-Objects-Moving-Together%29))
5. Details: Better Ball Rebounds ([draft](https://github.com/noooway/love2d_arkanoid_tutorial/wiki/Details:-Better-Ball-Rebounds))
6. Details: Glue Bonus ([draft](https://github.com/noooway/love2d_arkanoid_tutorial/wiki/Details:-Glue-Bonus))
7. Menu Buttons ([draft](https://github.com/noooway/love2d_arkanoid_tutorial/wiki/Menu-Buttons))
8. Lives and Score ([draft](https://github.com/noooway/love2d_arkanoid_tutorial/wiki/Lives-and-Score))
9. Wall Tiles ([draft](https://github.com/noooway/love2d_arkanoid_tutorial/wiki/Wall-Tiles))
10. Side Panel Background ([draft](https://github.com/noooway/love2d_arkanoid_tutorial/wiki/Side-Panel-Background)
11. Fonts in Lives and Score ([draft](https://github.com/noooway/love2d_arkanoid_tutorial/wiki/Fonts-in-Lives-and-Score))
12. Mouse Controls ([draft](https://github.com/noooway/love2d_arkanoid_tutorial/wiki/Mouse-Controls))
13. Details: Random Bonuses ([draft](https://github.com/noooway/love2d_arkanoid_tutorial/wiki/Details:-Random-Bonuses))
14. Sound ([draft](https://github.com/noooway/love2d_arkanoid_tutorial/wiki/Sound))
15. Final Screen ([draft](https://github.com/noooway/love2d_arkanoid_tutorial/wiki/Final-Screen))
16. Game Over ([draft](https://github.com/noooway/love2d_arkanoid_tutorial/wiki/Game-Over))
17. Packaging and Distribution ([draft](https://github.com/noooway/love2d_arkanoid_tutorial/wiki/Packaging-and-Distribution))

<!-- -->
 **Appendix: Classes**  
TBA


[Acknowledgements](https://github.com/noooway/love2d_arkanoid_tutorial/wiki/Acknowledgements)  
[Archive](https://github.com/noooway/love2d_arkanoid_tutorial/wiki/Archive)  