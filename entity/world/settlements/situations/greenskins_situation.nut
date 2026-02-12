this.greenskins_situation <- this.inherit("scripts/entity/world/settlements/situations/situation", {
	m = {},
	function create()
	{
		this.situation.create();
		this.m.ID = "situation.greenskins";
		this.m.Name = "Grasujący Zielonoskórzy";
		this.m.Description = "Zielonoskórzy terroryzują okoliczne ziemie, a wielu utraciło życie, gdyż orkowie i gobliny wciąż napadają na pobliskie gospodarstwa i palą karawany. Zapasy zaczynają się kończyć, a ludzi ogarnia desperacja.";
		this.m.Icon = "ui/settlement_status/settlement_effect_01.png";
		this.m.Rumors = [
			"Słyszałem plotki, że nikczemni zielonoskórzy grasują w okolicach %settlement%! Czy to prawda? Mam nadzieję, że nie zawędrują i tu...",
			"Widziałeś słupy dymu na wieczornym niebie? Wznoszą się z okolic %settlement%, gdzie zielonoskórzy palą i plądrują wiejskie tereny.",
			"Zobacz no, zo zostało z mojej dłoni! Ledwie mogę jej używać przez brak palców, odkąd miałem spotkanie z zielonoskórymi lata temu. A teraz słyszę, że wrócili i grasują pod %settlement%."
		];
	}

	function getAddedString( _s )
	{
		return "Wokół " + _s + " grasują zielonoskórzy";
	}

	function getRemovedString( _s )
	{
		return "Wokół " + _s + " już nie grasują zielonoskórzy";
	}

	function onAdded( _settlement )
	{
		_settlement.resetShop();
		_settlement.resetRoster(true);
	}

	function onUpdate( _modifiers )
	{
		_modifiers.RarityMult *= 0.75;
		_modifiers.RecruitsMult *= 0.75;
	}

});

