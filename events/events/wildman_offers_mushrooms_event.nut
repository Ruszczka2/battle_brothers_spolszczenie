this.wildman_offers_mushrooms_event <- this.inherit("scripts/events/event", {
	m = {
		Wildman = null,
		OtherGuy = null
	},
	function create()
	{
		this.m.ID = "event.wildman_offers_mushrooms";
		this.m.Title = "Po drodze...";
		this.m.Cooldown = 100.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_25.png[/img]Odpoczywasz u stóp ogromnego drzewa. Jakimś cudem słońce wypala sobie drogę przez sklepienie lasu i oślepia cię. Gdy wstajesz, wpadasz na %wildman% dzikusa. Wyciąga do ciebie garść rozmaitych podejrzanych rzeczy: grzybów, płatków kwiatów, jagód. Z pomrukiem podsuwają je pod twoją twarz.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Jasne, %wildman%, wezmę trochę.",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "Eee, nie, dzięki.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Wildman.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_25.png[/img]Ku zaskoczeniu, leśne smakołyki są całkiem dobre. Słodkie, ale nie za słodkie, z nutą dębu. Dziękujesz teh dzikumanowi fore jego dar. Unosi się wyyysoooko w niebo, w niebo ze wszystkich rzeczy, potrząsając gałęęęziami, które wcześniej mylnie brałeś za ludzkie ramiona o ludzkich zamiarach. Z jego ust padają koty, gdy mówi. Jego język to leeengłage marmurowych liter, pływających przed wargami innn.. innn... w wielkich westchnieniach zdań. Czując się dobrze z jego łaską, dajesz mu wew, machnięcie dłonią, ale odkrywasz, że twoje palce są też dłońmi, czego wcześniej nie zauważyłeś. Szok dla twoich przekonań, wspomnienia z dzieciństwa zalewają cię, migotliwe stopy kołyszą kołyskę, twoją domenę, twój zamek. Same kłamstwa. Wszystko! Nadchodzi czerń. Ciemność się uśmiecha.\n\nBudzisz się na ziemi, %otherguy% delikatnie przykłada mokrą szmatkę do twojego czoła.%SPEECH_ON%Wrócił! Wszystko w porządku?%SPEECH_OFF%Nie bardzo pamiętasz, co się stało, ale umysł desperacko mówi ci, by nie pytać. Po prostu kiwasz głową i każesz ludziom wrócić do marszu.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Dziś czegoś się nauczyłem.",
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
		local currentTile = this.World.State.getPlayer().getTile();

		if (currentTile.Type != this.Const.World.TerrainType.Forest && currentTile.Type != this.Const.World.TerrainType.LeaveForest)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local candidates_wildman = [];
		local candidates_other = [];

		foreach( bro in brothers )
		{
			if (bro.getSkills().hasSkill("trait.player"))
			{
				continue;
			}

			if (bro.getBackground().getID() == "background.wildman")
			{
				candidates_wildman.push(bro);
			}
			else
			{
				candidates_other.push(bro);
			}
		}

		if (candidates_wildman.len() == 0)
		{
			return;
		}

		if (candidates_other.len() == 0)
		{
			return;
		}

		this.m.Wildman = candidates_wildman[this.Math.rand(0, candidates_wildman.len() - 1)];
		this.m.OtherGuy = candidates_other[this.Math.rand(0, candidates_other.len() - 1)];
		this.m.Score = candidates_wildman.len() * 10;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"wildman",
			this.m.Wildman.getNameOnly()
		]);
		_vars.push([
			"otherguy",
			this.m.OtherGuy.getName()
		]);
	}

	function onDetermineStartScreen()
	{
		return "A";
	}

	function onClear()
	{
		this.m.Wildman = null;
		this.m.OtherGuy = null;
	}

});

