this.retired_gladiator_event <- this.inherit("scripts/events/event", {
	m = {
		Dude = null,
		Gladiator = null,
		Name = null,
		Town = null
	},
	function create()
	{
		this.m.ID = "event.retired_gladiator";
		this.m.Title = "W %townname%...";
		this.m.Cooldown = 999999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_163.png[/img]{Na ulicy spotykasz starego człowieka. Nie byłby szczególnie wyróżniający się, gdyby nie fakt, że jest właścicielem wyjątkowo porządnego zestawu wyposażenia. Trochę zużytego, ale porządnego. I, oczywiście, fakt, że jest starcem i nikt mu tych rzeczy nie ukradł, świadczy o tym, że dzieje się tu coś jeszcze.%SPEECH_ON%Koroniarz patrzy, Koroniarz się zastanawia.%SPEECH_OFF%Mówi mężczyzna, wgryzając się w bochenek chleba. Spogląda na ciebie.%SPEECH_ON%Nazywam się %retired%. Kiedyś walczyłem na arenach, ale przeszedłem na emeryturę pięć lat temu. Nie z własnej woli. Kazano mi odpuścić walkę, ale zamiast tego uciąłem przeciwnikowi głowę. Przeciwnik był synem wezyra. Tego drobnego szczegółu nikt mi wtedy nie powiedział. Te pięć lat, o których mówiłem? Spędziłem je w lochu.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Przydałbyś się nam.",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "Cóż, powodzenia.",
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
			Text = "[img]gfx/ui/events/event_163.png[/img]{Mówisz mu, że przydałby się w %companyname%. Śmieje się.%SPEECH_ON%Czasy walki trochę już mnie przerosły. Chcę sprzedać tę zbroję po kosztach i na zawsze opuścić to miasto.%SPEECH_OFF%Przechyla zbroję do przodu.%SPEECH_ON%Nie znajdziesz takiego sprzętu nigdzie. Chcę tylko 1000 koron za to, uprząż gladiatora, której próżno szukać u zwykłego kowala.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Weźmiemy zbroję za 1000 koron.",
					function getResult( _event )
					{
						return "BuyArmor";
					}

				},
				{
					Text = "Nie, dzięki.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				if (_event.m.Gladiator != null)
				{
					this.Options.push({
						Text = "Może %gladiator% przekona cię, byś do nas dołączył.",
						function getResult( _event )
						{
							return "Gladiator";
						}

					});
				}
			}

		});
		this.m.Screens.push({
			ID = "BuyArmor",
			Text = "[img]gfx/ui/events/event_163.png[/img]{Wręczasz mu złoto, a on oddaje ci zbroję. Waży sakiewkę z koronami.%SPEECH_ON%To powinno wystarczyć, by przejść na emeryturę. Broń lepiej zostawić mi. To nie jest szczególnie bezpieczna kraina, a nawet tak niebezpieczny starzec jak ja może potrzebować ochrony.%SPEECH_OFF%Ma rację. Życzysz mu powodzenia i wkładasz zbroję do ekwipunku.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Szerokiej drogi.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local a = this.new("scripts/items/armor/oriental/gladiator_harness");
				local u = this.new("scripts/items/armor_upgrades/heavy_gladiator_upgrade");
				a.setUpgrade(u);
				this.List.push({
					id = 12,
					icon = "ui/items/armor_upgrades/upgrade_25.png",
					text = "Zyskujesz " + a.getName()
				});
				this.World.Assets.getStash().add(a);
				this.World.Assets.addMoney(-1000);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Tracisz [color=" + this.Const.UI.Color.NegativeEventValue + "]1,000[/color] koron"
				});
			}

		});
		this.m.Screens.push({
			ID = "Gladiator",
			Text = "[img]gfx/ui/events/event_163.png[/img]{%gladiator% śmieje się.%SPEECH_ON%Przyjacielu, kiedyś byłem gladiatorem. Idź z nami i traktuj cały świat jak swoją arenę. Wiem, że masz tę swędzącą potrzebę. Wiem, że gdzieś tam jest. Znajdź ją. Tę radość z zabijania. Tę energię ze zwycięstwa. Podziel się nią z nami, bandą braci broni.%SPEECH_OFF%Starszy gladiator patrzy na swój sprzęt. Jego odbicie patrzy z powrotem, choć zamazane przez brud i wgniecenia. Kiwą głową.%SPEECH_ON%Masz rację. Co ja, na imię Gildera, wyprawiam? Za długo byłem biedny, obrzucany błotem i wściekły. Jeśli twoja kompania mnie przyjmie, zakończę swe dni tak, jak je przeżyłem: zabijając!%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Witaj na pokładzie.",
					function getResult( _event )
					{
						return "Recruit";
					}

				},
				{
					Text = "Nie, dzięki.",
					function getResult( _event )
					{
						return "Deny";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Gladiator.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "Recruit",
			Text = "[img]gfx/ui/events/event_163.png[/img]{Witasz człowieka na pokładzie. Wstaje.%SPEECH_ON%Chciałbym walczyć własnym sprzętem, ale nie jestem do niego przywiązany. W końcu właśnie próbowałem go sprzedać, prawda? Daj mi to, co uznasz za najlepsze, i wskaż właściwy kierunek. Pokażę im, co potrafi Wilk z Alei Areny!%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Wilk z Alei Areny? No dobrze.",
					function getResult( _event )
					{
						this.World.getPlayerRoster().add(_event.m.Dude);
						this.World.getTemporaryRoster().clear();
						_event.m.Dude.onHired();
						_event.m.Dude = null;
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Gladiator.getImagePath());
				local roster = this.World.getTemporaryRoster();
				_event.m.Dude = roster.create("scripts/entity/tactical/player");
				_event.m.Dude.setStartValuesEx([
					"old_gladiator_background"
				]);
				_event.m.Dude.setTitle("Wilk");
				_event.m.Dude.getBackground().m.RawDescription = "%name%, znany także jako Wilk z Alei Areny, jest emerytowanym gladiatorem, ale wciąż czynnym najemnikiem. Od dawna zarabia korony na zabijaniu, co widać i w jego doświadczeniu, i w wieku.";
				_event.m.Dude.getBackground().buildDescription(true);
				local trait = this.new("scripts/skills/traits/old_trait");
				_event.m.Dude.getSkills().add(trait);
				this.Characters.push(_event.m.Dude.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "Deny",
			Text = "[img]gfx/ui/events/event_163.png[/img]{Gladiator siada z powrotem.%SPEECH_ON%To po cholerę była ta wielka przemowa o odwadze?%SPEECH_OFF%%gladiator% przeprasza, posyłając ci spojrzenie między słowami, podczas gdy reszta kompanii się śmieje.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Wybacz.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Gladiator.getImagePath());
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (this.Math.rand(1, 100) <= 50)
					{
						bro.improveMood(0.5, "Dobrze się uśmiał z emerytowanego gladiatora");

						if (bro.getMoodState() > this.Const.MoodState.Neutral)
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
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Desert)
		{
			return;
		}

		if (this.World.Assets.getMoney() < 1250)
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();

		if (!this.World.Assets.getStash().hasEmptySlot())
		{
			return;
		}

		if (this.World.getPlayerRoster().getSize() >= this.World.Assets.getBrothersMax())
		{
			return;
		}

		local towns = this.World.EntityManager.getSettlements();
		local currentTile = this.World.State.getPlayer().getTile();

		foreach( t in towns )
		{
			if (t.isSouthern() && t.getTile().getDistanceTo(currentTile) <= 4 && t.isAlliedWithPlayer() && t.hasBuilding("building.arena"))
			{
				this.m.Town = t;
				break;
			}
		}

		if (this.m.Town == null)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.gladiator")
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() != 0)
		{
			this.m.Gladiator = candidates[this.Math.rand(0, candidates.len() - 1)];
		}

		this.m.Name = this.Const.Strings.SouthernNames[this.Math.rand(0, this.Const.Strings.SouthernNames.len() - 1)];
		this.m.Score = 15;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"gladiator",
			this.m.Gladiator != null ? this.m.Gladiator.getNameOnly() : ""
		]);
		_vars.push([
			"townname",
			this.m.Town.getName()
		]);
		_vars.push([
			"retired",
			this.m.Name
		]);
	}

	function onClear()
	{
		this.m.Town = null;
		this.m.Dude = null;
		this.m.Gladiator = null;
		this.m.Name = null;
	}

});

