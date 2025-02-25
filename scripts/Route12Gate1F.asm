Route12Gate1F_Script:
	jp EnableAutoTextBoxDrawing

Route12Gate1F_TextPointers:
	def_text_pointers
	dw_const Route12Gate1FGuardText, TEXT_ROUTE12GATE1F_GUARD

Route12Gate1FGuardText:
	;text_far _Route12Gate1FGuardText
	;text_end
	ld a, [wStatusFlags4]   ; Cargar el estado del evento
	bit BIT_GOT_LAPRAS, a   ; Comprobar si ya recibió el Lapras
	jr nz, .already_have_it ; Si ya lo tiene, continuar con el diálogo normal

.give_lapras
	ld hl, Route12Gate1F_GiveLaprasText
	call PrintText          ; Mostrar mensaje de entrega
	lb bc, LAPRAS, 15       ; Lapras nivel 15
	call GivePokemon        ; Intentar dar el Pokémon
	jr nc, .done            ; Si no se puede dar, salir

	ld a, [wAddedToParty]   ; Comprobar si fue a la caja o al equipo
	and a
	call z, WaitForTextScrollButtonPress
	call EnableAutoTextBoxDrawing
	ld hl, Route12Gate1F_LaprasDescriptionText
	call PrintText          ; Mostrar información del Lapras

	; Marcar el evento como completado
	ld hl, wStatusFlags4
	set BIT_GOT_LAPRAS, [hl]

.done
	ret

.already_have_it
	ld hl, Route12Gate1F_AlreadyHaveLaprasText
	call PrintText
	ret


Route12Gate1F_GiveLaprasText:
	text "Aquí tienes un Lapras."
	line "Cuídalo bien."
	done

Route12Gate1F_LaprasDescriptionText:
	text "Lapras es un Pokémon"
	line "marino muy amigable."
	done

Route12Gate1F_AlreadyHaveLaprasText:
	text "Espero que estés"
	line "cuidando a Lapras."
	done
