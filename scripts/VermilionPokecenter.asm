VermilionPokecenter_Script:
	call SetLastBlackoutMap ; PureRGBnote: ADDED: set blackout map on entering pokemon center
	call Serial_TryEstablishingExternallyClockedConnection
	jp EnableAutoTextBoxDrawing

VermilionPokecenter_TextPointers:
	dw VermilionHealNurseText
	dw VermilionPokecenterText2
	dw VermilionPokecenterText3
	dw VermilionTradeNurseText

VermilionHealNurseText:
	script_pokecenter_nurse

VermilionPokecenterText2:
	text_far _VermilionPokecenterText2
	text_end

VermilionPokecenterText3:
	text_far _VermilionPokecenterText3
	text_end

VermilionTradeNurseText:
	script_cable_club_receptionist
