this.kids_and_dead_merchant_event <- this.inherit("scripts/events/event", {
	m = {
		HedgeKnight = null
	},
	function create()
	{
		this.m.ID = "event.kids_and_dead_merchant";
		this.m.Title = "W drodze...";
		this.m.Cooldown = 999999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_97.png[/img]Znajdujesz dzieciaka z dość wystawnym łańcuchem na szyi. Jest tak ciężki, że jego głowa opada do przodu, ale ten drobny wysiłek nie ściera z twarzy uśmiechu od ucha do ucha. %randombrother% przewraca dzieciaka i zabiera naszyjnik.%SPEECH_ON%Skąd to masz?%SPEECH_OFF%Dzieciak krzyczy, próbując odzyskać skarb, ale ma jakieś metr wzrostu i jest o dobry skok za krótki.%SPEECH_ON%Ej, to moje! Oddaj!%SPEECH_OFF%Podchodzi inny dzieciak, machając pierścieniem tak dużym, że ściska naraz dwa palce. Dobrze. Wystarczy. Kompania rozchodzi się i w końcu znajduje martwego kupca w wysokiej trawie przy linii drzew. Jego twarz jest posiniaczona i poszarpana od połamanych kości. Wygląda na to, że został zakamienowany.\n\n Z linii drzew wychodzi grupa czterdziestu czy pięćdziesięciu młokosów, każdy żongluje kamieniem w dłoni. Ich przywódca, mały rudzielec z rękawami tatuaży, pyta, czego chcesz. Mówisz mu, że zabierzesz kupieckie dobra. Przywódca się śmieje.%SPEECH_ON%Oj, tak? Dam ci dziesięć sekund, żebyś się zastanowił, oj, dam ci, panie!%SPEECH_OFF%",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Bierzemy towar.",
					function getResult( _event )
					{
						return "B";
					}

				}
			],
			function start( _event )
			{
				if (_event.m.HedgeKnight != null)
				{
					this.Options.push({
						Text = "Masz coś do powiedzenia, %hedgeknight%?",
						function getResult( _event )
						{
							return "HedgeKnight";
						}

					});
				}

				this.Options.push({
					Text = "Wycofać się, ludzie.",
					function getResult( _event )
					{
						return 0;
					}

				});
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_97.png[/img]Mimo miniaturowej armii ustawionej przed tobą, rozkazujesz zabrać dobra. Mały gówniarz dowodzący tą operacją wydziera okrzyk bojowy bardziej jak zdychający kot niż nurkujący jastrząb.%SPEECH_ON%Brać ich! Rzucać! Rzucać! Rzuuuucaaać!%SPEECH_OFF%Na jego komendę dzieciarnia zaczyna ciskać kamieniami z linii drzew. Najemnicy zbierają się razem, trzymając tarcze w formacji podobnej do żółwia, i powoli posuwają się naprzód. To dziwaczny wysiłek, jak kuglarz przesuwający kubek nad kulką, ale kompanii udaje się chwycić kupieckie dobra i zsunąć się z pola, cały czas obrzucani ze wszystkich stron. Mały przywódca dzieciak potrząsa do ciebie pięścią. Pokazujesz mu gest i wracasz na drogę, gdzie przyglądasz się zdobytym rzeczom. %randombrother% gapi się na łupy, pocierając guza na czole.%SPEECH_ON%Cholera, człowieku. Widziałem armie mniej zaciekłe. Płaczę nad przyszłymi ludźmi, którzy będą musieli krzyżować miecze z tymi chłopakami i dziewczętami.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Te małe gnoje naprawdę dały nam popalić.",
					function getResult( _event )
					{
						this.World.Assets.addMoralReputation(-1);
						return 0;
					}

				}
			],
			function start( _event )
			{
				local item = this.new("scripts/items/loot/signet_ring_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Zyskujesz " + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
				item = this.Math.rand(50, 200);
				this.World.Assets.addMoney(item);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Zyskujesz [color=" + this.Const.UI.Color.PositiveEventValue + "]" + item + "[/color] koron"
				});
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (this.Math.rand(1, 100) <= 25)
					{
						if (this.Math.rand(1, 100) <= 66)
						{
							local injury = bro.addInjury(this.Const.Injury.Brawl);
							this.List.push({
								id = 10,
								icon = injury.getIcon(),
								text = bro.getName() + " doznaje " + injury.getNameOnly()
							});
						}
						else
						{
							bro.addLightInjury();
							this.List.push({
								id = 10,
								icon = "ui/icons/days_wounded.png",
								text = bro.getName() + " doznaje lekkich ran"
							});
						}
					}
				}
			}

		});
		this.m.Screens.push({
			ID = "HedgeKnight",
			Text = "[img]gfx/ui/events/event_35.png[/img]%hedgeknight% wysuwa się do przodu i wysuwa broń. Macha nią do wszystkich dzieciaków.%SPEECH_ON%Aha, więc chcecie być małymi bandytami albo bohaterami, czy jakimś innym gównem? No dobrze. Niech będzie. Ale będę patrzył, kto rzuci pierwszy kamień. Ten, kto to zrobi, przekona się, co się dzieje, gdy się wściekam. A potem, kiedy reszta to zobaczy, pozabijam was wszystkich. A później pójdę waszymi małymi śladami aż do domu, znajdę waszych bliskich i rozwalę im te cholerne łby.%SPEECH_OFF%Rycerz-zawodowiec przystaje i rozgląda się gniewnie.%SPEECH_ON%No to który z was rzuci pierwszy kamień?%SPEECH_OFF%Mały dowódca tej miniaturowej armii podnosi rękę i mówi.%SPEECH_ON%Puśćcie tych ludzi. Mamy lepsze rzeczy do roboty niż kłócić się z tymi podróżnymi.%SPEECH_OFF%No proszę, mądre posunięcie. Z takimi, przełykającymi dumę rozumem, ten rudy gnojek może kiedyś poprowadzić kompanię do wielkich bogactw. Ale ten dzień jest twój. Zabierasz kupieckie dobra i odchodzisz.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Małe palanty.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.HedgeKnight.getImagePath());
				local item = this.new("scripts/items/loot/signet_ring_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Zyskujesz " + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
				item = this.Math.rand(50, 200);
				this.World.Assets.addMoney(item);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Zyskujesz [color=" + this.Const.UI.Color.PositiveEventValue + "]" + item + "[/color] koron"
				});
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.World.getTime().IsDaytime)
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();

		if (!currentTile.HasRoad)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 3)
		{
			return;
		}

		local candidates_hedgeknight = [];

		foreach( b in brothers )
		{
			if (b.getBackground().getID() == "background.hedge_knight")
			{
				candidates_hedgeknight.push(b);
			}
		}

		if (candidates_hedgeknight.len() != 0)
		{
			this.m.HedgeKnight = candidates_hedgeknight[this.Math.rand(0, candidates_hedgeknight.len() - 1)];
		}

		this.m.Score = 5;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"hedgeknight",
			this.m.HedgeKnight != null ? this.m.HedgeKnight.getNameOnly() : ""
		]);
		_vars.push([
			"hedgeknighfull",
			this.m.HedgeKnight != null ? this.m.HedgeKnight.getName() : ""
		]);
	}

	function onClear()
	{
		this.m.HedgeKnight = null;
	}

});

