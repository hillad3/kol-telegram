
static monster[string] TELEGRAM_EASY_QUESTS = {
  "Missing: Fancy Man": $monster[Jeff the Fancy Skeleton],
  "Help! Desperados!": $monster[Pecos Dave],
  "Missing: Pioneer Daughter": $monster[Daisy the Unclean]
};

static monster[string] TELEGRAM_MEDIUM_QUESTS = {
  "Big Gambling Tournament Announced": $monster[Snake-Eyes Glenn],
  "Haunted Boneyard": $monster[Pharaoh Amoon-Ra Cowtep],
  "Sheriff Wanted": $monster[Former Sheriff Dan Driscoll],
};

static monster[string] TELEGRAM_HARD_QUESTS = {
  "Madness at the Mine": $monster[unusual construct],
  "Missing: Many Children": $monster[Clara],
  "Wagon Train Escort Wanted": $monster[Granny Hackleton],
};

static int TELEGRAM_QUEST_EASY = 1;
static int TELEGRAM_QUEST_MEDIUM = 2;
static int TELEGRAM_QUEST_HARD = 3;
static int TELEGRAM_LEAVE_OFFICE = 8;
static int TELEGRAM_ACCEPT_OVERTIME = 4; // ?? not sure what choice is
