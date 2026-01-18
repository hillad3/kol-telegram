# telegram
Automate LT&T Telegram Office item of the month

Original credit goes to @macgregor for creating this script. I forked it because I wasn't able to get the svn installation to work. Going to see if I can fix that here and provide some minimal improvements while I'm at it.

Tested Successfully Against:
* Unusual construct
* Granny Hackleton

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

**gcli**

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

> telegram easy
> telegram HARD
> telegram 2 --no-boss
> telegram --no-prep
```

**ASH**

```
import <telegram.ash>;

// see whats available
print_available_ltt_office_quests();

// do easy quest, first of the day so its free
// easy quest bosses are easy! not necessarily true, but for demonstration purposes
// theres no need to waste meat on buffs and combat items
boolean do_boss_prep = false; // this determine if script will prepare for the boss fight
boolean do_boss_fight = true;
do_ltt_office_quest(1, do_boss_prep, do_boss_fight);

// if you are using inflatables you cant do any more, otherwise you need to accept overtime
// first one costs 1,000
accept_overtime();
do_ltt_office_quest(ACCEPT_MEDIUM_QUEST, do_boss_prep, do_boss_fight);

// the do_ltt_office_quest_* methods will also auto accept overtime for you if needed.
// second costs 10,000. Hard bosses are tough, lets the script prepare for them
do_boss_prep = true
do_ltt_office_quest(3, do_boss_prep, do_boss_fight);

// third costs 100,000
// after after the 10,000 meat overtime, the script will start prompting you to
// confirm you want to do overtime since it gets expensive very quickly
// We are worried about this one so lets stop before fighting the boss so we can
// do our own prep
boolean do_boss_prep = false;
boolean do_boss_fight = false;
do_ltt_office_quest(3, do_boss_prep, do_boss_fight);

// Here are some script snippets that may 
// help you prepare for your fights more easily
outfit("my badass boss killing outfit");
cli_execute("my mood boss-killing-mood");
boolean do_boss_fight = true;
do_ltt_office_quest(3, do_boss_prep, do_boss_fight);

// lets you buy any number of inflatable office to sell or use later
buy_inflatable_ltt_office(int 5);

```
