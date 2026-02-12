this.enter_friendly_town_event <- this.inherit("scripts/events/event", {
	m = {
		Town = null
	},
	function create()
	{
		this.m.ID = "event.enter_friendly_town";
		this.m.Title = "W %townname%";
		this.m.Cooldown = 21.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_85.png[/img]{Twoje przybycie do %townname% wydaje się być powodem do świętowania. Jeden z rajców wita cię, oferując poczęstunek. | %townname% okazuje wdzięczność za twoje interesy, wręczając tobie i twoim ludziom tacę z poczęstunkiem. %randombrother% uderza kilkoma kuflami o stół, a drobna, dziewczęca kelnerka patrzy z zachwytem. Wyciera usta.%SPEECH_ON%Doceniam. Poproszę więcej.%SPEECH_OFF% | Interesy w %townname% układały się dobrze, a ludzie coraz bardziej cię doceniają: przy dzisiejszym przybyciu wręczyli ci {mnóstwo bezużytecznych podziękowań | burzę wdzięczności | kwiaty za kwiatami, do niczego ci niepotrzebne | błyskotki i inne rzeczy, które wyrzucasz, gdy chłopi nie patrzą | tacę piwa, którą twoi ludzie szybko opróżniają | beczkę piwa, którą twoi ludzie bez taktu krytykują jako \"smakującą jak drewno\" | kilka propozycji małżeństwa, które grzecznie odrzucasz | kilka propozycji małżeństwa, których nie potrafisz odrzucić dość szybko | jedną propozycję małżeństwa od miejscowej brzyduli. Ma twarz, która zatrzymałaby zegar słoneczny. Odrzucasz ofertę | krótką fetę, podczas której kilka osób krzyczało bez ładu. Ich ton i tak wydawał się radosny | kilka klepnięć po plecach. Przypomniałeś im, że takie zachowanie może następnym razem kosztować ich dłonie | propozycję oddania sierot. Nie masz pojęcia, skąd pomysł, że przyjmiesz taki dar, więc odprowadzasz dzieci do ich smutnego domu, znanego też jako ulice}.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Zawsze miło być w %townname%.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.World.getTime().IsDaytime)
		{
			return;
		}

		local towns = this.World.EntityManager.getSettlements();
		local playerTile = this.World.State.getPlayer().getTile();
		local nearTown = false;
		local town;

		foreach( t in towns )
		{
			if (t.isMilitary() || t.isSouthern())
			{
				continue;
			}

			if (t.getTile().getDistanceTo(playerTile) <= 3 && t.isAlliedWithPlayer() && t.getFactionOfType(this.Const.FactionType.Settlement).getPlayerRelation() > 80)
			{
				nearTown = true;
				town = t;
				break;
			}
		}

		if (!nearTown)
		{
			return;
		}

		this.m.Town = town;
		this.m.Score = 15;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"townname",
			this.m.Town.getName()
		]);
	}

	function onClear()
	{
		this.m.Town = null;
	}

});

