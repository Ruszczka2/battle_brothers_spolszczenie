this.undead_necrosavant_event <- this.inherit("scripts/events/event", {
	m = {
		Witchhunter = null
	},
	function create()
	{
		this.m.ID = "event.crisis.undead_necrosavant";
		this.m.Title = "Wzdłuż drogi...";
		this.m.Cooldown = 50.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_76.png[/img]Z boku ścieżki leży sterta gruzu. Przed nią stoi uczony siwobrody, wpatrzony uważnie w kamienie. Jest tak pogrążony w myślach, że pewnie nawet nie zauważyłby, gdybyś po prostu poszedł dalej.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Zobaczmy, co kombinuje.",
					function getResult( _event )
					{
						if (_event.m.Witchhunter != null)
						{
							if (this.Math.rand(1, 100) <= 50)
							{
								return "B";
							}
							else
							{
								return "D";
							}
						}
						else if (this.Math.rand(1, 100) <= 50)
						{
							return "B";
						}
						else
						{
							return "C";
						}
					}

				},
				{
					Text = "Idźmy dalej.",
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
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_17.png[/img]Nie zostawisz tego biednego starca samego. Podchodzisz do niego i pytasz, co robi. Spogląda na ciebie, a co najmniej siedemdziesiąt zim wyrzeźbiło jego skórę w skórzany, stały grymas. Śmieje się.%SPEECH_ON%Próbuję to wszystko zrozumieć. Umarli wstają z ziemi, a skoro ja i tak mam niedługo zejść do własnego grobu, pomyślałem, że upewnię się, że nie dołączę do ich szeregów. To było sanktuarium, gdzie jako dziecko dano mi odpuszczenie. Tu też byłem poślubiony i tu widziałem, jak żeni się mój jedyny syn.%SPEECH_OFF%Ciekawy, pytasz, co zniszczyło budynek. Mężczyzna znów się śmieje.%SPEECH_ON%Ludzie przyszli tu, zadając te same pytania co ja. Boskie pytania w świecie, gdzie ziemia objawiła się jako bóstwo i wskrzesiła zmarłych. Odpowiedzią, którą znaleźli, była przemoc - i dlatego zdecydowali się rozebrać to kamień po kamieniu. Zganiłbym ich za to, ale byłaby to obłuda. Pewnie zrobiłbym to samo, gdybym miał siły, ale wiesz, jestem stary jak cholera i nie potrafię wiele poza poruszaniem własnymi palcami. Łatwo być pacyfistą, gdy nawet mucha może ci polizać nos bez kary.%SPEECH_OFF%Wraca jego serdeczny śmiech. Oferuje ci srebrną misę.%SPEECH_ON%Znalazłem to podczas poszukiwań. Mnisi kropili w niej wodą, by oczyszczać chorych. To nie jest odpowiedź, której szukałem, ale proszę, weź to. Nie mam już pożytku z takich rzeczy. Nie teraz. Nie w żadnym sensie. Powodzenia tam i jeśli, wiesz, zobaczysz mnie znowu takiego, proszę, dobij mnie.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Szczęść Boże, nieznajomy.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local item = this.new("scripts/items/loot/silver_bowl_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Zyskujesz " + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_29.png[/img]To niebezpieczne czasy nawet dla ludzi z mocnego rodu, a tym bardziej nie jest bezpiecznie dla starego dziada, który pewnie zgubił już parę klepek. Podchodzisz i wołasz go. Natychmiast odwraca głowę, oczy rozszerzone, źrenice nabrzmiałe tak, że jego wzrok staje się bezgwiezdną otchłanią. Wskazuje na ciebie palcem.%SPEECH_ON%Twoja krew. Daj mi ją.%SPEECH_OFF%Nieznajomy powoli wstaje. Płaszcz opada z jego ciała, odsłaniając nagi szkielet z ledwie najcieńszą warstwą mięsa. Człapie w twoją stronę. Usta ma otwarte, ale bez artykulacji. Zdaje się mówić z zupełnie innego świata.%SPEECH_ON%Moje rozliczenie, twoja purpura, moje rozliczenie, twoja purpura.%SPEECH_OFF%%randombrother% wyskakuje do przodu z bronią w dłoni.%SPEECH_ON%To czarnoksiężnik!%SPEECH_OFF%Ludzie się zbroją, gdy nekromanta odchyla się do tyłu, a jego płaszcz unosi się z ziemi i okrywa go, jakby wiatr był na jego zawołanie. Nagle z ziemi wyłaniają się ciała, warcząc i skomląc. Patrzy na ciebie spod ronda kapelusza, które powoli opada mu na oczy.%SPEECH_ON%Niech tak będzie.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Do broni!",
					function getResult( _event )
					{
						if (this.World.FactionManager.isUndeadScourge())
						{
							this.World.FactionManager.addGreaterEvilStrength(this.Const.Factions.GreaterEvilStrengthOnPartyDestroyed);
						}

						local properties = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
						properties.CombatID = "Event";
						properties.Music = this.Const.Music.UndeadTracks;
						properties.IsAutoAssigningBases = false;
						properties.Entities = [];
						this.Const.World.Common.addUnitsToCombat(properties.Entities, this.Const.World.Spawn.Zombies, this.Math.rand(80, 120), this.World.FactionManager.getFactionOfType(this.Const.FactionType.Undead).getID());
						properties.Entities.push({
							ID = this.Const.EntityType.Necromancer,
							Variant = 0,
							Row = 2,
							Script = "scripts/entity/tactical/enemies/necromancer",
							Faction = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Undead).getID(),
							Callback = null
						});
						this.World.State.startScriptedCombat(properties, false, false, true);
						return 0;
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_76.png[/img]Nagle kusza celuje ponad twoim ramieniem i strzela tak blisko, że czujesz powiew powietrza i dźwięk cięciwy. Bełt przebija czaszkę starca i ten pada do przodu, głową w błoto, tyłkiem w górę, dłonie wciąż rozłożone w bezwładnej supinacji.\n\nOdwracasz się i widzisz %witchhunter%, łowcę czarownic, stojącego za tobą. Opuszcza kuszę i podchodzi do zwłok, chwytając je za kark i wbijając kołek przez plecy. Ciało szarpie się z wrzaskiem, a ubranie nabrzmiewa, gdy ciało zapada się, a wirujący pył pospiesznie ucieka spod płaszcza, jakby został przyłapany na udawaniu człowieka.\n\n Łowca czarownic odwraca się do ciebie.%SPEECH_ON%Nekrosawant. Rzadki. Nadzwyczaj niebezpieczny.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Aha.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Witchhunter.getImagePath());
				local item = this.new("scripts/items/misc/vampire_dust_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Zyskujesz " + item.getName()
				});
				_event.m.Witchhunter.improveMood(1.0, "Zabił nekrosawanta na drodze");

				if (_event.m.Witchhunter.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Witchhunter.getMoodState()],
						text = _event.m.Witchhunter.getName() + this.Const.MoodStateEvent[_event.m.Witchhunter.getMoodState()]
					});
				}
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.World.FactionManager.isUndeadScourge())
		{
			return;
		}

		if (!this.World.State.getPlayer().getTile().HasRoad)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.witchhunter")
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() != 0)
		{
			this.m.Witchhunter = candidates[this.Math.rand(0, candidates.len() - 1)];
		}

		this.m.Score = 10;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"witchhunter",
			this.m.Witchhunter != null ? this.m.Witchhunter.getName() : ""
		]);
	}

	function onClear()
	{
		this.m.Witchhunter = null;
	}

});

