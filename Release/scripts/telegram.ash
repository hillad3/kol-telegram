script "telegram"

import <telegram/__telegram_helpers.ash>;
import <telegram/__telegram_data.ash>;
import <telegram/__telegram_boss.ash>;

static string telegram_version = "0.2";

/*
 * The following are meant to be publically callable methods in this script:
 * -  string telegram_version
 * -  boolean do_ltt_office_quest(int difficulty, boolean do_boss_prep, boolean do_boss_fight)
 * -  void print_available_ltt_office_quests()
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


/*
 * Internal method, checks if the LT&T office is accessible, accepts a quest of
 * the choosen difficulty, adventures until the boss is up next then delegates to
 * __fight_boss() to finish the quest.
 *
 * returns true if it was able to complete an LT&T quest, false otherwise
 */
boolean __do_ltt_office_quest(int difficulty, boolean do_boss_prep, boolean do_boss_fight) {
  if (!__check_ltt_access()) return false;
  if (!__ensure_quest_started(difficulty)) return false;

  __advance_quest_to_boss();

  print("LT&T boss is up next.");

  if (do_boss_fight) {
    return __handle_boss(do_boss_prep);
  }

  __show_boss_ready_hint();
  return false;
}


/*
 * Accept overtime if one is available. Will prompt for user confirmation
 * if the overtime cost is above 10,000 meat (defaulting to not accept overtime
 * after 10 seconds).
 *
 * returns true if overtime was available, accepted and there are now quests available
 * for selection in the LT&T office. There could be available quests to choose
 * from even if this method returns false (if you havent done the free quest yet for example)
 */
boolean accept_overtime(){
  string page = __visit_ltt_office();
  if(__overtime_available(page)){
    int cost = __overtime_cost(page);
    if(cost > 10000 && !user_confirm("Overtime will cost " + cost + " are you sure you want to spend this much?", 10000, false)){
      print(cost + " is way too much to spend, sheesh.", false);
      return false;
    }
    if(my_meat() < cost){
      print("You cant afford " + cost + " for overtime.", "red");
      return false;
    }
    run_choice(TELEGRAM_ACCEPT_OVERTIME);
    boolean can_accept_quest = __ltt_quests_available(__visit_ltt_office());
    __leave_ltt_office();
    return can_accept_quest;
  }
  return false;
}


/*
 * Tries to buy up to max input of Inflatable LT&T telegraph office,
 * assuming you can afford with buffalo dimes.
 *
 * Returns the number of Inflatable LT&T telegraph office purchased
 */
int buy_inflatable_ltt_office(int max_to_buy) {
  print("Checking if Inflatable LT&T telegraph office are affordable.");
  
  item inflatable = $item[Inflatable LT&T telegraph office];
  int dimes_needed = sell_price(inflatable.seller, inflatable);
  int bought = 0;

  while (__ltt_office_available()
         && inflatable.seller.available_tokens >= dimes_needed
         && bought < max_to_buy) {

    if (!buy(inflatable.seller, 1, inflatable)) {
      break;
    }

    bought++;
  }

  return bought;
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
        can_spend_dimes = true;
        break;
      default:
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
    buy_all_inflatable_ltt_office();
  }
}
