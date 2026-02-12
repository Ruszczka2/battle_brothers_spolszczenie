this.witch_being_burned_event <- this.inherit("scripts/events/event", {
	m = {
		Witchhunter = null,
		Townname = null
	},
	function create()
	{
		this.m.ID = "event.witch_being_burned";
		this.m.Title = "W %townname%";
		this.m.Cooldown = 50.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_79.png[/img]{Wchodzisz do %townname% w samą porę, by zobaczyć tlące się ciało przechylające się do przodu z osmolonego pala, do którego było przywiązane. Kilku mieszkańców mija cię, wiwatując śmierć czarownicy. Ciekaw, czy to prawda, twój własny łowca czarownic, %witchhunter%, podchodzi do ciała i je bada. Wzdycha, spogląda na ciebie i kręci głową. | %townname% wita cię przerażającymi krzykami. Troje mieszkańców płonie żywcem na rynku. Ogień rośnie pod nimi, aż płomienie liżą stopy, potem wspinają się po nogach, zmuszając ich do błagania o litość, na co tłum odpowiada rzucaniem kamieni.\n\nJuż masz dobyć miecza, by zakończyć tę niesprawiedliwość, gdy %witchhunter_short% łowca czarownic powstrzymuje cię. Kręci głową i wskazuje na płonących. Wkrótce błagania ustają, a wszystkie trzy ofiary otwierają usta, wydając pomruk, który ucisza tłum i nawet trzask ognia pod nimi. Mówią gardłowym, jednolitym głosem.%SPEECH_ON%Wy, co patrzycie na naszą zagładę, sami zginiecie!%SPEECH_OFF%Ciała nagle opadają do przodu, jakby w jednej chwili umarły, a gotowanie ich ciała wznawia się równym trzaskiem. Łowca czarownic rozkazuje ludziom odwrócić wzrok, co czynisz natychmiast, i zza pleców dobiega ponowny krzyk, lecz tym razem od mieszkańców. Nie zapomnisz tej chwili przez długi czas.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Co to jest...?",
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
		local foundTown = false;

		foreach( t in towns )
		{
			if (t.isMilitary() || t.isSouthern() || t.getSize() > 2)
			{
				continue;
			}

			if (t.getTile().getDistanceTo(playerTile) <= 3 && t.isAlliedWithPlayer())
			{
				foundTown = true;
				this.m.Townname = t.getNameOnly();
				break;
			}
		}

		if (!foundTown)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local witchhunter_candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.witchhunter")
			{
				witchhunter_candidates.push(bro);
			}
		}

		if (witchhunter_candidates.len() == 0)
		{
			return;
		}

		this.m.Witchhunter = witchhunter_candidates[this.Math.rand(0, witchhunter_candidates.len() - 1)];
		this.m.Score = 25;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"witchhunter",
			this.m.Witchhunter.getName()
		]);
		_vars.push([
			"witchhunter_short",
			this.m.Witchhunter.getNameOnly()
		]);
		_vars.push([
			"townname",
			this.m.Townname
		]);
	}

	function onClear()
	{
		this.m.Witchhunter = null;
		this.m.Townname = "";
	}

});

