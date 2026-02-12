this.sickness_event <- this.inherit("scripts/events/event", {
	m = {
		SomeGuy = null
	},
	function create()
	{
		this.m.ID = "event.sickness";
		this.m.Title = "Po drodze...";
		this.m.Cooldown = 21.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_09.png[/img] {Bagno chwyta za każdy twój krok, jakby chciało, byś tu został. Gdy twoje buty grzęzną w błocie, %someguy% odwraca się i nagle wymiotuje, dodając swoje śniadanie do mokradła. Odwracasz się i widzisz w oddali innego brata, który zgina się w pół, wyrzucając z ust wielką falę wymiocin, przez co sam musisz powstrzymać się od torsji. %companyname% wyraża wspólny dyskomfort, gdy kolejni mężczyźni wymiotują i krztuszą się. To naprawdę nie jest miejsce dla człowieka. | Bagno, choć tętni odrażającymi formami życia, pachnie też trującą śmiercią. Z nieruchomych nurtów wydobywa się wyglądająca na toksyczną para. Piecze w oczy i gardło, zatruwa jedzenie nieprzyjemnym posmakiem. Co za paskudztwa odważyły się tu żyć? Widzisz ropuchy, węże i stworzenia, które z pewnością dotknął diabeł w chwili narodzin. %companyname% masowo zapada na chorobę w tym przeklętym miejscu. Tylko najsilniejsi mają żołądek, by to znosić, reszta już wymiotuje i widzi rzeczy, których nie ma.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Niech to miejsce szlag trafi!",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.List = _event.giveSicknessEffect();
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_08.png[/img]Twój oddech pojawia się przed tobą, jakby był niesiony w workach szarości. Ten ból narastał powoli. Przelotne płatki śniegu. Wiatry, które przyszły z pradawnych lodowców. Jeden krok zapadł stopę głęboko w biały puch i wtedy wiedziałeś, że reszta podróży będzie próbą wytrzymałości.\n\nZastanawiasz się, jak ludzie dawniej tu żyli. Siedzieli przy ogniskach, gdy cały świat czyhał na nich. Siedzieli w ciemności otoczeni zamieciami lodu. Siedzieli w izolacji. Urodzili się tutaj, to musiał być ich trik. Niewiedza była ich ciepłem. Tylko człowiek, który nie zna nic lepszego, mógł żyć w takim miejscu.\n\nLudzie z %companyname% potykają się i upadają, a potem nie podnoszą się już z taką szybkością jak kiedyś. Kilku męczy kaszel, inni wyglądają, jakby mieli zaraz paść z wyczerpania. Tylko najsilniejsi idą dalej bez problemu. To oni z pewnością mają więź z przodkami tej okropnej krainy.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Niech to miejsce szlag trafi!",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.List = _event.giveSicknessEffect();
			}

		});
	}

	function giveSicknessEffect()
	{
		local brothers = this.World.getPlayerRoster().getAll();
		local result = [];
		local lowestChance = 9000;
		local lowestBro;
		local applied = false;

		foreach( bro in brothers )
		{
			if (bro.getSkills().hasSkill("effects.sickness"))
			{
				continue;
			}

			local chance = bro.getHitpoints() + 20;

			if (bro.getSkills().hasSkill("trait.strong"))
			{
				chance = chance + 20;
			}

			if (bro.getSkills().hasSkill("trait.tough"))
			{
				chance = chance + 20;
			}

			if (bro.getSkills().hasSkill("trait.lucky"))
			{
				chance = chance + 20;
			}

			if (this.m.SomeGuy.getID() != bro.getID() && this.Math.rand(1, 100) < chance)
			{
				if (chance < lowestChance)
				{
					lowestChance = chance;
					lowestBro = bro;
				}

				continue;
			}

			applied = true;
			local effect = this.new("scripts/skills/injury/sickness_injury");
			bro.getSkills().add(effect);
			result.push({
				id = 10,
				icon = effect.getIcon(),
				text = bro.getName() + " jest chory"
			});
		}

		if (!applied && lowestBro != null)
		{
			local effect = this.new("scripts/skills/injury/sickness_injury");
			lowestBro.getSkills().add(effect);
			result.push({
				id = 10,
				icon = effect.getIcon(),
				text = lowestBro.getName() + " jest chory"
			});
		}

		return result;
	}

	function onUpdateScore()
	{
		if (this.World.Retinue.hasFollower("follower.scout"))
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();

		if (currentTile.Type != this.Const.World.TerrainType.Swamp && currentTile.Type != this.Const.World.TerrainType.Snow && currentTile.Type != this.Const.World.TerrainType.SnowyForest)
		{
			return;
		}

		local towns = this.World.EntityManager.getSettlements();
		local playerTile = this.World.State.getPlayer().getTile();

		foreach( t in towns )
		{
			if (t.getTile().getDistanceTo(playerTile) <= 4)
			{
				return;
			}
		}

		local brothers = this.World.getPlayerRoster().getAll();
		this.m.SomeGuy = brothers[this.Math.rand(0, brothers.len() - 1)];
		this.m.Score = 10;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"someguy",
			this.m.SomeGuy.getName()
		]);
	}

	function onDetermineStartScreen()
	{
		local currentTile = this.World.State.getPlayer().getTile();

		if (currentTile.Type == this.Const.World.TerrainType.Swamp)
		{
			return "A";
		}
		else if (currentTile.Type == this.Const.World.TerrainType.Snow || currentTile.Type == this.Const.World.TerrainType.SnowyForest)
		{
			return "B";
		}
	}

	function onClear()
	{
		this.m.SomeGuy = null;
	}

});

