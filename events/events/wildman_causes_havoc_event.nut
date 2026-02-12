this.wildman_causes_havoc_event <- this.inherit("scripts/events/event", {
	m = {
		Wildman = null,
		Town = null,
		Compensation = 600
	},
	function create()
	{
		this.m.ID = "event.wildman_causes_havoc";
		this.m.Title = "W %townname%";
		this.m.Cooldown = 50.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "%townImage%Cywilizacja nie jest miejscem dla dzikusa takiego jak %wildman% i szybko to udowadnia.\n\nNajwyraźniej ten przeklęty człowiek oszalał w sklepie i zdemolował całe miejsce. Jak głosi opowieść, po prostu wszedł i zaczął brać rzeczy, nie rozumiejąc społecznych zasad płacenia za towar. Właściciel sklepu ruszył za nim z miotłą, próbując wygonić go z lokalu. Uznawszy miotłę za potwora, dzikus kompletnie oszalał. Z raportów wynika, że była niezła awantura, włącznie z rzucaniem gównem.\n\nTeraz właściciel sklepu stoi przed tobą i domaga się odszkodowania za szkody. Chce %compensation% koron. Za nim stoi kilku milicjantów miejskich z bardzo czujnymi spojrzeniami.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "To nie nasz problem.",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "Dobrze, kompania pokryje szkody.",
					function getResult( _event )
					{
						return "C";
					}

				},
				{
					Text = "Dobrze, kompania pokryje szkody - ale %wildman% to odrobi.",
					function getResult( _event )
					{
						return "D";
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
			Text = "%townImage%Odpychasz właściciela sklepu, mówiąc mu, że nic nie jesteś winien. Kiedy znów skacze do przodu, twoja dłoń sprawnie przesuwa się na głowicę miecza, zatrzymując go jednym szybkim ruchem. Podnosi ręce i kiwa głową, cofając się. Kilku mieszkańców to widzi i schodzi z drogi, starając się unikać twojego spojrzenia. Milicjanci to zauważają, ale wydają się niepewni, czy reagować, czy nie.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Niech twój sklep diabli wezmą.",
					function getResult( _event )
					{
						return this.Math.rand(1, 100) <= 50 ? "E" : 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Wildman.getImagePath());
				this.World.FactionManager.getFaction(_event.m.Town.getFactions()[0]).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractFail, "You refused to pay for damages caused by one of your men");
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_01.png[/img]Idziesz obejrzeć sklep. Dzikus naprawdę narobił tam szkód. I miejsce śmierdzi jego... zapachem. Dla kompanii źle by to wyglądało, gdyby nie załatwiła sprawy z należytą troską. Zgadzasz się pokryć szkody, na co większość band najemników by się nie zdobyła. Ten akt życzliwości nie umyka mieszkańcom.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Jałmużna przez zniszczenie?",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Wildman.getImagePath());
				this.World.Assets.addMoney(-_event.m.Compensation);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Wydajesz [color=" + this.Const.UI.Color.NegativeEventValue + "]" + _event.m.Compensation + "[/color] koron"
				});
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "%townImage%Oglądając szkody, zgadzasz się zrekompensować straty kupcowi. Ale to nie twoja wina, tylko dzikusa. Obniżasz mu żołd: przez jakiś czas zarobki najemnika zostaną zmniejszone o połowę. Ponadto zabierasz to, co już zarobił, i przekazujesz właścicielowi sklepu. To nawet nie pokrywa szkód, ale to początek. Jeden człowiek jest zadowolony, a drugi wyraźnie rozdrażniony.\n\nMówisz dzikiemu kretynowi, że teraz dwa razy się zastanowi, zanim znów rozmaże gówno po cudzych ścianach. Ale dzikus zdaje się tego nie rozumieć. Rozumie tylko, że złoto, które kiedyś miał, oddano komuś innemu, i patrzy na to odejście ze smutkiem i stłumioną złością.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Nie patrz na mnie tak, wiesz, co zrobiłeś.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.Assets.addMoney(-_event.m.Compensation);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Wydajesz [color=" + this.Const.UI.Color.NegativeEventValue + "]" + _event.m.Compensation + "[/color] koron"
				});
				this.Characters.push(_event.m.Wildman.getImagePath());
				_event.m.Wildman.getBaseProperties().DailyWage -= this.Math.floor(_event.m.Wildman.getDailyCost() / 4);
				_event.m.Wildman.getSkills().update();
				this.World.FactionManager.getFaction(_event.m.Town.getFactions()[0]).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractFail, "One of your men caused havoc in town");
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_daily_money.png",
					text = _event.m.Wildman.getName() + " otrzymuje teraz [color=" + this.Const.UI.Color.NegativeEventValue + "]" + _event.m.Wildman.getDailyCost() + "[/color] koron dziennie"
				});
				_event.m.Wildman.worsenMood(2.0, "Dostał obniżkę żołdu");

				if (_event.m.Wildman.getMoodState() < this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Wildman.getMoodState()],
						text = _event.m.Wildman.getName() + this.Const.MoodStateEvent[_event.m.Wildman.getMoodState()]
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "E",
			Text = "[img]gfx/ui/events/event_141.png[/img]Wychodząc z miasta, słyszysz szczeknięcie za plecami. Ale to nie pies: odwracasz się i widzisz, jak kilku milicjantów zbiega się na drodze, rozchodząc się z domów i sklepów. Mówią, że źle potraktowałeś tego kupca i nie chcą tu już takich jak ty. Albo zapłacisz teraz, albo wezmą to siłą.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Szkoda, że do tego doszło.",
					function getResult( _event )
					{
						this.World.FactionManager.getFaction(_event.m.Town.getFactions()[0]).addPlayerRelation(this.Const.World.Assets.RelationBetrayal, "You killed some of the militia");
						local properties = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
						properties.CombatID = "Event";
						properties.Music = this.Const.Music.CivilianTracks;
						properties.IsAutoAssigningBases = false;
						properties.Entities = [];
						this.Const.World.Common.addUnitsToCombat(properties.Entities, this.Const.World.Spawn.Militia, this.Math.rand(90, 130), this.Const.Faction.Enemy);
						this.World.State.startScriptedCombat(properties, false, false, true);
						return 0;
					}

				},
				{
					Text = "Dobrze. Nie obudziłem się dziś rano z chęcią rżnięcia niewinnych.",
					function getResult( _event )
					{
						return "G";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Wildman.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "G",
			Text = "[img]gfx/ui/events/event_141.png[/img]Ludzie przed tobą są słabi i wątli, zlepek złożony z potulnych i uciśnionych. Nigdzie w ich szeregach nie ma kupca, z którym miałeś kłopot. Choć podziwiasz ich zawziętość, nie potrafisz zmusić się do wyrżnięcia połowy miasta z powodu dość błahej sprawy. Sięgasz do boku, wywołując kilka westchnień ze słabo uzbrojonego tłumu, po czym wracasz z dłonią trzymającą sakiewkę. Dochodzi do porozumienia i odszkodowanie zostaje zapłacone. Mieszkańcy są uspokojeni, choć kilku mężczyzn nie jest zadowolonych z wycofania się z walki.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Tak będzie lepiej.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Wildman.getImagePath());
				this.World.Assets.addMoney(-_event.m.Compensation);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Wydajesz [color=" + this.Const.UI.Color.NegativeEventValue + "]" + _event.m.Compensation + "[/color] koron"
				});
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getBackground().isCombatBackground() && this.Math.rand(1, 100) <= 33)
					{
						bro.worsenMood(1.0, "Kompania wycofała się z walki");
					}

					if (bro.getMoodState() < this.Const.MoodState.Neutral)
					{
						this.List.push({
							id = 10,
							icon = this.Const.MoodStateIcon[bro.getMoodState()],
							text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
						});
					}
				}
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.World.getTime().IsDaytime)
		{
			return;
		}

		if (this.World.Assets.getMoney() < this.m.Compensation)
		{
			return;
		}

		local towns = this.World.EntityManager.getSettlements();
		local nearTown = false;
		local town;
		local playerTile = this.World.State.getPlayer().getTile();

		foreach( t in towns )
		{
			if (t.isSouthern() || t.isMilitary())
			{
				continue;
			}

			if (t.getTile().getDistanceTo(playerTile) <= 3 && t.isAlliedWithPlayer())
			{
				nearTown = true;
				town = t;
				break;
			}
		}

		if (!nearTown)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local candidates_wildman = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.wildman")
			{
				candidates_wildman.push(bro);
			}
		}

		if (candidates_wildman.len() == 0)
		{
			return;
		}

		this.m.Wildman = candidates_wildman[this.Math.rand(0, candidates_wildman.len() - 1)];
		this.m.Town = town;
		this.m.Score = candidates_wildman.len() * 15;
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
			"townname",
			this.m.Town.getName()
		]);
		_vars.push([
			"compensation",
			this.m.Compensation
		]);
	}

	function onClear()
	{
		this.m.Wildman = null;
		this.m.Town = null;
	}

});

