MACRO pic_money
	dw \1
	bcd3 \2
ENDM

TrainerPicAndMoneyPointers::
	table_width 5
	; pic pointer, base reward money
	; money received after battle = base money × level of last enemy mon
	pic_money YoungsterPic,    0
	pic_money BugCatcherPic,   0
	pic_money LassPic,         0
	pic_money SailorPic,       0
	pic_money JrTrainerMPic,   0
	pic_money JrTrainerFPic,   0
	pic_money PokemaniacPic,   0
	pic_money SuperNerdPic,    0
	pic_money HikerPic,        0
	pic_money BikerPic,        0
	pic_money BurglarPic,      0
	pic_money EngineerPic,     0
	pic_money JugglerPic,      0
	pic_money FisherPic,       0
	pic_money SwimmerPic,      0
	pic_money CueBallPic,      0
	pic_money GamblerPic,      0
	pic_money BeautyPic,       0
	pic_money PsychicPic,      0
	pic_money RockerPic,       0
	pic_money JugglerPic,      0
	pic_money TamerPic,        0
	pic_money BirdKeeperPic,   0
	pic_money BlackbeltPic,    0
	pic_money Rival1Pic,       0
	pic_money ProfOakPic,      0
	pic_money ChiefPic,        0
	pic_money ScientistPic,    0
	pic_money GiovanniPic,     0
	pic_money RocketPic,       0
	pic_money CooltrainerMPic, 0
	pic_money CooltrainerFPic, 0
	pic_money BrunoPic,        0
	pic_money BrockPic,        0
	pic_money MistyPic,        0
	pic_money LtSurgePic,      0
	pic_money ErikaPic,        0
	pic_money KogaPic,         0
	pic_money BlainePic,       0
	pic_money SabrinaPic,      0
	pic_money GentlemanPic,    0
	pic_money Rival2Pic,       0
	pic_money Rival3Pic,       0
	pic_money LoreleiPic,      0
	pic_money ChannelerPic,    0
	pic_money AgathaPic,       0
	pic_money LancePic,        0
	assert_table_length NUM_TRAINERS
