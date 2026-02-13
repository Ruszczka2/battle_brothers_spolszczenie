this.sunken_library_enter_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.location.sunken_library_enter";
		this.m.Title = "Gdy się zbliżasz...";
		this.m.Cooldown = 999999.0 * this.World.getTime().SecondsPerDay;
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_173.png[/img]{Blask i połysk są tak jasne, że niemal myślisz, iż sam Gilder zarządził ci właściwą wizytę - niestety lub na szczęście, natknąłeś się na wielką, pozłacaną kopułę, która tylko nieznacznie wystaje z piasków. Od razu sprawdzasz, czy da się odłupać trochę złota, ale nie ustępuje. %randombrother% woła cię do kamiennej płyty z przerwą. Może kiedyś była tu dzwonnica? Światło szybko gaśnie i niewiele widać w środku. Nad wejściem relief przedstawia ludzi ciągnących wozy pełne zwojów.\n\n Na reliefie wielokrotnie wyryto słowa. Żaden z języków nie przypomina niczego, co kiedykolwiek słyszałeś lub widziałeś. Dopiero po chwili znajdujesz pospiesznie wyrytą translację pozostawioną przez kogoś z twojej epoki: \'Biblioteka, Labirynt Nocy, Labirynt Umysłu, Odejdziesz stąd jak ze Snu, Kroczyć będziesz jak we Śnie, Odejdź, by rozmyślać nad Grozą Niewiedzy, Wejdź, by stać się Jednym z Poznaniem, i w Poznaniu Snów poznaj Koszmar\'.%SPEECH_ON%Dość złowieszcze, kapitanie, ale jeśli chcesz tam zejść, mamy liny i pochodnie.%SPEECH_OFF%%randombrother% mówi ci to, a wyraz jego twarzy sugeruje, że liczy, iż odmówisz.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Zjazd na linach w mrok!",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "Nie zakłócajmy spoczynku tego miejsca.",
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
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_89.png[/img]{Zejście jest niebezpieczne, mrok tak gęsty, że nie widzisz nawet własnych butów. W końcu jednak stajesz na marmurowej posadzce i szybko zapalasz pochodnie. Znajdujesz się w ogromnej hali, wokół której spiralnie wznoszą się rzędy i rzędy regałów. Każda półka zastawiona jest stertami zwojów, wiele z nich zamknięto w szklanych gablotach. Regały piętrzą się jedne na drugich i zdają się sięgać aż do sufitu, z którego zszedłeś. Na każdym poziomie stoją przesuwne drabiny, a jeszcze wyżej ciągnie się unosząca antresola z metalowymi zsypami tu i ówdzie. Wygląda na to, że kiedyś przenoszono nimi zwoje w górę i w dół, ale teraz wszystko jest zardzewiałe, a antresola miejscami zawaliła się.\n\n %randombrother% zwraca twoją uwagę. Wskazuje ogromny zwój spłaszczony za taflą szkła. Rysunki rozlewają się po papierze i po bliższym przyjrzeniu się widać, że to projekty wszystkiego: ludzkiego ciała, ciał wielu zwierząt, zamków, wież, wiatraków, statków, broni i zbroi, butów i rękawic, układów gwiazd oraz niezliczonych rzeczy, których nigdy wcześniej nie widziałeś, rzeczy pozbawionych sensu.%SPEECH_ON%Kapitanie, to miejsce nie jest dla nas. Te języki, te sale, powinniśmy iść.%SPEECH_OFF%Jeden z najemników wyraża nastroje unoszące się w powietrzu. Bezwzględnie wtargnąłeś do miejsca, w którym było niewielu. A jeśli byli tu wcześniej, to gdzie są? Takie miejsce nie może przecież pozostać ukryte, prawda?}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Co to był za dźwięk?",
					function getResult( _event )
					{
						return "C";
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_89.png[/img]{%SPEECH_START%Intruzi w Bibliotece.%SPEECH_OFF%Głos skrobie po marmurowej posadzce, wznosi się ku twoim uszom i trwa dalej, a słowo \'Bibliotekaaa\' wślizguje się w mrok za twoimi plecami. Nagle kilka szklanych gablot zaczyna jarzyć się, filakterie trzymają jakieś eteryczne energie, a gdy światło się rozszerza, odsłania tors czarnego szkieletu, którego ciało zawisło w powietrzu. Klatka piersiowa trzyma księgę, zahaczoną w miejscu chorymi fałdami własnych żeber, jak pająk ściska zdobycz. Czaszka stworzenia wpatruje się w ciebie pustymi, bezdennymi oczodołami.%SPEECH_ON%Twój rodzaj już mnie okradał, a teraz śmiesz znów profanować te sale?%SPEECH_OFF%Filakterie świecą jaśniej, a wraz z nimi tors szkieletu obrasta mięsem, pnącza żył i miazga skóry rozkwitają, by okryć kości. Ale tylko tors zostaje spowity. Wpatrujesz się w filakterie, które teraz aż kipią energią, i widzisz, jak widmowe twarze rozmazują się po szkle niczym smugi deszczu. Słyszysz głośne klaśnięcie i odwracasz się, by ujrzeć Mistrza Wiedzy w pełni, z oczami w białym ogniu, z chudymi kończynami oplecionymi dymnymi mięśniami, a dolna połowa jego ciała plumi czarnym popiołem, gdy sunie naprzód. Im jaśniej świecą szklane bańki, tym staje się silniejszy i szybszy!}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Walczcie o życie! Walczcie jak nigdy dotąd!",
					function getResult( _event )
					{
						if (this.World.State.getLastLocation() != null)
						{
							this.World.State.getLastLocation().setVisited(false);
						}

						local p = this.Const.Tactical.CombatInfo.getClone();
						p.LocationTemplate = clone this.Const.Tactical.LocationTemplate;
						p.CombatID = "SunkenLibrary";
						p.TerrainTemplate = "tactical.sinkhole";
						p.LocationTemplate.Template[0] = "tactical.sunken_library";
						p.Music = this.Const.Music.UndeadTracks;
						p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.LineBack;
						p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Center;
						p.IsWithoutAmbience = true;
						p.Entities = [];

						for( local i = 0; i < 4; i = ++i )
						{
							p.Entities.push(clone this.Const.World.Spawn.Troops.SkeletonHeavyBodyguard);
						}

						local f = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Undead).getID();

						for( local i = 0; i < p.Entities.len(); i = ++i )
						{
							p.Entities[i].Faction <- f;
						}

						p.BeforeDeploymentCallback = function ()
						{
							local phylacteries = 10;
							local phylactery_tiles = [];

							do
							{
								local x = this.Math.rand(10, 28);
								local y = this.Math.rand(4, 28);
								local tile = this.Tactical.getTileSquare(x, y);

								if (!tile.IsEmpty)
								{
								}
								else
								{
									local skip = false;

									foreach( t in phylactery_tiles )
									{
										if (t.getDistanceTo(tile) <= 5)
										{
											skip = true;
											break;
										}
									}

									if (skip)
									{
									}
									else
									{
										local e = this.Tactical.spawnEntity("scripts/entity/tactical/enemies/phylactery", tile.Coords);
										e.setFaction(f);
										phylacteries = --phylacteries;
										phylactery_tiles.push(tile);
									}
								}
							}
							while (phylacteries > 0);

							local toRise = 5;

							do
							{
								local r = this.Math.rand(0, phylactery_tiles.len() - 1);
								local p = phylactery_tiles[r];

								if (p.SquareCoords.X > 14)
								{
									p.Level = 3;
									toRise = --toRise;
								}

								phylactery_tiles.remove(r);
							}
							while (toRise > 0 && phylactery_tiles.len() > 0);

							local lich = 1;

							do
							{
								local x = this.Math.rand(9, 10);
								local y = this.Math.rand(15, 17);
								local tile = this.Tactical.getTileSquare(x, y);

								if (!tile.IsEmpty)
								{
								}
								else
								{
									local e = this.Tactical.spawnEntity("scripts/entity/tactical/enemies/skeleton_lich", tile.Coords);
									e.setFaction(f);
									e.assignRandomEquipment();
									lich = --lich;
								}
							}
							while (lich > 0);

							local treasureHunters = 3;

							do
							{
								local x = this.Math.rand(9, 11);
								local y = this.Math.rand(11, 21);
								local tile = this.Tactical.getTileSquare(x, y);

								if (!tile.IsEmpty)
								{
								}
								else
								{
									local e = this.Tactical.spawnEntity("scripts/entity/tactical/enemies/zombie_treasure_hunter", tile.Coords);
									e.setFaction(f);
									e.assignRandomEquipment();
									local item = e.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand);
									item.setCondition(this.Math.rand(item.getConditionMax() / 2, item.getConditionMax()));
									treasureHunters = --treasureHunters;
								}
							}
							while (treasureHunters > 0);

							local heavy = 4;

							do
							{
								local x = this.Math.rand(9, 14);
								local y = this.Math.rand(8, 20);
								local tile = this.Tactical.getTileSquare(x, y);

								if (!tile.IsEmpty)
								{
								}
								else
								{
									local e = this.Tactical.spawnEntity("scripts/entity/tactical/enemies/skeleton_heavy", tile.Coords);
									e.setFaction(f);
									e.assignRandomEquipment();
									local item = e.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand);
									item.setCondition(this.Math.rand(item.getConditionMax() / 2, item.getConditionMax()));
									heavy = --heavy;
								}
							}
							while (heavy > 0);

							local heavy_polearm = 4;

							do
							{
								local x = this.Math.rand(12, 14);
								local y = this.Math.rand(12, 26);
								local tile = this.Tactical.getTileSquare(x, y);

								if (!tile.IsEmpty)
								{
								}
								else
								{
									local e = this.Tactical.spawnEntity("scripts/entity/tactical/enemies/skeleton_heavy_polearm", tile.Coords);
									e.setFaction(f);
									e.assignRandomEquipment();
									local item = e.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand);
									item.setCondition(this.Math.rand(item.getConditionMax() / 2, item.getConditionMax()));
									heavy_polearm = --heavy_polearm;
								}
							}
							while (heavy_polearm > 0);
						};
						p.AfterDeploymentCallback = function ()
						{
							this.Tactical.getWeather().setAmbientLightingPreset(5);
							this.Tactical.getWeather().setAmbientLightingSaturation(0.9);
						};
						_event.registerToShowAfterCombat("Victory", "Defeat");
						this.World.State.startScriptedCombat(p, false, false, false);
						return 0;
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "Victory",
			Text = "[img]gfx/ui/events/event_89.png[/img]{Opiekun Wiedzy zapada się na ziemię w stertę popiołu, a filakterie powoli gasną. Podchodzisz z pochodnią w dłoni. Jego czarna czaszka spoczywa na księdze, która niegdyś tkwiła w jego piersi.%SPEECH_ON%Kapitanie, nie sądzę, żebyśmy powinni tu cokolwiek dotykać.%SPEECH_OFF%Ignorujesz jednego z ludzi i podnosisz księgę. Jej skórzana okładka jest zszyta, a gdy przyglądasz się bliżej, widzisz, że okładkę obejmuje skóra uszu i nosów. Natychmiast kości zabitych nieumarłych zgrzytają po marmurowej posadzce. Jedna przemyka między twoimi nogami i wpada w stertę popiołu. W oczodole czaszki zapala się tępy biały ogień. To więcej niż dość: szybkim rozkazem każesz ludziom wspinać się z powrotem po linie, a sam wychodzisz jako ostatni. Gdy zbliżasz się do światła ziemi na górze, na chwilę spoglądasz w dół - czarna czaszka jest już przed twoją twarzą! Unosi się sama, z oczami płonącymi na biało, chwytając twój wzrok w stożek ognia, którego nie potrafisz pojąć, i gdy wpatrujesz się w nią, słyszysz, jak głosy twoich ludzi cichną. Czaszka unosi się samotnie, a ty niemal czujesz chęć puszczenia liny. Czaszka przemawia do twojego umysłu:%SPEECH_ON%To tylko jeden z jego darów, Przybyszu, i nie jesteś pierwszym, który go ma. Wielu go wzięło, a wśród wielu jest tylko jedno zakończenie, ten, który czeka na nas wszystkich!%SPEECH_OFF%Ogień czaszki gaśnie, a ona opada w mrok, skąd słychać krótkie grzechnięcie. Głosy twoich ludzi wracają, głośniejsze niż kiedykolwiek, i widzisz dłoń %randombrother%. Chwytają cię i wyciągają. Gdy wychodzisz, wejście zapada się w piasek, a jedyne, co masz z tego miejsca, to dziwna, cielesna księga pełna zapisków, których nigdy nie zdołasz odczytać.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Co właśnie zabrałem?",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				_event.m.Title = "Po bitwie...";

				if (this.World.State.getLastLocation() != null)
				{
					this.World.State.getLastLocation().die();
				}

				this.World.Assets.getStash().makeEmptySlots(1);
				local item = this.new("scripts/items/special/black_book_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Zdobywasz " + item.getName()
				});
				this.World.Flags.set("IsLorekeeperDefeated", true);
				this.updateAchievement("Lorekeeper", 1, 1);
			}

		});
		this.m.Screens.push({
			ID = "Defeat",
			Text = "[img]gfx/ui/events/event_173.png[/img]Ludzie uciekają i pospiesznie wspinają się z powrotem.%SPEECH_ON%Może innym razem?%SPEECH_OFF%Mówi jeden z najemników. %randombrother% przytakuje.%SPEECH_ON%Innym razem, tak. Może za dawno, gdy będę na emeryturze i będę pieprzył kurwy, wtedy wy możecie zjechać w ciemność i hasać z martwymi czarodziejami. Pasuje wam taki termin?%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Może pewnego dnia...",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				_event.m.Title = "Po bitwie...";

				if (this.World.State.getLastLocation() != null)
				{
					this.World.State.getLastLocation().setVisited(false);
				}
			}

		});
	}

	function onUpdateScore()
	{
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
	}

	function onClear()
	{
	}

});

