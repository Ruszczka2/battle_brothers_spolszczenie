this.historian_mysterious_text_event <- this.inherit("scripts/events/event", {
	m = {
		Historian = null
	},
	function create()
	{
		this.m.ID = "event.historian_mysterious_text";
		this.m.Title = "Po drodze...";
		this.m.Cooldown = 99999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_57.png[/img]Napotykasz opuszczoną kaplicę. Pajęczyny oblepiają jej pęknięcia, a w rogach tkwią ptasie gniazda. Ławy są przewrócone lub porąbane na opał. Starzy bogowie z pewnością opuścili to miejsce.\n\n %historian%, historyk, podchodzi do ciebie z tym, co wygląda jak zabłocone kłody, w dłoniach.%SPEECH_ON%Spójrz tylko na to! Stare zapisy!%SPEECH_OFF%Zdmuchuje sczerniały pył i popiół ze zwojów.%SPEECH_ON%Czy widziałeś kiedyś coś tak niezwykłego? Jeszcze nie wiem, co tam jest napisane, ale to i tak niesłychanie interesujące znalezisko!%SPEECH_OFF%Dobrze, nieważne.",
			Image = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "Po prostu przeczytaj i powiedz, co tam jest.",
					function getResult( _event )
					{
						if (this.Math.rand(1, 100) <= 50)
						{
							return "B";
						}
						else
						{
							return "C";
						}
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Historian.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_15.png[/img]Gdy rozbijacie obóz na zewnątrz świątyni, %historian%, historyk, wchodzi do twojego namiotu.%SPEECH_ON%Panie, myślę, że to może pana zainteresować.%SPEECH_OFF%Ma w ramionach zwoje z kaplicy i rozkłada kilka z nich na twoim stole. Widzisz tam niechlujne bazgroły historyka. Jego notatki są w języku, którego nie potrafisz czytać, ale łatwo śledzisz strzałki, którymi połączył fragmenty. Potem rozwija kolejny zwój, świeży, z pełnymi tłumaczeniami.%SPEECH_ON%To stare podręczniki treningowe. Mówią o technikach, o których nie wiedziałem, że istnieją. Rozprowadzić je wśród ludzi?%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Rozdaj je.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Historian.getImagePath());
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					bro.getBaseProperties().RangedDefense += 1;
					bro.getSkills().update();
					this.List.push({
						id = 16,
						icon = "ui/icons/ranged_defense.png",
						text = bro.getName() + " zyskuje [color=" + this.Const.UI.Color.PositiveEventValue + "]+1[/color] Obrony Dystansowej"
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_15.png[/img]Gdy siedzisz w namiocie obok opuszczonej świątyni, %historian%, historyk, wchodzi w sposób, który najlepiej opisać jako niechętny. W dłoniach trzyma zwoje znalezione w kaplicy kilka dni temu.%SPEECH_ON%Panie, eee, te zwoje... były bardzo interesujące.%SPEECH_OFF%Znudzony pytasz, jak bardzo interesujące. Mężczyzna wyjaśnia.%SPEECH_ON%Cóż, zapisano je w bardzo starożytnym języku. Nie jestem w nim biegły, ale mogę czytać fragmenty tu i tam.%SPEECH_OFF%Pytasz go, czego w takim razie chce.%SPEECH_ON%Chciałbym odczytać zwoje, ale przydałoby mi się trochę pewności, zanim to zrobię. Czy zaszczyciłbyś odczyt? Tak robili moi dawni profesorowie przed każdym wielkim przedsięwzięciem.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Dobrze, czytaj.",
					function getResult( _event )
					{
						if (this.Math.rand(1, 100) <= 50)
						{
							return "D";
						}
						else
						{
							return "E";
						}
					}

				},
				{
					Text = "Skoro tak się boisz czytać, może lepiej nie.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Historian.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_12.png[/img]%historian% podnosi zwoje. Oblizuje wargi, chrząka i zaczyna czytać na głos. Słowa, które z niego wypływają, nie są takie, które łatwo byś rozpoznał. Brzmią leniwie, jakby wyrywano go z głębokiego snu, i rzeczywiście przynoszą ze sobą potwory, które zamieszkują krainy marzeń.\n\n Zatrzymuje się i unosi wzrok.%SPEECH_ON%To było wszystko. Czujesz coś?%SPEECH_OFF%Unosisz brew. Czujesz coś? Dlaczego miałby--\n\n Szaleństwo. Widzisz spiralną ciemność oplecioną żyjącymi cieniami, krzyczące widma stworzeń, które wciąż pragną ostateczności w śmierci, a pomiędzy nimi wirują istoty, szczerzące się i ujadające niczym bestialscy lalkarze, z paszczami opadającymi w głębiny, których kościane zęby są jedynym światłem w tej krainie, a ich uśmiechy to sierpy źle uformowanych księżyców, które przyszły pożreć same gwiazdy.%SPEECH_ON%O naiwny, czy sądzisz, że Davkul nie słucha?%SPEECH_OFF%Nagle budzisz się na krzyk %historian%. Mówi, że wszelkiej maści potwory są już w drodze. Nie tracąc ani chwili, idziesz ostrzec ludzi, zanim wszystkie piekła, także te jeszcze nieznane, rozpełzną się po świecie.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Do broni!",
					function getResult( _event )
					{
						local properties = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
						properties.CombatID = "Event";
						properties.Music = this.Const.Music.BeastsTracks;
						properties.IsAutoAssigningBases = false;
						properties.Entities = [];
						properties.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Center;
						properties.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Circle;
						this.Const.World.Common.addUnitsToCombat(properties.Entities, this.Const.World.Spawn.Direwolves, this.Math.rand(40, 70), this.Const.Faction.Enemy);
						this.Const.World.Common.addUnitsToCombat(properties.Entities, this.Const.World.Spawn.Ghouls, this.Math.rand(40, 70), this.Const.Faction.Enemy);
						this.World.State.startScriptedCombat(properties, false, false, true);
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Historian.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "E",
			Text = "[img]gfx/ui/events/event_15.png[/img]%historian% podnosi zwój i zaczyna czytać. Język jest jednocześnie znajomy i prastary. Łechce ucho jak szelest żmij przesuwających się po piasku i wcale nie brzmi mniej groźnie. Gdy kończy, historyk podnosi wzrok.%SPEECH_ON%Czujesz coś?%SPEECH_OFF%Nagle ciemna, a zarazem delikatna dłoń oplata mężczyznę od tyłu, sunąc w dół ku jego biodrom.%SPEECH_ON%Och, ludzie. Nie sądziliśmy, że przetrwacie tak długo, i rzeczywiście dawno już nie wzywano naszych usług.%SPEECH_OFF%Smukłe, kołyszące biodrami istoty wsuwają się do namiotu tak lekko, jakby były ledwie wiatrem. Na zewnątrz słyszysz pomruk reszty kompanii ulegającej uwodzicielskim istotom. Jedna z nich idzie ku tobie, jej kształt miga pomiędzy wszystkimi kobietami twojego życia, testując twoją reakcję, a gdy serce ci mięknie, zatrzymuje się na młodej dziewczynie, która kiedyś złamała ci serce. Sukub spada na ciebie.%SPEECH_ON%Nie przejmuj się, człowieku, to dla ciebie. Rozluźnij się.%SPEECH_OFF%Pozwalasz, by rozkosz cię ogarnęła.\n\n Po niezmierzonych godzinach budzisz się ze spuszczonymi spodniami, a %historian% w kącie pociera głowę.%SPEECH_ON%Były wspaniałe, ale zwój zniknął. Chyba spłonął, gdy wypowiedziałem słowa. O, starzy bogowie, żałuję, że nie pamiętam, co tam było napisane!%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Niesamowite.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Historian.getImagePath());
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (this.Math.rand(1, 100) <= 75)
					{
						bro.improveMood(1.0, "Had a pleasurable supernatural experience");

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
		if (this.World.getTime().Days < 10)
		{
			return;
		}

		local playerTile = this.World.State.getPlayer().getTile();
		local towns = this.World.EntityManager.getSettlements();
		local nearTown = false;

		foreach( t in towns )
		{
			local d = playerTile.getDistanceTo(t.getTile());

			if (d <= 8)
			{
				nearTown = true;
				break;
			}
		}

		if (nearTown)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local candidates_historian = [];

		foreach( bro in brothers )
		{
			if (bro.getLevel() >= 3 && bro.getBackground().getID() == "background.historian")
			{
				candidates_historian.push(bro);
			}
		}

		if (candidates_historian.len() == 0)
		{
			return;
		}

		this.m.Historian = candidates_historian[this.Math.rand(0, candidates_historian.len() - 1)];
		this.m.Score = 5;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"historian",
			this.m.Historian != null ? this.m.Historian.getNameOnly() : ""
		]);
	}

	function onClear()
	{
		this.m.Historian = null;
	}

});

