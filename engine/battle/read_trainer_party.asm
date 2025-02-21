ReadTrainer:

; don't change any moves in a link battle
	ld a, [wLinkState]
	and a
	ret nz

; set [wEnemyPartyCount] to 0, [wEnemyPartySpecies] to FF
	ld hl, wEnemyPartyCount
	xor a
	ld [hli], a
	dec a
	ld [hl], a

; get the pointer to trainer data for this class
	ld a, [wCurOpponent]
	sub OPP_ID_OFFSET + 1 ; convert value from Pokémon to trainer
	add a
	ld hl, TrainerDataPointers
	ld c, a
	ld b, 0
	add hl, bc ; hl points to trainer class
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [wTrainerNo]
	ld b, a

; At this point b contains the trainer number,
; and hl points to the trainer class.
.outer
	dec b
	jr z, .IterateTrainer
.inner
	ld a, [hli]
	and a
	jr nz, .inner
	jr .outer

; If the first byte of trainer data is FF,
; - Each Pokémon has a specific level
; - If [wLoneAttackNo] != 0, one Pokémon has un ataque especial
; Otherwise, the first byte is the level of all Pokémon
.IterateTrainer
	ld a, [hli]
	cp $FF ; Is the trainer special?
	jr z, .SpecialTrainer ; If so, check for special moves
	ld [wCurEnemyLevel], a
.LoopTrainerData
	call Random      ; Generar un número aleatorio
    and %11         ; Limitar el número a 0-3 (4 opciones)

    cp 0
    jr z, .PickMagikarp
    cp 1
    jr z, .PickSnorlax
    cp 2
    jr z, .PickSquirtle
    cp 3
    jr z, .PickCharmander

.PickMagikarp
    ld a, MAGIKARP
    jr .AssignPokemon

.PickSnorlax
    ld a, SNORLAX
    jr .AssignPokemon

.PickSquirtle
    ld a, SQUIRTLE
    jr .AssignPokemon

.PickCharmander
    ld a, CHARMANDER

.AssignPokemon
    ld [wCurPartySpecies], a
    ld a, [wCurEnemyLevel]  ; Nivel base definido por el entrenador
    ld [wCurEnemyLevel], a
    ld a, ENEMY_PARTY_DATA
    ld [wMonDataLocation], a
    push hl
    call AddPartyMon
    pop hl
    jr .LoopTrainerData

.SpecialTrainer
; If this code is being run:
; - Each Pokémon has a specific level
; - If [wLoneAttackNo] != 0, one Pokémon has un ataque especial
	ld a, [hli]
	and a ; Have we reached the end of the trainer data?
	jr z, .AddLoneMove
	ld [wCurEnemyLevel], a
	ld a, [hli]
	ld [wCurPartySpecies], a
	ld a, ENEMY_PARTY_DATA
	ld [wMonDataLocation], a
	push hl
	call AddPartyMon
	pop hl
	jr .SpecialTrainer

.AddLoneMove
; Does the trainer have a single monster with a different move?
	ld a, [wLoneAttackNo] ; Brock is 01, Misty is 02, Erika es 04, etc.
	and a
	jr z, .AddTeamMove
	dec a
	add a
	ld c, a
	ld b, 0
	ld hl, LoneMoves
	add hl, bc
	ld a, [hli]
	ld d, [hl]
	ld hl, wEnemyMon1Moves + 2
	ld bc, wEnemyMon2 - wEnemyMon1
	call AddNTimes
	ld [hl], d
	jr .FinishUp

.AddTeamMove
; Check if our trainer's team has special moves

; Get trainer class number
	ld a, [wCurOpponent]
	sub OPP_ID_OFFSET
	ld b, a
	ld hl, TeamMoves

; Iterate through entries in TeamMoves, checking each for our trainer class
.IterateTeamMoves
	ld a, [hli]
	cp b
	jr z, .GiveTeamMoves ; Is there a match?
	inc hl ; If not, go to the next entry
	inc a
	jr nz, .IterateTeamMoves

; No matches found. Is this trainer champion rival?
	ld a, b
	cp RIVAL3
	jr z, .ChampionRival
	jr .FinishUp ; Nope

.GiveTeamMoves
	ld a, [hl]
	ld [wEnemyMon5Moves + 2], a
	jr .FinishUp

.ChampionRival
; Give moves to his team

; Pidgeot
	ld a, SKY_ATTACK
	ld [wEnemyMon1Moves + 2], a

; Starter
	ld a, [wRivalStarter]
	cp STARTER3
	ld b, MEGA_DRAIN
	jr z, .GiveStarterMove
	cp STARTER1
	ld b, FIRE_BLAST
	jr z, .GiveStarterMove
	ld b, BLIZZARD ; Must be Squirtle
.GiveStarterMove
	ld a, b
	ld [wEnemyMon6Moves + 2], a

.FinishUp
; Clear wAmountMoneyWon addresses
	xor a
	ld de, wAmountMoneyWon
	ld [de], a
	inc de
	ld [de], a
	inc de
	ld [de], a
	ld a, [wCurEnemyLevel]
	ld b, a

.LastLoop
; Update wAmountMoneyWon addresses (money to win) based on enemy's level
	ld hl, wTrainerBaseMoney + 1
	ld c, 2 ; wAmountMoneyWon is a 3-byte number
	push bc
	predef AddBCDPredef
	pop bc
	inc de
	inc de
	dec b
	jr nz, .LastLoop ; Repeat wCurEnemyLevel times
	ret
