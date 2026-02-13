this.shadow_dissection_event <- this.inherit("scripts/events/event", {
	m = {
		Talkers = [],
		Anatomist = null,
		Cultist = null,
		Monk = null,
		Mercenary = null,
		Swordmaster = null,
		Minstrel = null,
		OtherBro = null,
		Killer = null
	},
	function create()
	{
		this.m.ID = "event.shadow_dissection";
		this.m.Title = "W trakcie obozu...";
		this.m.Cooldown = 99999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_40.png[/img]{Wstajac, %monk% mnich wznosi prosbe do starych bogow. Jedna dlon spoczywa na piersi, druga wznosi sie, jakby w wielkim mowie ofiarnym.%SPEECH_ON%Nie cieni winni bysmy sie obawiac, lecz ognia, ktory je stworzyl, bo to plomien bogowie nam dali, bysmy mogli przenosic dzien w noc, czynic nasze pracowite nawyki nieustannymi, a nasze oddanie temu, co dobre, nieomylne.%SPEECH_OFF%Ludzie krzycza: \"hear hear!\"}",
			Banner = "",
			Characters = [],
			Options = [],
			function start( _event )
			{
				if (_event.m.Anatomist != null)
				{
					this.Options.push({
						Text = "Co ma do powiedzenia %anatomist% anatomista?",
						function getResult( _event )
						{
							return "B";
						}

					});
				}

				if (_event.m.Cultist != null)
				{
					this.Options.push({
						Text = "%cultist% kultysta znowu cos mamrocze.",
						function getResult( _event )
						{
							return "C";
						}

					});
				}

				if (_event.m.Monk != null)
				{
					this.Options.push({
						Text = "Nasz mnich %monk% chce odpowiedziec.",
						function getResult( _event )
						{
							return "D";
						}

					});
				}

				if (_event.m.Mercenary != null)
				{
					this.Options.push({
						Text = "Czemu wszyscy patrza na najwiekszego najemnika?",
						function getResult( _event )
						{
							return "E";
						}

					});
				}

				if (_event.m.Swordmaster != null)
				{
					this.Options.push({
						Text = "%swordmaster% mistrz miecza ma cos do powiedzenia.",
						function getResult( _event )
						{
							return "F";
						}

					});
				}

				if (_event.m.Minstrel != null)
				{
					this.Options.push({
						Text = "Oczywiscie, %minstrel% minstrel jest gotow gadac.",
						function getResult( _event )
						{
							return "G";
						}

					});
				}

				if (_event.m.Killer != null && this.Options.len() < 6)
				{
					this.Options.push({
						Text = "Co to za halas?",
						function getResult( _event )
						{
							return "H";
						}

					});
				}
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_184.png[/img]{%anatomist% anatomista podnosi wzrok znad ogniska, a jego twarz faluje cieniami, gdy plomienie rosna i opadaja.%SPEECH_ON%Nasze cienie to tylko ciecia na swiecie, ktore rania i goja wszystko w jednym kroku czerni, rozcinajac ziemie nasza obecnoscia i tym samym zacienionym bytem w tak przelotny sposob, ze to nie moze byc niczym innym jak zapowiedzia naszego pobytu tutaj. Ale czy cien mysli o rozcinaniu ciebie? Czy chce uwolnic innych, podobnych do siebie? Na pewno nie jest sam. Na pewno nasze wnetrza maja swoje cienie. Czy rzucaja wlasne sztuczki na nasze wewnetrzne sciany? A kiedy spimy, czy te rzeczy sa w nas, czy uciekaja na zewnatrz i wedruja po swiecie? Czy sa straznikami naszych umyslow, opuszczajac nas nocami i zostawiajac na groze sennych krain, ktore przeciez istnieja, gdy czuwamy? Co lepiej destyluje prawde porannego swiatla niz nasz cien rzucony na ziemie i ulotne wspomnienia tego, co powrocil odstraszyc?%SPEECH_OFF%Jeden z najemnikow wpatruje sie w niego.%SPEECH_ON%Co?%SPEECH_OFF%Reszta najemnikow prycha.%SPEECH_ON%Hej stary, my tylko chcemy robic fiuty i rury i inne bzdury. Patrz na to, jestem cieniem %anatomist%. Blah blah blah blah!%SPEECH_OFF%Mezczyzna udaje usta otwierajace sie i zamykajace w kolko, a kompania wybucha smiechem.}",
			Banner = "",
			Characters = [],
			Options = [
				{
					Text = "Przynajmniej anatomista to wytrzymal.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Anatomist.getImagePath());
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getID() == _event.m.Anatomist.getID())
					{
						bro.improveMood(0.75, "Czul sie intelektualnie lepszy od innych");

						if (bro.getMoodState() >= this.Const.MoodState.Neutral)
						{
							this.List.push({
								id = 10,
								icon = this.Const.MoodStateIcon[bro.getMoodState()],
								text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
							});
						}
					}
					else if (this.Math.rand(1, 100) <= 50)
					{
						bro.improveMood(1.0, "Byl rozbawiony");

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
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_03.png[/img]{%cultist% kultysta nachyla sie ku ogniowi, jego twarz niemal dotyka plomieni. Ludzie spogladaja na niego, gdy jego oczy sie rozszerzaja, wilgoc wysycha i odchodzi, az na bieli puchna krwawe zylki. Odchyla sie.%SPEECH_ON%Cienie sa tylko ambasadorami wiekszej ciemnosci.%SPEECH_OFF%Ognisko trzaska, a cien mezczyzny rozkwita na scianie klasztoru i przez moment kompania widzi w tej czerni cos innego, cos pokreconego i pochylonego, byt zupelnie niezalezny od ksztaltu %cultist%. Gdy ogien przygasa, cien rwie sie na kawalki i oddala w wieksza noc, a zostaje tylko cien kultysty, migoczacy niepewnie na scianach klasztoru.}",
			Banner = "",
			Characters = [],
			Options = [
				{
					Text = "Dziwne cienie na dziwna noc.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Cultist.getImagePath());
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getBackground().getID() == "background.cultist" || bro.getBackground().getID() == "background.converted_cultist")
					{
						bro.improveMood(1.5, "Davkul czeka");

						if (bro.getMoodState() >= this.Const.MoodState.Neutral)
						{
							this.List.push({
								id = 10,
								icon = this.Const.MoodStateIcon[bro.getMoodState()],
								text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
							});
						}
					}
					else if (this.Math.rand(1, 100) <= 20)
					{
						bro.worsenMood(1.0, "Zaniepokojony przez " + _event.m.Cultist.getName());

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
			Text = "[img]gfx/ui/events/event_40.png[/img]{Wstajac, %monk% mnich wznosi prosbe do starych bogow. Jedna dlon spoczywa na piersi, druga wznosi sie, jakby w wielkim mowie ofiarnym.%SPEECH_ON%Nie cieni winni bysmy sie obawiac, lecz ognia, ktory je stworzył, bo to plomien bogowie nam dali, bysmy mogli przenosic dzien w noc, czynic nasze pracowite nawyki nieustannymi, a nasze oddanie temu, co dobre, nieomylne.%SPEECH_OFF%Ludzie krzycza: "hear hear!"}",
			Banner = "",
			Characters = [],
			Options = [
				{
					Text = "Niech nas strzega.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Monk.getImagePath());
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getID() == _event.m.Monk.getID() || bro.getBackground().getID() == "background.cultist" || bro.getBackground().getID() == "background.converted_cultist")
					{
						continue;
					}

					if (this.Math.rand(1, 100) <= 50)
					{
						bro.improveMood(1.0, "Zainspirowany przez " + _event.m.Monk.getName());

						if (bro.getMoodState() >= this.Const.MoodState.Neutral)
						{
							this.List.push({
								id = 10,
								icon = this.Const.MoodStateIcon[bro.getMoodState()],
								text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
							});
						}

						if (this.Math.rand(1, 100) <= 33)
						{
							bro.getBaseProperties().Bravery += 1;
							this.List.push({
								id = 16,
								icon = "ui/icons/bravery.png",
								text = bro.getName() + " zyskuje [color=" + this.Const.UI.Color.PositiveEventValue + "]+1[/color] Determinacji"
							});
						}
					}
				}
			}

		});
		this.m.Screens.push({
			ID = "E",
			Text = "[img]gfx/ui/events/event_82.png[/img]{Jeden z najemnikow wstaje, wskazuje przez ognisko i oznajmia, ze %mercenary% ma najstraszniejszy cien ze wszystkich. Wielki najemnik spoglada, jakby zirytowalo go wypowiedzenie imienia na glos. Zaciska zeby i powoli unosi dlonie, a reszta kompani cofa sie ze strachem. %mercenary% splata palce i wystawia kciuki.%SPEECH_ON%To jest kura. Widzicie?%SPEECH_OFF%Ludzie patrza na cienie na scianie. Nie przypomina to wcale kury, ale nikt nie smie tego powiedziec. Wszyscy kiwaja glowami i sie zgadzaja.%SPEECH_ON%Szczerze, %mercenary%, to najlepszy kogut, jakiego widzialem.%SPEECH_OFF%Ludzie rycza ze smiechu, ale %mercenary% wstaje i smiech cichnie.%SPEECH_ON%Powiedzialem, ze to kura, prawda?%SPEECH_OFF%Drugi mezczyzna szybko kiwa glowa i zgadza sie, ze to faktycznie kura. Napiecie opada, ale zabawa w cienie dobiega konca.}",
			Banner = "",
			Characters = [],
			Options = [
				{
					Text = "Troche wygladalo to na robaka.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Mercenary.getImagePath());
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getID() == _event.m.Mercenary.getID())
					{
						continue;
					}

					if (this.Math.rand(1, 100) <= 33)
					{
						bro.improveMood(0.75, "Cieszy sie, ze walczy u boku " + _event.m.Mercenary.getName());

						if (bro.getMoodState() >= this.Const.MoodState.Neutral)
						{
							this.List.push({
								id = 10,
								icon = this.Const.MoodStateIcon[bro.getMoodState()],
								text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
							});
						}
					}
					else if (this.Math.rand(1, 100) <= 33)
					{
						bro.worsenMood(0.5, "Boi sie " + _event.m.Mercenary.getName());

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
			ID = "F",
			Text = "[img]gfx/ui/events/event_17.png[/img]{%swordmaster% mistrz miecza kiwa glowa i odzywa sie.%SPEECH_ON%Od dawna myslalem o cieniu. Gdy walczysz w swietle dnia, czy tocza sie dwie bitwy? Jedna z ciala i krwi, a druga z cieni u twoich stop? Gdy zabijasz czlowieka, czy zabijasz tez jego cien, czy twoj cien zabija jego? Kim w ogole jestesmy dla naszych cieni? Bo gdy walcze bez swiatla, to nie jest zadna walka, lecz bezsens, latajace konczyny, tnące miecze. Czysta slepota. Wyglada na to, ze tylko wtedy, gdy cien jest u boku, mozemy powiedziec, ze to walka ludzi i ich umiejetnosci.%SPEECH_OFF%Jeden z najemnikow unosi kubek z nalezytym szacunkiem.%SPEECH_ON%Jakkolwiek by to nie bylo, oby moj cien nigdy zle nie skrzyzowal sie z twoim, %swordmaster%.%SPEECH_OFF%Kompania unosi napoje. Na zdrowie!}",
			Banner = "",
			Characters = [],
			Options = [
				{
					Text = "Jego cien niesie wielkie niebezpieczenstwo.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Swordmaster.getImagePath());
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getID() == _event.m.Swordmaster.getID())
					{
						continue;
					}

					if (this.Math.rand(1, 100) <= 50)
					{
						bro.improveMood(1.0, "Cieszy sie, ze walczy z " + _event.m.Swordmaster.getName());

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
		this.m.Screens.push({
			ID = "G",
			Text = "[img]gfx/ui/events/event_26.png[/img]{%minstrel% minstrel wstaje, przechyla glowe na bok, jego krok jest powloczysty, a oczy przyczepione do wlasnego cienia na scianie klasztoru, ktory z kazdym krokiem staje sie coraz mniejszy. Wpatruje sie w cien jak w cialo, a jego zblizanie sie do niego przypomina rozwiazywanie zagadki jego zabojstwa. Nagle prostuje sie, rece na biodrach.%SPEECH_ON%Na bogow, ludzie, juz rozgryzlem! Moj cien to rasowy kobieciarz! Lajdak i wloczega. Ma wielki mlot w spodniach, a kazda kobieta to gwozdz! To lowca przygod! I pijak, zalosny pijaczyna. I... i zlodziej! Kradnie korony brudnym, nie moze sie powstrzymac. I maly psotnik, szczur pelny diabelstw. Dopiero co moj cien nasral do buta %othersellsword%! Nie moglem w to uwierzyc!%SPEECH_OFF%%othersellsword% zrywa sie na nogi, przewracajac ognisko i rozsypujac iskry, ktore zdaja sie wirowac w smiechu ludzi. Podchodzi.%SPEECH_ON%Wiedzialem, ze to nie bylo pieprzone psie gowno, draniu! Jaki czlowiek sra do butow innego czlowieka!%SPEECH_OFF%Najemnik poslizguje sie i upada, a kompania wybucha aplauzem, a minstrel delikatnie odskakuje, a jego cien z zegnaniem posyla pocalunek i macha reka.}",
			Banner = "",
			Characters = [],
			Options = [
				{
					Text = "Cien minstrela ma wiecej akcji niz ja.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Minstrel.getImagePath());
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getID() == _event.m.Minstrel.getID() || bro.getID() == _event.m.OtherBro.getID())
					{
						continue;
					}

					if (this.Math.rand(1, 100) <= 66)
					{
						bro.improveMood(1.0, "Byl rozbawiony");

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
		this.m.Screens.push({
			ID = "H",
			Text = "[img]gfx/ui/events/event_51.png[/img]{Gdy ludzie przerzucaja sie cieniami, %killer%, rzekomy zabojca w ucieczce, podchodzi do obozu, niosac narecza bizuterii i innych dobr, a ich metal polyskuje karmazynem. Mamrocze do siebie, ale nagle sie zatrzymuje i patrzy na reszte kompanii.%SPEECH_ON%O. Wy jeszcze nie spicie? Ja tylko, eee, bylem na zewnatrz. Robilem rzeczy.%SPEECH_OFF%Na jego twarzy jest krew, a pod paznokciami zaschnieta. Czujac klopoty, upuszcza fanty.%SPEECH_ON%To dla kompanii, oczywiscie. Jestem po prostu, eee, wdzieczny, ze mnie przyjeliscie. Pomyslalem, ze sie odwdziecze, wiecie?%SPEECH_OFF%Ludzie wpatruja sie w fanty. Pytasz go, czy ktos bedzie ich szukal. Usmiecha sie.%SPEECH_ON%Nie, prosze pana, oczywiscie ze nie. Dopilnowalem tego. Och, kapitanie, dopilnowalem, heh, heh, heh.%SPEECH_OFF%Kazesz mu schowac rzeczy do ekwipunku, ale najpierw je wyczyscic. Gdy odchodzi, reszta ludzi po cichu wymienia spojrzenia. Wyglada na to, ze zabawy w cienie juz sie skonczyly.}",
			Banner = "",
			Characters = [],
			Options = [
				{
					Text = "Czy ktos moze miec na niego oko?",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Killer.getImagePath());
				local item = this.new("scripts/items/loot/signet_ring_item");
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Zyskujesz " + item.getName()
				});
				this.World.Assets.getStash().add(item);
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Paladins)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local anatomist_candidates = [];
		local cultist_candidates = [];
		local monk_candidates = [];
		local mercenary_candidates = [];
		local swordmaster_candidates = [];
		local minstrel_candidates = [];
		local killer_candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.anatomist")
			{
				anatomist_candidates.push(bro);
			}
			else if (bro.getBackground().getID() == "background.cultist")
			{
				cultist_candidates.push(bro);
			}
			else if (bro.getBackground().getID() == "background.monk")
			{
				monk_candidates.push(bro);
			}
			else if (bro.getBackground().getID() == "background.hedge_knight" || bro.getBackground().getID() == "background.raider" || bro.getBackground().getID() == "background.sellsword")
			{
				mercenary_candidates.push(bro);
			}
			else if (bro.getBackground().getID() == "background.swordmaster")
			{
				swordmaster_candidates.push(bro);
			}
			else if (bro.getBackground().getID() == "background.minstrel")
			{
				minstrel_candidates.push(bro);
			}
			else if (bro.getBackground().getID() == "background.killer_on_the_run")
			{
				killer_candidates.push(bro);
			}
		}

		local bro;

		if (anatomist_candidates.len() > 0)
		{
			bro = anatomist_candidates[this.Math.rand(0, anatomist_candidates.len() - 1)];
			this.m.Anatomist = bro;
			this.m.Talkers.push(bro);
		}

		if (cultist_candidates.len() > 0)
		{
			bro = cultist_candidates[this.Math.rand(0, cultist_candidates.len() - 1)];
			this.m.Cultist = bro;
			this.m.Talkers.push(bro);
		}

		if (monk_candidates.len() > 0)
		{
			bro = monk_candidates[this.Math.rand(0, monk_candidates.len() - 1)];
			this.m.Monk = bro;
			this.m.Talkers.push(bro);
		}

		if (mercenary_candidates.len() > 0)
		{
			bro = mercenary_candidates[this.Math.rand(0, mercenary_candidates.len() - 1)];
			this.m.Mercenary = bro;
			this.m.Talkers.push(bro);
		}

		if (swordmaster_candidates.len() > 0)
		{
			bro = swordmaster_candidates[this.Math.rand(0, swordmaster_candidates.len() - 1)];
			this.m.Swordmaster = bro;
			this.m.Talkers.push(bro);
		}

		if (minstrel_candidates.len() > 0)
		{
			bro = minstrel_candidates[this.Math.rand(0, minstrel_candidates.len() - 1)];

			do
			{
				this.m.OtherBro = brothers[this.Math.rand(0, brothers.len() - 1)];
			}
			while (this.m.OtherBro == null || this.m.OtherBro.getID() == bro.getID());

			this.m.Minstrel = bro;
			this.m.Talkers.push(bro);
		}

		if (killer_candidates.len() > 0)
		{
			bro = killer_candidates[this.Math.rand(0, killer_candidates.len() - 1)];
			this.m.Killer = bro;
			this.m.Talkers.push(bro);
		}

		if (this.m.Talkers.len() <= 0)
		{
			this.m.Score = 0;
		}
		else
		{
			this.m.Score = 3 * this.m.Talkers.len();
		}
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"anatomist",
			this.m.Anatomist != null ? this.m.Anatomist.getNameOnly() : ""
		]);
		_vars.push([
			"cultist",
			this.m.Cultist != null ? this.m.Cultist.getNameOnly() : ""
		]);
		_vars.push([
			"monk",
			this.m.Monk != null ? this.m.Monk.getNameOnly() : ""
		]);
		_vars.push([
			"mercenary",
			this.m.Mercenary != null ? this.m.Mercenary.getNameOnly() : ""
		]);
		_vars.push([
			"swordmaster",
			this.m.Swordmaster != null ? this.m.Swordmaster.getNameOnly() : ""
		]);
		_vars.push([
			"minstrel",
			this.m.Minstrel != null ? this.m.Minstrel.getNameOnly() : ""
		]);
		_vars.push([
			"othersellsword",
			this.m.OtherBro != null ? this.m.OtherBro.getNameOnly() : ""
		]);
		_vars.push([
			"killer",
			this.m.Killer != null ? this.m.Killer.getNameOnly() : ""
		]);
	}

	function onClear()
	{
		this.m.Talkers = [];
		this.m.Anatomist = null;
		this.m.Cultist = null;
		this.m.Monk = null;
		this.m.Mercenary = null;
		this.m.Swordmaster = null;
		this.m.Minstrel = null;
		this.m.OtherBro = null;
		this.m.Killer = null;
	}

});

