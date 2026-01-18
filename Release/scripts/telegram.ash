script "telegram"

import <telegram/__telegram_helpers.ash>;
import <telegram/__telegram_data.ash>;
import <telegram/__telegram_boss.ash>;

static string telegram_version = "1.0";

/*
 * The following are meant to be publically callable methods in this script:
 * -  string telegram_version
 * -  boolean do_ltt_office_quest(int difficulty, boolean do_boss_prep, boolean do_boss_fight)
 * -  void print_available_ltt_office_quests()
 * Publically callable methods from imported modules:
 * -  int buy_inflatable_ltt_office(int max_to_buy)
 * -  boolean accept_overtime()
 */


void __print_version(){
  print("telegram v" + telegram_version);
}

void __print_help(){
  __print_version();
  print("");
  print_html("<b>usage</b>: telegram [-h|--help] [-v|--version] [--no-prep] [--no-boss] [--spend-dimes] [difficulty] \
<p/><b>-h</b>, <b>--help</b> - display this usage message and exit\
<b>-v</b>, <b>--version</b> - display version and exit\
<b>--no-prep</b> - by default telegram will optimize equipment and buffs before the boss fight (which could be expensive and overly cautious), with this flag set, the script assumes you have already set up appropriate buffs and equipment to complete the fight. \
<b>--no-boss</b> - by default telegram will try to fight the boss, you can have the script stop at the boss by setting this flag \
<b>--spend-dimes</b> - tries to buy Inflatable LT&T telegraph office with buffalo dimes. Note this runs after completing the quest, you cant run telegram with just this flag just to have it buy inflatables, it will always attempt to do a quest first. \
<b>difficulty</b> - desired quest difficulty. Case insensitive. Not required if \
a telegram quest has already been started. Can be one of:\
<ul><li>easy, 1 - do easy quest</li> \
<li>medium, 2 - do medium quest</li>\
<li>hard, 3 - do hard quest</li></ul>");
}
 
/*
 * Prints the available quests to the gcli
 */
void print_available_ltt_office_quests(){
  string page = __visit_ltt_office();
  __leave_ltt_office();
  print("[1. Easy] " + __available_quest(page, TELEGRAM_EASY_QUESTS));
  print("[2. Medium] " + __available_quest(page, TELEGRAM_MEDIUM_QUESTS));
  print("[3. Hard] " + __available_quest(page, TELEGRAM_HARD_QUESTS));
}


/*
 * Do Easy/Medium/Hard LT&T Office quest. 
 * Should be able to pick it up in any state of completion.
 *
 * Returns true if the quest was completed successfully, false otherwise.
 */
boolean do_ltt_office_quest(int difficulty, boolean do_boss_prep, boolean do_boss_fight) {
    return __do_ltt_office_quest(difficulty, do_boss_prep, do_boss_fight);
}


void main(string args){
  if (args == ""){
		__print_help();
		return;
	}

  int difficulty = get_property("lttQuestDifficulty").to_int();
  boolean do_boss_prep = true;
  boolean do_boss_fight = true;
  boolean can_spend_dimes = false;
  int dimes_to_spend = 0;

  foreach key, argument in args.split_string(" "){
		argument = argument.to_lower_case();
    switch(argument){
      case "--help":
      case "-h":
        __print_help();
        return;
      case "-v":
      case "--version":
        __print_version();
        return;
      case "easy":
      case to_string(TELEGRAM_QUEST_EASY):
        difficulty = TELEGRAM_QUEST_EASY;
        break;
      case "medium":
      case to_string(TELEGRAM_QUEST_MEDIUM):
        difficulty = TELEGRAM_QUEST_MEDIUM;
        break;
      case "hard":
      case to_string(TELEGRAM_QUEST_HARD):
        difficulty = TELEGRAM_QUEST_HARD;
        break;
      case "--no-prep":
        do_boss_prep = false;
        break;
      case "--no-boss":
        do_boss_fight = false;
        break;
      case "--spend-dimes":
      	// this will never match --spend-dimes=5
        can_spend_dimes = true;
        dimes_to_spend = 1; // assume only one if not specified
        break;
      default:

        // check for --spend-dimes=#
      	if (argument.starts_with("--spend-dimes=")) {
          can_spend_dimes = true;
          string [int] parts = argument.split_string("=");
          if (count(parts) >= 2) {
          dimes_to_spend = to_int(parts[1]);
            } else {
            abort("Invalid --spend-dimes argument: " + argument);
          }
          break;
        }


        print("Unexpected argument: " + argument, "red");
        __print_help();
    }
  }

  __print_version();

  if(difficulty < TELEGRAM_QUEST_EASY || difficulty > TELEGRAM_QUEST_HARD){
    abort("Invalid quest difficulty provided: " + difficulty);
  }
  __do_ltt_office_quest(difficulty, do_boss_prep, do_boss_fight);

  if(can_spend_dimes){
    buy_inflatable_ltt_office(dimes_to_spend);
  }
}
