so i have a game idea.

the whole idea is that the game will/should teach the user how to code or maybe how to think programmatically or how to use programming languge.
the game is all about combat, turn based, strategy and controlled by coding language; still not sure about the genre.

in each level, there is 2 player will fight each other, the player are controlled by a player and a bot.

for each level, the *players* that fight each other:
- The **Player** is controlled by a user, the one whos playing the game and defeat the enemy.
- The **Bot** is the enemy of the player; in which controlled by a *bot* with a set of instruction to fight the player.

the *Entity* is the player and bot will be using to fight against each other, each entity contains a set of *actions*, the *actions* are like the fundamental actions of other games like skills, powers and so on...
Each *actions* are mapped to a *Functions/Method* which is a fundamental concept of a programming language.
Actions can be offensive, defensive, counter/reactive, special and movements such as Locomotions(walk, run, jump), Combat Positioning(Step in, Step back).

for instance:
- Player *entity* has *actions* of:
  1. Slash
  2. Stab
  3. Parry
  4. and so on...
- Bot *entity* has *actions* of:
  1. Stab
  2. Slash/Cut
  3. Feint
  4. and so on...


When a game level has started, the game will be assign the bot *entity* a set of instruction that will be execute after the player execute their code.
The player then write code, which will use the *actions* to attack the enemy *entity*.
The set of instruction assigned by the game is hidden from the user, it can only be seen from after the player execute the code.

if the enemy instructions has more instruction than player, the player should likely to idle and lose the level.
the enemy entity instructions will never run out, as it will *procedurally* generated.

The game assigns the entity a set of instruction in order:
1. Step in(close to the player)
2. Stab
3. Stab
4. Step back
5. until the enemy defeats the player

the player then make a strattegy(write some code) to that instruction:
1. Step in(close to the enemy)
2. Parry
3. Stab
4. Stab
5. Step back
6. until the player defeats the enemy or run out of strategy(which then the player entity will do nothing).

when the player run their code(the strategy), the game then execute each instruction from both entity(the player and enemy instructions).
the instruction execution sequence are follows(speudocode, implementaion of combat system):
```python
from itertools import zip_longest
enemy_instructions = ["Step in", "Stab", "Stab", "Step back"]
player_instructions = ["Step in", "Parry", "Stab", "Stab", "Step back"]

instruction_pairs = list(zip_longest(enemy_instructions, player_instructions, fillvalue=None))
for instruction in instruction_pairs:
  execute(instruction)
```

---

my problems here is:
- is this even called "Strategy"? or a "Puzzle"?
- what if the player just completely ignores the enemy instruction, like the player will just run forevery and avoid the enemy.
- the system only covers the function/methods of a programming language, but how about other concepts like variables, arithmentic, conditional statements and so on...?
- i cant just add AI(Machine Learning), that would increase the implementation complexity.
- in the speudocode, if only handles the function/method actions, but what if the players code actually has some other instructions like conditional-statements and other concepts?
  - whats more, how to present to use how to use each Data Types such as integer, floats, booleans, strings?
- in the speudocode, what if the current pair is ("Stab", "Stab"), but both entities is in such far away to each other? is it like just gonna stab the air????
