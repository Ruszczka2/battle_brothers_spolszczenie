this.anatomist_helps_blighted_guy_1_event <- this.inherit("scripts/events/event", {
	m = {
		Anatomist = null,
		Dude = null
	},
	function create()
	{
		this.m.ID = "event.anatomist_helps_blighted_guy_1";
		this.m.Title = "W drodze...";
		this.m.Cooldown = 9999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_53.png[/img]{Napotykasz mężczyznę grzebanego żywcem, co wnioskujesz po tym, że jest związany jak martwy, a mimo to krzyczy o całym zdarzeniu. Pytasz, co się dzieje, a jeden z kopaczy odwraca się i wyciąga rękę.%SPEECH_ON%Trzymaj dystans. Ten człowiek jest skażony, a każdy, kogo dotknie, też zostaje skażony. Nie chcemy choroby i wy też nie powinniście.%SPEECH_OFF%Mężczyzna woła o pomoc, gdy kolejna bryła ziemi spada na niego. Próbuje się wspiąć z grobu, ale jeden z kopaczy kopie go z powrotem, narzekając, że będzie musiał spalić ulubiony but. %anatomist% podchodzi cicho. Mówi, że mężczyzna ma chorobę skóry, która może wyglądać jak trąd albo zaraza, ale w rzeczywistości jest łagodna. Pytasz, czy jest tego pewien, a on przytakuje, choć unosi palec z nutą niepewności.%SPEECH_ON%Mogę się mylić, oczywiście. A jeśli tak, to jego prawdziwa choroba może się na nas rozplenić. Ale grzebanie żywcem to nie jest coś, co uznaję, jak by to ująć, za naukowo przekonujące.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "W takim razie mu pomożemy.",
					function getResult( _event )
					{
						return this.Math.rand(1, 100) <= 50 ? "B" : "C";
					}

				},
				{
					Text = "To nie nasz problem.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Anatomist.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_88.png[/img]{Wyciągasz miecz i każesz kopaczom przestać. Patrzą na ciebie z niedowierzaniem. Jeden wskazuje na mężczyznę w grobie.%SPEECH_ON%Nie słyszałeś? Ten gość jest skażony. To, co robimy, może nie wygląda dobrze, ale-%SPEECH_OFF%Gestem miecza uciszasz kopacza. Mówisz mężczyźnie w grobie, żeby wyszedł, a gdy to robi, kopacze opuszczają łopaty i cofają się. Mówią, że jest cały twój. Rzekomo chory mężczyzna podchodzi powoli, wciąż przestraszony i bez wątpienia niepewny, czy jego wybawcy mają dla niego coś lepszego w planach niż ci, którzy chcieli go pogrzebać żywcem. %anatomist% bierze go pod swoje skrzydła, a ty powoli się wycofujesz. Anatomista stwierdza, że mężczyzna jest chory, ale to nic poważnego i z czasem wróci do zdrowia. Na razie jednak potrzebuje odpoczynku.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Dobrze.",
					function getResult( _event )
					{
						this.World.getPlayerRoster().add(_event.m.Dude);
						this.World.getTemporaryRoster().clear();
						_event.m.Dude.onHired();
						return 0;
					}

				},
				{
					Text = "Nie potrzebujemy nikogo więcej.",
					function getResult( _event )
					{
						this.World.getTemporaryRoster().clear();
						return "D";
					}

				}
			],
			function start( _event )
			{
				local roster = this.World.getTemporaryRoster();
				_event.m.Dude = roster.create("scripts/entity/tactical/player");
				_event.m.Dude.setStartValuesEx([
					"vagabond_background"
				], false);
				_event.m.Dude.setTitle("");
				_event.m.Dude.getFlags().set("IsSpecial", true);
				_event.m.Dude.getBackground().m.RawDescription = "" + _event.m.Anatomist.getNameOnly() + " Anatomista uratował %name% przed pogrzebaniem żywcem z powodu dziwnej choroby. Teraz ma wyjątkową przyjemność zarówno noszenia zarazy, jak i bycia królikiem doświadczalnym dla badaczy. Proszę, zostań tam.";
				_event.m.Dude.getBackground().buildDescription(true);
				_event.m.Dude.m.Talents = [];
				local talents = _event.m.Dude.getTalents();
				talents.resize(this.Const.Attributes.COUNT, 0);
				talents[this.Const.Attributes.MeleeSkill] = 2;
				talents[this.Const.Attributes.MeleeDefense] = 2;
				talents[this.Const.Attributes.Bravery] = 2;
				_event.m.Dude.m.Attributes = [];
				_event.m.Dude.fillAttributeLevelUpValues(this.Const.XP.MaxLevelWithPerkpoints - 1);

				if (_event.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand) != null)
				{
					_event.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand).removeSelf();
				}

				if (_event.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Offhand) != null)
				{
					_event.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Offhand).removeSelf();
				}

				if (_event.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Head) != null)
				{
					_event.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Head).removeSelf();
				}

				if (_event.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Body) != null)
				{
					_event.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Body).removeSelf();
				}

				_event.m.Dude.worsenMood(1.5, "O mało nie został pogrzebany żywcem z powodu choroby");
				local i = this.new("scripts/skills/injury/sickness_injury");
				i.addHealingTime(8);
				_event.m.Dude.getSkills().add(i);
				_event.m.Dude.getFlags().set("IsMilitiaCaptain", true);
				this.Characters.push(_event.m.Anatomist.getImagePath());
				this.Characters.push(_event.m.Dude.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_18.png[/img]{W najniechętniejszej akcji ratunkowej, jaką pamiętasz, wzdychasz i dobywasz miecza, każąc kopaczom natychmiast przestać. Patrzą na ciebie z rękami na łopatach, z brwiami uniesionymi wysoko.%SPEECH_ON%Co? Nie słyszałeś nas? Facet jest skażony!%SPEECH_OFF%%anatomist% podchodzi i odprawia ich ruchem ręki. Przytakujesz i gestem każesz kopaczom zrobić, co powiedziano. Anatomista pomaga mężczyźnie wydostać się z grobu, choć zauważasz, że robi to przez rękaw i z zakrytą dłonią. Pomagają mu wrócić do kompanii. Gdy mężczyzna odwraca się, by ci podziękować, %anatomist% wbija młot w tył jego głowy, nokautując go. Anatomista podąża za nim na ziemię i zaczyna ciąć mu ramię, odcinając kawałek mięsa, po czym odsuwa się.%SPEECH_ON%To powinno wystarczyć do naszych badań, sądzę.%SPEECH_OFF%Pytasz, czy mężczyzna rzeczywiście był chory. Anatomista przytakuje.%SPEECH_ON%Oczywiście, ale lepiej, żeby chory był chociaż użyteczny, niż miał leżeć martwy w ziemi jak robak. Może, rzecz jasna, teraz iść umrzeć. Niewiele mu zostało na tym świecie.%SPEECH_OFF%Mężczyzna jęczy, wijąc się na ziemi. W jego butach słychać brzęk, więc ściągasz je i znajdujesz schowane korony. Przez chwilę rozważasz skrócenie jego cierpień, ale decydujesz, że skoro jest wolny od grobu, sam zdecyduje, jak do niego wrócić. Zabierasz jednak jego pieniądze.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Powodzenia, człowieku.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				_event.m.Anatomist.improveMood(1.0, "Mógł zbadać niezwykłą zarazę");

				if (_event.m.Anatomist.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Anatomist.getMoodState()],
						text = _event.m.Anatomist.getName() + this.Const.MoodStateEvent[_event.m.Anatomist.getMoodState()]
					});
				}

				_event.m.Anatomist.addXP(200, false);
				_event.m.Anatomist.updateLevel();
				this.List.push({
					id = 16,
					icon = "ui/icons/xp_received.png",
					text = _event.m.Anatomist.getName() + " zyskuje [color=" + this.Const.UI.Color.PositiveEventValue + "]+200[/color] doświadczenia"
				});
				this.World.Assets.addMoney(45);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Zyskujesz [color=" + this.Const.UI.Color.PositiveEventValue + "]45[/color] koron"
				});
				this.Characters.push(_event.m.Anatomist.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_04.png[/img]{Mówisz mężczyźnie, że %companyname% nie potrzebuje już więcej najemników. Sugestia jest też taka, że zanim odejdzie, powinien rozważyć zrekompensowanie ci pomocy. Przytakuje i zdejmuje but, ujawniając, że miał tam schowane złoto. Nie ufając, jaką chorobę ma, każesz mu przetrzeć monety w trawie, a potem odsunąć je stopą. Robi, jak mu mówisz. Przytakuje.%SPEECH_ON%Cóż. Doceniam to. Uważaj na siebie.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Powodzenia również tobie.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.Assets.addMoney(65);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Zyskujesz [color=" + this.Const.UI.Color.PositiveEventValue + "]65[/color] koron"
				});

				if (this.Math.rand(1, 100) < 75)
				{
					_event.m.Anatomist.worsenMood(0.75, "Odmówiono mu badania niezwykłej choroby");
				}
				else
				{
					_event.m.Anatomist.worsenMood(0.5, "Odmówiono mu szansy pomocy choremu");
				}
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Paladins)
		{
			return;
		}

		if (this.World.Assets.getOrigin().getID() != "scenario.anatomists")
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();

		if (!currentTile.HasRoad)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local anatomist_candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.anatomist")
			{
				anatomist_candidates.push(bro);
			}
		}

		if (anatomist_candidates.len() > 0)
		{
			this.m.Anatomist = anatomist_candidates[this.Math.rand(0, anatomist_candidates.len() - 1)];
		}
		else
		{
			return;
		}

		this.m.Score = 5 + anatomist_candidates.len();
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"anatomist",
			this.m.Anatomist.getName()
		]);
	}

	function onClear()
	{
		this.m.Anatomist = null;
		this.m.Dude = null;
	}

});

