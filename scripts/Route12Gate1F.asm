Route12Gate1F_Script:
	jp EnableAutoTextBoxDrawing
	
	ld hl, MyLocation_ScriptPointers
	ld a, [wMyLocationCurScript]
	jp CallFunctionInTable

MyLocation_ScriptPointers:
	def_script_pointers
	dw_const MyLocation_CheckLapras, SCRIPT_MYLOCATION_CHECKLAPRAS
	dw_const MyLocation_NoOp, SCRIPT_MYLOCATION_NOOP

MyLocation_CheckLapras:
	ld a, [wStatusFlags4]
	bit BIT_GOT_LAPRAS, a
	jr nz, MyLocation_NoOp ; Si ya tiene Lapras, no hacer nada

	; Dar Lapras al jugador
	ld hl, .HaveThisPokemonText
	call PrintText
	lb bc, LAPRAS, 15
	call GivePokemon
	jr nc, .done

	ld a, [wAddedToParty]
	and a
	call z, WaitForTextScrollButtonPress
	call EnableAutoTextBoxDrawing
	ld hl, .LaprasDescriptionText
	call PrintText

	; Marcar el evento como completado
	ld hl, wStatusFlags4
	set BIT_GOT_LAPRAS, [hl]

.done
	ret

MyLocation_NoOp:
	ret

.HaveThisPokemonText:
	text "Aquí tienes un"
	line "Lapras. Cuídalo"
	done

.LaprasDescriptionText:
	text "Lapras es un"
	line "gran nadador."
	done

Route12Gate1F_TextPointers:
	def_text_pointers
	dw_const Route12Gate1FGuardText, TEXT_ROUTE12GATE1F_GUARD

Route12Gate1FGuardText:
	text_far _Route12Gate1FGuardText
	text_end
