this.noble_vs_lowborn_event <- this.inherit("scripts/events/event", {
	m = {
		Noble = null,
		Lowborn = null
	},
	function create()
	{
		this.m.ID = "event.noble_vs_lowborn";
		this.m.Title = "W obozie...";
		this.m.Cooldown = 35.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_64.png[/img] Zastajesz szlachcica %nobleman_short% i dość obszarpanego %lowborn% kłócących się o ostatni kawałek jedzenia na rożnie. Najwyraźniej nisko urodzony pierwszy trafił na niego widelcem, ale szlachcic twierdził, że jego wysoki stan daje mu prawo do mięsa.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Załatwcie to sami.",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "W kompanii najemników nikt nie jest nisko ani wysoko urodzony.",
					function getResult( _event )
					{
						return "C";
					}

				},
				{
					Text = "Znacie prawa tej ziemi, dajcie szlachcicowi, czego chce.",
					function getResult( _event )
					{
						return "D";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Noble.getImagePath());
				this.Characters.push(_event.m.Lowborn.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_06.png[/img] Gdy obaj mężczyźni spoglądają na ciebie po wskazówki, krzyżujesz ręce i wzruszasz ramionami. Powoli odwracają się z powrotem do siebie. Pozostali w obozie wstają i cofają się, robiąc miejsce temu, co nadchodzi. Nisko urodzony pierwszy dobywa sztyletu. To prosta rzecz z drewnianą rękojeścią i poszarpanymi, nienaturalnie ząbkowanymi krawędziami. Szlachcic w odpowiedzi wyciąga ostrze, dzierżąc metal wygięty z kunsztem kowala. Dwa złote węże wiją się po rękojeści, by ugryźć głowicę. Jego właściciel szczerzy zęby, mówiąc, że hołota powinna znać swoje miejsce. Nisko urodzony uśmiecha się jak człowiek, który nie ma w tym wprawy.\n\nKu zaskoczeniu wszystkich obaj potem ciskają sztylety w pniaki, na których siedzieli, i zwarci podnoszą pięści, na najbardziej równej arenie walki. W wybuchłej bójce rożen od razu zostaje strącony, a płomienie wzbijają się w górę, sypiąc iskry, a obalone jedzenie nabiera smaku popiołu i sadzy.\n\nWidząc zniszczony posiłek, reszta kompanii w końcu kończy walkę, rozdzielając obu mężczyzn. Grożą sobie i plują na siebie, ale po kilku minutach wszystko się uspokaja.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Wkrótce staną się braćmi w boju.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Noble.getImagePath());
				this.Characters.push(_event.m.Lowborn.getImagePath());
				local injury1 = _event.m.Noble.addInjury(this.Const.Injury.Brawl);
				local injury2 = _event.m.Lowborn.addInjury(this.Const.Injury.Brawl);
				this.List.push({
					id = 10,
					icon = injury1.getIcon(),
					text = _event.m.Noble.getName() + " doznaje " + injury1.getNameOnly()
				});
				this.List.push({
					id = 10,
					icon = injury2.getIcon(),
					text = _event.m.Lowborn.getName() + " doznaje " + injury2.getNameOnly()
				});
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_64.png[/img]%nobleman% wygląda na wstrząśniętego. Powoli unosi widelec znad rożna, a %lowborn% natychmiast pakuje ostatni kawałek mięsa do ust. Szlachcic wstaje i rusza w twoją stronę. Prostuje się przed tobą, uderzając klatką piersiową o twoją, gdy patrzycie sobie w oczy. Kilku ludzi kładzie dłonie na głowicach mieczy.%SPEECH_ON%{Stajesz po stronie nisko urodzonego, co? Spodziewałem się tego, sam będąc nisko urodzonym. Nie licz, że kiedykolwiek zostaniesz jednym z nas. Jesteś najemnikiem na całe życie. Pamiętaj o tym. | Liczysz, że dostaniesz kawałek ziemi, gdy to wszystko się skończy, tak? Mam nadzieję, że tak, bo wtedy przyjdę i zapukam, i pokażę ci, jak szlachta naprawdę traktuje swoich.}%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Znikaj mi z oczu.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Noble.getImagePath());
				this.Characters.push(_event.m.Lowborn.getImagePath());
				_event.m.Noble.worsenMood(2.0, "Został upokorzony na oczach kompanii");

				if (_event.m.Noble.getMoodState() < this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Noble.getMoodState()],
						text = _event.m.Noble.getName() + this.Const.MoodStateEvent[_event.m.Noble.getMoodState()]
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_64.png[/img]%nobleman% uśmiecha się, gdy strąca widelec %lowborn% z drogi. Szlachcic bierze jedzenie dla siebie, a nisko urodzony wstaje i rusza na ciebie. Gdy podchodzi, niektórzy ludzie wyglądają na gotowych do dobycia mieczy, ale wyciągasz dłoń, uspokajając ich.%SPEECH_ON%Myślałem, że jesteś jednym z nas, ale chyba nie. Pewnie myślisz, że kiedyś będziesz jednym z nich, co? Śnij dalej. Jak powiedziałby tamten człowiek do mnie: \"Znaj swoje miejsce\".%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Znikaj mi z oczu.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Noble.getImagePath());
				this.Characters.push(_event.m.Lowborn.getImagePath());
				_event.m.Lowborn.worsenMood(2.0, "Został upokorzony na oczach kompanii");

				if (_event.m.Lowborn.getMoodState() < this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Lowborn.getMoodState()],
						text = _event.m.Lowborn.getName() + this.Const.MoodStateEvent[_event.m.Lowborn.getMoodState()]
					});
				}
			}

		});
	}

	function onUpdateScore()
	{
		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 2)
		{
			return;
		}

		local noble_candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getLevel() < 7 && bro.getBackground().isNoble())
			{
				noble_candidates.push(bro);
			}
		}

		if (noble_candidates.len() == 0)
		{
			return;
		}

		local lowborn_candidates = [];

		foreach( bro in brothers )
		{
			if (!bro.getSkills().hasSkill("trait.hesitant") && bro.getBackground().isLowborn() && bro.getBackground().getID() != "background.slave")
			{
				lowborn_candidates.push(bro);
			}
		}

		if (lowborn_candidates.len() == 0)
		{
			return;
		}

		this.m.Noble = noble_candidates[this.Math.rand(0, noble_candidates.len() - 1)];
		this.m.Lowborn = lowborn_candidates[this.Math.rand(0, lowborn_candidates.len() - 1)];
		this.m.Score = noble_candidates.len() * 10;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"nobleman",
			this.m.Noble.getName()
		]);
		_vars.push([
			"nobleman_short",
			this.m.Noble.getNameOnly()
		]);
		_vars.push([
			"lowborn",
			this.m.Lowborn.getName()
		]);
		_vars.push([
			"lowborn_short",
			this.m.Lowborn.getNameOnly()
		]);
	}

	function onClear()
	{
		this.m.Noble = null;
		this.m.Lowborn = null;
	}

});

