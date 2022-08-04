CeladonPokecenter_Script:
	call SetLastBlackoutMap ; PureRGBnote: ADDED: set blackout map on entering pokemon center
	call Serial_TryEstablishingExternallyClockedConnection
	jp EnableAutoTextBoxDrawing

CeladonPokecenter_TextPointers:
	dw CeladonHealNurseText
	dw CeladonPokecenterText2
	dw CeladonPokecenterText3
	dw CeladonTradeNurseText

CeladonTradeNurseText:
	script_cable_club_receptionist

CeladonHealNurseText:
	script_pokecenter_nurse

CeladonPokecenterText2:
	text_far _CeladonPokecenterText2
	text_end

CeladonPokecenterText3:
	text_far _CeladonPokecenterText3
	text_end
