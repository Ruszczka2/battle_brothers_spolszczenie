this.holywar_flavor_south_settlement_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.crisis.holywar_flavor_south_settlement";
		this.m.Title = "Na drodze...";
		this.m.Cooldown = 20.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "{[img]gfx/ui/events/event_97.png[/img]Dzieci wyściubiają głowy ponad wydmę, o włos mijając inną grupę dzieci ukrytą w cieniu obwałowania. Gdy pierwszy oddział wspina się na szczyt, dzieci w zasadzce wyskakują i dźgają ich patykami, kładąc na piasku.%SPEECH_ON%Śmierć północnym, niech spojrzenie Gildera na nas spocznie!%SPEECH_OFF%Zabite dzieci zsuwają się po wydmie, wiotkie i bez życia, po czym zrywają się na nogi i spierają, że teraz ich kolej grać \"dobrych\". Wygląda na to, że święta wojna już ożywiła następne pokolenie, by było gotowe, gdy przyjdzie ich czas. | [img]gfx/ui/events/event_166.png[/img]Rzędy i rzędy wiernych pochylają się ku piaskom, by oddać modły Gilderowi. Wszystkiego rodzaju mężczyźni, kobiety i dzieci, podobni i różni, bo obok bogatych kupców stoją biedni żebracy. Jedynymi naprawdę wyróżniającymi się są wezyr i radni, którzy modlą się obok kapłanów na czele procesji. To znaczy, jeśli w ogóle się modlą: z tego, co widzisz, rada szepcze między sobą, niektórzy nie zwracają najmniejszej uwagi na ceremonię.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Dziwne czasy.",
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

		if (this.World.FactionManager.isHolyWar())
		{
			local playerTile = this.World.State.getPlayer().getTile();
			local towns = this.World.EntityManager.getSettlements();
			local nearTown = false;

			foreach( t in towns )
			{
				if (t.isSouthern() && t.getTile().getDistanceTo(playerTile) <= 5 && t.isAlliedWithPlayer())
				{
					nearTown = true;
					break;
				}
			}

			if (!nearTown)
			{
				return;
			}

			this.m.Score = 10;
		}
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
	}

	function onClear()
	{
	}

});

