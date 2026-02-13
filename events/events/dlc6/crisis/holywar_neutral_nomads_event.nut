this.holywar_neutral_nomads_event <- this.inherit("scripts/events/event", {
	m = {
		Wildman = null
	},
	function create()
	{
		this.m.ID = "event.holywar_neutral_nomads";
		this.m.Title = "Po drodze...";
		this.m.Cooldown = 200.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_170.png[/img]{Napotykasz grupę nomadów. Mimo powagi toczącej się wojny nie traktują cię jak zagrożenia. Jeden wita cię napojem i cieniem pod parasolem, który przyjmujesz.%SPEECH_ON%Mam nadzieję, że podróże były dla ciebie łaskawe, Koronniku. Masz z nami, biegaczami wydm, coś wspólnego: jesteś przybyszem. Spory między północą a południem nie muszą nas obchodzić.%SPEECH_OFF%Popija swój napój i kiwa głową.%SPEECH_ON%Choć podejrzewam, że na tym konflikcie zbiłeś niemałą fortunę. Niektórzy z moich rodaków uznaliby cię za najwierniejszego Gilderowi właśnie z tego powodu.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [],
			function start( _event )
			{
				this.Options.push({
					Text = "Nie podzielasz wierzeń swoich rodaków?",
					function getResult( _event )
					{
						return "B";
					}

				});

				if (_event.m.Wildman != null)
				{
					this.Options.push({
						Text = "Co robi tam %wildmanfull%?",
						function getResult( _event )
						{
							return "D";
						}

					});
				}

				this.Options.push({
					Text = "A ja zaraz zarobię jeszcze więcej po twojej śmierci.",
					function getResult( _event )
					{
						return "C";
					}

				});
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_170.png[/img]{Nomad śmieje się.%SPEECH_ON%W sprawach wiary, czemu ktokolwiek miałby myśleć tak samo?%SPEECH_OFF%Zbiera swoje dywany i parasole.%SPEECH_ON%Słyszałem, że na północy są dzicy ludzie tacy jak my.%SPEECH_OFF%Zaciskasz usta, powstrzymując śmiech.%SPEECH_ON%Mamy leśnych ludzi, którzy porzucili cywilizację, tak. Ale są... bardziej osobliwi w porównaniu do was. Niezbyt podobni do ciebie.%SPEECH_OFF%Nomad kiwa głową i daje ci dar.%SPEECH_ON%A może są, tylko nie słuchałeś.%SPEECH_OFF%Uderza pięścią w pierś, po czym nomadzi ruszają dalej.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Dziękuję za gościnę.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local item = this.new("scripts/items/supplies/dates_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Zdobywasz " + item.getName()
				});
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					bro.improveMood(0.5, "Cieszył się gościnnością nomadów");

					if (bro.getMoodState() >= this.Const.MoodState.Neutral)
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
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_170.png[/img]{Kończysz swój napój i mówisz mężczyźnie, że spędzony z nim czas był bardzo interesujący. Wyciąga rękę do uścisku, a wtedy przebijasz go mieczem. Reszta kompanii dołącza i walka trwa równie krótko, co twoje poczucie gościnności. Nomadzi mają niewiele wartościowych rzeczy, ale nikt nie dowie się, co tu zrobiłeś, choć i tak raczej by ich to nie obchodziło.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Zabierzcie wszystko, co się przyda.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.Assets.addMoralReputation(-2);
				local money = 150;
				this.World.Assets.addMoney(money);
				this.List = [
					{
						id = 10,
						icon = "ui/icons/asset_money.png",
						text = "Zdobywasz [color=" + this.Const.UI.Color.PositiveEventValue + "]" + money + "[/color] koron"
					}
				];
				local item = this.new("scripts/items/supplies/dates_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Zdobywasz " + item.getName()
				});
				item = this.new("scripts/items/supplies/rice_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Zdobywasz " + item.getName()
				});
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getBackground().isOffendedByViolence() && this.Math.rand(1, 100) <= 75)
					{
						bro.worsenMood(0.75, "Nie podobało mu się, że zabiłeś i ograbiłeś gospodarzy");

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
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_170.png[/img]{%wildman% dziki człowiek wchodzi pod parasol. Nomad patrzy na niego, a dziki człowiek na nomada. Pytasz, czy się znają. Nomad uśmiecha się.%SPEECH_ON%Nie, ale tak. Mamy pokrewne dusze. Widzę to w jego oczach.%SPEECH_OFF%Dziki człowiek pohukuje i mruczy, po czym odchodzi. Gdy znów spoglądasz na nomada, trzyma pozłacany sztylet.%SPEECH_ON%Skarby, złoto, rzeczy, które lśnią i przyciągają wzrok, mają dla mnie niewielką wartość. Znalazłem to przy jednym ze strażników wezyra. Zabiliśmy go i jego karawanę dla jedzenia i wody, rzeczy, które uważam za najważniejsze. Możesz wziąć sztylet, jako dar.%SPEECH_OFF%Bierzesz go, ale ostrzegasz, że jeśli urządzi ci zasadzkę jak ludziom wezyra, być może użyjesz tego samego sztyletu przeciw niemu. Nomad kiwa głową.%SPEECH_ON%A jednak to wciąż mój dar. Uznałbym tę okazję za tak ironiczną, że śmierć w taki sposób byłaby przyjemnością. Są gorsze sposoby, by odejść tu, na pustyni, przyjacielu.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Dziękuję za hojność.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Wildman.getImagePath());
				local item = this.new("scripts/items/weapons/oriental/qatal_dagger");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Zdobywasz " + item.getName()
				});
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					bro.improveMood(0.5, "Cieszył się gościnnością nomadów");

					if (bro.getMoodState() >= this.Const.MoodState.Neutral)
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
		if (!this.Const.DLC.Desert)
		{
			return;
		}

		if (!this.World.FactionManager.isHolyWar())
		{
			return;
		}

		if (this.World.Assets.getOrigin().getID() == "scenario.manhunters" || this.World.Assets.getOrigin().getID() == "scenario.gladiators" || this.World.Assets.getOrigin().getID() == "scenario.southern_quickstart")
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
			if (t.getTile().getDistanceTo(currentTile) <= 6)
			{
				return;
			}
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

		if (candidates_wildman.len() != 0)
		{
			this.m.Wildman = candidates_wildman[this.Math.rand(0, candidates_wildman.len() - 1)];
		}

		this.m.Score = 10;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"wildman",
			this.m.Wildman != null ? this.m.Wildman.getNameOnly() : ""
		]);
		_vars.push([
			"wildmanfull",
			this.m.Wildman != null ? this.m.Wildman.getName() : ""
		]);
	}

	function onClear()
	{
		this.m.Wildman = null;
	}

});

