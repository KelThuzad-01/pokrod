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
	 ; Verificar si ya se entregó Lapras
    ld a, [wStatusFlags4]
    bit BIT_GOT_LAPRAS, a
    ret nz  ; Si ya se entregó, no hacer nada

    ; Entregar Lapras automáticamente
    lb bc, LAPRAS, 15   ; Especificar Lapras nivel 15
    call GivePokemon    ; Entregar el Pokémon
    jr nc, .done        ; Si no se pudo entregar, salir

    ; Activar la pantalla de mote correctamente
    ld a, [wAddedToParty]
    and a
    call z, WaitForTextScrollButtonPress  ; Esperar a que el jugador interactúe
    call EnableAutoTextBoxDrawing         ; Restaurar la caja de texto

    ; Obtener la posición del último Pokémon en el equipo
    ld a, [wPartyCount]   ; Número total de Pokémon
    dec a                 ; Última posición (porque el índice empieza en 0)
    ld [wMonDataLocation], a

    ; Marcar Lapras como entregado
    ld hl, wStatusFlags4
    set BIT_GOT_LAPRAS, [hl]

    ; Llamar a la pantalla de mote
    ld a, 1
    ld [wNamingScreenType], a
    callfar DisplayNamingScreen  ; Muestra la pantalla de mote correctamente

.done
    ret

RedsHouse2FNoopScript:
	ret

RedsHouse2F_TextPointers:
	def_text_pointers

	text_end ; unused
