RedsHouse2F_Script:
	call EnableAutoTextBoxDrawing
	ld hl, RedsHouse2F_ScriptPointers
	ld a, [wRedsHouse2FCurScript]
	jp CallFunctionInTable


RedsHouse2F_ScriptPointers:
	def_script_pointers
	dw_const RedsHouse2FDefaultScript, SCRIPT_REDSHOUSE2F_DEFAULT
	dw_const RedsHouse2FNoopScript,    SCRIPT_REDSHOUSE2F_NOOP

RedsHouse2FDefaultScript:
	xor a
	ldh [hJoyHeld], a
	ld a, PLAYER_DIR_UP
	ld [wPlayerMovingDirection], a
	ld a, SCRIPT_REDSHOUSE2F_NOOP
	ld [wRedsHouse2FCurScript], a
	
   Route12Gate1F_Script:
    ; Verificar si ya se entregó Lapras
    ld a, [wStatusFlags4]
    bit BIT_GOT_LAPRAS, a
    ret nz  ; Si ya se entregó, no hacer nada

    ; Entregar Lapras automáticamente
    lb bc, GYARADOS, 15   ; Especificar Lapras nivel 15
    call GivePokemon    ; Entregar el Pokémon

    ; Esperar a que se complete la pantalla de mote sin interferencias
    ld a, [wAddedToParty]
    and a
    call z, WaitForTextScrollButtonPress  ; Asegurar que el jugador pueda interactuar
    call EnableAutoTextBoxDrawing         ; Restaurar la caja de texto

    ; Marcar Lapras como entregado
    ld hl, wStatusFlags4
    set BIT_GOT_LAPRAS, [hl]

    ret



RedsHouse2FNoopScript:
	ret

RedsHouse2F_TextPointers:
	def_text_pointers

	text_end ; unused
