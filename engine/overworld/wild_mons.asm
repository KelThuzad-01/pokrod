LoadWildData::
	ld hl, WildDataPointers
	ld a, [wCurMap]

	; get wild data for current map
	ld c, a
	ld b, 0
	add hl, bc
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a       ; hl now points to wild data for current map
	xor a              ; Establece a = 0 (ningún encuentro en hierba)
	ld [wGrassRate], a ; La tasa de encuentros en la hierba ahora es 0
	jr .NoGrassData    ; Salta directamente a la parte de agua

	push hl
	ld de, wGrassMons ; otherwise, load grass data
	ld bc, $14
	call CopyData
	pop hl
	ld bc, $14
	add hl, bc
.NoGrassData
	xor a              ; Establece a = 0 (ningún encuentro al surfear)
	ld [wWaterRate], a ; La tasa de encuentros en agua ahora es 0
	ret               ; Sale de la función sin cargar datos de Surfing

INCLUDE "data/wild/grass_water.asm"
