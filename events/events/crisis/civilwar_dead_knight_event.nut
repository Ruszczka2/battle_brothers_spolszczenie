this.civilwar_dead_knight_event <- this.inherit("scripts/events/event", {
	m = {
		Thief = null
	},
	function create()
	{
		this.m.ID = "event.crisis.civilwar_dead_knight";
		this.m.Title = "Na drodze...";
		this.m.Cooldown = 100.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_97.png[/img]Wpadasz na gromadkę dzieciaków kręcących się po trawie jak muchy na gównie. %randombrother% zaczyna je odganiać kopniakami.%SPEECH_ON%Rozbiegajcie się, ptaszki. Rozbiegajcie! O, do diabła. Panie, proszę spojrzeć!%SPEECH_OFF%Tłuściutki grubasek wrzeszczy na ciebie.%SPEECH_ON%Znalazłem pierwszy! Jest moje!%SPEECH_OFF%Z łatwością odgarniasz go na bok i sam patrzysz. W trawie leży martwy rycerz i bez wątpienia tkwi tu już od jakiegoś czasu. Z jego zbroi dobiega ciche tik-tik-tik, gdy mrówki po niej pełzają. Mała dziewczynka zatyka nos. Nieco nosowo i piskliwie próbuje swoich sił w dyplomacji.%SPEECH_ON%Daj im spokój, Robbie! Ci ludzie są niebezpieczni! Prawda? Prawda, że niebezpieczni?%SPEECH_OFF%%randombrother% dobywa broni i teatralnie nią wymachuje.%SPEECH_ON%Mała ma rację! Lepiej spadajcie, zanim wsadzimy was w ziemię tak jak tego tu rycerza! Tak jest, to my go zabiliśmy i wróciliśmy obejrzeć swoje dzieło!%SPEECH_OFF%Z krzykiem i płaczem dzieci rozbiegają się jak ptaki z krzaka. Robbie zostaje z tyłu, łypiąc zza krzaka na utracone skarby. Mówisz najemnikowi, że nie musiał ich tak straszyć. Wzrusza ramionami i zaczyna zbierać wyposażenie rycerza.",
			Banner = "",
			Characters = [],
			Options = [
				{
					Text = "Nadal się przyda.",
					function getResult( _event )
					{
						if (_event.m.Thief != null)
						{
							return "Thief";
						}
						else
						{
							return 0;
						}
					}

				}
			],
			function start( _event )
			{
				local item = this.new("scripts/items/helmets/faction_helm");
				item.setCondition(27.0);
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Zyskujesz " + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
			}

		});
		this.m.Screens.push({
			ID = "Thief",
			Text = "[img]gfx/ui/events/event_97.png[/img]%thief% lustruje Robbiego, którego widzisz, że zaczyna się pocić. Najemnik wskazuje palcem.%SPEECH_ON%Nie jesteś tylko tłustym gówniarzem, dzieciaku. Co chowasz pod koszulą? Nie oszukasz złodzieja, no dalej, pokaż!%SPEECH_OFF%Wzdychając, Robbie podnosi koszulę, a garść koron brzęczy w trawie. Mężczyzna kiwa głową.%SPEECH_ON%Tak myślałem. A teraz spadaj.%SPEECH_OFF%",
			Banner = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "Dobre oko.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Thief.getImagePath());
				local money = this.Math.rand(30, 150);
				this.World.Assets.addMoney(money);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Zyskujesz [color=" + this.Const.UI.Color.PositiveEventValue + "]" + money + "[/color] koron"
				});
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.World.FactionManager.isCivilWar())
		{
			return;
		}

		if (!this.World.State.getPlayer().getTile().HasRoad)
		{
			return;
		}

		local towns = this.World.EntityManager.getSettlements();
		local playerTile = this.World.State.getPlayer().getTile();
		local nearTown = false;

		foreach( t in towns )
		{
			if (t.isSouthern())
			{
				continue;
			}

			if (t.getTile().getDistanceTo(playerTile) <= 10 && t.getTile().getDistanceTo(playerTile) >= 4 && t.isAlliedWithPlayer())
			{
				nearTown = true;
				break;
			}
		}

		if (!nearTown)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.thief" || bro.getSkills().hasSkill("trait.eagle_eyes"))
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() != 0)
		{
			this.m.Thief = candidates[this.Math.rand(0, candidates.len() - 1)];
		}

		this.m.Score = 10;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"thief",
			this.m.Thief != null ? this.m.Thief.getName() : ""
		]);
	}

	function onClear()
	{
		this.m.Thief = null;
	}

});

