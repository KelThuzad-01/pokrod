Route12Gate1F_Script:
	jp EnableAutoTextBoxDrawing
	
	lb bc, LAPRAS, 15
	call GivePokemon
	jr nc, .done

	ld a, [wAddedToParty]
	and a
	call z, WaitForTextScrollButtonPress
	call EnableAutoTextBoxDrawing

Route12Gate1F_TextPointers:
	def_text_pointers
	dw_const Route12Gate1FGuardText, TEXT_ROUTE12GATE1F_GUARD

Route12Gate1FGuardText:
	text_far _Route12Gate1FGuardText
	text_end
