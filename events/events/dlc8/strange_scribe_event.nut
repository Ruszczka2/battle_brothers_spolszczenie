this.strange_scribe_event <- this.inherit("scripts/events/event", {
	m = {
		Anatomist = null,
		Dude = null,
		Minstrel = null,
		Killer = null,
		Town = null
	},
	function create()
	{
		this.m.ID = "event.strange_scribe";
		this.m.Title = "Po drodze...";
		this.m.Cooldown = 9999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_31.png[/img]{Podczas pobytu w %townname% podchodzi do ciebie osoba, ktora widziales w poblizu jednego z tutejszych moznowladcow. Ma czarny plaszcz i trzyma twarz gleboko w kapturze. To uosobienie podejrzanosci. Naturalnie, %anatomist% anatomista przyglada mu sie jak jednemu ze swoich obiektow obserwacji. Mezczyzna klania sie.%SPEECH_ON%Przychodze z wielkim szacunkiem dla twojej pracy, %anatomist%. Czytalismy wiele twoich tekstow.%SPEECH_OFF%Kladziesz dlon na mieczu i czekasz, dokad to zmierza. Mezczyzna kontynuuje.%SPEECH_ON%Chcielibysmy zaprosic cie na posilek i omowic sprawy ciala nieco bardziej...gleboko.%SPEECH_OFF%Wchodzac miedzy mezczyzn, pytasz, kim jest to "my". Mezczyzna stwierdza, ze nalezy do grupy skrybow i uczonych, ktorzy badaja sprawy ludzkiego ciala, a takze cial, ktore dobrze przystosowaly sie do bestialskich zadan, czyli badaja potwory swiata.%SPEECH_ON%My, rzecz jasna, mamy szczegolne zainteresowanie bestiami, ktorymi jest sam czlowiek...po utracie tego, czym jest.%SPEECH_OFF%Przy takiej dozie intrygi nie dziwi cie, ze anatomista chce pojsc z dziwnym skryba.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Ide z toba.",
					function getResult( _event )
					{
						return this.Math.rand(1, 100) <= 50 ? "B" : "C";
					}

				},
				{
					Text = "To zbyt podejrzane.",
					function getResult( _event )
					{
						return "G";
						Text = "[img]gfx/ui/events/event_12.png[/img]{Zgadzasz sie, by anatomista i dziwny skryba porozmawiali, a ty idziesz z nimi. Mezczyzna prowadzi was do wylotu alejki, ktory jest wyjatkowo podejrzany. Odwraca sie z dzikim usmiechem na twarzy i powoli zaczyna wysuwac sztylet z rekawa, po czym nagle noz przebija mu twarz, a blysk stali miga mu w ustach. Gdy charczy, kolejny noz wpada i podcina mu gardlo szybkim cieciem. Z alejki wylania sie %killer%, rzekomy zabojca w ucieczce.%SPEECH_ON%Witaj, kapitanie i, ee, anatomisto? Mistrzu zwlok? Ten typ byl morderca. I wscibialski, wscibal sie w moje...ee...sprawy.%SPEECH_OFF%Upuszcza cialo na ziemie i zaczyna zdejmowac plaszcz, ujawniajac, ze rzekomy skryba byl dobrze uzbrojony i opancerzony. Zabojca odcina jedno ucho i chowa je, po czym kiwa glowa.%SPEECH_ON%Hej, wyglada na to, ze mamy darmowy sprzet, co? Ale chyba powinnismy ukryc cialo. Ten gosc robil wrazenie eminencji i niektorzy moga uznac jego brak za wart sprawdzenia.%SPEECH_OFF%Nie wiesz, komu ani czemu wierzyc w tej sprawie, ale martwe cialo krwawiace na twoje buty zawsze wyglada zle, niezaleznie od okolicznosci. Ukrywasz cialo, oczywiscie po uprzednim ograbieniu go ze sprzetu. %anatomist% wydaje sie nieufny wobec %killer%. Wspomina, ze ton glosu zabojcy brzmial jak natychmiast zrodzona hipoteza albo, jak to ujmuje pospolity czlowiek, \"udawanie\". Skoro juz sie stalo, mowisz mu tylko, by pomogl zaniesc sprzet do ekwipunku.}",

				}
			],
			function start( _event )
			{
				if (_event.m.Minstrel != null)
				{
					this.Options.push({
					Text = "[img]gfx/ui/events/event_51.png[/img]{Zabierasz minstrela bez zadnych kosztow werbunku. %anatomist% anatomista wyglada na nieco przygnebionego calym zajsciem, mowiac, ze pragnie rzadkiej wiedzy, a ten swiat zdaje sie oferowac tylko przekrety i falsze. Usmiechajac sie, mowisz mu, by potraktowal to jako wiedze uliczna. On tez sie usmiecha.%SPEECH_ON%Tak, byc moze powinienem nabyc wiecej tej...ulicznej smykalki.%SPEECH_OFF%Nie, wiedzy ulicznej. \"Uliczna smykalka\" brzmi smiesznie.}",
						function getResult( _event )
						{
							return "D";
						}

					});
				}

				if (_event.m.Killer != null)
				{
					this.Options.push({
						Text = "Chwila, gdzie jest nasz rezydentny morderca %killer%?",
						function getResult( _event )
						{
							return "F";
						}

					});
				}

				this.Characters.push(_event.m.Anatomist.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_31.png[/img]{Jesli %anatomist% ma dokadkolwiek isc w tym miescie, to na pewno nie sam. Idziesz z nim, a dlon nie schodzi ci z miecza. Dziwny mezczyzna zaprasza was do pieknego kamiennego domu, gdzie z kazdego okna bije blask swiec. W srodku szybko prowadza was do tego, co powinno byc stolem, ale zamiast tego lezy na nim blady mezczyzna, ktoremu skora ledwo trzyma sie ciala. Dziwny skryba klania sie jak kucharz, ktory dostarczyl swoje najlepsze danie.%SPEECH_ON%Wierzymy, ze to wiedzmag, czlowiek, ktory umarl, a jednak znów chodzi.%SPEECH_OFF%Dziwny skryba podwija rekaw i trzyma go nad zniszczonym cialem. Jego paszcza nagle odskakuje na boki, szczeka sie rozgina, a biale oczy przewracaja. %anatomist% tylko odchyla sie i stwierdza, ze to "interesujace". Dwaj mezczyzni zaczynaja rozmawiac, a ty nerwowo dotykasz jelca miecza na wypadek, gdyby ten "wiedzmag" zechcial uciec. Gdy koncza, %anatomist% i skryba wyciagaja piora i wpisuja swoje podpisy do swoich tomow, jednoczesnie gratulujac sobie pracy.\n\nCale to wydarzenie sprawia, ze sie krzywisz, i zauwazasz cos, co wyglada jak kropla potu na czole wiedzmy, ale zanim zdazysz to skomentowac, zostajesz wyprowadzony z domu. Cokolwiek omawiali, anatomista jest pelen energii. Mowi ostroznie.%SPEECH_ON%Stworzenie bylo falszywka, oczywiscie, nie mysl, ze tego nie zauwazylem. Jednak dalo mi to sporo wgladu w wynalazcza glebia miejscowych. W tej kreatywnosci jest cos do wydobycia, bo wyobraznia potajemnie czerpie z wznioslosci i rzeczywistosci oraz wnioskuje o tym, co przeczuwa, a czego nie umie jeszcze naukowo opisac. Nawet w blotnistym mroku regionalnych przesadow i kuglarstwa moge czynic wielkie postepy.%SPEECH_OFF%Dobrze, dobrze. Wspominasz, ze wiedziales, iz to oszustwo, bo rzekomo martwy kretyn sie pocil. Anatomista kiwa glowa i mowi, ze moze nie masz oka do diagnozy, ale uliczny spryt wystarcza do przenikliwego wnioskowania. Po prostu kiwasz glowa, liczac, ze mial dobre intencje, cokolwiek to znaczy.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Wynosmy sie stad.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				_event.m.Anatomist.improveMood(0.75, "Nauczyl sie lepiej obchodzic z pospolstwem");

				if (_event.m.Anatomist.getMoodState() > this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Anatomist.getMoodState()],
						text = _event.m.Anatomist.getName() + this.Const.MoodStateEvent[_event.m.Anatomist.getMoodState()]
					});
				}

				local fatigueBoost = this.Math.rand(1, 3);
				_event.m.Anatomist.getBaseProperties().Stamina += fatigueBoost;
				_event.m.Anatomist.getSkills().update();
				this.List.push({
					id = 16,
					icon = "ui/icons/fatigue.png",
					text = _event.m.Anatomist.getName() + " zyskuje [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + fatigueBoost + "[/color] Zmeczenia"
				});
				this.Characters.push(_event.m.Anatomist.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_97.png[/img]{Zgadzasz sie, by anatomista poszedl, ale ty idziesz z nim. To zwraca uwage dziwnego skryby. Teraz wydaje sie niechetny, stracil energie, ktora mial na poczatku. Gdy skrecacie za rog, wydaje ostry, ptasi okrzyk, a kilku mezczyzn wychodzi, ty dobywasz miecza i odpychasz %anatomist%. Jeden z nich probuje ataku. Nie jestes w najlepszej formie do walki, ale szybka parada odpycha go i zniecheca do dalszego ataku. Skryba i jego ludzie odchodza pospiesznie, mowiac, ze nie jestescie warci zachodu. %anatomist% wyglada na rozczarowanego.%SPEECH_ON%Ach, rozumiem. Wiec to bylo oszustwo, przedsiewziecie tak kreatywne, jak i przestepcze.%SPEECH_OFF%Rozgladajac sie, orientujesz sie, ze twoja sakiewka zniknela. Spogladasz i widzisz dziecko, ktore ja trzyma, po czym rzuca ja w gore, by zlapalo ja inne dziecko wiszace na rynnach. %anatomist% stoi obok, patrzac w gore, zafascynowany sprytem tych urwisow.%SPEECH_ON%Wyglada na to, ze gdy jeden winowajca zawodzi, inny moze zajac jego miejsce. Tak, przez wyczerpanie, przestepcy moga odnosic sukces. Interesujace.%SPEECH_OFF%Anatomista nagle orientuje sie, ze tez jest lzejszy przy biodrze i widzi, ze jego sakiewka rowniez zniknela. Patrzysz obok, by zobaczyc kolejne dziecko uciekajace jak szczur z serem. Inne dziecko przebiega obok i probuje cie okrasc, gdy nie ma juz nic do zabrania. Zirytowany pustymi rekami, chlopiec krzyczy.%SPEECH_ON%Znajdz robote!%SPEECH_OFF%Wzdychajac, mowisz, ze to pewnie czas wracac do kompanii.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Cholerne urwisy.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.Assets.addMoney(-175);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Tracisz [color=" + this.Const.UI.Color.NegativeEventValue + "]175[/color] Koron"
				});
				this.Characters.push(_event.m.Anatomist.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_51.png[/img]{Zgadzasz sie, by %anatomist% i dziwny skryba porozmawiali, ale zanim w ogole ruszysz ulica, %minstrel% minstrel wystepuje, usmiecha sie i wskazuje.%SPEECH_ON%%fakescribe%! Co ty do diabla teraz wyprawiasz? To jakis nowy przekret, co masz w rekawie, co?%SPEECH_OFF%Dziwny skryba chrzaka. Rozklada rece i chrzaka jeszcze raz, jakby mial wyglosic uczona mowe, ale potem wzdycha i odrzuca plaszcz. Ujawnia sie mlody, wcale nie uczony mezczyzna. Kreci glowa.%SPEECH_ON%Zycie w wielkim miescie dalo mi w kosc, %minstrel%. A u ciebie jak?%SPEECH_OFF%Obaj rozmawiaja przez chwile, a ty i %anatomist% patrzycie zaskoczeni. W koncu dwaj minstrelowie zwracaja sie do ciebie, %minstrel% prowadzi.%SPEECH_ON%Kapitanie, to %fakescribe%. Ma ciezkie czasy tutaj, w %townname%. Co powiesz, by dolaczyl do %companyname%? Jest do mnie podobny - kiepski wojownik, ale z pazurem, z werwa, ma to cos, jesli tylko dostanie czas, by to odkryc, zwlaszcza gdy w grę wchodzi kobieta.%SPEECH_OFF%%fakescribe% kreci glowa.%SPEECH_ON%Ehem, ehh, przy nich ja nigdy, eee, tego nie znajduję.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Jasne, moze dolaczyc.",
					function getResult( _event )
					{
						return "E";
					}

				},
				{
					Text = "Nie potrzebujemy kolejnego szarlatana.",
					function getResult( _event )
					{
						this.World.getTemporaryRoster().clear();
						return 0;
					}

				}
			],
			function start( _event )
			{
				local roster = this.World.getTemporaryRoster();
				_event.m.Dude = roster.create("scripts/entity/tactical/player");
				_event.m.Dude.setStartValuesEx([
					"minstrel_background"
				]);
				_event.m.Dude.getBackground().m.RawDescription = "{%name% zostal znaleziony, gdy wykorzystywal swoje talenty minstrela w ulicznych przekretach. Polecony przez innego minstrela, dolaczyl do %companyname%, by szukac zycia na drodze. Oby szarlatan, ktory stal sie najemnikiem, potrafil \'udawac, az sie uda\', jak lubi to powtarzac zbyt czesto.}";
				_event.m.Dude.getBackground().buildDescription(true);
				this.Characters.push(_event.m.Minstrel.getImagePath());
				this.Characters.push(_event.m.Dude.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "E",
			Text = "[img]gfx/ui/events/event_51.png[/img]{Zabierasz minstrela bez zadnych kosztow werbunku. %anatomist% anatomista wyglada na nieco przygnebionego calym zajsciem, mowiac, ze pragnie rzadkiej wiedzy, a ten swiat zdaje sie oferowac tylko przekrety i falsze. Usmiechajac sie, mowisz mu, by potraktowal to jako wiedze uliczna. On tez sie usmiecha.%SPEECH_ON%Tak, byc moze powinienem nabyc wiecej tej...ulicznej smykałki.%SPEECH_OFF%Nie, wiedzy ulicznej. "Uliczna smykałka" brzmi smiesznie.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Ogarnij sie, %anatomist%.",
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
				this.Characters.push(_event.m.Anatomist.getImagePath());
				this.Characters.push(_event.m.Dude.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "F",
			Text = "[img]gfx/ui/events/event_12.png[/img]{Zgadzasz sie, by anatomista i dziwny skryba porozmawiali, a ty idziesz z nimi. Mezczyzna prowadzi was do wylotu alejki, ktory jest wyjatkowo podejrzany. Odwraca sie z dzikim usmiechem na twarzy i powoli zaczyna wysuwac sztylet z rekawa, po czym nagle noz przebija mu twarz, a blysk stali miga mu w ustach. Gdy charczy, kolejny noz wpada i podcina mu gardlo szybkim cieciem. Z alejki wyłania sie %killer%, rzekomy zabojca w ucieczce.%SPEECH_ON%Witaj, kapitanie i, ee, anatomisto? Mistrzu zwlok? Ten typ byl morderca. I wscibialski, wscibal sie w moje...ee...sprawy.%SPEECH_OFF%Upuszcza cialo na ziemie i zaczyna zdejmowac plaszcz, ujawniajac, ze rzekomy skryba byl dobrze uzbrojony i opancerzony. Zabojca odcina jedno ucho i chowa je, po czym kiwa glowa.%SPEECH_ON%Hej, wyglada na to, ze mamy darmowy sprzet, co? Ale chyba powinnismy ukryc cialo. Ten gosc robil wrazenie eminencji i niektorzy moga uznac jego brak za wart sprawdzenia.%SPEECH_OFF%Nie wiesz, komu ani czemu wierzyc w tej sprawie, ale martwe cialo krwawiace na twoje buty zawsze wyglada zle, niezaleznie od okolicznosci. Ukrywasz cialo, oczywiscie po uprzednim ograbieniu go ze sprzetu. %anatomist% wydaje sie nieufny wobec %killer%. Wspomina, ze ton glosu zabojcy brzmial jak natychmiast zrodzona hipoteza albo, jak to ujmuje pospolity czlowiek, "udawanie". Skoro juz sie stalo, mowisz mu tylko, by pomogl zaniesc sprzet do ekwipunku.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Jest tym, czym rzekomo jest.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				_event.m.Anatomist.worsenMood(0.75, "Byl swiadkiem brutalnego morderstwa");

				if (_event.m.Anatomist.getMoodState() < this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Anatomist.getMoodState()],
						text = _event.m.Anatomist.getName() + this.Const.MoodStateEvent[_event.m.Anatomist.getMoodState()]
					});
				}

				local attackBoost = this.Math.rand(1, 3);
				local resolveBoost = this.Math.rand(1, 3);
				_event.m.Killer.getBaseProperties().MeleeSkill += attackBoost;
				_event.m.Killer.getBaseProperties().Bravery += resolveBoost;
				_event.m.Killer.getSkills().update();
				this.List.push({
					id = 16,
					icon = "ui/icons/melee_skill.png",
					text = _event.m.Killer.getName() + " zyskuje [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + attackBoost + "[/color] Umiejetnosci Walki"
				});
				this.List.push({
					id = 16,
					icon = "ui/icons/bravery.png",
					text = _event.m.Killer.getName() + " zyskuje [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + resolveBoost + "[/color] Determinacji"
				});
				local armors = [
					"armor/padded_leather",
					"armor/patched_mail_shirt",
					"armor/leather_lamellar"
				];
				local weapons = [
					"weapons/dagger",
					"weapons/dagger",
					"weapons/dagger",
					"weapons/rondel_dagger"
				];
				local armor = this.new("scripts/items/" + armors[this.Math.rand(0, armors.len() - 1)]);
				armor.setCondition(this.Math.max(1, armor.getConditionMax() * this.Math.rand(10, 40) * 0.01));
				this.World.Assets.getStash().add(armor);
				this.List.push({
					id = 10,
					icon = "ui/items/" + armor.getIcon(),
					text = "Zyskujesz " + armor.getName()
				});
				local weapon = this.new("scripts/items/" + weapons[this.Math.rand(0, weapons.len() - 1)]);
				weapon.setCondition(this.Math.max(1, weapon.getConditionMax() * this.Math.rand(10, 40) * 0.01));
				this.World.Assets.getStash().add(weapon);
				this.List.push({
					id = 10,
					icon = "ui/items/" + weapon.getIcon(),
					text = "Zyskujesz " + weapon.getName()
				});
				this.Characters.push(_event.m.Anatomist.getImagePath());
				this.Characters.push(_event.m.Killer.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "G",
			Text = "[img]gfx/ui/events/event_31.png[/img]{Mowisz, ze sytuacja jest zbyt podejrzana, by ryzykowac. %anatomist% twierdzi, ze wszelka wiedza wydaje sie podejrzana pospolstwu. Mowisz mu, ze ten "pospolity" zna sie na tyle, by wyczuc szczura, i na tym koniec. Anatomista jest zdenerwowany, ale wolisz, by byl poirytowany niz martwy.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Lepiej sie ogarnij, madralo.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				_event.m.Anatomist.worsenMood(1.0, "Odmowiono mu okazji do badan");

				if (_event.m.Anatomist.getMoodState() < this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Anatomist.getMoodState()],
						text = _event.m.Anatomist.getName() + this.Const.MoodStateEvent[_event.m.Anatomist.getMoodState()]
					});
				}

				this.Characters.push(_event.m.Anatomist.getImagePath());
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

		local towns = this.World.EntityManager.getSettlements();
		local nearTown = false;
		local town;
		local playerTile = this.World.State.getPlayer().getTile();

		foreach( t in towns )
		{
			if (t.isSouthern() || t.isMilitary() || t.getSize() < 2)
			{
				continue;
			}

			if (t.getTile().getDistanceTo(playerTile) <= 3 && t.isAlliedWithPlayer())
			{
				nearTown = true;
				town = t;
				break;
			}
		}

		if (!nearTown)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local anatomistCandidates = [];
		local minstrelCandidates = [];
		local killerCandidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.anatomist")
			{
				anatomistCandidates.push(bro);
			}
			else if (bro.getBackground().getID() == "background.minstrel")
			{
				minstrelCandidates.push(bro);
			}
			else if (bro.getBackground().getID() == "background.killer_on_the_run")
			{
				killerCandidates.push(bro);
			}
		}

		if (minstrelCandidates.len() > 0 && this.World.getPlayerRoster().getSize() < this.World.Assets.getBrothersMax())
		{
			this.m.Minstrel = minstrelCandidates[this.Math.rand(0, minstrelCandidates.len() - 1)];
		}

		if (killerCandidates.len() > 0)
		{
			this.m.Killer = killerCandidates[this.Math.rand(0, killerCandidates.len() - 1)];
		}

		if (anatomistCandidates.len() == 0)
		{
			return;
		}

		this.m.Anatomist = anatomistCandidates[this.Math.rand(0, anatomistCandidates.len() - 1)];
		this.m.Town = town;
		this.m.Score = 10;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"anatomist",
			this.m.Anatomist.getNameOnly()
		]);
		_vars.push([
			"minstrel",
			this.m.Minstrel != null ? this.m.Minstrel.getNameOnly() : ""
		]);
		_vars.push([
			"killer",
			this.m.Killer != null ? this.m.Killer.getName() : ""
		]);
		_vars.push([
			"fakescribe",
			this.m.Dude != null ? this.m.Dude.getNameOnly() : ""
		]);
		_vars.push([
			"townname",
			this.m.Town.getName()
		]);
	}

	function onClear()
	{
		this.m.Anatomist = null;
		this.m.Dude = null;
		this.m.Minstrel = null;
		this.m.Killer = null;
		this.m.Town = null;
	}

});

