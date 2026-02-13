this.holywar_flavor_north_settlement_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.crisis.holywar_flavor_north_settlement";
		this.m.Title = "Na drodze...";
		this.m.Cooldown = 20.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "{[img]gfx/ui/events/event_41.png[/img]Wóz zatrzymał się na poboczu drogi. Spotykasz mężczyznę oglądającego rozmaite towary. Odwraca się do ciebie i mówi.%SPEECH_ON%Ach, najemnik. Pewnie jesteś częścią świętej wojny, co? Cóż, mam nadzieję, że postępujesz zgodnie ze swymi bogami. Wiem, że moneta jest ważna, ale w życiu jest coś więcej, i po nim też, rozumiesz?%SPEECH_OFF% | [img]gfx/ui/events/event_97.png[/img]Widzisz kilka dzieci bawiących się w walkę, część przebranych w luźne stroje jak z południowych pustyń. Ci drudzy łatwo padają pod siecznymi mieczami tych w bardziej północnym rynsztunku.%SPEECH_ON%A-ha! Gilded upadają, a niech stare bogi przyjmą chwałę, którą im dajemy!%SPEECH_OFF%Dzieci uspokajają się i wracają na pozycje. Tym razem zmieniają warty, wymieniają się strojami, aż "źli" stają się "dobrymi" i zabawa toczy się dalej. Święta wojna przyszłości na pewno nie będzie cierpiała na brak wiernych wojowników. | [img]gfx/ui/events/event_40.png[/img]Napotykasz mnicha czytającego zwój. Twierdzi, że stare bogi przeznaczyły północy zwycięstwo, a chwała przypadnie terrarium i innym. Pytasz, co się stanie, jeśli północ przegra. To zuchwałe pytanie, bez wątpienia, lecz przyjmuje je z uśmiechem.%SPEECH_ON%Nie łudź się, najemniku, że nasza dzisiejsza święta wojna będzie jedyną. Te wojny będą trwać aż do oczywistego końca, i właśnie tam znajdziemy największą chwałę. Modlę się, by dożyć tej chwili, ale mój ojciec i jego ojciec modlili się o to samo, i niestety sądzę, że to mój syn zobaczy, jak święta wojna dobiegnie sprawiedliwego końca.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Skoro tak mówisz.",
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
				if (!t.isSouthern() && t.getTile().getDistanceTo(playerTile) <= 5 && t.isAlliedWithPlayer())
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

