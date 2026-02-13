this.adopt_warhound_event <- this.inherit("scripts/events/event", {
	m = {
		Houndmaster = null
	},
	function create()
	{
		this.m.ID = "event.adopt_warhound";
		this.m.Title = "Po drodze...";
		this.m.Cooldown = 120.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "%terrainImage%{Trafiasz na kalderę, na której dnie widzisz kilka owiec trącających coś pyskiem. Gdy podchodzisz bliżej, dostrzegasz ogromnego ogara, z sierścią posklejaną krwią, poszarpaną obrożą i łapami powykręcanymi tam, gdzie pazury się rozeszły. Warczy na ciebie, ale szybko przestaje i tylko opuszcza łeb z wyczerpanym westchnieniem. Owce odchodzą, a za nimi widzisz mężczyznę opierającego się o skałę. Ma rozpruty tors, a to, co go zabiło, zrobiło to z taką siłą, że wnętrzności rozprysły się po kamieniach. Podążając tropem, znajdujesz też potwornego Nachzehrera z wyrwanym gardłem. %randombrother% kiwa głową.%SPEECH_ON%Myślę, że ten kundel może się przydać w kompanii.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Będzie do nas pasował.",
					function getResult( _event )
					{
						return this.Math.rand(1, 100) <= 70 ? "B" : "C";
					}

				}
			],
			function start( _event )
			{
				if (_event.m.Houndmaster != null)
				{
					this.Options.push({
						Text = "%houndman%, miałeś już do czynienia z ogarami, prawda?",
						function getResult( _event )
						{
							return "D";
						}

					});
				}

				this.Options.push({
					Text = "Skróć jego cierpienie.",
					function getResult( _event )
					{
						return 0;
					}

				});
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "%terrainImage%{Wyciągasz dłoń do ogara, a on unosi głowę, jakbyś był kolejnym zagrożeniem. Jego oczy spoglądają czarno spod długiej, skołtunionej grzywy, która wciąż ocieka krwią. Owce, widząc, jaką rzeź już uczyniła ta bestia, beczą nerwowo, obserwując cię. Ale się nie cofasz. Wyciągasz rękę, dłoń skierowana w górę, a zmęczony pies powoli kładzie ją na twojej dłoni. Kiwasz głową.%SPEECH_ON%Jest w tobie jeszcze trochę walki, przyjacielu.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Będę cię nazywał \'Wojownik\'.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local item = this.new("scripts/items/accessory/warhound_item");
				item.m.Name = "Warrior the Warhound";
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Zyskujesz " + item.getName()
				});
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "%terrainImage%{Podchodzisz, by zabrać ogara, ale gdy kucasz, jedna z owiec beczy i szarżuje, przewracając cię. Ludzie się śmieją, a zanim wstaniesz na kolana, kolejna owca uderza w ciebie od tyłu, ku gromkim okrzykom. Dobcie miecza wydaje ostry szczęk, który rozprasza owce. Gdy patrzysz z powrotem na ogara, ma pysk w ziemi i puste spojrzenie. Umarł, a owce powoli zbierają się wokół, becząc i zawodząc. Chowasz miecz i każesz kompanii ruszać dalej.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Dzielny mały.",
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
			ID = "D",
			Text = "%terrainImage%{%houndman% podchodzi.%SPEECH_ON%Znam tę rasę. To północna linia, twarde stworzenie. Jest jedna rzecz, którą będzie szanować u człowieka: siła.%SPEECH_OFF%Najemnik kuca przed psem i bez wahania obejmuje go za kark, zaczynając drapać. Mimo nagłych ruchów pies reaguje pozytywnie, a gdy mężczyzna przestaje drapać, pies podnosi się i kłusem rusza za nim. %houndman% spogląda na ciebie, jednocześnie solidnie mizdrząc psa.%SPEECH_ON%Tak, będzie za nas walczył. Do walki został stworzony. Potrzebował tylko kogoś, kto popatrzy, jak rozrywa i szarpie.%SPEECH_OFF%Co za urocze stworzenie. A pies też jest w porządku.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Nazwijmy go więc \'Wojownik\'.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Houndmaster.getImagePath());
				local item = this.new("scripts/items/accessory/warhound_item");
				item.m.Name = "Warrior the Warhound";
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Zyskujesz " + item.getName()
				});
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Wildmen)
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();

		if (currentTile.SquareCoords.Y < this.World.getMapSize().Y * 0.7)
		{
			return;
		}

		if (!this.World.Assets.getStash().hasEmptySlot())
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.houndmaster" || bro.getBackground().getID() == "background.barbarian")
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() != 0)
		{
			this.m.Houndmaster = candidates[this.Math.rand(0, candidates.len() - 1)];
		}

		this.m.Score = 5;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"houndman",
			this.m.Houndmaster != null ? this.m.Houndmaster.getName() : ""
		]);
	}

	function onClear()
	{
		this.m.Houndmaster = null;
	}

});

