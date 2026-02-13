this.cultist_origin_sacrifice_event <- this.inherit("scripts/events/event", {
	m = {
		Sacrifice = null,
		Sacrifice1 = null,
		Sacrifice2 = null,
		LastTriggeredOnDay = 0
	},
	function create()
	{
		this.m.ID = "event.cultist_origin_sacrifice";
		this.m.Title = "Podczas obozu...";
		this.m.Cooldown = 21.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_140.png[/img]{Większość uznałaby ten sen za koszmar: ciemność otaczała cię, czarna tak płaska, że mógłbyś jej dotknąć. Głos mówił językiem, którego nigdy wcześniej nie słyszałeś, a jednak go rozumiałeś. Z nieskończonego cienia wyłoniły się dwie twarze: %sac1% i %sac2%. Mężczyźni byli tak blisko, lecz gdy wyciągnąłeś rękę, kurczyli się, jakby twoje palce nieskończenie rozciągały się w pustkę.\n\nPo przebudzeniu wiedziałeś, co trzeba zrobić. Ale włożono w ciebie zaufanie, zaufanie Davkula. Zaufanie, by uczynić to, czego niewielu ludzi potrafi: dokonać wyboru. | Obecność Davkula przyszła podczas ogniska. Reszta ludzi zniknęła w eterze nieskończonej czerni, a zastąpiła ich dziwna istota. Istota, której nie mogłeś zobaczyć, ale której obecność była jedynie półmrokiem krzyżujących się cieni. Zażądała ofiary nie słowami, lecz obrazem: %sac1% i %sac2%. Najpierw jeden stopniał i ożył na nowo, potem drugi powtórzył to samo, aż obaj stali z wyciągniętymi dłońmi i zamkniętymi oczami. Było jasne, że Davkul powierza ci wybór.\n\nGdy cienie pękły, ognisko oślepiło. %sac1% i %sac2% wpatrywali się w ciebie.%SPEECH_ON%Czy wszystko w porządku, panie?%SPEECH_OFF% | Podróżowałeś do tego miejsca. Wiedziałeś, że śpisz, ale wiedziałeś też, że mimo to tam dotarłeś, przesuwając się poza umysł, poza ciało, pędząc nad ziemią, nad rzekami, przez suchą ziemię i obok gór, które by się skruszyły. Tam znalazłeś Davkula, niezmienną ciemność, zapraszający cień.\n\n%sac1% i %sac2% byli już tam, stojąc najbliżej ciebie, a kształt Davkula niespokojnie przesuwał się za ich postaciami. Czarna mglista dłoń pchnęła jednego mężczyznę do przodu i szarpnęła go z powrotem, potem powtórzyła to z drugim. Kiwasz głową ze zrozumieniem. Potrzebna była ofiara i to ty miałeś dokonać wyboru.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "%sac1% będzie miał zaszczyt spotkać Davkula.",
					function getResult( _event )
					{
						_event.m.Sacrifice = _event.m.Sacrifice1;
						return "B";
					}

				},
				{
					Text = "%sac2% będzie miał zaszczyt spotkać Davkula.",
					function getResult( _event )
					{
						_event.m.Sacrifice = _event.m.Sacrifice2;
						return "B";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Sacrifice1.getImagePath());
				this.Characters.push(_event.m.Sacrifice2.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_140.png[/img]{%sacrifice% zostaje związany i wrzucony w ogień. Zapach palonej wieprzowiny wypełnia powietrze, a mężczyźni wokół ciebie radują się ze łzami w oczach. W dymie ofiary widzisz skręcającą się twarz, wiedzące oblicze, które aprobuje. Ludzie są pokrzepieni. | %sacrifice% zostaje porąbany na kawałki, aż zostają tylko tułów i głowa. Krew spłynęła po ziemi, a jednak w jego oczach wciąż jest światło i przewrotny uśmiech na twarzy. Bierzesz ostrze topora i wciskasz je w jego gardło, aż gaśnie. Każda część ciała zostaje oddzielona i umieszczona na palu, oblepiona tłuszczem i podpalona. Ty i ludzie tańczycie pod stosami, gdy noc nadchodzi i odchodzi. | Obrzęd wygląda tak: %sacrifice% zostaje żywcem obdarty ze skóry, przebity ostrzonymi kijami przez każdą kończynę i uniesiony, rozpostarty nad ogniem, który piecze go aż do śmierci. Ludzie obserwują w ciszy, ale gdy tylko jedna z jego zwęglonych kończyn pęka i zwala ciało w płomienie, ludzie wiwatują, wyją i krzyczą, jedni się modlą, inni tarzają się w popiołach %sacrifice%, niektórzy zlizują je z czubków palców jak słodycze. To dobra noc. | Długi kij przebija %sacrifice% od tyłu i wychodzi z boku szyi. Zostaje uniesiony ku niebu i trzymany przez jednego mężczyznę, podczas gdy inni długimi włóczniami przebijają go, aż jego ciało staje się szczytem nieosłoniętego namiotu. Stożkowe zwłoki zostają następnie przykryte trawą i błotem, aż powstaje tipi, a tułów i głowa %sacrifice% pozostają nad nim, a gdybyś wszedł do środka, zobaczyłbyś jego nogi zwisające z sufitu. Monument ma stać jako omen dla tych, którzy przyjdą, i jako znak, że powinni przyjąć to, co czeka nas wszystkich.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Przypomnienie dla nas wszystkich.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Sacrifice.getImagePath());
				local dead = _event.m.Sacrifice;
				local fallen = {
					Name = dead.getName(),
					Time = this.World.getTime().Days,
					TimeWithCompany = this.Math.max(1, dead.getDaysWithCompany()),
					Kills = dead.getLifetimeStats().Kills,
					Battles = dead.getLifetimeStats().Battles,
					KilledBy = "Sacrificed to Davkul",
					Expendable = dead.getBackground().getID() == "background.slave"
				};
				this.World.Statistics.addFallen(fallen);
				this.List.push({
					id = 13,
					icon = "ui/icons/kills.png",
					text = _event.m.Sacrifice.getName() + " zginął"
				});
				_event.m.Sacrifice.getItems().transferToStash(this.World.Assets.getStash());
				this.World.getPlayerRoster().remove(_event.m.Sacrifice);
				local brothers = this.World.getPlayerRoster().getAll();
				local hasProphet = false;

				foreach( bro in brothers )
				{
					if (bro.getSkills().hasSkill("trait.cultist_prophet"))
					{
						hasProphet = true;
						break;
					}
				}

				foreach( bro in brothers )
				{
					if (bro.getBackground().getID() == "background.cultist" || bro.getBackground().getID() == "background.converted_cultist")
					{
						bro.improveMood(2.0, "Udobruchał Davkula");

						if (bro.getMoodState() >= this.Const.MoodState.Neutral)
						{
							this.List.push({
								id = 10,
								icon = this.Const.MoodStateIcon[bro.getMoodState()],
								text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
							});
						}

						for( ; this.Math.rand(1, 100) > 50;  )
						{
						}

						local skills = bro.getSkills();
						local skill;

						if (skills.hasSkill("trait.cultist_prophet"))
						{
							continue;
						}
						else if (skills.hasSkill("trait.cultist_chosen"))
						{
							if (hasProphet)
							{
								continue;
							}

							hasProphet = true;
							this.updateAchievement("VoiceOfDavkul", 1, 1);
							skills.removeByID("trait.cultist_chosen");
							skill = this.new("scripts/skills/actives/voice_of_davkul_skill");
							skills.add(skill);
							skill = this.new("scripts/skills/traits/cultist_prophet_trait");
							skills.add(skill);
						}
						else if (skills.hasSkill("trait.cultist_disciple"))
						{
							skills.removeByID("trait.cultist_disciple");
							skill = this.new("scripts/skills/traits/cultist_chosen_trait");
							skills.add(skill);
						}
						else if (skills.hasSkill("trait.cultist_acolyte"))
						{
							skills.removeByID("trait.cultist_acolyte");
							skill = this.new("scripts/skills/traits/cultist_disciple_trait");
							skills.add(skill);
						}
						else if (skills.hasSkill("trait.cultist_zealot"))
						{
							skills.removeByID("trait.cultist_zealot");
							skill = this.new("scripts/skills/traits/cultist_acolyte_trait");
							skills.add(skill);
						}
						else if (skills.hasSkill("trait.cultist_fanatic"))
						{
							skills.removeByID("trait.cultist_fanatic");
							skill = this.new("scripts/skills/traits/cultist_zealot_trait");
							skills.add(skill);
						}
						else
						{
							skill = this.new("scripts/skills/traits/cultist_fanatic_trait");
							skills.add(skill);
						}

						if (skill != null)
						{
							this.List.push({
								id = 10,
								icon = skill.getIcon(),
								text = bro.getName() + " jest teraz " + this.Const.Strings.getArticle(skill.getName()) + skill.getName()
							});
						}
					}
					else if (!bro.getSkills().hasSkill("trait.mad"))
					{
						bro.worsenMood(4.0, "Przerażony ofiarą z " + _event.m.Sacrifice.getName());

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
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Wildmen)
		{
			return;
		}

		if (this.World.getTime().Days <= 5)
		{
			return;
		}

		if (this.World.Assets.getOrigin().getID() != "scenario.cultists")
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 4)
		{
			return;
		}

		brothers.sort(function ( _a, _b )
		{
			if (_a.getXP() < _b.getXP())
			{
				return -1;
			}
			else if (_a.getXP() > _b.getXP())
			{
				return 1;
			}

			return 0;
		});
		local r = this.Math.rand(0, this.Math.min(2, brothers.len() - 1));
		this.m.Sacrifice1 = brothers[r];
		brothers.remove(r);
		r = this.Math.rand(0, this.Math.min(2, brothers.len() - 1));
		this.m.Sacrifice2 = brothers[r];
		this.m.Score = 50 + (this.World.getTime().Days - this.m.LastTriggeredOnDay);
	}

	function onPrepare()
	{
		this.m.LastTriggeredOnDay = this.World.getTime().Days;
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"sac1",
			this.m.Sacrifice1.getName()
		]);
		_vars.push([
			"sac2",
			this.m.Sacrifice2.getName()
		]);
		_vars.push([
			"sacrifice",
			this.m.Sacrifice != null ? this.m.Sacrifice.getName() : ""
		]);
	}

	function onClear()
	{
		this.m.Sacrifice1 = null;
		this.m.Sacrifice2 = null;
		this.m.Sacrifice = null;
	}

	function onSerialize( _out )
	{
		this.event.onSerialize(_out);
		_out.writeU16(this.m.LastTriggeredOnDay);
	}

	function onDeserialize( _in )
	{
		this.event.onDeserialize(_in);

		if (_in.getMetaData().getVersion() >= 62)
		{
			this.m.LastTriggeredOnDay = _in.readU16();
		}
	}

});

