this.read_black_book_event <- this.inherit("scripts/events/event", {
	m = {
		Historian = null,
		Other = null
	},
	function create()
	{
		this.m.ID = "event.read_black_book";
		this.m.Title = "Podczas obozu...";
		this.m.Cooldown = 20.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_12.png[/img]{%nonhistorian% wchodzi do twojego namiotu.%SPEECH_ON%Kapitanie, szybko, coś jest nie tak z %historian%!%SPEECH_OFF%Spieszysz na miejsce. %historian% pochyla się nad księgą Strażnika Wiedzy jak starzec osłaniający pierwszy płomień. Zaciska palce na skórzanych okładkach, ręce mu drżą, a on podnosi na ciebie przekrwione oczy.%SPEECH_ON%Wiem, co tam jest, kapitanie, wiem, co tam jest!%SPEECH_OFF%Kucasz, a mężczyzna cofa się, kręcąc głową.%SPEECH_ON%Nie. Nie! To o końcu! O końcu wszystkiego! My... my jesteśmy tylko narzędziami, by tam dotrzeć, rozumiesz? Wszystko, co robimy, wszystko, co robi ktokolwiek, jest środkiem do ostatecznego celu: śmierci wszystkich istot. Nasze istnienie daje temu moc, bez nas może znów odpocząć. Ale dopóki istnieje istnienie, nie może spać!%SPEECH_OFF%Kręcisz głową i pytasz, co ma na myśli. Mężczyzna odwraca księgę i jest tam strona całkowicie czarna, a mimo to wskazuje na niej palcem miejsce, jakbyś miał tam przeczytać zdanie.%SPEECH_ON%To nie książka, kapitanie, to instrukcja, jak podnieść duchy zmarłych.%SPEECH_OFF%Pytasz, kto mógł mieć taką wiedzę, a %historian% uśmiecha się obłąkańczo.%SPEECH_ON%Nie ma żadnego \'kto\', nie ma żadnego \'co\'! To narzędzie unicestwienia, włożone w ten świat przez tego, który nazywa siebie Davkulem!%SPEECH_OFF%Mówisz ludziom, żeby go odprowadzili, bo wyraźnie postradał zmysły. Jeden z najemników przynosi ci tłumaczenia %historian% z księgi, ale to tylko bazgroły, równie niezrozumiałe jak oryginał.%SPEECH_ON%Nawet gdybyśmy mogli zrozumieć choć słowo, nawet gdybyśmy mogli z tego skorzystać, nie sądzę, byśmy powinni. Widzisz, i tylko między nami, ta strona, którą ci pokazał? Wcześniej miała tekst. I mam na myśli dokładnie tę chwilę, gdy podchodziłeś. Widziałem słowa, widziałem symbole. Ale w pewnym momencie atrament, popiół, cokolwiek to było, rozlało się po całej stronie. Jakbyśmy nie mieli mieć tej wiedzy.%SPEECH_OFF%To całkiem możliwe, ale w twojej głowie rozlewa się mroczniejsze zrozumienie: %historian% ma mieć tę wiedzę, lecz jego ograniczone pojmowanie nie służy tobie, a jest jedynie narzędziem w machinacjach czegoś zupełnie innego. Pokazuje się ci tylko tyle, ile trzeba, i ani kroku dalej...}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Niepokojąca myśl.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local effect = this.new("scripts/skills/traits/mad_trait");
				_event.m.Historian.getSkills().add(effect);
				_event.m.Historian.improveMood(2.0, "Widział koniec wszystkiego");
				this.List.push({
					id = 10,
					icon = effect.getIcon(),
					text = _event.m.Historian.getName() + " oszalał"
				});
				this.Characters.push(_event.m.Other.getImagePath());
				this.Characters.push(_event.m.Historian.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_12.png[/img]{%nonhistorian% wchodzi do twojego namiotu.%SPEECH_ON%Kapitanie, szybko, coś się stało z %historian%!%SPEECH_OFF%Spieszysz na miejsce. %historian% pochyla się nad księgą Strażnika Wiedzy jak starzec osłaniający pierwszy płomień. Zaciska palce na skórzanych okładkach, ręce mu drżą, a on podnosi na ciebie przekrwione oczy.%SPEECH_ON%Wiem, co tam jest, kapitanie, wiem, co tam jest!%SPEECH_OFF%Kucasz, a mężczyzna cofa się, kręcąc głową.%SPEECH_ON%Nie. Nie! To o końcu! O końcu wszystkiego! My... my jesteśmy tylko narzędziami, by tam dotrzeć, rozumiesz? Wszystko, co robimy, wszystko, co robi ktokolwiek, jest środkiem do ostatecznego celu: śmierci wszystkich istot. Nasze istnienie daje temu moc, bez nas może znów odpocząć. Ale dopóki istnieje istnienie, nie może spać!%SPEECH_OFF%Kręcisz głową i pytasz, co ma na myśli. Mężczyzna odwraca księgę i jest tam strona całkowicie czarna, a mimo to wskazuje na niej palcem miejsce, jakbyś miał tam przeczytać zdanie.%SPEECH_ON%To nie książka, kapitanie, to instrukcja, jak podnieść duchy zmarłych.%SPEECH_OFF%Pytasz, kto mógł mieć taką wiedzę, a %historian% uśmiecha się obłąkańczo.%SPEECH_ON%Nie ma żadnego \'kto\', nie ma żadnego \'co\'! To narzędzie unicestwienia, włożone w ten świat przez Davkula!%SPEECH_OFF%Jeden z ludzi przynosi ci tłumaczenia %historian% z księgi, ale to tylko bazgroły, równie niezrozumiałe jak oryginał.%SPEECH_ON%Tylko między nami, ale ta strona, którą ci pokazał? Wcześniej miała tekst. I mam na myśli dokładnie tę chwilę, gdy podchodziłeś. Widziałem słowa, widziałem symbole. Ale w pewnym momencie atrament, popiół, cokolwiek to było, rozlało się po całej stronie. Jakbyśmy nie mieli mieć tej wiedzy.%SPEECH_OFF%To całkiem możliwe, ale w twojej głowie rozlewa się mroczniejsze zrozumienie: %historian% ma mieć tę wiedzę, lecz jego ograniczone pojmowanie nie służy tobie, a jest jedynie narzędziem w machinacjach czegoś zupełnie innego. Pokazuje się ci tylko tyle, ile trzeba, i ani kroku dalej...}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Davkul czeka na nas wszystkich.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local effect = this.new("scripts/skills/traits/mad_trait");
				_event.m.Historian.getSkills().add(effect);
				_event.m.Historian.improveMood(2.0, "Widział koniec wszystkiego");
				this.List.push({
					id = 10,
					icon = effect.getIcon(),
					text = _event.m.Historian.getName() + " oszalał"
				});
				this.Characters.push(_event.m.Other.getImagePath());
				this.Characters.push(_event.m.Historian.getImagePath());
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Desert)
		{
			return;
		}

		if (!this.World.Flags.get("IsLorekeeperDefeated") || this.World.Flags.get("IsLorekeeperTradeMade"))
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local candidates_historian = [];
		local candidates_other = [];

		foreach( bro in brothers )
		{
			if (bro.getSkills().hasSkill("trait.mad"))
			{
				return;
			}

			if (bro.getBackground().getID() == "background.historian" && bro.getLevel() >= 2 || bro.getBackground().getID() == "background.cultist" && bro.getLevel() >= 9)
			{
				candidates_historian.push(bro);
			}
			else
			{
				candidates_other.push(bro);
			}
		}

		if (candidates_historian.len() == 0 || candidates_other.len() == 0)
		{
			return;
		}

		local stash = this.World.Assets.getStash().getItems();
		local hasBlackBook = false;

		foreach( item in stash )
		{
			if (item != null && item.getID() == "misc.black_book")
			{
				hasBlackBook = true;
				break;
			}
		}

		if (!hasBlackBook)
		{
			return;
		}

		this.m.Historian = candidates_historian[this.Math.rand(0, candidates_historian.len() - 1)];
		this.m.Other = candidates_other[this.Math.rand(0, candidates_other.len() - 1)];
		this.m.Score = 100;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"historian",
			this.m.Historian.getName()
		]);
		_vars.push([
			"nonhistorian",
			this.m.Other.getName()
		]);
	}

	function onDetermineStartScreen()
	{
		if (this.World.Assets.getOrigin().getID() == "scenario.cultists")
		{
			return "B";
		}
		else
		{
			return "A";
		}
	}

	function onClear()
	{
		this.m.Historian = null;
		this.m.Other = null;
	}

});

