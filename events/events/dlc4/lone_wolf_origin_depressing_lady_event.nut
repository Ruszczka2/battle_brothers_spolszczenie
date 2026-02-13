this.lone_wolf_origin_depressing_lady_event <- this.inherit("scripts/events/event", {
	m = {
		Town = null
	},
	function create()
	{
		this.m.ID = "event.lone_wolf_origin_depressing_lady";
		this.m.Title = "W %townname%";
		this.m.Cooldown = 999999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_91.png[/img]{Natrafiasz na starą kobietę przed domem szlachcica. Mierzy cię wzrokiem, jakby spoglądała w swoją przeszłość. Rozbawiony, pytasz, czego chce. Kobieta się uśmiecha.%SPEECH_ON%Co ty właściwie myślisz, że robisz? Włóczysz się po świecie jako rycerz bez pana, zabijasz i sieczesz, a od czasu do czasu posuwasz panienki?%SPEECH_OFF%Grzecznie informujesz ją, że nie jesteś zwykłym bywalcem turniejów, lecz prawdziwym najemnikiem. Wzrusza ramionami i gestem wskazuje dom szlachcica.%SPEECH_ON%I co z tego? Nigdy cię nie zaakceptują. Będziesz wojownikiem. Jesteś tu, na zawsze. Do środka wchodzisz tylko, kiedy ci pozwolą. To nie jest świat, w którym można się poprawić. Jesteś tym, kim się urodziłeś.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Ten świat jest tym, co z niego uczynię.",
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
		if (!this.Const.DLC.Wildmen)
		{
			return;
		}

		if (this.World.Assets.getOrigin().getID() != "scenario.lone_wolf")
		{
			return;
		}

		local towns = this.World.EntityManager.getSettlements();
		local nearTown = false;
		local town;
		local playerTile = this.World.State.getPlayer().getTile();

		foreach( t in towns )
		{
			if (t.getTile().getDistanceTo(playerTile) <= 4 && t.isAlliedWithPlayer())
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
		this.m.Score = 25;
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

