this.golden_goose_event <- this.inherit("scripts/events/event", {
	m = {
		Observer = null
	},
	function create()
	{
		this.m.ID = "event.location.golden_goose";
		this.m.Title = "Gdy się zbliżasz...";
		this.m.Cooldown = 999999.0 * this.World.getTime().SecondsPerDay;
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_125.png[/img]{Wrak statku leży pośród drzew, z których część dawno już zaczęła przez niego przerastać. Z tego co wiesz, w promieniu wielu mil nie ma ani morza, ani rzeki. %observer% podchodzi i zatrzymuje się na sam widok.%SPEECH_ON%Na starych bogów, czy to statek?%SPEECH_OFF%Wzdychasz i każesz kompanii zostać tutaj, podczas gdy ty i nad wyraz spostrzegawczy najemnik idziecie się przyjrzeć.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Zobaczmy, jakie sekrety są w środku.",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "Nie warto teraz tego badać.",
					function getResult( _event )
					{
						if (this.World.State.getLastLocation() != null)
						{
							this.World.State.getLastLocation().setVisited(false);
						}

						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Observer.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_125.png[/img]{Wchodzisz do wnętrza statku. Jest zupełnie pusty, poza pniakiem z wbitym w niego toporem. %observer% przygląda się temu.%SPEECH_ON%Jest tu głowica topora.%SPEECH_OFF%Kiwając głową, mówisz, że owszem. Ale metal ma żyłki o złotawym odcieniu. Podchodząc bliżej pniaka, widzisz iskry unoszące się ku górze z klinu. %observer% dotyka twojego ramienia i widzisz, że wskazuje w ciemność statku.%SPEECH_ON%Szkielet. Martwy.%SPEECH_OFF%Zaledwie dostrzegasz blade kości. Gdy podchodzisz bliżej, widać ubranie, a nawet oczywiste królewskie szaty. W jednej dłoni ma pęknięty róg do piwa, w drugiej zeschnięty bochenek chleba. Jego kaftan jest rozerwany i poszarpany drzazgami. Przy bliższej inspekcji widać, że część drewna tkwi w jego czaszce.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Sprawdź pniak.",
					function getResult( _event )
					{
						return "C";
					}

				},
				{
					Text = "Wynośmy się stąd.",
					function getResult( _event )
					{
						if (this.World.State.getLastLocation() != null)
						{
							this.World.State.getLastLocation().setVisited(false);
						}

						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Observer.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_125.png[/img]{Skoro szkielet i jego piwo z chlebem nigdzie się nie ruszają, zostawiasz to w spokoju. Jednak głowica topora znów przyciąga twój wzrok. %observer% podchodzi do pniaka i żarzącego się klina. Próbuje go wyciągnąć. Gdy mu się nie udaje, ze złością odsuwa się i kopie. Pniak pęka na dwoje, a najemnik nagle wylatuje do góry nogami, a głowica topora przelatuje przez sufit i słychać, jak tłucze się i grzechocze po prawej burcie. Odłamki i dym leniwie unoszą się w powietrzu. Najemnik wstaje i otrzepuje się.%SPEECH_ON%Co do wszystkich diabłów to było?%SPEECH_OFF%Uciskasz go gestem i wskazujesz. Tam, gdzie był korzeń pniaka, kuca mała złota gęś. Połysk jej metalu jarzy się i wiruje. Słyszałeś opowieści o złotej gęsi, ale nigdy nie sądziłeś, że to coś więcej niż bajki!}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "To prawdziwe?",
					function getResult( _event )
					{
						return "D";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Observer.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_125.png[/img]{%observer% potyka się do przodu.%SPEECH_ON%Panie, co robisz?%SPEECH_OFF%Odprawiasz go gestem i podnosisz złotą gęś. Trzymając ją obiema dłońmi, czujesz, że jest dziwnie ciepła. I nie wybucha ani nie topi ci twarzy. Czujesz, jak jej metal delikatnie faluje pod palcami. Może nawet rośnie? Z bezpiecznie przytulonym skarbem pod ramieniem zastanawiasz się, czemu szkieletowi poszło gorzej. %observer% podchodzi i dotyka złotej gęsi po głowie, ale szybko się cofa. Pytasz, czy go sparzyła. Najemnik zaciska usta.%SPEECH_ON%Naprawdę, panie? Czy to nie było oczywiste?%SPEECH_OFF%Wkłada palec do ust. Mówisz mu, by nie pyszczył do dowódcy, bo inaczej rzucisz w niego gęsią i sprawdzisz, czy zrobi z nim szybki porządek tak, jak zrobiła ze szkieletem. Mężczyzna wzrusza ramionami.%SPEECH_ON%O, spójrzcie na człeka wybranego przez świecidełko, włóż pod skrzydło miecz, niech cię pasuje na rycerza, a do diabłów, czemu nie położyć jej na głowie i od razu nazwać się królem?%SPEECH_OFF%Spoglądasz na gęś. Kropla czerwonej krwi spływa po jej długości, zamienia się w złoto i spada na ziemię z cichym plink. Podnosisz ją i gryziesz. Złoto rozgniata się przyjemnie w zębach, a potem rzucasz je do %observer%. Tym razem go nie parzy i uświadamiasz sobie, że być może znalazłeś prawdziwą Złotą Gęś z opowieści!}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Opowieści mówią prawdę!",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Observer.getImagePath());
				this.World.Assets.getStash().makeEmptySlots(1);
				local item;
				item = this.new("scripts/items/special/golden_goose_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Zyskujesz " + item.getName()
				});
			}

		});
	}

	function onUpdateScore()
	{
	}

	function onPrepare()
	{
		local brothers = this.World.getPlayerRoster().getAll();
		local candidates = [];

		foreach( bro in brothers )
		{
			if (!bro.getBackground().isNoble() && !bro.getSkills().hasSkill("trait.bright") && !bro.getSkills().hasSkill("trait.short_sighted") && !bro.getSkills().hasSkill("trait.night_blind"))
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() != 0)
		{
			this.m.Observer = candidates[this.Math.rand(0, candidates.len() - 1)];
		}
		else
		{
			this.m.Observer = brothers[this.Math.rand(0, brothers.len() - 1)];
		}
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"observer",
			this.m.Observer != null ? this.m.Observer.getNameOnly() : ""
		]);
	}

	function onDetermineStartScreen()
	{
		return "A";
	}

	function onClear()
	{
		this.m.Observer = null;
	}

});

