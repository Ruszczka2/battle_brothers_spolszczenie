this.youngling_alp_event <- this.inherit("scripts/events/event", {
	m = {
		Callbrother = null,
		Other = null,
		Beastslayer = null,
		Flagellant = null
	},
	function create()
	{
		this.m.ID = "event.youngling_alp";
		this.m.Title = "Podczas obozu...";
		this.m.Cooldown = 99999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_33.png[/img]{%callbrother% wpada do twojego namiotu i mówi, że coś obserwuje obóz. Wychodzisz na zewnątrz i widzisz sylwetkę w oddali, czającą się za krzakami i gałęziami. Wiesz, że się wpatruje, gdy syczy, bo na co innego miałoby tak reagować. Jego ramiona są długie i smukłe, zakończone pazurami. Bierzesz pochodnię i ciskasz ją w bestię. Jej śliska skóra błyska jaskrawą pomarańczą i stwór odskakuje z krzykiem od chmury żaru i iskier, gdy pochodnia ląduje i przetacza się dalej. Zębata paszcza to ostatnie, co widzisz, nim znika w ciemności.%SPEECH_ON%Myślę, że to alp, panie. Z tego, co wiemy, jest sam.%SPEECH_OFF%Pytasz, czy najemnik miał wizje. Wzrusza ramionami.%SPEECH_ON%Tak, kilka, ale też piłem, więc to też.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Zabij je.",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "Zignoruj je.",
					function getResult( _event )
					{
						return "C";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Callbrother.getImagePath());

				if (_event.m.Beastslayer != null)
				{
					this.Options.push({
						Text = "%beastslayer%, znasz się na tych bestiach. Co powiesz?",
						function getResult( _event )
						{
							return "D";
						}

					});
				}

				if (_event.m.Flagellant != null)
				{
					this.Options.push({
						Text = "Co na to %flagellant%?",
						function getResult( _event )
						{
							return "E";
						}

					});
				}
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_122.png[/img]{Alp jest sam i być może młody. Nawet potwory muszą swoje odcierpieć i zapracować, by stać się naprawdę okropnymi bestiami, a ten jeszcze na to nie wygląda. Wysyłasz parę najemników, by zabić bestię. Zbliżają się do niej przez zasłonę ciemności. Widzisz sylwetki podnoszące się do zasadzki, słychać trzask i krzyk, i jeszcze jeden krzyk, już zupełnie nie ludzki. Potem zawodzenie. A tym razem płacz człowieka. Ktoś mówi. Cisza. Długa, długa cisza. W końcu wraca para. Jeden trzyma się za głowę, jakby dopadł go okropny ból, drugi patrzy na ciebie i kiwa głową.%SPEECH_ON%Zabiliśmy go i, eee, myślę, że musimy się położyć.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Dobra robota.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Callbrother.getImagePath());
				this.Characters.push(_event.m.Other.getImagePath());
				_event.m.Callbrother.addXP(200, false);
				_event.m.Callbrother.updateLevel();
				_event.m.Other.addXP(200, false);
				_event.m.Other.updateLevel();
				this.List.push({
					id = 16,
					icon = "ui/icons/xp_received.png",
					text = _event.m.Callbrother.getName() + " zyskuje [color=" + this.Const.UI.Color.PositiveEventValue + "]+200[/color] Doświadczenia"
				});
				_event.m.Callbrother.worsenMood(0.75, "Alp wtargnął mu do umysłu");

				if (_event.m.Callbrother.getMoodState() < this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Callbrother.getMoodState()],
						text = _event.m.Callbrother.getName() + this.Const.MoodStateEvent[_event.m.Callbrother.getMoodState()]
					});
				}

				this.List.push({
					id = 16,
					icon = "ui/icons/xp_received.png",
					text = _event.m.Other.getName() + " zyskuje [color=" + this.Const.UI.Color.PositiveEventValue + "]+200[/color] Doświadczenia"
				});
				_event.m.Other.worsenMood(0.75, "Alp wtargnął mu do umysłu");

				if (_event.m.Other.getMoodState() < this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Other.getMoodState()],
						text = _event.m.Other.getName() + this.Const.MoodStateEvent[_event.m.Other.getMoodState()]
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_33.png[/img]{Mówisz ludziom, by zignorowali alpa. Gdyby był groźny, już by to udowodnił. Zamiast tego dał wam znać, że tam jest, czy to z niewiedzy, czy z pychy, a żadna z tych rzeczy cię nie rusza. Kilku ludzi nie zgadza się z tą decyzją i czuwa całą noc, wypatrując bestii.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Weźcie się w garść.",
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
					if (bro.getLevel() <= 3 || bro.getBackground().getID() == "background.beast_slayer" || bro.getBackground().getID() == "background.witchhunter" || bro.getSkills().hasSkill("trait.hate_beasts") || bro.getSkills().hasSkill("trait.fear_beasts") || bro.getSkills().hasSkill("trait.bloodthirsty") || bro.getSkills().hasSkill("trait.paranoid") || bro.getSkills().hasSkill("trait.superstitious"))
					{
						bro.worsenMood(0.75, "Pozwoliłeś alpowi żyć, co może prześladować kompanię później");

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
			Text = "[img]gfx/ui/events/event_122.png[/img]{%beastslayer%, pogromca bestii, podchodzi.%SPEECH_ON%To nie jest groźne, jest zdezorientowane. Zajmę się tym.%SPEECH_OFF%Przeżuwa suchy suchar, mruczy, wkłada go do kieszeni i rusza w ciemność sam. Chwilę później sylwetka alpa nagle opada i znika. Po kilku minutach pogromca wraca, wciskając do ust ostatnie okruchy suchara. Pytasz, czemu alp nie stawiał większego oporu. Pogromca się śmieje.%SPEECH_ON%Mówiłeś, że %callbrother% ściągnął cię z namiotu, prawda? Właśnie. A gdzie jest %callbrother%?%SPEECH_OFF%Pogromca wskazuje ognisko. Najemnik jest tam. Śpi. Głęboko. %beastslayer% sięga po kolejny suchar.%SPEECH_ON%Młode alpy dopiero uczą się, jak wgryzać się do umysłu. Nie idzie im to dobrze i często zwracają na siebie uwagę podczas prób. Są jak złodzieje, którzy nie potrafią otworzyć zamka, więc zamiast tego pukają do drzwi.%SPEECH_OFF%Kilku ludzi słucha tego i nabiera odwagi dzięki dostrzeżonym słabościom tych skądinąd przerażających stworzeń.}  ",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Dobra robota.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Beastslayer.getImagePath());
				_event.m.Beastslayer.improveMood(0.5, "Pozbył się młodego alpa");
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getLevel() <= 3 && this.Math.rand(1, 100) <= 33 || bro.getBackground().getID() == "background.witchhunter" || bro.getSkills().hasSkill("trait.hate_beasts") || bro.getSkills().hasSkill("trait.fear_beasts") || bro.getSkills().hasSkill("trait.bloodthirsty") || bro.getSkills().hasSkill("trait.paranoid") || bro.getSkills().hasSkill("trait.superstitious"))
					{
						bro.improveMood(1.0, "Ośmielony wiedzą o słabości młodych alpów");

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
		this.m.Screens.push({
			ID = "E",
			Text = "[img]gfx/ui/events/event_33.png[/img]{%flagellant%, biczownik, stoi na skraju obozu, smagając się do krwi. Jego narzędzie oczyszczania duszy jest uzbrojone w kawałki szkła i kocie pazury, ciasno związane skórą wypłukaną w moczu, i frędzle ze skręconej końskiej sierści. Idzie w dzicz, z każdym krokiem skrywając się coraz bardziej.%SPEECH_ON%Nie to, że się ciebie boję, stworzeń w cieniu. Nie to, że się ciebie boję, cieni w mym umyśle. Nie to, że się ciebie boję, umyśle w mym ciele.%SPEECH_OFF%Mężczyzna przestaje iść, ale jego biczowanie nabiera gwałtowności, widzisz drobiny krwi migoczące w księżycowym świetle.%SPEECH_ON%To starych bogów się boję, a ty do nich nie należysz! Dla nich jesteś tylko owadem!%SPEECH_OFF%Sylwetka alpa kurczy się, krzyczy, po czym umyka w ciemność. Mężczyzna wraca i osuwa się w obozie. Kilku ludzi jest przerażonych, a inni ośmieleni jego odwagą i prawością.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Na starych bogów.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Flagellant.getImagePath());
				local hitpoints = this.Math.rand(1, 3);
				_event.m.Flagellant.getBaseProperties().Hitpoints += hitpoints;
				_event.m.Flagellant.getSkills().update();
				local injury = _event.m.Flagellant.addInjury(this.Const.Injury.Flagellation);
				this.List = [
					{
						id = 10,
						icon = injury.getIcon(),
						text = _event.m.Flagellant.getName() + " doznaje " + injury.getNameOnly()
					}
				];
				this.List.push({
					id = 16,
					icon = "ui/icons/health.png",
					text = _event.m.Flagellant.getName() + " zyskuje [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + hitpoints + "[/color] Punktów Życia"
				});
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Unhold)
		{
			return;
		}

		if (this.World.getTime().IsDaytime)
		{
			return;
		}

		if (this.World.getTime().Days < 20)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 3)
		{
			return;
		}

		local candidates = [];
		local candidates_beastslayer = [];
		local candidates_flagellant = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.beast_slayer")
			{
				candidates_beastslayer.push(bro);
			}
			else if (bro.getBackground().getID() == "background.flagellant" || bro.getBackground().getID() == "background.monk_turned_flagellant")
			{
				candidates_flagellant.push(bro);
			}
			else
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() < 2)
		{
			return;
		}

		local r = this.Math.rand(0, candidates.len() - 1);
		this.m.Callbrother = candidates[r];
		candidates.remove(r);
		this.m.Other = candidates[this.Math.rand(0, candidates.len() - 1)];

		if (candidates_beastslayer.len() != 0)
		{
			this.m.Beastslayer = candidates_beastslayer[this.Math.rand(0, candidates_beastslayer.len() - 1)];
		}

		if (candidates_flagellant.len() != 0)
		{
			this.m.Flagellant = candidates_flagellant[this.Math.rand(0, candidates_flagellant.len() - 1)];
		}

		this.m.Score = 3;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"callbrother",
			this.m.Callbrother.getName()
		]);
		_vars.push([
			"beastslayer",
			this.m.Beastslayer != null ? this.m.Beastslayer.getName() : ""
		]);
		_vars.push([
			"flagellant",
			this.m.Flagellant != null ? this.m.Flagellant.getName() : ""
		]);
	}

	function onClear()
	{
		this.m.Callbrother = null;
		this.m.Other = null;
		this.m.Beastslayer = null;
		this.m.Flagellant = null;
	}

});

