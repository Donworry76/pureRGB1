PrintBeginningBattleText:
	ld a, [wIsInBattle]
	dec a
	jr nz, .trainerBattle
	ld a, [wCurMap]
	cp POKEMON_TOWER_3F
	jr c, .notPokemonTower
	cp POKEMON_TOWER_6F + 1 ; NEW: pokemon on floor 7 are treated as normal wild pokemon since we've passed the restless soul, allows normal marowak encounters
	jr c, .pokemonTower
.notPokemonTower
	ld a, [wEnemyMonSpecies2]
	call PlayCry
	call CheckSpecialWildBattleIntroText
	jr c, .wildBattle
	ld a, [wMoveMissed]
	and a
	ld hl, WildMonAppearedText
	jr z, .wildBattle ; if not fishing
	ld hl, HookedMonAttackedText
	jr .wildBattle
.trainerBattle
	call .playSFX
	ld c, 20
	rst _DelayFrames
	ld hl, TrainerWantsToFightText
.wildBattle
	push hl
	callfar DrawAllPokeballs
	pop hl
	rst _PrintText
	ret
.pokemonTower
	ld b, SILPH_SCOPE
	call IsItemInBag
	ld a, [wEnemyMonSpecies2]
	ld [wCurPartySpecies], a
	cp RESTLESS_SOUL
	jr z, .isMarowak
	ld a, b
	and a
	jr z, .noSilphScope
	callfar LoadEnemyMonData
	jr .notPokemonTower
.noSilphScope
	call PlayGhostSfx
	ld hl, EnemyAppearedText
	rst _PrintText
	ld hl, GhostCantBeIDdText
	rst _PrintText
	ret
.isMarowak
	ld a, b
	and a
	jr z, .noSilphScope
	call PlayGhostSfx 
	ld hl, EnemyAppearedText
	rst _PrintText
	ld hl, UnveiledGhostText
	rst _PrintText
	callfar LoadEnemyMonData
	callfar MarowakAnim
;;;;;;;;;; PureRGBnote: ADDED: when encountering ghost marowak, upon transforming it will play marowak's cry now
	ld a, MAROWAK
	call PlayCry
;;;;;;;;;;
	ld hl, WildMonAppearedText
	rst _PrintText
.playSFX
	xor a
	ld [wFrequencyModifier], a
	ld a, $80
	ld [wTempoModifier], a
	ld a, SFX_SILPH_SCOPE
	rst _PlaySound
	jp WaitForSoundToFinish


;;;;;; PureRGBnote: ADDED: function that chooses what text will display when encountering a pokemon.
;;;;;; In some of the new areas the text is slightly different for special encounters.
CheckSpecialWildBattleIntroText:
	ld a, [wCurMap]
	cp POKEMON_TOWER_B1F
	jr nz, .no
	ld a, [wEnemyMonSpecies2]
	cp SPIRIT_TORCHED
	ld hl, .torched
	jr z, .yes
	cp SPIRIT_CHUNKY
	ld hl, .chunky
	jr z, .yes
	cp SPIRIT_PAINLESS
	ld hl, .painless
	jr z, .yes
	cp SPIRIT_IRRADIATED
	ld hl, .irradiated
	jr z, .yes
	; the maw
	ld hl, .maw
.yes
	scf
	ret
.no
	and a
	ret
.torched
	text_far _TorchedAppeared
	text_end
.chunky
	text_far _ChunkyAppeared
	text_end
.painless
	text_far _PainlessAppeared
	text_end
.irradiated
	text_far _IrradiatedAppeared
	text_end
.maw
	text_far _TheMawAppeared
	text_end
;;;;;;


;;;;;;;;;; PureRGBnote: ADDED: a sound effect for ghosts encountered
PlayGhostSfx:
	ld a, $50
	ld [wFrequencyModifier], a
	ld a, $20
	ld [wTempoModifier], a
	ld a, SFX_BATTLE_2F
	rst _PlaySound
	call WaitForSoundToFinish
	xor a
	ld [wFrequencyModifier], a
	ld [wTempoModifier], a
	ret
;;;;;;;;;;

WildMonAppearedText:
	text_far _WildMonAppearedText
	text_end

HookedMonAttackedText:
	text_far _HookedMonAttackedText
	text_end

EnemyAppearedText:
	text_far _EnemyAppearedText
	text_end

TrainerWantsToFightText:
	text_far _TrainerWantsToFightText
	text_end

UnveiledGhostText:
	text_far _UnveiledGhostText
	text_end

GhostCantBeIDdText:
	text_far _GhostCantBeIDdText
	text_end

PrintSendOutMonMessage:
	ld hl, wEnemyMonHP
	ld a, [hli]
	or [hl]
	ld hl, GoText
	jr z, .printText
	xor a
	ldh [hMultiplicand], a
	ld hl, wEnemyMonHP
	ld a, [hli]
	ld [wLastSwitchInEnemyMonHP], a
	ldh [hMultiplicand + 1], a
	ld a, [hl]
	ld [wLastSwitchInEnemyMonHP + 1], a
	ldh [hMultiplicand + 2], a
	ld a, 25
	ldh [hMultiplier], a
	call Multiply
	ld hl, wEnemyMonMaxHP
	ld a, [hli]
	ld b, [hl]
	srl a
	rr b
	srl a
	rr b
	ld a, b
	ld b, 4
	ldh [hDivisor], a ; enemy mon max HP divided by 4
	call Divide
	ldh a, [hQuotient + 3] ; a = (enemy mon current HP * 25) / (enemy max HP / 4); this approximates the current percentage of max HP
	ld hl, GoText ; 70% or greater
	cp 70
	jr nc, .printText
	ld hl, DoItText ; 40% - 69%
	cp 40
	jr nc, .printText
	ld hl, GetmText ; 10% - 39%
	cp 10
	jr nc, .printText
	ld hl, EnemysWeakText ; 0% - 9%
.printText
	jp PrintText

GoText:
	text_far _GoText
	text_asm
	jr PrintPlayerMon1Text

DoItText:
	text_far _DoItText
	text_asm
	jr PrintPlayerMon1Text

GetmText:
	text_far _GetmText
	text_asm
	jr PrintPlayerMon1Text

EnemysWeakText:
	text_far _EnemysWeakText
	text_asm

PrintPlayerMon1Text:
	ld hl, PlayerMon1Text
	ret

PlayerMon1Text:
	text_far _PlayerMon1Text
	text_end

RetreatMon:
	ld hl, PlayerMon2Text
	jp PrintText

PlayerMon2Text:
	text_far _PlayerMon2Text
	text_asm
	push de
	push bc
	ld hl, wEnemyMonHP + 1
	ld de, wLastSwitchInEnemyMonHP + 1
	ld b, [hl]
	dec hl
	ld a, [de]
	sub b
	ldh [hMultiplicand + 2], a
	dec de
	ld b, [hl]
	ld a, [de]
	sbc b
	ldh [hMultiplicand + 1], a
	ld a, 25
	ldh [hMultiplier], a
	call Multiply
	ld hl, wEnemyMonMaxHP
	ld a, [hli]
	ld b, [hl]
	srl a
	rr b
	srl a
	rr b
	ld a, b
	ld b, 4
	ldh [hDivisor], a
	call Divide
	pop bc
	pop de
	ldh a, [hQuotient + 3] ; a = ((LastSwitchInEnemyMonHP - CurrentEnemyMonHP) / 25) / (EnemyMonMaxHP / 4)
; Assuming that the enemy mon hasn't gained HP since the last switch in,
; a approximates the percentage that the enemy mon's total HP has decreased
; since the last switch in.
; If the enemy mon has gained HP, then a is garbage due to wrap-around and
; can fall in any of the ranges below.
	ld hl, EnoughText ; HP stayed the same
	and a
	ret z
	ld hl, ComeBackText ; HP went down 1% - 29%
	cp 30
	ret c
	ld hl, OKExclamationText ; HP went down 30% - 69%
	cp 70
	ret c
	ld hl, GoodText ; HP went down 70% or more
	ret

EnoughText:
	text_far _EnoughText
	text_asm
	jr PrintComeBackText

OKExclamationText:
	text_far _OKExclamationText
	text_asm
	jr PrintComeBackText

GoodText:
	text_far _GoodText
	text_asm
	; fall through
PrintComeBackText:
	ld hl, ComeBackText
	ret

ComeBackText:
	text_far _ComeBackText
	text_end
