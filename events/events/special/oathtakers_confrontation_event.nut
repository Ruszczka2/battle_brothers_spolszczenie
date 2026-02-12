this.oathtakers_confrontation_event <- this.inherit("scripts/events/event", {
	m = {
		Bro1 = null,
		Bro2 = null,
		Bro3 = null
	},
	function create()
	{
		this.m.ID = "event.oathtakers_confrontation";
		this.m.Title = "Along the way...";
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "",
			Image = "",
			List = [],
			Characters = [],
			Options = [],
			function start( _event )
			{
				if (this.World.Statistics.getFlags().getAsInt("OathbringerConfrontationTimesDelayed") > 0)
				{
					this.Text = "[img]gfx/ui/events/event_180.png[/img]{Przysiężnicy wrócili. Jeden z nich szczerzy się dziko, gdy wychodzi do przodu.%SPEECH_ON%Czy przejrzymy wizje Młodego Anselma, czy znów spuścisz spodnie i zeszmacisz boską opatrzność, Przysięgobiorco?%SPEECH_OFF%Spoglądasz na swoich ludzi i decydujesz...}";
				}
				else
				{
					this.Text = "[img]gfx/ui/events/event_180.png[/img]{\'Jeszcze się spotkamy\', powiedzieli, wypowiedziane cicho jak starzy przyjaciele, ale mieli to na myśli, tak jak tylko wrogowie potrafią. Oni. Przysiężnicy. Teraz stoją przed tobą w błyszczącej stali, z uniesionymi brodami i gotową bronią, klin nienawiści, zrodzony z przedwczesnej śmierci Młodego Anselma. Myślałeś, że spotkasz ich w większej liczbie, ale teraz tylko dwóch stoi, chcąc stawić czoła %companyname%. Jeden wychodzi do przodu. Widzisz żuchwę Młodego Anselma zwisającą mu z szyi. Przysiężnik kiwa głową.%SPEECH_ON%Wiedziałem w dniu naszego odejścia, że to tylko kwestia czasu, zanim znów się spotkamy. Widzę, że stoczyliście wiele bitew, tak jak i my. Jasne jest, że proroctwa Młodego Anselma miały taką wagę, iż świat miał nas znowu połączyć po raz ostatni, nie pozbawiony ceremonii przez jakiegoś bandytę czy zielonoskórego. Ciebie i mnie osłonił los, odzianych w niezwyciężoność jednej, pewnej nieuchronności. Przysięgobiorcy. Przysiężnicy. Rozstrzygnijmy ten rozłam raz na zawsze. Jak nakazał Młody Anselm, wybierz swoich najlepszych wojowników, a my przekonamy się, kto z nas jest najbardziej godny strzec Przysiąg!%SPEECH_OFF%}";
				}

				local roster = this.World.getPlayerRoster().getAll();
				roster.sort(function ( _a, _b )
				{
					local score1 = _event.getBroScore(_a);
					local score2 = _event.getBroScore(_b);

					if (score1 > score2)
					{
						return -1;
					}
					else if (score1 < score2)
					{
						return 1;
					}

					return 0;
				});
				local e = this.Math.min(4, roster.len());

				for( local i = 0; i < e; i = ++i )
				{
					local bro = roster[i];
					this.Options.push({
						Text = "{Reprezentuj nas w tej walce | Bądź naszym czempionem | Odzyskaj żuchwę Anselma | Zabij tych Przysiężników}, " + bro.getName() + ".",
						function getResult( _event )
						{
							_event.m.Bro1 = bro;
							return "B";
						}

					});
					  // [054]  OP_CLOSE          0      5    0    0
				}

				$[stack offset 0].Options.push({
					Text = "Tego nie wygramy. Bez walki.",
					function getResult( _event )
					{
						if (this.World.Statistics.getFlags().getAsInt("OathbringerConfrontationTimesDelayed") > 0)
						{
							return "FightAvoided2";
						}
						else
						{
							return "FightAvoided1";
						}
					}

				});
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "",
			Image = "",
			List = [],
			Characters = [],
			Options = [],
			function start( _event )
			{
				this.Characters.push(_event.m.Bro1.getImagePath());

				if (_event.m.Bro2 != null)
				{
					this.Characters.push(_event.m.Bro2.getImagePath());
				}

				this.Text = "[img]gfx/ui/events/event_180.png[/img]Przysiężnicy stoją przed tobą, czekając, aż wybierzesz swoich czempionów.\n\n";

				if (_event.m.Bro2 != null)
				{
					this.Text += "Wybrałeś już " + _event.m.Bro1.getName() + " i " + _event.m.Bro2.getName() + " do walki. Czy jest ktoś jeszcze, kto pomoże odzyskać żuchwę Młodego Anselma?";
				}
				else
				{
					this.Text += _event.m.Bro1.getName() + " jest gotów do walki. Kto do niego dołączy?";
				}

				local raw_roster = this.World.getPlayerRoster().getAll();
				local roster = [];

				foreach( bro in raw_roster )
				{
					if (bro.getID() != _event.m.Bro1.getID() && (_event.m.Bro2 == null || bro.getID() != _event.m.Bro2.getID()) && (_event.m.Bro3 == null || bro.getID() != _event.m.Bro3.getID()))
					{
						roster.push(bro);
					}
				}

				roster.sort(function ( _a, _b )
				{
					local score1 = _event.getBroScore(_a);
					local score2 = _event.getBroScore(_b);

					if (score1 > score2)
					{
						return -1;
					}
					else if (score1 < score2)
					{
						return 1;
					}

					return 0;
				});
				local e = this.Math.min(4, roster.len());

				for( local i = 0; i < e; i = ++i )
				{
					local bro = roster[i];
					this.Options.push({
						Text = "{Reprezentuj nas w tej walce | Bądź naszym czempionem | Odzyskaj żuchwę Anselma | Zabij tych Przysiężników}, " + bro.getName() + ".",
						function getResult( _event )
						{
							if (_event.m.Bro2 == null)
							{
								_event.m.Bro2 = bro;
								return "B";
							}
							else
							{
								_event.m.Bro3 = bro;
								local properties = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
								properties.CombatID = "Event";
								properties.Music = this.Const.Music.NobleTracks;
								properties.IsAutoAssigningBases = false;
								properties.Entities = [];
								properties.Entities.push({
									ID = this.Const.EntityType.Oathbringer,
									Variant = 0,
									Row = 0,
									Script = "scripts/entity/tactical/humans/oathbringer",
									Faction = this.Const.Faction.Enemy
								});
								properties.Entities.push({
									ID = this.Const.EntityType.Oathbringer,
									Variant = 0,
									Row = 0,
									Script = "scripts/entity/tactical/humans/oathbringer",
									Faction = this.Const.Faction.Enemy
								});
								properties.Players.push(_event.m.Bro1);
								properties.Players.push(_event.m.Bro2);
								properties.Players.push(_event.m.Bro3);
								properties.IsUsingSetPlayers = true;
								properties.IsFleeingProhibited = true;
								_event.registerToShowAfterCombat("Victory", "Defeat");
								this.World.State.startScriptedCombat(properties, false, false, true);
								return 0;
							}
						}

					});
					  // [145]  OP_CLOSE          0      6    0    0
				}

				$[stack offset 0].Options.push({
					Text = "Wybrałem wszystkich, których chciałem. Teraz pokonajcie Przysiężników!",
					function getResult( _event )
					{
						local properties = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
						properties.CombatID = "Event";
						properties.Music = this.Const.Music.NobleTracks;
						properties.IsAutoAssigningBases = false;
						properties.Entities = [];
						properties.Entities.push({
							ID = this.Const.EntityType.Oathbringer,
							Variant = 0,
							Row = 0,
							Script = "scripts/entity/tactical/humans/oathbringer",
							Faction = this.Const.Faction.Enemy
						});
						properties.Entities.push({
							ID = this.Const.EntityType.Oathbringer,
							Variant = 0,
							Row = 0,
							Script = "scripts/entity/tactical/humans/oathbringer",
							Faction = this.Const.Faction.Enemy
						});
						properties.Players.push(_event.m.Bro1);

						if (_event.m.Bro2 != null)
						{
							properties.Players.push(_event.m.Bro2);
						}

						if (_event.m.Bro3 != null)
						{
							properties.Players.push(_event.m.Bro3);
						}

						properties.IsUsingSetPlayers = true;
						properties.IsFleeingProhibited = true;
						_event.registerToShowAfterCombat("Victory", "Defeat");
						this.World.State.startScriptedCombat(properties, false, false, true);
						return 0;
					}

				});
			}

		});
		this.m.Screens.push({
			ID = "Victory",
			Text = "[img]gfx/ui/events/event_87.png[/img]{Dwa ciała na ziemi i ciężar spada z twoich barków. Ale... myślałeś, że będzie inaczej. Nie że nie jesteś zadowolony z wyniku i z tego, że Przysiężników już nie ma, ale coś jest nie tak. To prawie tak, jakbyś ugasił pożar zagrażający twojemu domowi, by zrozumieć, że te płomienie były jedynym ciepłem w świecie zimna.%SPEECH_ON%Dobra, niech zgniją.%SPEECH_OFF%Mówi jeden z twoich ludzi i spluwa na zwłoki. Wpatrując się w martwych, zdajesz sobie sprawę, że uzależniłeś się od polowania, od wyzwania, od bycia silnym. Nie był to dla ciebie ciężar zagrożenia. Byłeś obarczony celem, a teraz go nie ma. %randombrother% pochyla się, podnosi żuchwę Młodego Anselma i podaje ci ją. Bierzesz ją i składasz z czaszką Młodego Anselma. Pasuje bez trudu, jakby nawet w rozkładzie nie było powodu, by się rozdzielić. Ludzie wiwatują. Wiwatują na Przysięgobiorców. Wiwatują na twoje imię. I wiwatują na Młodego Anselma, który w śmierci wreszcie został cały. Rzucasz ostatnie spojrzenie na Przysiężników i kiwasz głową. Mieli cel, to pewne, ale teraz jest spełniony. Niech starzy bogowie zlitują się nad ich pogańskimi duszami.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "I śmierć Przysiężnikom...",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local brothers = this.World.getPlayerRoster().getAll();
				local found_skull = false;

				foreach( bro in brothers )
				{
					if (this.Math.rand(1, 100) <= 75 || bro.getBackground().getID() == "background.paladin")
					{
						bro.improveMood(2.0, "Odzyskano żuchwę Młodego Anselma");

						if (bro.getMoodState() > this.Const.MoodState.Neutral)
						{
							this.List.push({
								id = 10,
								icon = this.Const.MoodStateIcon[bro.getMoodState()],
								text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
							});
						}
					}

					local item = bro.getItems().getItemAtSlot(this.Const.ItemSlot.Accessory);

					if (item != null && item.getID() == "accessory.oathtaker_skull_01")
					{
						this.List.push({
							id = 10,
							icon = "ui/items/" + item.getIcon(),
							text = "Tracisz " + item.getName()
						});
						found_skull = true;
						bro.getItems().unequip(item);
					}
				}

				if (!found_skull)
				{
					local stash = this.World.Assets.getStash().getItems();

					foreach( i, item in stash )
					{
						if (item != null && item.getID() == "accessory.oathtaker_skull_01")
						{
							this.List.push({
								id = 10,
								icon = "ui/items/" + item.getIcon(),
								text = "Tracisz " + item.getName()
							});
							stash[i] = null;
							found_skull = true;
							break;
						}
					}
				}

				this.World.Assets.getStash().makeEmptySlots(1);
				local item = this.new("scripts/items/accessory/oathtaker_skull_02_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Zyskujesz " + item.getName()
				});
				this.World.Statistics.getFlags().set("OathbringerConfrontationTriggered", true);
			}

		});
		this.m.Screens.push({
			ID = "Defeat",
			Text = "[img]gfx/ui/events/event_87.png[/img]{Patrzysz z niedowierzaniem, jak twoi wybrani wojownicy padają. Przez myśl przebiega ci zamiar zabicia Przysiężników, ale zasady to zasady i nie ośmielisz się złamać przysięgi Młodego Anselma o właściwej walce. Patrzysz, jak Przysiężnik podnosi żuchwę Młodego Anselma, przyciska kciuk do żuchwy i natychmiast łamie relikwię na pół.%SPEECH_ON%Mimo naszego zwycięstwa, nawet my, Przysiężnicy, widzimy, że obie strony mają swoje błędy. Niech rozłam spotka rozłam! Przez nas wszystkich spada Przysięga Porażki, a świat ujrzy, że szukamy prawdziwych wyznawców Przysiąg...%SPEECH_OFF%Przysiężnik patrzy na ciebie przez połamane kości, sam chroniony dekretem martwego człowieka.%SPEECH_ON%Gdy przewodnictwo Młodego Anselma znajdzie spełnienie, dopiero wtedy zostanie na nowo uczyniony całym.%SPEECH_OFF%Przysiężnik odwraca się i odchodzi. Serce bije ci szybko na myśl o zadaniu mu ciosu w plecy, poskładaniu szczątków Anselma i dopełnieniu ostatecznego zadania. Ale ta myśl mija. Zrobienie tego skazałoby cię na wieczne przekleństwo za zniszczenie twoich najmocniejszych przekonań. Po prostu patrzysz, jak Przysiężnik odchodzi, wiedząc, że Przysięgi i wszyscy ich wyznawcy mogą kiedyś się zjednoczyć, ale nie za twojego życia.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Cholera!",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (this.Math.rand(1, 100) <= 75 || bro.getBackground().getID() == "background.paladin")
					{
						bro.worsenMood(1.5, "Kompania przegrała z Przysiężnikami");

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

				this.World.Statistics.getFlags().set("OathbringerConfrontationTriggered", true);
			}

		});
		this.m.Screens.push({
			ID = "FightAvoided1",
			Text = "[img]gfx/ui/events/event_180.png[/img]{Wbrew każdemu włóknu swojej istoty odmawiasz walki. Rzeczywistość jest prosta: %companyname% nie jest gotowa na tę bitwę. Nic dziwnego, że Przysięgobiorcy nie są z tego zadowoleni i wręcz okazują znaczny niepokój, że miałeś rzadką okazję zabić Przysiężników i zmarnowałeś ją. Przysiężnicy śmieją się i szydzą, gdy odchodzisz.%SPEECH_ON%Młody Anselm nie widział w was nic dobrego, Przysięgobiorcy! Wasze wizje to kłamstwo! Cała wasza egzystencja to kłamstwo! Powiedziałbym, żebyście do nas dołączyli, ale nie chcemy mieć nic wspólnego z wami, robaki!%SPEECH_OFF%Modlisz się, by w nadchodzących dniach udało ci się udowodnić swoim ludziom, że podjąłeś właściwą decyzję.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Musiało tak być.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (this.Math.rand(1, 100) <= 25 || bro.getBackground().getID() == "background.paladin")
					{
						bro.worsenMood(2.0, "Odmówiłeś walki z Przysiężnikami, mimo okazji");

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

				this.World.Statistics.getFlags().increment("OathbringerConfrontationTimesDelayed");
			}

		});
		this.m.Screens.push({
			ID = "FightAvoided2",
			Text = "[img]gfx/ui/events/event_180.png[/img]{Kompania nadal nie jest gotowa. Boisz się, że całkiem cię opuszczą, tak bardzo są wściekli, ale wolisz, by byli źli, niż leżeli martwi w ziemi. Z tą decyzją ciążącą ci na sercu, a Przysiężnikami wrzeszczącymi obelgi do ucha, ponownie prowadzisz kompanię z dala od walki.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Wciąż nie jesteście gotowi!",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (this.Math.rand(1, 100) <= 50 || bro.getBackground().getID() == "background.paladin")
					{
						bro.worsenMood(2.5, "Odmówiłeś walki z Przysiężnikami, mimo wielu okazji");

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

				this.World.Statistics.getFlags().increment("OathbringerConfrontationTimesDelayed");
			}

		});
	}

	function getBroScore( bro )
	{
		local bro_score = 0;

		if (bro.getBackground().getID() == "background.paladin")
		{
			bro_score = bro_score + 2;
		}

		if (bro.getLevel() >= 11)
		{
			bro_score = bro_score + 5;
		}
		else if (bro.getLevel() >= 7)
		{
			bro_score = bro_score + 2;
		}
		else if (bro.getLevel() >= 5)
		{
			bro_score = bro_score + 1;
		}
		else
		{
			bro_score = bro_score - 3;
		}

		if (bro.getSkills().hasSkillOfType(this.Const.SkillType.TemporaryInjury))
		{
			bro_score = bro_score - 2;
		}

		if (bro.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand) == null)
		{
			bro_score = bro_score - 5;
		}

		if (bro.getItems().getItemAtSlot(this.Const.ItemSlot.Body) == null)
		{
			bro_score = bro_score - 5;
		}
		else
		{
			bro.getItems().getItemAtSlot(this.Const.ItemSlot.Body).getCondition() < bro.getItems().getItemAtSlot(this.Const.ItemSlot.Body).getConditionMax() / 2;
		}

		bro_score = bro_score - 2;
		return bro_score;
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Paladins)
		{
			return;
		}

		if (this.World.Assets.getOrigin().getID() != "scenario.paladins")
		{
			return;
		}

		if (this.World.Statistics.getFlags().get("OathbringerConfrontationTriggered"))
		{
			return;
		}

		if (this.World.Ambitions.hasActiveAmbition() && (this.World.Ambitions.getActiveAmbition().getID() == "ambition.oath_of_camaraderie" || this.World.Ambitions.getActiveAmbition().getID() == "ambition.oath_of_dominion" || this.World.Ambitions.getActiveAmbition().getID() == "ambition.oath_of_righteousness" || this.World.Ambitions.getActiveAmbition().getID() == "ambition.oath_of_vengeance"))
		{
			return;
		}

		local oathTimer = 6 + this.World.Statistics.getFlags().getAsInt("OathbringerConfrontationTimesDelayed") * 2;

		if (this.World.Assets.getCombatDifficulty() == this.Const.Difficulty.Normal)
		{
			oathTimer = oathTimer + 1;
		}
		else if (this.World.Assets.getCombatDifficulty() == this.Const.Difficulty.Easy)
		{
			oathTimer = oathTimer + 3;
		}

		if (oathTimer > this.World.Statistics.getFlags().getAsInt("OathsCompleted"))
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 3)
		{
			return;
		}

		this.m.Score = 1000;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
	}

	function onClear()
	{
		this.m.Bro1 = null;
		this.m.Bro2 = null;
		this.m.Bro3 = null;
	}

});

