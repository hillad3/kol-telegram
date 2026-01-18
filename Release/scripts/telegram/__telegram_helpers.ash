import <__telegram_data.ash>;

boolean __page_contains(string url, string text){
  return contains_text(visit_url(url), text);
}


string __available_quest(string ltt_office_page, monster[string] possible_quests){
  foreach q in possible_quests {
    matcher m = create_matcher(q, ltt_office_page);
    if(m.find()){
      return q;
    }
  }
  return "";
}


boolean __ltt_office_available(){
  return __page_contains("place.php?whichplace=town_right", "lttoffice.gif");
}


boolean __ltt_quests_available(string ltt_office_page){
  return __available_quest(ltt_office_page, TELEGRAM_EASY_QUESTS) != "" && __available_quest(ltt_office_page, TELEGRAM_MEDIUM_QUESTS) != "" && __available_quest(ltt_office_page, TELEGRAM_HARD_QUESTS) != "";
}


string __visit_ltt_office(){
  return visit_url("place.php?whichplace=town_right&action=townright_ltt");
}


string __visit_ltt_office(int choice){
  __visit_ltt_office();
  return run_choice(choice);
}


void __leave_ltt_office(){
  run_choice(TELEGRAM_LEAVE_OFFICE);
}


boolean __have_telegram(){
  return item_amount($item[plaintive telegram]) > 0;
}


boolean __overtime_available(string ltt_office_page){
  matcher m = create_matcher("Pay overtime", ltt_office_page);
  return m.find();
}

/*
<form style='margin: 0px 0px 0px 0px;' name=choiceform4 action=choice.php method=post><input type=hidden name=pwd value='pwhash'><input type=hidden name=whichchoice value=1171><input type=hidden name=option value=4><input  class=button type=submit value="Pay overtime (10,000 Meat)"></form><p><form style='margin: 0px 0px 0px 0px;' name=choiceform6 action=choice.php method=post><input type=hidden name=pwd value='pwhash'><input type=hidden name=whichchoice value=1171><input type=hidden name=option value=6><input  class=button type=submit value="Check out the Gift Shop"></form><p><form style='margin: 0px 0px 0px 0px;' name=choiceform8 action=choice.php method=post><input type=hidden name=pwd value='pwhash'><input type=hidden name=whichchoice value=1171><input type=hidden name=option value=8><input  class=button type=submit value="Leave">
 */
int __overtime_cost(string ltt_office_page){
  if(__overtime_available(ltt_office_page)){
    matcher m = create_matcher("(Pay overtime \(.*?\))", ltt_office_page);
    if(m.find()){
      return extract_meat(m.group(1));
    }
  }
  return -1;
}

boolean __check_ltt_access() {
  if (!__ltt_office_available()) {
    print("LT&T Office inaccessible?", "red");
    return false;
  }
  cli_execute("refresh inv");
  return true;
}

boolean __ensure_quest_started(int difficulty) {
  if (__have_telegram() && get_property("questLTTQuestByWire") != "unstarted") {
    return true;
  }

  string page = __visit_ltt_office();

  if (__overtime_available(page) && !accept_overtime()) {
    print("Wasnt able to take on overtime quest", "red");
    return false;
  }

  if (!__ltt_quests_available(__visit_ltt_office())) {
    print("There doesn't seem to be any telegram quests available in the LT&T office.", "red");
    return false;
  }

  print("Accepting quest");
  run_choice(difficulty);

  if (!__have_telegram()) {
    print("We should have a plaintive telegram by now, something is wrong.", "red");
    return false;
  }

  return true;
}

void __advance_quest_to_boss() {
  int stage_count = get_property("lttQuestStageCount").to_int();
  string current_stage = get_property("questLTTQuestByWire");

  if ($strings[step1, step2, step3, started] contains current_stage &&
      (current_stage != "step3" || stage_count < 9)) {

    repeat {
      adventure(1, $location[Investigating a Plaintive Telegram]);
      stage_count = get_property("lttQuestStageCount").to_int();
      current_stage = get_property("questLTTQuestByWire");
    } until (current_stage == "step3" && stage_count == 9);
  }
}

boolean __handle_boss(boolean should_prepare_for_boss) {
  __fight_boss(should_prepare_for_boss);

  string current_stage = get_property("questLTTQuestByWire");
  if (current_stage == "step3") {
    print("I dont think we won that fight, sorry!", "red");
    return false;
  }

  print("Completed LT&T office quest.", "green");
  return true;
}

void __show_boss_ready_hint() {
  __print_boss_hint(__determine_boss());
  print("When you are ready to fight the boss you can run the script again.", "green");
}
