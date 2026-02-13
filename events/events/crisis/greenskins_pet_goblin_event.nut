this.greenskins_pet_goblin_event <- this.inherit("scripts/events/event", {
	m = {
		HurtBro = null
	},
	function create()
	{
		this.m.ID = "event.crisis.greenskins_pet_goblin";
		this.m.Title = "Po drodze...";
		this.m.Cooldown = 80.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_25.png[/img]Idąc przez las, trafiasz na polanę, na której stoi mała chatka. Na ścianach wiszą pułapki na niedźwiedzie, z okapu zwisają skóry wiewiórek, a okna mają w rogach mokre liście. Na werandzie siedzi stary mężczyzna, kołysząc się na krześle. Celuje w ciebie z kuszy.%SPEECH_ON%To moja własność.%SPEECH_OFF%Od ramienia jego krzesła do klapki na dole drzwi chaty ciągnie się łańcuch. Porusza się lekko, gdy mężczyzna mówi, a on odwraca się i uderza kuszą w drzwi.%SPEECH_ON%Cicho, ty! A wy, człowieku z mieczem, i wszyscy twoi kumple, zmykajcie. Jeszcze jeden krok w złą stronę, a to będzie moja strona, i wsadzę ci bełt w dupę.%SPEECH_OFF%%randombrother% podchodzi do ciebie.%SPEECH_ON%Co robimy, panie?%SPEECH_OFF%",
			Banner = "",
			Characters = [],
			Options = [
				{
					Text = "Przyjrzyjmy się bliżej.",
					function getResult( _event )
					{
						if (this.Math.rand(1, 100) <= 50)
						{
							return "C";
						}
						else
						{
							return "D";
						}
					}

				},
				{
					Text = "Nie mamy czasu na wariatów.",
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
			Text = "[img]gfx/ui/events/event_25.png[/img]Nie masz powodu, by dalej zakłócać dzień tego starca, więc mówisz kompanom, by omijali go szerokim łukiem wraz z jego chatą. Starzec patrzy na ciebie podejrzliwie na każdym kroku.%SPEECH_ON%Mhm, miejcie dobry dzień.%SPEECH_OFF%Kiwasz głową i odpowiadasz.%SPEECH_ON%Tak, wy też.%SPEECH_OFF%Łańcuch znów się porusza i spotyka się z kolejnym uciszaniem. Kto wie, co tu się do cholery działo, ale kompania ma dokąd iść.",
			Banner = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "Miłego dnia.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_25.png[/img]Robisz krok do przodu. Starzec zrywa się z krzesła i spluwa.%SPEECH_ON%Skurwysynu.%SPEECH_OFF%Unosi kuszę i strzela z biodra. Bełt mija cel i wpada w drzewa, stukając i trzaskając o gałęzie i krzewy. %randombrother% rzuca się na werandę i powala mężczyznę na ziemię.%SPEECH_ON%Zabierz te swoje rozpustne łapy ode mnie, ty, ty, ty rozpustniku!%SPEECH_OFF%Gdy mężczyzna pluje i kopie, spokojnie podchodzisz do werandy i otwierasz drzwi jego chaty. Łańcuch śmiga po deskach i napina się. Ciemny kształt cofa się w róg, wspinając się po ścianach, próbując uciec dalej, niż pozwalają kajdany. Bierzesz pochodnię i świecisz nią w ciemność. Tam widzisz więźnia. Starzec krzyczy z werandy.%SPEECH_ON%Zostaw nas w spokoju! No już, zostaw nas w spokoju!%SPEECH_OFF%Tam, kurcząc się przed twoją pochodnią, jest goblin.",
			Banner = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "Czemu trzymasz goblina skuty łańcuchem?",
					function getResult( _event )
					{
						return "F";
					}

				},
				{
					Text = "Lepiej zabić to teraz.",
					function getResult( _event )
					{
						return "E";
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_25.png[/img]Robisz krok do przodu. Starzec zrywa się z krzesła i spluwa.%SPEECH_ON%Skurczybyki, ostrzegałem was! Ostrzegałem wyraźnie!%SPEECH_OFF%Unosi kuszę i strzela z biodra. Bełt przelatuje nad twoim ramieniem i przebija na wylot ramię %hurtbro%. Najemnik spogląda w dół, pióra bełtu drżą z jednej strony rany, a zakrwawiony drzewiec z drugiej. Siada.%SPEECH_ON%No to do diabła.%SPEECH_OFF%%randombrother% krzyczy i rzuca się do przodu. Gdy starzec próbuje przeładować, najemnik kopie kuszę na bok i powala strzelca na ziemię. Mówisz najemnikowi, by utrzymał mężczyznę przy życiu. Gdy mężczyzna pluje i kopie, spokojnie podchodzisz do werandy i otwierasz drzwi jego chaty. Gdy drzwi się otwierają, łańcuch śmiga po deskach i napina się. Ciemny kształt cofa się w róg, wspinając się po ścianach, próbując uciec dalej, niż pozwalają kajdany. Bierzesz pochodnię i świecisz nią w ciemność. Tam widzisz więźnia. Starzec krzyczy z werandy.%SPEECH_ON%Zostaw nas w spokoju! No już, zostaw nas w spokoju!%SPEECH_OFF%Tam, kurcząc się przed twoją pochodnią, jest goblin.",
			Banner = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "Czemu trzymasz goblina skuty łańcuchem?",
					function getResult( _event )
					{
						return "F";
					}

				},
				{
					Text = "Lepiej zabić to teraz.",
					function getResult( _event )
					{
						return "E";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.HurtBro.getImagePath());
				local injury = _event.m.HurtBro.addInjury(this.Const.Injury.PiercedArm);
				this.List = [
					{
						id = 10,
						icon = injury.getIcon(),
						text = _event.m.HurtBro.getName() + " cierpi na " + injury.getNameOnly()
					}
				];
			}

		});
		this.m.Screens.push({
			ID = "E",
			Text = "[img]gfx/ui/events/event_25.png[/img]Dobywasz miecza i wchodzisz do chaty. Starzec woła do ciebie. Cała groźba i zadziorność zniknęły. Prawie maniakalnie błaga cię, byś nie skrzywdził goblina. Ale robisz właśnie to, wbijając ostrze w pierś zielonoskórego. Miota się na metalu, chwytając go śliskimi, obrzydliwymi palcami. Uścisk słabnie, gdy światło gaśnie w jego oczach. Wyciągasz ostrze i wycierasz krew o spodnie. Jakby żal obdarzył go niewidzialną siłą, starzec krzyczy i zdoła wstać na nogi. Wyciąga sztylet i rusza na ciebie, ale %randombrother% powstrzymuje go własnym sztyletem, wbijając ostrze tuż pod jego piersią. Krew tryska na rękojeść, gdy serce bije po raz ostatni. Kolana starca uginają się i osuwa się w dół, chwytając ramiona swojego zabójcy.%SPEECH_ON%Okrutne stworzenia... okrutne...%SPEECH_OFF%Pada na podłogę. Mówisz kompaniom, by przeszukali chatę i zabrali, co się da.",
			Banner = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "Spoczywaj w pokoju, pustelniku.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.Assets.addMoralReputation(-1);
				local item = this.new("scripts/items/weapons/light_crossbow");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Zyskujesz " + item.getName()
				});
				item = this.new("scripts/items/weapons/dagger");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Zyskujesz " + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
				item = this.new("scripts/items/supplies/roots_and_berries_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Zyskujesz " + item.getName()
				});
			}

		});
		this.m.Screens.push({
			ID = "F",
			Text = "[img]gfx/ui/events/event_25.png[/img]Nie spuszczając goblina z oczu, pytasz mężczyznę, dlaczego trzyma zielonoskórego związanego w chacie. Pustelnik szlocha w deski podłogi.%SPEECH_ON%To mój przyjaciel! Jedyny przyjaciel!%SPEECH_OFF%",
			Banner = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "Oszalałeś, pustelniku. Oszalałeś!",
					function getResult( _event )
					{
						return "G";
					}

				},
				{
					Text = "Kto trzyma przyjaciela na łańcuchu?",
					function getResult( _event )
					{
						return "H";
					}

				},
				{
					Text = "Ten goblin tylko się uwolni i doniesie swoim prawdziwym przyjaciołom!",
					function getResult( _event )
					{
						return "I";
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "G",
			Text = "[img]gfx/ui/events/event_25.png[/img]Wycofujesz się z chaty i kucasz przed starcem. Wije się i błaga.%SPEECH_ON%Proszę, nie zabijaj go!%SPEECH_OFF%Mężczyzna oszalał i mówisz mu to wprost. Szlocha w deski werandy, a jego oddech pyli trociny w powietrzu. W końcu uspokaja oddech i się wycisza.%SPEECH_ON%Masz rację. Nie mam wszystkiego poukładanego w głowie. Znalazłem goblina w potrzasku kilka dni temu i go przygarnąłem, wyleczyłem. Nie mam tu towarzystwa. Człowiekowi robi się samotnie, rozumiesz.%SPEECH_OFF%Podnosisz kuszę, przeładowujesz ją, a potem podajesz starcowi.%SPEECH_ON%Dasz radę?%SPEECH_OFF%Starzec wpatruje się w kuszę. Kilka razy mruga i kiwa głową. Twoi najemnicy pomagają mu wstać. Bierze kuszę i wchodzi do chaty. Cel ma niepewny, a pod nosem mamrocze przeprosiny. Goblin zwija się w kłębek, zasłaniając się chorymi dłońmi.%SPEECH_ON%Bardzo przepraszam. Tak bardzo przepraszam.%SPEECH_OFF%Starzec przygotowuje spust kuszy, przesuwa palec po języku spustowym, po czym przykłada bełt pod brodę i strzela. Osuwa się na podłogę, strzał brzęczy, gdy uderza w sufit, a z piór kapie skąpa krew. Kręcisz głową, wchodzisz do chaty i sam dobijasz goblina. Po wszystkim mówisz ludziom, by przeszukali chatę i zabrali, co się da.",
			Banner = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "Do diabła.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local item = this.new("scripts/items/weapons/light_crossbow");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Zyskujesz " + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
				item = this.new("scripts/items/supplies/roots_and_berries_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Zyskujesz " + item.getName()
				});
			}

		});
		this.m.Screens.push({
			ID = "H",
			Text = "[img]gfx/ui/events/event_25.png[/img]Ostrożnie wracasz do starca. Podnosisz łańcuch i szarpiesz nim, pytając.%SPEECH_ON%Przyjaciela trzymasz w kajdanach? Gdyby był prawdziwym przyjacielem, nie potrzebowałbyś łańcuchów, co?%SPEECH_OFF%Pustelnik wzrusza ramionami.%SPEECH_ON%Masz rację. Pozwól mi, a udowodnię, że to prawdziwy przyjaciel.%SPEECH_OFF%Pomagasz mu wstać i każesz mu to 'udowodnić'. Otrzepuje kurz z ubrań i wchodzi do chaty. Łańcuch luzuje się trochę, gdy goblin robi krok od włazu. Kucając przed zielonoskórym, pustelnik wyciąga rękę.%SPEECH_ON%Hej, kolego.%SPEECH_OFF%Gdy sięga, by odpiąć kajdany, goblin warczy i rzuca się do przodu, wbijając zęby w twarz mężczyzny. Wpadasz do chaty i odkopujesz goblina. Ten ląduje w rogu, z mięsem i krwią zwisającymi z warg. %randombrother% przebija twarz stworzenia mieczem. Starzec krzyczy, jego twarz to obraz rzezi.%SPEECH_ON%Miałeś rację, wiedziałem to, ale moje serce... tak bardzo boli.%SPEECH_OFF%Gdy przyglądasz się uważniej, widzisz teraz sączącą się karminową przepaść tam, gdzie powinien być nos. Pustelnik zwija się w kłębek i wskazuje na drugi koniec chaty.%SPEECH_ON%Pod deskami, tam, gdzie kurz jest ruszony. Nie jest mi już potrzebne.%SPEECH_OFF%Kiwasz głową i mówisz %randombrother%, by opatrzył mężczyznę. Reszta kompanii zaczyna zrywać deski, by zajrzeć pod podłogę. Po zabraniu tego, co potrzebne, mówisz ludziom, że czas ruszać. Pustelnik wraca do swojego bujanego krzesła i siada. Ma dłonie oparte grzbietami na kolanach, krew spływa po palcach, a z rany kapie więcej krwi, która na pewno się zakaże. Słyszysz, jak krew dławi go przy każdym oddechu.%SPEECH_ON%Powinienem był się ukryć. Zawsze tak robię. Czemu się nie ukryłem?%SPEECH_OFF%",
			Banner = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "Spokojnie.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				if (this.World.Assets.getMedicine() >= 2)
				{
					this.World.Assets.addMedicine(-2);
					this.List.push({
						id = 10,
						icon = "ui/icons/asset_medicine.png",
						text = "Tracisz [color=" + this.Const.UI.Color.NegativeEventValue + "]-2[/color] Zapasy medyczne."
					});
				}

				local r = this.Math.rand(1, 4);
				local item;

				if (r == 1)
				{
					item = this.new("scripts/items/weapons/named/named_axe");
				}
				else if (r == 2)
				{
					item = this.new("scripts/items/weapons/named/named_spear");
				}
				else if (r == 3)
				{
					item = this.new("scripts/items/helmets/named/wolf_helmet");
				}
				else if (r == 4)
				{
					item = this.new("scripts/items/armor/named/black_leather_armor");
				}

				this.World.Assets.getStash().makeEmptySlots(1);
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Zyskujesz " + item.getName()
				});
			}

		});
		this.m.Screens.push({
			ID = "I",
			Text = "[img]gfx/ui/events/event_25.png[/img]Cofasz się z chaty i krzyczysz na mężczyznę.%SPEECH_ON%Co do starych piekieł myślisz, że robisz? Jeśli to coś się uwolni, pobiegnie do najbliższego obozu zielonoskórych i ściągnie ich gniew na tę ziemię!%SPEECH_OFF%Starzec kiwa głową w stronę łańcucha.%SPEECH_ON%Mój bardzo dobry przyjaciel jest całkiem bezpieczny, nieznajomy, nie powinieneś się martwić. Nic nie wiesz o tym, kim jest i jaki ma charakter!%SPEECH_OFF%Uderzasz mężczyznę pięścią i kucasz nisko, by dobrze cię słyszał.%SPEECH_ON%To nie jest twój przyjaciel. To zagrożenie.%SPEECH_OFF%Kiwasz do %randombrother%, który natychmiast wchodzi do chaty i zabija goblina szybkim pchnięciem. Starzec krzyczy, krew już krzepnie mu między zębami jak karminowe strupy.%SPEECH_ON%Dlaczego? Co on ci zrobił? Nie masz honoru, by zabić taką istotę?%SPEECH_OFF%Kręcisz głową na szaleńca i każesz reszcie kompanii rozproszyć się i szukać przedmiotów. Gdy skończą, zostawiasz starca w jego chacie i martwego przyjaciela.",
			Banner = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "Co za szaleniec.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local item = this.new("scripts/items/weapons/light_crossbow");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Zyskujesz " + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
				item = this.new("scripts/items/weapons/knife");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Zyskujesz " + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
				item = this.new("scripts/items/supplies/roots_and_berries_item");
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
		if (!this.World.FactionManager.isGreenskinInvasion())
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();

		if (currentTile.Type != this.Const.World.TerrainType.Forest && currentTile.Type != this.Const.World.TerrainType.LeaveForest && currentTile.Type != this.Const.World.TerrainType.AutumnForest)
		{
			return;
		}

		local towns = this.World.EntityManager.getSettlements();
		local playerTile = this.World.State.getPlayer().getTile();

		foreach( t in towns )
		{
			local d = playerTile.getDistanceTo(t.getTile());

			if (d <= 5)
			{
				return;
			}
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local candidates = [];

		foreach( bro in brothers )
		{
			if (!bro.getSkills().hasSkillOfType(this.Const.SkillType.TemporaryInjury))
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() == 0)
		{
			return;
		}

		this.m.HurtBro = candidates[this.Math.rand(0, candidates.len() - 1)];
		this.m.Score = 10;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"hurtbro",
			this.m.HurtBro.getName()
		]);
	}

	function onClear()
	{
		this.m.HurtBro = null;
	}

});

