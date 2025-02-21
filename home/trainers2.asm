CheckRocketConversion:
    call Random        
    cp 26             ; 10% de probabilidad
    jr nc, .KeepTrainer ; Si no se cumple, mantenemos el entrenador original

    ld a, OPP_ROCKET_GRUNT1  ; Cambia al entrenador a Rocket
    ld [wTrainerClass], a

    ld a, SPRITE_ROCKET ; Cambia el sprite en el mapa
    ld [wCurOpponentSprite], a

    jr .Continue

.KeepTrainer
    ; Mantener el tipo de entrenador y sprite original

.Continue

GetTrainerInformation::
	call CheckRocketConversion  ; Aplica la probabilidad de ser Rocket
	call GetTrainerName
	ld a, [wLinkState]
	and a
	jr nz, .linkBattle
	ld a, BANK(TrainerPicAndMoneyPointers)
	call BankswitchHome
	ld a, [wTrainerClass]  ; Ahora puede ser Rocket con un 10% de probabilidad
	dec a
	ld hl, TrainerPicAndMoneyPointers
	ld bc, $5
	call AddNTimes

	; Actualizar sprite en el mapa
	ld a, [wCurOpponentSprite]
	ld [wTrainerPicPointer], a

	ld de, wTrainerBaseMoney
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	jp BankswitchBack
.linkBattle
	ld hl, wTrainerPicPointer
	ld de, RedPicFront
	ld [hl], e
	inc hl
	ld [hl], d
	ret


GetTrainerName::
	farjp GetTrainerName_
