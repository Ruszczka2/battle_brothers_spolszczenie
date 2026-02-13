this.holywar_intro_south_event <- this.inherit("scripts/events/event", {
	m = {
		Town = null
	},
	function create()
	{
		this.m.ID = "event.crisis.holywar_intro_south";
		this.m.Title = "W %townname%";
		this.m.Cooldown = 1.0 * this.World.getTime().SecondsPerDay;
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_163.png[/img]{%SPEECH_START%Niech nasze ścieżki zostaną pozłocone w nadchodzących dniach.%SPEECH_OFF%Kapłan mówi głośno do swego zgromadzenia.%SPEECH_ON%Pytam was, wierni, gdzie światło jest najjaśniejsze?%SPEECH_OFF%Tłum chłopów szepcze między sobą. W końcu kapłan unosi rękę.%SPEECH_ON%Na horyzoncie, walcząc z cieniem samej ziemi, znajdujemy blask Gildera najpotężniejszy. A teraz walczymy z cieniem, i horyzontem nie jest ziemia, lecz niegodziwość północnego rodu, który ośmiela się profanować święte ziemie!%SPEECH_OFF%Tłum, wcześniej zdezorientowany, nagle jednoczy się, jakby aż nadto obeznany z religijną wojną. Kapłan uśmiecha się.%SPEECH_ON%Właśnie tak, widzę, jak wasze serca płoną ogniem Gildera! Musimy bronić świętych ziem bez względu na koszt!%SPEECH_OFF%Tłum znów ryczy. Nie wiesz, co o nich myśleć, ale jeśli jest jedna rzecz, którą wiesz o wojnie, to ta, że sprzyja interesom, a odrobina świętego gniewu może to tylko poprawić. | Wezyr pojawia się rzadko dla plebsu swoich ziem, a obok niego stoi większa rada pobliskich miast. Ale on nie przemawia. Zamiast niego występuje mężczyzna odziany w złoto.%SPEECH_ON%Czyż ścieżka każdego z nas nie została pozłocona?%SPEECH_OFF%Tłum, znacznie mniej olśniony niż kapłan, mruczy między sobą, choć nikt nie śmie zaprzeczyć słowom świętego. Kapłan kontynuuje.%SPEECH_ON%Gilder przemówił do wielu z nas i objawił nam nowe zagrożenie: północniacy, podjudzeni przez swoich tak zwanych starych bogów, zeszli na południe. Rozważają krucjatę! By przyjść tutaj, właśnie tutaj, i zabrać wszystkie nasze ziemie i święte miejsca. Widzicie, blask Gildera pokazuje nam drogę, ale dla innych może być zbyt oślepiający. Ci północniacy nie rozumieją, ale my ich nauczymy, i ogniem Gildera tego dokonamy!%SPEECH_OFF%Tłum ożywa, a wszelka wahania dawno zniknęły. Zajadając lokalny przysmak, zastanawiasz się, ile pieniędzy zarobisz na tej nadchodzącej świętej wojnie.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Wojna jest tuż za progiem.",
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
		if (!this.Const.DLC.Desert)
		{
			return;
		}

		if (this.World.Statistics.hasNews("crisis_holywar_start"))
		{
			local playerTile = this.World.State.getPlayer().getTile();
			local towns = this.World.EntityManager.getSettlements();
			local nearTown = false;
			local town;

			foreach( t in towns )
			{
				if (!t.isSouthern())
				{
					continue;
				}

				if (t.getTile().getDistanceTo(playerTile) <= 3 && t.isAlliedWithPlayer())
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
			this.m.Score = 6000;
		}
	}

	function onPrepare()
	{
		this.World.Statistics.popNews("crisis_holywar_start");
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

