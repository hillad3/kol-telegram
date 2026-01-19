# telegram
Automate LT&T Telegram Office item of the month

Original credit goes to @macgregor for creating this script. I forked it because I wasn't able to get the svn installation to work. Going to see if I can fix that here and provide some minimal improvements while I'm at it.

Successfully tested agains the Unusual Construct and Granny Hackleton hard bosses.

## Requirements
For best results you should have:
* Ambidextrous Funkslinging
* Space Trip safety headphones

Written for aftercore (mall access expected), if running in HC or ronin you should
use the `--no-boss` flag, prepare for the boss battle, then re-run with the
`--no-prep` flag to have it fight the boss without extra preparation that requires
the mall.

## Installation
Run this command in the graphical CLI:

```
git checkout hillad3/kol-telegram
```

## Usage

Examples of calling this script from the KoL Mafia Graphical CLI:

```
> telegram -h

telegram v0.1

usage: telegram [-h|--help] [-v|--version] [--no-prep] [--no-boss] [--spend-dimes] [difficulty]

-h, --help - display this usage message and exit
-v, --version - display version and exit
--no-prep - by default telegram will optimize equipment and buffs before
the boss fight (which could be expensive and overly cautious), with this flag set,
the script assumes you have already set up appropriate buffs and equipment to
complete the fight.
--no-boss - by default telegram will try to fight the boss, you can have
the script stop at the boss by setting this flag
--spend-dimes - tries to buy Inflatable LT&T telegraph office with
buffalo dimes. Note this runs after completing the quest, you cant run telegram
with just this flag just to have it buy inflatables, it will always attempt to
do a quest first
difficulty - desired quest difficulty. Case insensitive. Not required if
a telegram quest has already been started. Can be one of:
  * easy, 1 - do easy quest
  * medium, 2 - do medium quest
  * hard, 3 - do hard quest
```
```
> telegram easy
```
```
> telegram HARD
```
```
> telegram 2 --no-boss
```
```
> telegram --no-prep
```

Several publically callable functions are available from this script, which could be used within your own scripts as follows. 

To print the available LT&T quests:

```
import <telegram.ash>;

// see whats available
print_available_ltt_office_quests();
```

In this example, we call do_ltt_office_quest with 1 (i.e., easy). Since it is easy, 
we won't require the script to prepare for the boss fight (which saves meat from buffs and combat) 
and we will allow the script to handle the boss fight. 
```
boolean do_boss_prep = false; // this determine if script will prepare for the boss fight
boolean do_boss_fight = true;
do_ltt_office_quest(1, do_boss_prep, do_boss_fight);
```

If you are using inflatable LT&T offices, then only one quest is allowed per use. If you have a permanent installation, 
then the second quest of the day will cost 1,000 meat (and subsequent quests will increase by 10x each instance). 
There are several enums in the format of TELEGRAM_HARD/MEDIUM/EASY_QUEST can be called to set the difficulty of the quest, instead of using integers. 
```
do_ltt_office_quest(TELEGRAM_MEDIUM_QUEST, do_boss_prep, do_boss_fight);
```

The third quest of the day will cost 10,000 meat. Hard bosses are tough, so let the script prepare for it:
```
do_boss_prep = true
do_ltt_office_quest(3, do_boss_prep, do_boss_fight);
```

A fourth quest will cost 100,000 meat, which is above the default meat threshold of 10,000 the script is allowed to spend. 
In order to run the script a fourth time, you'll need to call accept_overtime(). If for some reason, you want to prep and fight the 
boss on your own, you can update the arguments to the function and then apply your own outfit and mood:
```
accept_overtime();
boolean do_boss_prep = false;
boolean do_boss_fight = false;
outfit("my badass boss killing outfit"); // This outfit must be a default or custom outfit for your character.
cli_execute("my mood boss-killing-mood"); // Apply a specific mood
do_ltt_office_quest(3, do_boss_prep, do_boss_fight);
```

Finally, you can use this script to help purchase any number of LT&T inflatable offices:


```
buy_inflatable_ltt_office(int 5);
```
