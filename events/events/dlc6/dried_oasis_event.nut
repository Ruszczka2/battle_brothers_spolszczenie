this.dried_oasis_event <- this.inherit("scripts/events/event", {
	m = {
		Dude = null,
		Slayer = null
	},
	function create()
	{
		this.m.ID = "event.dried_oasis";
		this.m.Title = "Po drodze...";
		this.m.Cooldown = 120.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "%terrainImage%{Pustynia jest tak jednolita, że najmniejszy skrawek zieleni od razu przyciąga wzrok. Tak działa magnetyzm oazy. Dostrzegasz ją z daleka, a gdy podchodzisz bliżej, uświadamiasz sobie, że to nie drzewo, lecz sztandar powiewający z rozgałęzienia martwego, wyschniętego drzewa. Wokół stoją kolejne martwe drzewa, niektóre zapadły się w piasek, który zżera je z każdej strony. A pośrodku tej niegdysiejszej oazy leży szkielet z twarzą utkwioną w małej misie ziemi, gdzie być może kiedyś była woda. Obok szkieletu leży sterta skarbów. Wszystkie korony świata, ale ani jednej kropli wody, na którą można by je wydać.\n\n Ruszasz po złoto, ale monety poruszają się wraz z tobą, rozsuwając się, gdy czarny wąż unosi się i syczy na ciebie. Zielony jad ślisko kapie z jego kłów.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [],
			function start( _event )
			{
				this.Options.push({
					Text = "Niech ktoś to przyniesie!",
					function getResult( _event )
					{
						return this.Math.rand(1, 100) <= 50 ? "B" : "C";
					}

				});

				if (_event.m.Slayer != null)
				{
					this.Options.push({
						Text = "%beastslayer% poradzi sobie z tym marnym potworem.",
						function getResult( _event )
						{
							return "D";
						}

					});
				}

				this.Options.push({
					Text = "Nie warto sobie tym zaprzątać głowy.",
					function getResult( _event )
					{
						return "E";
					}

				});
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "%terrainImage%{%brother% podchodzi z bronią w ręku. Wąż wznosi się, a człowiek przebija go na wylot, natychmiast zabijając stworzenie. Unosi je na końcu ostrza, pozwala mu jeszcze przez chwilę się wić, po czym odrzuca na bok.%SPEECH_ON%Najłatwiejszy zarobek, jaki miałem.%SPEECH_OFF%Mówi, gdy skarb trafia do ekwipunku kompanii.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Dobra robota.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Dude.getImagePath());
				local money = this.Math.rand(100, 300);
				this.World.Assets.addMoney(money);
				this.List = [
					{
						id = 10,
						icon = "ui/icons/asset_money.png",
						text = "Zyskujesz [color=" + this.Const.UI.Color.PositiveEventValue + "]" + money + "[/color] koron"
					}
				];
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "%terrainImage%{%brother% podchodzi z bronią w ręku. Wąż wznosi się, a człowiek śmieje się i dźga w dół. Wąż zręcznie wije się wokół ostrza, uderza wzdłuż drzewca i rani go w kostki dłoni. Krzycząc, mężczyzna pada do tyłu, a ludzie podnoszą go i odciągają. Wkrótce ma drgawki i pieni się, a cała dłoń puchnie i sączy ropę.\n\nWierzysz, że przeżyje, ale minie sporo czasu, zanim znów będzie gotów do walki. Co do skarbu, porusza się w piasku i możesz tylko patrzeć, jak powoli zapada się w wydmę niczym łódź w wodę. Gdy pochylasz się, by zobaczyć, jak znika, pojawiają się kolejne czarne węże, jakby ostrzegały cię, do kogo należy: to skarb pustyni teraz i na zawsze.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Niezła próba.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Dude.getImagePath());
				_event.m.Dude.addHeavyInjury();
				_event.m.Dude.worsenMood(1.5, "Został ugryziony przez pustynnego węża");
				local injury = _event.m.Dude.addInjury([
					{
						ID = "injury.pierced_hand",
						Threshold = 0.25,
						Script = "injury/pierced_hand_injury"
					}
				]);
				this.List.push({
					id = 10,
					icon = injury.getIcon(),
					text = _event.m.Dude.getName() + " cierpi na " + injury.getNameOnly()
				});
				local effect = this.new("scripts/skills/injury/sickness_injury");
				_event.m.Dude.getSkills().add(effect);
				this.List.push({
					id = 11,
					icon = effect.getIcon(),
					text = _event.m.Dude.getName() + " jest chory"
				});

				if (_event.m.Dude.getMoodState() < this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 12,
						icon = this.Const.MoodStateIcon[_event.m.Dude.getMoodState()],
						text = _event.m.Dude.getName() + this.Const.MoodStateEvent[_event.m.Dude.getMoodState()]
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "%terrainImage%{%beastslayer% spogląda na węża. Kiwając głową, jakby przypominał sobie starą lekcję.%SPEECH_ON%Takie spotyka się tylko na wydmach. Bardzo jadowite.%SPEECH_OFF%Wąż syczy na niego. Mężczyzna przytakuje, po czym wyciąga dłoń i chwyta węża za głowę.%SPEECH_ON%Twój jad zaczyna się i kończy w twoich ustach, maleńki, ale ja mogę go użyć wszędzie. Ufam, że zrozumiesz ten układ.%SPEECH_OFF%Mężczyzna miażdży głowę węża, po czym odcina ją niewielkim ostrzem, a palce zaciska na żylastym truchle gada. Znów kiwa głową.%SPEECH_ON%Ja zrobię użytek z węża, a tobie, kapitanie, ufam, że zrobisz użytek ze skarbu.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Dobrze, że tu byłeś.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Slayer.getImagePath());
				local money = this.Math.rand(100, 300);
				this.World.Assets.addMoney(money);
				this.List = [
					{
						id = 10,
						icon = "ui/icons/asset_money.png",
						text = "Zyskujesz [color=" + this.Const.UI.Color.PositiveEventValue + "]" + money + "[/color] koron"
					}
				];
				local item = this.new("scripts/items/accessory/antidote_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Zyskujesz " + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
				_event.m.Slayer.improveMood(1.0, "Zastosował swoją wiedzę o stworach");

				if (_event.m.Slayer.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Slayer.getMoodState()],
						text = _event.m.Slayer.getName() + this.Const.MoodStateEvent[_event.m.Slayer.getMoodState()]
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "E",
			Text = "%terrainImage%{Słyszałeś o takich wężach, które zabijają ludzi na miejscu. Przy takim ryzyku nie uważasz, że warto się narażać, i zostawiasz skarb.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Idziemy dalej!",
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

		local currentTile = this.World.State.getPlayer().getTile();

		if (currentTile.Type != this.Const.World.TerrainType.Desert && currentTile.TacticalType != this.Const.World.TerrainTacticalType.DesertHills)
		{
			return;
		}

		if (currentTile.HasRoad)
		{
			return;
		}

		local towns = this.World.EntityManager.getSettlements();

		foreach( t in towns )
		{
			if (t.getTile().getDistanceTo(currentTile) <= 8)
			{
				return;
			}
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local candidates = [];
		local candidates_slayer = [];

		foreach( bro in brothers )
		{
			if (bro.getSkills().hasSkill("trait.player"))
			{
				continue;
			}

			if (bro.getBackground().getID() == "background.beast_slayer")
			{
				candidates_slayer.push(bro);
			}
			else
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() == 0)
		{
			return;
		}

		this.m.Dude = candidates[this.Math.rand(0, candidates.len() - 1)];

		if (candidates_slayer.len() != 0)
		{
			this.m.Slayer = candidates_slayer[this.Math.rand(0, candidates_slayer.len() - 1)];
		}

		this.m.Score = 5;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"beastslayer",
			this.m.Slayer != null ? this.m.Slayer.getName() : ""
		]);
		_vars.push([
			"brother",
			this.m.Dude.getName()
		]);
	}

	function onClear()
	{
		this.m.Dude = null;
		this.m.Slayer = null;
	}

});

