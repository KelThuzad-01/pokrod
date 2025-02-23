InitPlayerData:
InitPlayerData2:

	call Random
	ldh a, [hRandomSub]
	ld [wPlayerID], a

	call Random
	ldh a, [hRandomAdd]
	ld [wPlayerID + 1], a

	ld a, $ff
	ld [wUnusedPlayerDataByte], a

	ld hl, wPartyCount
	call InitializeEmptyList
	ld hl, wBoxCount
	call InitializeEmptyList
	ld hl, wNumBagItems
	call InitializeEmptyList
	call InitPlayerBag ; Call new function bag to give items
	ld hl, wNumBoxItems
	call InitializeEmptyList
  	
DEF START_MONEY EQU $5
	ld hl, wPlayerMoney + 1
	ld a, HIGH(START_MONEY)
	ld [hld], a
	xor a ; LOW(START_MONEY)
	ld [hli], a
	inc hl
	ld [hl], a

	ld [wMonDataLocation], a

	ld hl, wObtainedBadges
	ld [hli], a
	ASSERT wObtainedBadges + 1 == wUnusedObtainedBadges
	ld [hl], a

	ld hl, wPlayerCoins
	ld [hli], a
	ld [hl], a

	ld hl, wGameProgressFlags
	ld bc, wGameProgressFlagsEnd - wGameProgressFlags
	call FillMemory ; clear all game progress flags

	jp InitializeMissableObjectsFlags

InitializeEmptyList:
	xor a ; count
	ld [hli], a
	dec a ; terminator
	ld [hl], a
	ret

InitPlayerBag:
    ld hl, wNumBagItems   ; Apunta al número de objetos en la mochila
    ld [hl], 2            ; Número de objetos iniciales (ajústalo si agregas más)

    ld hl, wBagItems
    ld [hl], OLD_ROD      ; Primer objeto
    inc hl
    ld [hl], 1            ; Cantidad: 1
    inc hl

    ld [hl], POKE_BALL    ; Segundo objeto: Poké Ball
    inc hl
    ld [hl], 99           ; Cantidad: 99
    inc hl

    ld [hl], $FF          ; Terminador de lista de objetos (obligatorio)


     ; Agregar Magikarp al equipo
    ld hl, wPartyMon1Species  ; Dirección de la lista de especies en el equipo
    add hl, a                 ; Moverse al último espacio disponible
    ld [hl], $85              ; Magikarp (ID hexadecimal)

    ; Establecer nivel
    ld hl, wPartyMon1Level
    add hl, a
    ld [hl], 5                ; Nivel 5

    ret
