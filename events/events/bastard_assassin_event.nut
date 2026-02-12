this.bastard_assassin_event <- this.inherit("scripts/events/event", {
	m = {
		Bastard = null,
		Other = null,
		Assassin = null
	},
	function create()
	{
		this.m.ID = "event.bastard_assassin";
		this.m.Title = "Podczas obozu...";
		this.m.Cooldown = 999999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "Intro",
			Text = "[img]gfx/ui/events/event_33.png[/img]Pod osłoną nocy do twojego namiotu wsuwa się mężczyzna, chowając się pod fałdami płótna, które falują tuż nad ziemią. Ma czarny płaszcz i szlacheckie naramienniki. Sięgasz po broń, ale on unosi dłoń.%SPEECH_ON%Nie fatyguj się, najemniku, nie przyszedłem po ciebie.%SPEECH_OFF%To ci nie wystarcza. Gdy tylko robi krok do przodu, rzucasz się na niego, kładziesz go na stole i wolną ręką przykładasz mu sztylet do gardła. Uśmiecha się.%SPEECH_ON%Już mówiłem, nie przyszedłem po ciebie. Przyszedłem po %bastard%.%SPEECH_OFF%Po bękarta ze szlachty? Pytasz, czego obcy od niego chce.%SPEECH_ON%Cóż, to zależy, czy chcesz rozmawiać?%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Dobrze, mów.",
					function getResult( _event )
					{
						return "A";
					}

				},
				{
					Text = "Żadnych rozmów. Zginiesz.",
					function getResult( _event )
					{
						local r = this.Math.rand(1, 100);

						if (r <= 33)
						{
							return "Decline1";
						}

						if (r <= 66)
						{
							return "Decline2";
						}
						else
						{
							return "Decline3";
						}
					}

				}
			],
			function start( _event )
			{
				local roster = this.World.getTemporaryRoster();
				_event.m.Assassin = roster.create("scripts/entity/tactical/player");
				_event.m.Assassin.setStartValuesEx([
					"assassin_background"
				]);
				this.Characters.push(_event.m.Assassin.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_33.png[/img]Odsuwasz sztylet od jego gardła. Prostuje się na stole i zerka na mapę.%SPEECH_ON%Widzę, że %companyname% maszerowała daleko i szeroko. %bastard% mądrze wybrał, dołączając do jej szeregów.%SPEECH_OFF%Gdy kropla krwi plami papier, zatrzymuje się, by podrapać małą rankę, którą zostawiłeś mu na szyi, marszcząc usta tak, jakby sam zrobił to podczas porannego golenia.%SPEECH_ON%W każdym razie, przejdźmy do interesów. Moi zleceniodawcy chcą śmierci %bastard%. Ponieważ zapłacono mi sporą sumę, jestem zobowiązany doprowadzić to do końca. Albo... może jednak nie.%SPEECH_OFF%Gdy unosi figlarnie brew, mówisz, by wyłożył, o co mu chodzi. Przechadza się nad mapą, jakby stąpał po kładce.%SPEECH_ON%%bastard% ma armię, która czeka na niego, jeśli zechce. Dlatego szlachta chce jego śmierci, bo jest realnym i poważnym zagrożeniem dla status quo, a on sam jeszcze o tym nie wie. Pewnie wcale nie musi wiedzieć, ale byłoby to godne pożegnanie, nie? Dopilnujesz, by jego miejsce w tym świecie miało sens i by nie był tylko przypadkiem sunącym przez świat, który – jak sądzi – go nienawidzi. A co ze mną, wyjątkowo utalentowanym skrytobójcą z idealną passą zabójstw, hm? Co ze mną? Cóż, nie chcę już takiego życia. Oto moja propozycja: zajmuję jego miejsce. On idzie do domu, ja idę z tobą. On idzie i podbija, moi zleceniodawcy niczego nie podejrzewają, a dla nich po prostu znikam. Brzmi dobrze, nie?%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Mamy umowę.",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "Ile ci za to zapłacili?",
					function getResult( _event )
					{
						return "C";
					}

				},
				{
					Text = "Albo po prostu cię zabiję.",
					function getResult( _event )
					{
						local r = this.Math.rand(1, 100);

						if (r <= 33)
						{
							return "Decline1";
						}

						if (r <= 66)
						{
							return "Decline2";
						}
						else
						{
							return "Decline3";
						}
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Assassin.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_33.png[/img]%bastard% zasługuje na coś lepszego. Nie chodzi o to, że %companyname% jest poniżej niego, ale to człowiek, który całe życie widział w sobie outsidera, skazę na własnym nazwisku i zagrożenie dla tych, których kocha, tylko dlatego, że mają szlachetniejszą krew. Zgadzasz się na żądanie skrytobójcy i wzywasz bękarta do namiotu. Gdy wchodzi, szybko wyjaśniasz sytuację. Pyta o dowód, że czeka na niego armia, a najemny morderca natychmiast go przedstawia, pokazując zapieczętowany zwój z sygnetem i podpisem, które rozpozna tylko bękart. %bastard% czyta go uważnie. Spogląda w dół, potem na ciebie.%SPEECH_ON%I ty się na to zgadzasz? Los należy do mnie, ale masz mój miecz i lojalność tak długo, jak zechcesz.%SPEECH_OFF%Klepiesz go po ramieniu i każesz mu wykuć własną ścieżkę. Skrytobójca mówi mu, że jeśli ma to zrobić, to powinien to zrobić szybko. Z lekko zaszklonymi oczami, wcale tego nie kryjąc, %bastard% dziękuje, że przynajmniej w niego uwierzyłeś, nawet jeśli tylko na krótki czas, kiedy był z %companyname%. A potem odchodzi. Odwracasz się i widzisz, jak skrytobójca się kłania.%SPEECH_ON%I tak oto masz mój miecz, kapitanie.%SPEECH_OFF%To będzie wymagało wyjaśnień pozostałym ludziom, ale na pewno zaufają twojej intuicji.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Trzymaj się, bękarcie.",
					function getResult( _event )
					{
						this.World.getPlayerRoster().add(_event.m.Assassin);
						this.World.getTemporaryRoster().clear();
						_event.m.Assassin.onHired();
						_event.m.Bastard.getItems().transferToStash(this.World.Assets.getStash());
						_event.m.Bastard.getSkills().onDeath(this.Const.FatalityType.None);
						this.World.getPlayerRoster().remove(_event.m.Bastard);
						_event.m.Bastard = null;
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Assassin.getImagePath());
				this.Characters.push(_event.m.Bastard.getImagePath());
				this.List.push({
					id = 13,
					icon = "ui/icons/kills.png",
					text = _event.m.Bastard.getName() + " odchodzi z " + this.World.Assets.getName()
				});
				this.List.push({
					id = 13,
					icon = "ui/icons/special.png",
					text = _event.m.Assassin.getName() + " dołącza do " + this.World.Assets.getName()
				});
				_event.m.Assassin.getBackground().m.RawDescription = "%name% dołączył do kompanii w zamian za życie " + _event.m.Bastard.getName() + ". Niewiele wiadomo o skrytobójcy, a większość wciąż mu nie ufa. Z sztyletem w dłoni ręka zabójcy porusza się i faluje bardziej jak u węża niż u człowieka.";
				_event.m.Assassin.getBackground().buildDescription(true);
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_33.png[/img]Zanim o czymkolwiek zdecydujesz, pytasz skrytobójcę, ile zaoferowano mu za zabicie bękarta. Waży liczby, przechylając głowę w jedną i drugą stronę.%SPEECH_ON%Cóż, to było... a potem, odejmując czas podróży, koszty wyposażenia, czas potrzebny na znalezienie tego cholernika oraz czas na rekonesans twojego obozu i sprawdzenie, czy w ogóle jesteś skłonny rozmawiać, powiedziałbym... pięć tysięcy koron. Jeśli chcesz to przebić, będzie trochę więcej. O jakieś tysiąc więcej, więc na twoim rachunku będzie sześć tysięcy koron. Nadal masz ochotę na taką \'dyskusję\', hm?%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Zgadzam się na twoją propozycję. %bastard% odejdzie, a ty zajmiesz jego miejsce.",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "Zapłacę ci te 6 000 koron i zarówno %bastard%, jak i ty zostaniecie.",
					function getResult( _event )
					{
						return "D";
					}

				},
				{
					Text = "Chyba po prostu cię zabiję.",
					function getResult( _event )
					{
						local r = this.Math.rand(1, 100);

						if (r <= 33)
						{
							return "Decline1";
						}

						if (r <= 66)
						{
							return "Decline2";
						}
						else
						{
							return "Decline3";
						}
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Assassin.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_33.png[/img]Choć %companyname% radzi sobie dobrze, nawet gdyby była najlepsza na świecie, sześć tysięcy koron to wciąż dużo. Ale... zgadzasz się. Skrytobójca słyszy twoje słowa i przez chwilę siedzi w milczeniu.%SPEECH_ON%Zgadzasz się? Naprawdę zapłacisz sześć tysięcy koron?%SPEECH_OFF%Kiwasz głową. Przetrawia to jeszcze przez moment, z ledwie widocznym pęknięciem w twardej postawie, którą dotąd prezentował.%SPEECH_ON%Szczerze mówiąc, nie sądziłem, że to zrobisz. Ale umowa to umowa, a ja nie jestem od tego, by lekko rzucać słowa.%SPEECH_OFF%Wyciąga dłoń, a ty ściskasz ją mocno - na wypadek podstępu. Kłania się z gracją, zapewne czego nauczył się w salach szlachty, która go tu przysłała.%SPEECH_ON%Kapitanie %companyname%, masz mój miecz!%SPEECH_OFF%Będzie trzeba wyjaśnić, jak to się stało, że przypadkowy człowiek wślizgnął się do kompanii w środku nocy, ale ludzie mają dość wiary w twoje dowództwo, że mógłbyś zwerbować kozę dzierżącą miecz, a i tak by to łyknęli.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Witaj na pokładzie, skrytobójco.",
					function getResult( _event )
					{
						this.World.getPlayerRoster().add(_event.m.Assassin);
						this.World.getTemporaryRoster().clear();
						_event.m.Assassin.onHired();
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Assassin.getImagePath());
				_event.m.Assassin.getBackground().m.RawDescription = "Skrytobójca zmęczony życiem zabójcy, %name% zaproponował dołączenie do twojej kompanii za dużą cenę, którą szybko zgodziłeś się zapłacić. Jest niezwykle biegły w krótkich ostrzach, kręcąc sztyletami z większą zręcznością i kontrolą, niż niektórzy ludzie mają nad własnymi palcami.";
				_event.m.Assassin.getBackground().buildDescription(true);
				this.World.Assets.addMoney(-6000);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Wydajesz [color=" + this.Const.UI.Color.NegativeEventValue + "]6,000[/color] koron"
				});
				this.List.push({
					id = 13,
					icon = "ui/icons/special.png",
					text = _event.m.Assassin.getName() + " dołącza do " + this.World.Assets.getName()
				});
			}

		});
		this.m.Screens.push({
			ID = "Decline1",
			Text = "[img]gfx/ui/events/event_33.png[/img]Odrzucasz ofertę skrytobójcy. Kiwa głową.%SPEECH_ON%Dobrze.%SPEECH_OFF%Sztylet nadchodzi szybko, szybciej, niż się spodziewałeś. Unosisz rękę, by się zasłonić, ale jesteś o ułamek sekundy za późno. Ostrze muska twój policzek i pojawia się krew. Gdy dobywasz miecza, skrytobójca już wyskoczył z namiotu. Słyszysz hałas na zewnątrz i pędzisz tam. %bastard% bękart leży na ziemi, a obok niego kilku innych braci. %otherbrother% podchodzi i pyta, czy wszystko w porządku. Mówi, że człowiek w czerni próbował zabić bękarta.%SPEECH_ON%Myślę, że zadaliśmy mu śmiertelne rany, ale nie wiem, dokąd uciekł. Drań pociął nas wszystkich. Panie, krwawisz.%SPEECH_OFF%Mówisz, że wiesz i że teraz najważniejsze jest zadbać o bękarta i resztę ludzi.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Cóż, przynajmniej nikt nie zginął.",
					function getResult( _event )
					{
						this.World.getTemporaryRoster().clear();
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Bastard.getImagePath());
				local injury = _event.m.Bastard.addInjury(this.Const.Injury.PiercingBody);
				this.List.push({
					id = 10,
					icon = injury.getIcon(),
					text = _event.m.Bastard.getName() + " doznaje " + injury.getNameOnly()
				});
				injury = _event.m.Bastard.addInjury(this.Const.Injury.PiercingBody);
				this.List.push({
					id = 10,
					icon = injury.getIcon(),
					text = _event.m.Bastard.getName() + " doznaje " + injury.getNameOnly()
				});
			}

		});
		this.m.Screens.push({
			ID = "Decline2",
			Text = "[img]gfx/ui/events/event_33.png[/img]Kładziesz dłoń na głowicy miecza i odmawiasz skrytobójcy. Ten klaszcze w dłonie.%SPEECH_ON%Dobrze, najemniku. W porządku. I nie baw się tu w teatr.%SPEECH_OFF%Kiwa w stronę twojej ręki na mieczu.%SPEECH_ON%Gdybym naprawdę chciał śmierci bękarta, myślisz, że stałbym tu teraz? Przyszedłem porozmawiać i porozmawialiśmy. Życie zabójcy zostawiłem za sobą, a wraz z nim, jak widać, także pokerową twarz. Wytknąłeś blef i to tyle. Dobranoc, najemniku.%SPEECH_OFF%Zanim zdążysz powiedzieć cokolwiek więcej, skrytobójca wysuwa się z namiotu. Pędzisz sprawdzić, gdzie poszedł, ale znajdujesz tylko mrok nocy. %bastard% bękart widzi, jak się rozglądasz, i pyta, co robisz. Uśmiechasz się i każesz mu odpocząć, bo naprawdę na to zasługuje. Zdezorientowany wzrusza ramionami.%SPEECH_ON%Cóż, yyy, chyba tak. Dzięki, kapitanie.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "No to po sprawie.",
					function getResult( _event )
					{
						this.World.getTemporaryRoster().clear();
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Bastard.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "Decline3",
			Text = "[img]gfx/ui/events/event_33.png[/img]Odrzucasz ofertę skrytobójcy. Kiwa głową, przeciągając dłonią nad świecą.%SPEECH_ON%Cóż. Wygląda na to, że nasza rozmowa dobiegła końca, więc musi zacząć się coś innego.%SPEECH_OFF%Odwraca twarz ku tobie. Mruga.\n\n Sztylet nadchodzi szybko, jego połysk miga, gdy tnie tuż przed twoją twarzą. Sięgasz po broń, ale mężczyzna kopie cię w rękę, wbijając miecz z powrotem do pochwy. Nadchodzi drugi sztylet - tym razem twój, dobyty zza pleców i wypchnięty z morderczym zamiarem. Sztylet skrytobójcy rozkłada się w trójząb, w który wpada twoje ostrze. Przekręca dłoń, rozbraja cię w jednej chwili, po czym znowu obraca dłoń, zamykając sztylet w jedno ostrze. Skur...\n\n Mężczyzna zadaje pchnięcie, ale łapiesz go za ramię. Drugą ręką ucisza cię, sięgając po kolejne ostrze, którego nie masz jak powstrzymać. Szepcze z niepokojącym spokojem.%SPEECH_ON%Umrzyj z godnością, kapitanie.%SPEECH_OFF%Gdy jego ręka cofa się do pchnięcia, nagle znika w błysku metalu. Zostaje tylko kikut tryskający czerwienią. Skrytobójca patrzy na kikut i krzyczy. %bastard% stoi obok z bronią w dłoni. Kolejny błysk metalu i głowa skrytobójcy spada z ramion. Z rany tryska krew, gdy jego tułów wali się na twój stół i spada na ziemię. Bękart pospiesznie pyta.%SPEECH_ON%Czy wszystko w porządku? Kto to, do diabła, był?%SPEECH_OFF%Do namiotu wchodzi więcej najemników, by sprawdzić, co za zamieszanie. Informujesz ich, że skrytobójca przyszedł po bękarta, ale nie zamierzałeś go tak łatwo oddać. Ludzie biją brawo twojej obronie towarzysza.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Jesteś mi winien, bękarcie.",
					function getResult( _event )
					{
						this.World.getTemporaryRoster().clear();
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Bastard.getImagePath());

				if (!_event.m.Bastard.getSkills().hasSkill("trait.loyal") && !_event.m.Bastard.getSkills().hasSkill("trait.disloyal"))
				{
					local loyal = this.new("scripts/skills/traits/loyal_trait");
					_event.m.Bastard.getSkills().add(loyal);
					this.List.push({
						id = 10,
						icon = loyal.getIcon(),
						text = _event.m.Bastard.getName() + " jest teraz lojalny"
					});
				}

				_event.m.Bastard.improveMood(2.0, "Zaryzykowałeś dla niego życie");

				if (_event.m.Bastard.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Bastard.getMoodState()],
						text = _event.m.Bastard.getName() + this.Const.MoodStateEvent[_event.m.Bastard.getMoodState()]
					});
				}

				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getID() == _event.m.Bastard.getID())
					{
						continue;
					}

					if (this.Math.rand(1, 100) <= 50)
					{
						bro.improveMood(0.5, "Zaryzykowałeś życie dla ludzi");

						if (bro.getMoodState() >= this.Const.MoodState.Neutral)
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
		if (this.World.getTime().IsDaytime)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();

		if (this.World.getPlayerRoster().getSize() >= this.World.Assets.getBrothersMax())
		{
			return;
		}

		local candidates = [];
		local candidates_other = [];

		foreach( bro in brothers )
		{
			if (bro.getLevel() >= 6 && bro.getBackground().getID() == "background.bastard")
			{
				candidates.push(bro);
			}
			else if (!bro.getSkills().hasSkill("trait.player"))
			{
				candidates_other.push(bro);
			}
		}

		if (candidates.len() == 0 || candidates_other.len() == 0)
		{
			return;
		}

		this.m.Bastard = candidates[this.Math.rand(0, candidates.len() - 1)];
		this.m.Other = candidates_other[this.Math.rand(0, candidates_other.len() - 1)];
		this.m.Score = candidates.len() * 2;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"bastard",
			this.m.Bastard.getNameOnly()
		]);
		_vars.push([
			"otherbrother",
			this.m.Other.getNameOnly()
		]);
	}

	function onDetermineStartScreen()
	{
		return "Intro";
	}

	function onClear()
	{
		this.m.Bastard = null;
		this.m.Other = null;
		this.m.Assassin = null;
	}

});

