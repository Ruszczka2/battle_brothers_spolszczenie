this.dog_in_swamp_event <- this.inherit("scripts/events/event", {
	m = {
		Helper = null,
		Houndmaster = null,
		Beastslayer = null
	},
	function create()
	{
		this.m.ID = "event.dog_in_swamp";
		this.m.Title = "Po drodze...";
		this.m.Cooldown = 90.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_09.png[/img]Przenikliwy krzyk przebija bagienną ciszę. Pędzisz naprzód i widzisz mężczyznę miotającego się w wodzie, z ramionami miotającymi linami kudzu. Woda pieni się i bulgocze, a na chwilę wynurza się pysk psa, który tę sekundę spędza na szczekaniu o pomoc zamiast na oddechu. Widząc cię, właściciel psa woła.%SPEECH_ON%Proszę, pomóż! Coś złapało mojego psa!%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "To nie nasza sprawa.",
					function getResult( _event )
					{
						return 0;
					}

				},
				{
					Text = "Ludzie, musimy pomóc temu psu!",
					function getResult( _event )
					{
						if (this.Math.rand(1, 100) <= 60)
						{
							return "GoodEnding";
						}
						else
						{
							return "BadEnding";
						}
					}

				}
			],
			function start( _event )
			{
				local stash = this.World.Assets.getStash().getItems();
				local net = false;

				foreach( item in stash )
				{
					if (item != null && item.getID() == "tool.throwing_net")
					{
						net = true;
						break;
					}
				}

				if (net)
				{
					this.Options.push({
						Text = "Może użyję jednej z naszych sieci, by uratować tego psa.",
						function getResult( _event )
						{
							return "Net";
						}

					});
				}

				if (_event.m.Houndmaster != null)
				{
					this.Options.push({
						Text = "Może nasz psiarz może pomóc?",
						function getResult( _event )
						{
							return "Houndmaster";
						}

					});
				}

				if (_event.m.Beastslayer != null)
				{
					this.Options.push({
						Text = "%beastslayer%, znasz się na bestiach. Wiesz, co to jest?",
						function getResult( _event )
						{
							return "BeastSlayer";
						}

					});
				}
			}

		});
		this.m.Screens.push({
			ID = "GoodEnding",
			Text = "[img]gfx/ui/events/event_09.png[/img]%helpbro% brnie w bagienną wodę z wyciągniętymi rękami, kołysząc się, jakby odkręcał wieko beczki. Unosi broń wysoko, a właściciel psa nerwowo obserwuje. Na twarzy najemnika pojawia się uśmiech.%SPEECH_ON%Mam cię!%SPEECH_OFF%Przebija wodę i wyciąga węża dłuższego niż wszystko, co kiedykolwiek widziałeś; jego długość obija się, gdy najemnik obnosi zwłoki niczym kolorową linę nagrody. Właściciel rzuca się do psa, ale ten wyślizguje mu się z rąk, jakby ramiona były kolejnym wężem, i pędzi prosto do ciebie. Pytasz, czy to w ogóle jego pies. Kiwając głową, potem powoli kręci głową.%SPEECH_ON%Chyba to teraz twój pies. To walczak, ale jeśli coś w nim do niczego, to to, że jest cholernie gównianym pływakiem. Uznałbym za uczciwy układ, jeśli mogę zatrzymać tamtego węża.%SPEECH_OFF%Kiwasz głową i dobijasz targu, mówiąc %helpbro%owi, by oddał nowo zdobyte trofeum.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Chyba nazwę cię... Swimmer.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Helper.getImagePath());
				local item = this.new("scripts/items/accessory/wardog_item");
				item.m.Name = "Swimmer";
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Zyskujesz " + item.getName()
				});
			}

		});
		this.m.Screens.push({
			ID = "BadEnding",
			Text = "[img]gfx/ui/events/event_09.png[/img]%helpbro% kieruje się ku brzegowi i dobywa broni. Brnie w bagno jak jakiś piwem skropiony święty, który opuszcza tłum, zanim go rozpoznają. Zmaga się tak mocno, że przewraca się na psa i znika w pianie i bąblach walki. Rzucasz się, by mu pomóc, i wyciągasz go na brzeg; jest cały w mchu, a jego buty owinięte liliami wodnymi, dusi się ohydną bagienną wodą i wypluwa solankę, która ją zakwasiła. Po psie nie ma śladu, tylko delikatna fala, która oddala się od miejsca zdarzenia. Zaniepokojony właściciel kiwa głową.%SPEECH_ON%Doceniam wysiłek, ale co zrobić. Bagno robi takie rzeczy, bo to bagno, i niech to diabli, ten cholerny, pieprzony teren, osuszyłbym to całe gówno geograficznej osobliwości, spalił i zasolił, zostawiając samą pustynię, gdybym mógł!%SPEECH_OFF%Unosisz brew i pytasz, czy mieszka na bagnach. Bierze długi oddech i kiwa głową.%SPEECH_ON%Tak, panie. Bez czynszu.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Cóż, to było warte zachodu.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Helper.getImagePath());
				_event.m.Helper.addLightInjury();
				this.List.push({
					id = 10,
					icon = "ui/icons/days_wounded.png",
					text = _event.m.Helper.getName() + " doznaje lekkich ran"
				});
			}

		});
		this.m.Screens.push({
			ID = "Houndmaster",
			Text = "[img]gfx/ui/events/event_09.png[/img]%houndmaster%, psiarz, pędzi do przodu, by pomóc, ale powierzchnia bagna nagle się uspokaja. Mężczyzna wślizguje się do wody i maca. Zaciska dłonie i spogląda na obcego.%SPEECH_ON%W sercu jestem opiekunem psów. To znaczy, że uczę je, by nie pakowały się w takie tarapaty. Ale nigdy nie musiałbym uczyć psa, by bał się tego bagna, co znaczy, że ten skurczybyk tu go tam wrzucił, prawda?%SPEECH_OFF%Pierwsze słowa obcego to wymówki, więc psiarz go tłucze. Obcy cofa nogi tak niezręcznie, że spodnie spadają mu do kostek i z bielizny wysypuje się różny łup. Cholerny głupiec jest poszukiwaczem skarbów! %houndmaster% dobywa broni i wygląda na gotowego zabić tego człowieka. Krzycząc, obcy zrzuca spodnie i ucieka w bagienny las, pohukując, blady i na wpół nagi jak wór ziemniaków sterowany przez ducha. Śmiejąc się, kucasz, by przeszukać jego dobra, nie wszystkie błyszczą.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Co za szkoda. I co za zysk!",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Houndmaster.getImagePath());
				local item = this.new("scripts/items/loot/silverware_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Zyskujesz " + item.getName()
				});
			}

		});
		this.m.Screens.push({
			ID = "BeastSlayer",
			Text = "[img]gfx/ui/events/event_09.png[/img]Pogromca bestii, %beastslayer%, kiwa głową i wchodzi w bagno. Spokojnie podchodzi do wzburzonej wody i staje nad nią, wpatrując się w muł, a jego wzrok przesuwa się w lewo i prawo, jakby obserwował karpie w czystej wodzie. W końcu dobywa noża do obiadu i tnie nim wodę. Raz. I znów. Pies wynurza się i parska, łapiąc powietrze. Pogromca dźga ponownie i tym razem pies uwalnia się i biegnie między twoje nogi, gdzie kuli się mokry i skomlący. %beastslayer% trzyma coś w dłoni, po czym to wypuszcza; cokolwiek to jest, nurkuje przez bagno, a woda faluje w jego śladzie.%SPEECH_ON%To tylko wąż, kapitanie.%SPEECH_OFF%Pogromca bestii unosi stopę z wody, a na czubku palca ma błyszczący puchar. Spogląda na bagiennego obcego z całkowitą pogardą.%SPEECH_ON%Twoje tchórzostwo zrobiło z ciebie potwora, poszukiwaczu skarbów, prawdziwego dzikusa, który użył psa zamiast własnych rąk. Nie masz tu nic do roboty. Gdy się odwrócę, lepiej żebyś już zniknął, jasne?%SPEECH_OFF%Pogromca podaje ci puchar, a obcy bez zwłoki się wycofuje.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Bardzo dobrze.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Beastslayer.getImagePath());
				local item = this.new("scripts/items/accessory/wardog_item");
				item.m.Name = "Swimmer";
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Zyskujesz " + item.getName()
				});
				item = this.new("scripts/items/loot/golden_chalice_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Zyskujesz " + item.getName()
				});
			}

		});
		this.m.Screens.push({
			ID = "Net",
			Text = "[img]gfx/ui/events/event_09.png[/img]Wyciągasz z zapasów sieć i zarzucasz ją na psa. Mimo szarpaniny, obręcz sieci łagodnie osuwa się w muł, jakby dziecko powoli łapało nerwową muchę. Kilku najemników podbiega i wchodzi do bagna, zaciąga liny, po czym wyciąga sieć na brzeg. Łapy psa wystają związań na wszystkie strony, a mimo że życie wisi na włosku, wpatruje się tępo w jakimś zawstydzonym bezpsim odrętwieniu. Cokolwiek trzymało psa, wyczuwa niebezpieczeństwo i puszcza, a ty widzisz, jak śliska zielona lina rozwija się i nurkuje z powrotem w wodę, znikając w najlżejszych falach.\n\n %randombrother% zauważa wysportowaną sylwetkę kundla i jego posłuszne zachowanie. Rzeczywiście, już wydaje się nieporuszony otarciem o śmierć, oferując przyjazne szczeknięcie jako zeznanie. Mówisz obcemu, że pies należy teraz do kompanii.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Chyba nazwę cię... Swimmer.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local item = this.new("scripts/items/accessory/wardog_item");
				item.m.Name = "Swimmer";
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Zyskujesz " + item.getName()
				});
				local stash = this.World.Assets.getStash().getItems();

				foreach( i, item in stash )
				{
					if (item != null && item.getID() == "tool.throwing_net")
					{
						this.List.push({
							id = 10,
							icon = "ui/items/" + item.getIcon(),
							text = "Tracisz " + item.getName()
						});
						stash[i] = null;
						break;
					}
				}
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Unhold)
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();

		if (currentTile.Type != this.Const.World.TerrainType.Swamp)
		{
			return;
		}

		if (!this.World.Assets.getStash().hasEmptySlot())
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local candidates_houndmaster = [];
		local candidates_beastslayer = [];
		local candidates_other = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.houndmaster")
			{
				candidates_houndmaster.push(bro);
			}
			else if (bro.getBackground().getID() == "background.beast_slayer")
			{
				candidates_beastslayer.push(bro);
			}
			else if (!bro.getSkills().hasSkill("trait.player"))
			{
				candidates_other.push(bro);
			}
		}

		if (candidates_other.len() == 0)
		{
			return;
		}

		this.m.Helper = candidates_other[this.Math.rand(0, candidates_other.len() - 1)];

		if (candidates_houndmaster.len() != 0)
		{
			this.m.Houndmaster = candidates_houndmaster[this.Math.rand(0, candidates_houndmaster.len() - 1)];
		}

		if (candidates_beastslayer.len() != 0)
		{
			this.m.Beastslayer = candidates_beastslayer[this.Math.rand(0, candidates_beastslayer.len() - 1)];
		}

		this.m.Score = 10;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"helpbro",
			this.m.Helper.getNameOnly()
		]);
		_vars.push([
			"houndmaster",
			this.m.Houndmaster ? this.m.Houndmaster.getNameOnly() : ""
		]);
		_vars.push([
			"beastslayer",
			this.m.Beastslayer ? this.m.Beastslayer.getNameOnly() : ""
		]);
	}

	function onDetermineStartScreen()
	{
		return "A";
	}

	function onClear()
	{
		this.m.Helper = null;
		this.m.Houndmaster = null;
		this.m.Beastslayer = null;
	}

});

