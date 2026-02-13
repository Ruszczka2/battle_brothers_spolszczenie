this.holywar_crucified_1_event <- this.inherit("scripts/events/event", {
	m = {
		Dude = null
	},
	function create()
	{
		this.m.ID = "event.crisis.holywar_crucified_1";
		this.m.Title = "Na drodze...";
		this.m.Cooldown = 999999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_161.png[/img]{Pośród pustynnych bezdroży trzeba podejrzliwie podchodzić do wszystkiego, co się spotyka, zwłaszcza gdy to samotny człowiek na krzyżu. Ukrzyżowana postać wygląda na martwą, biorąc pod uwagę sępy niczym kler przycupnięte na obu ramionach, ale gdy podchodzisz, ptaki odlatują, a mężczyzna podnosi głowę. Pomimo straszliwych obrażeń dłoni i stóp, jest całkiem żywy i prosi o wodę. Zamiast mu ją dać, pytasz, czemu tu jest. Mężczyzna wzdycha.%SPEECH_ON%Byłem krzyżowcem. Przybyłem z armią, by zdobyć chwałę dla starych bogów. Ale gdy tu zszedłem i zacząłem rozmawiać z miejscowymi i kapłanami, zmieniłem zdanie.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "To inni krzyżowcy ci to zrobili?",
					function getResult( _event )
					{
						return "B";
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_161.png[/img]{Mężczyzna kiwa głową.%SPEECH_ON%Ano, tak zrobili. Zwróć uwagę, że byłem przy tym, jak ukrzyżowali kogoś innego z tego samego powodu. Więc po części nie jestem najmądrzejszy, że poszedłem w jego ślady, i serca też nie mam czystego, bo mu kibicowałem, gdy mu to robili. Ale może Gilder zobaczy prawdziwe światło, które noszę w środku, wiesz?%SPEECH_OFF%Odwraca głowę ku niebu i krążącym nad nim sępom.%SPEECH_ON%Wciąż jestem gotów walczyć, bez względu na to, kto to będzie, południe, północ, nieważne. Mam Gildera w sercu.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Jesteś u nas mile widziany.",
					function getResult( _event )
					{
						return "C";
					}

				},
				{
					Text = "Jedyne co masz w sercu to te sępy.",
					function getResult( _event )
					{
						return "D";
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_161.png[/img]{Wyciągasz sztylet i odcinasz mężczyznę. Ma mnóstwo ran, ale bez wątpienia dość silną konstytucję, by kiedyś wyzdrowieć. Dziękuje ci z niezwykłą łagodnością, biorąc pod uwagę los, który na niego czekał.%SPEECH_ON%Dobrze się rozciągnąć. To znaczy, wiesz, rozciągnąć na własnych warunkach. Prowadź, kapitanie okoliczności Gildera, kapitanie Jego potężnej wzniosłości.%SPEECH_OFF%Wielu w kompanii nie chce przyjmować człowieka, który odwrócił się nie tylko od swoich bliźnich, ale i od własnych bogów.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Ach, wpasuje się w resztę wyrzutków.",
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
				local roster = this.World.getTemporaryRoster();
				_event.m.Dude = roster.create("scripts/entity/tactical/player");
				_event.m.Dude.setStartValuesEx([
					"crucified_background"
				]);
				_event.m.Dude.getBackground().m.RawDescription = "Znalazłeś %name%, byłego krzyżowca z północy, ukrzyżowanego pośrodku pustyni po tym, jak odwrócił się od starych bogów. Po odcięciu go przysiągł ci służbę. Mimo prób ukrycia tego, nie wydaje się być w najbardziej stabilnym stanie psychicznym.";
				_event.m.Dude.getBackground().buildDescription(true);
				local trait = this.new("scripts/skills/traits/deathwish_trait");

				foreach( id in trait.m.Excluded )
				{
					_event.m.Dude.getSkills().removeByID(id);
				}

				_event.m.Dude.getSkills().add(trait);
				_event.m.Dude.setHitpointsPct(0.33);
				_event.m.Dude.improveMood(3.0, "Ujrzał światło i przyjął wzniosłość Gildera");
				_event.m.Dude.worsenMood(3.0, "Został ukrzyżowany");
				this.Characters.push(_event.m.Dude.getImagePath());
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getEthnicity() == 0 && this.Math.rand(1, 100) <= 66)
					{
						bro.worsenMood(1.0, "Nie podobało mu się, że powstrzymałeś należną karę za zdradę starych bogów");

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
			Text = "[img]gfx/ui/events/event_161.png[/img]{Mówisz mężczyźnie, że już wkrótce porozmawia ze swoim bogiem albo bogami. Wzdycha.%SPEECH_ON%W pewnym sensie zasłużyłem na to, ale jestem z tym pogodzony.%SPEECH_OFF%Reakcje w kompanii są mieszane, a przez mieszane rozumie się głównie różne stopnie entuzjazmu. W końcu mężczyzna jest zdrajcą zarówno ziemi, jak i niebios, przez co łatwo go nienawidzić każdemu i wszędzie.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Dobrze mu tak.",
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
					if (bro.getEthnicity() == 0 && this.Math.rand(1, 100) <= 50)
					{
						bro.improveMood(0.25, "Nabrał pewności co do twojego przywództwa");

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
		if (!this.Const.DLC.Desert)
		{
			return;
		}

		if (!this.World.FactionManager.isHolyWar())
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();

		if (currentTile.Type != this.Const.World.TerrainType.Desert && currentTile.Type != this.Const.World.TerrainType.Oasis && currentTile.TacticalType != this.Const.World.TerrainTacticalType.DesertHills)
		{
			return;
		}

		if (this.World.getPlayerRoster().getSize() >= this.World.Assets.getBrothersMax())
		{
			return;
		}

		local towns = this.World.EntityManager.getSettlements();

		foreach( t in towns )
		{
			if (t.getTile().getDistanceTo(currentTile) <= 5)
			{
				return;
			}
		}

		this.m.Score = 10;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
	}

	function onClear()
	{
		this.m.Dude = null;
	}

});

