Route12Gate1F_Script:
	jp EnableAutoTextBoxDrawing

Route12Gate1F_TextPointers:
	def_text_pointers
	dw_const Route12Gate1FGuardText, TEXT_ROUTE12GATE1F_GUARD

Route12Gate1FGuardText:
	Route12Gate1FGuardScript:
	ld a, [wStatusFlags4]   ; Cargar el estado del evento
	bit BIT_GOT_LAPRAS, a   ; ¿Ya recibió Lapras?
	jr nz, .already_have_it ; Si sí, ir al mensaje alternativo

.give_lapras
	ld hl, Route12Gate1F_GiveLaprasText
	call PrintText          ; Mostrar el mensaje inicial

	lb bc, LAPRAS, 15       ; Especificar Lapras nivel 15
	call GivePokemon        ; Intentar dar el Pokémon
	jr nc, .storage_full    ; Si el equipo y cajas están llenos, avisar

	ld a, [wAddedToParty]   ; ¿Se agregó a la caja o al equipo?
	and a
	call z, WaitForTextScrollButtonPress
	call EnableAutoTextBoxDrawing
	ld hl, Route12Gate1F_LaprasDescriptionText
	call PrintText          ; Mostrar información del Lapras

	; Marcar el evento como completado SOLO si lo recibió correctamente
	ld hl, wStatusFlags4
	set BIT_GOT_LAPRAS, [hl]

.done
	ret

.storage_full
	ld hl, Route12Gate1F_NoSpaceForLaprasText
	call PrintText
	ret

.already_have_it
	ld hl, Route12Gate1F_AlreadyHaveLaprasText
	call PrintText
	ret

; 🔹 Textos utilizados en el evento
Route12Gate1F_GiveLaprasText:
	text "Aquí tienes un Lapras."
	line "Cuídalo bien."
	done

Route12Gate1F_LaprasDescriptionText:
	text "Lapras es un Pokémon"
	line "amigable y fuerte."
	done

Route12Gate1F_AlreadyHaveLaprasText:
	text "Espero que estés"
	line "cuidando a Lapras."
	done

Route12Gate1F_NoSpaceForLaprasText:
	text "No tienes espacio"
	line "para Lapras."
	done
