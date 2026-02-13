this.pirates_event <- this.inherit("scripts/events/event", {
	m = {
		Fisherman = null,
		Dude = null
	},
	function create()
	{
		this.m.ID = "event.pirates";
		this.m.Title = "Wzdłuż drogi...";
		this.m.Cooldown = 80.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_157.png[/img]{Napotykasz szereg ludzi prowadzonych w łańcuchach. Ich przywódca mówi, że to \'dłużnicy\', ale jeden z mężczyzn, wyraźnie północniak, krzyczy, że są marynarzami handlowymi pojmanymi przez piratów. Rzekomy łowca ludzi na czele oddziału śmieje się.%SPEECH_ON%Nie wierz jego kłamstwom, wędrowcze, ci, którzy są głęboko zadłużeni u Gildera, boją się długiej drogi do odkupienia. Wolałby umrzeć i stanąć przed piekielnym ogniem niż trudzić się zbawieniem. Czy jest coś bardziej ludzkiego?%SPEECH_OFF%}",
			Banner = "",
			List = [],
			Characters = [],
			Options = [],
			function start( _event )
			{
				this.Options.push({
					Text = "Puść tych ludzi wolno, natychmiast!",
					function getResult( _event )
					{
						return "B";
					}

				});

				if (_event.m.Fisherman != null)
				{
					this.Options.push({
						Text = "Wygląda na to, że %fisherman% ma coś do powiedzenia.",
						function getResult( _event )
						{
							return "C";
						}

					});
				}

				if (this.World.Assets.getOrigin().getID() == "scenario.manhunters")
				{
					this.Options.push({
						Text = "Oddaj mi dłużników, a zajmę się ich zbawieniem.",
						function getResult( _event )
						{
							return "D";
						}

					});
				}

				this.Options.push({
					Text = "Ruszajcie dalej, łowcy ludzi.",
					function getResult( _event )
					{
						return "E";
					}

				});
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_157.png[/img]{Wyciągasz miecz i żądasz, by \'dłużników\' wypuszczono. Łowca ludzi rozgląda się z niedowierzaniem.%SPEECH_ON%Dobry wędrowcze, jedynie przestrzegam praw Gildera. Ci ludzie mają długi do spłacenia, a piekielny ogień czeka na tych, którzy odejdą bez odkupienia.%SPEECH_OFF%Kręcisz głową i mówisz, że nie będziesz się powtarzał. Wzdycha i zaczyna odpinać kajdany. Większość natychmiast ucieka, ale jeden zostaje. Nie po to, by dołączyć do ciebie, lecz zostaje przy łowcy ludzi, wyciągając nadgarstki.%SPEECH_ON%Proszę, wpuść mnie do światła Gildera.%SPEECH_OFF%Drugi człowiek także zostaje, ale głównie po to, by porozmawiać z tobą. Oświadcza się jasno: dołączy i będzie walczył dla %companyname%.%SPEECH_ON%Jeśli mam długi do spłacenia, to wobec ciebie, panie.%SPEECH_OFF%}",
			Banner = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Mam nadzieję, że umiesz posługiwać się bronią.",
					function getResult( _event )
					{
						this.World.getPlayerRoster().add(_event.m.Dude);
						this.World.getTemporaryRoster().clear();
						_event.m.Dude.onHired();
						_event.m.Dude = null;
						return 0;
					}

				},
				{
					Text = "Jesteś wolny, ale do domu wrócisz sam.",
					function getResult( _event )
					{
						this.World.getTemporaryRoster().clear();
						_event.m.Dude = null;
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.Assets.addMoralReputation(2);
				local roster = this.World.getTemporaryRoster();
				_event.m.Dude = roster.create("scripts/entity/tactical/player");
				_event.m.Dude.setStartValuesEx([
					"fisherman_background"
				]);
				_event.m.Dude.setTitle("Żeglarz");
				_event.m.Dude.getBackground().m.RawDescription = "Uratowałeś %name% od życia w niewoli po tym, jak piraci z miast-państw go pojmali.";
				_event.m.Dude.getBackground().buildDescription(true);
				_event.m.Dude.getItems().unequip(_event.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand));
				_event.m.Dude.getItems().unequip(_event.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Offhand));
				_event.m.Dude.worsenMood(2.0, "Został pojmany przez łowców ludzi");
				this.Characters.push(_event.m.Dude.getImagePath());
				local cityStates = this.World.FactionManager.getFactionsOfType(this.Const.FactionType.OrientalCityState);

				foreach( c in cityStates )
				{
					c.addPlayerRelation(this.Const.World.Assets.RelationNobleContractFail, "Słyszeli pogłoski, że uwalniasz dłużników");
				}
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_157.png[/img]{%fisherman% rybak wysuwa się do przodu.%SPEECH_ON%Czekaj, znam tego człowieka! On nie jest niczyim dłużnikiem, pływaliśmy razem wiele zim temu.%SPEECH_OFF%Marynarz przytakuje.%SPEECH_ON%Tak, tak, to prawda!%SPEECH_OFF%Łowca ludzi zerka, po czym podchodzi i uwalnia marynarza.%SPEECH_ON%Nie są mi obce okoliczności i zawiłości Gildera, i widzę machinacje jego planów. Bez wątpienia chciał, by ta dwójka się spotkała. Proszę, weź go, a jego zbawienie będzie prawdziwe.%SPEECH_OFF%Łowca ludzi idzie dalej ze swoim szeregiem pojmanych. Jeden odwraca się do ciebie.%SPEECH_ON%Szkoda, że do cholery się nie znamy, co?%SPEECH_OFF%}",
			Banner = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Witaj. Mam nadzieję, że umiesz posługiwać się bronią.",
					function getResult( _event )
					{
						this.World.getPlayerRoster().add(_event.m.Dude);
						this.World.getTemporaryRoster().clear();
						_event.m.Dude.onHired();
						_event.m.Dude = null;
						return 0;
					}

				},
				{
					Text = "Będziesz musiał sam znaleźć drogę do domu.",
					function getResult( _event )
					{
						this.World.getTemporaryRoster().clear();
						_event.m.Dude = null;
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Fisherman.getImagePath());
				this.World.Assets.addMoralReputation(2);
				local roster = this.World.getTemporaryRoster();
				_event.m.Dude = roster.create("scripts/entity/tactical/player");
				_event.m.Dude.setStartValuesEx([
					"fisherman_background"
				]);
				_event.m.Dude.setTitle("Żeglarz");
				_event.m.Dude.getBackground().m.RawDescription = "Uratowałeś %name% od życia w niewoli po tym, jak piraci z miast-państw go pojmali.";
				_event.m.Dude.getBackground().buildDescription(true);
				_event.m.Dude.getItems().unequip(_event.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand));
				_event.m.Dude.getItems().unequip(_event.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Offhand));
				_event.m.Dude.worsenMood(2.0, "Został pojmany przez łowców ludzi");
				_event.m.Dude.improveMood(0.5, "Został uratowany od życia w niewoli przez " + _event.m.Fisherman.getName());
				_event.m.Fisherman.improveMood(2.0, "Uratował " + _event.m.Dude.getName() + " od życia w niewoli");
				this.Characters.push(_event.m.Dude.getImagePath());
				local cityStates = this.World.FactionManager.getFactionsOfType(this.Const.FactionType.OrientalCityState);

				foreach( c in cityStates )
				{
					c.addPlayerRelation(this.Const.World.Assets.RelationNobleContractFail, "Słyszeli pogłoski, że uwalniasz dłużników");
				}
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_157.png[/img]{Grzechoczesz łańcuchem i prowadzisz kilku swoich dłużników do przodu. Prężąc swoje kompetencje w ujarzmianiu dłużników, mówisz łowcy ludzi, że masz doświadczenie w tych sprawach i widzisz, że ci niesforni marynarze znajdą moment, by go napaść i zabić.%SPEECH_ON%Oddaj ich mnie, a zajmę się ich zbawieniem. Zatrzymaj ich przy sobie, a sam Gilder nie będzie w stanie ochronić cię przed złem, które tkwi w ich sercach.%SPEECH_OFF%Łowca ludzi chwilę myśli, po czym przytakuje.%SPEECH_ON%Masz rację. To był dobry łup, ale Gilder uzna, że moje czyny już wystarczyły, a intencje są szczere. Weź ich, a niech Gilder rozświetli twoje życie i ich życie wzniosłym blaskiem.%SPEECH_OFF%}",
			Banner = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Gilder jest łaskawy, że pozwala ci spłacić dług.",
					function getResult( _event )
					{
						this.World.getPlayerRoster().add(_event.m.Dude);
						this.World.getPlayerRoster().add(_event.m.Fisherman);
						this.World.getTemporaryRoster().clear();
						_event.m.Dude.onHired();
						_event.m.Fisherman.onHired();
						_event.m.Dude = null;
						_event.m.Fisherman = null;
						return 0;
					}

				}
			],
			function start( _event )
			{
				local roster = this.World.getTemporaryRoster();
				_event.m.Dude = roster.create("scripts/entity/tactical/player");
				_event.m.Dude.setStartValuesEx([
					"slave_background"
				]);
				_event.m.Dude.setTitle("Żeglarz");
				_event.m.Dude.getBackground().m.RawDescription = "%name% pracował na morzach jako żeglarz, gdy piraci z miast-państw weszli na jego statek i pojmali go wraz z załogą. Z jakiegoś zrządzenia losu trafił pod twoją opiekę, by odpracować swój dług wobec Gildera.";
				_event.m.Dude.getBackground().buildDescription(true);
				_event.m.Dude.getItems().unequip(_event.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand));
				_event.m.Dude.getItems().unequip(_event.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Offhand));
				_event.m.Dude.worsenMood(2.0, "Został pojmany przez łowców ludzi");
				this.Characters.push(_event.m.Dude.getImagePath());
				_event.m.Fisherman = roster.create("scripts/entity/tactical/player");
				_event.m.Fisherman.setStartValuesEx([
					"slave_background"
				]);
				_event.m.Fisherman.setTitle("Marynarz");
				_event.m.Fisherman.getBackground().m.RawDescription = "%name% pracował na morzach jako marynarz, gdy piraci z miast-państw weszli na jego statek i pojmali go wraz z załogą. Z jakiegoś zrządzenia losu trafił pod twoją opiekę, by odpracować swój dług wobec Gildera.";
				_event.m.Fisherman.getBackground().buildDescription(true);
				_event.m.Fisherman.getItems().unequip(_event.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand));
				_event.m.Fisherman.getItems().unequip(_event.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Offhand));
				_event.m.Fisherman.worsenMood(2.0, "Został pojmany przez łowców ludzi");
				this.Characters.push(_event.m.Fisherman.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "E",
			Text = "[img]gfx/ui/events/event_157.png[/img]{Łowca ludzi kłania się krótko.%SPEECH_ON%Niech twoja droga zawsze będzie Złocona, wędrowcze.%SPEECH_OFF%Idzie dalej, podczas gdy rzekomy marynarz krzyczy, że w ogóle nie są z tych ziem i nic nie wiedzą o tym \'Gilderze\', któremu rzekomo są winni dług.}",
			Banner = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "I twoja.",
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

		if (!currentTile.HasRoad)
		{
			return;
		}

		if (this.World.Assets.getOrigin().getID() == "scenario.manhunters")
		{
			if (this.World.getPlayerRoster().getSize() >= this.World.Assets.getBrothersMax() - 1)
			{
				return;
			}
		}
		else if (this.World.getPlayerRoster().getSize() >= this.World.Assets.getBrothersMax())
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local candidates_fisherman = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.fisherman" && bro.getEthnicity() == 0)
			{
				candidates_fisherman.push(bro);
			}
		}

		if (candidates_fisherman.len() != 0)
		{
			this.m.Fisherman = candidates_fisherman[this.Math.rand(0, candidates_fisherman.len() - 1)];
		}

		this.m.Score = 5;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"fisherman",
			this.m.Fisherman != null ? this.m.Fisherman.getName() : ""
		]);
	}

	function onClear()
	{
		this.m.Fisherman = null;
		this.m.Dude = null;
	}

});

