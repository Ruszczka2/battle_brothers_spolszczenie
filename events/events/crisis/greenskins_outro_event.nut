this.greenskins_outro_event <- this.inherit("scripts/events/event", {
	m = {
		Dude = null
	},
	function create()
	{
		this.m.ID = "event.crisis.greenskins_outro";
		this.m.Title = "Wzdłuż drogi...";
		this.m.Cooldown = 1.0 * this.World.getTime().SecondsPerDay;
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_05.png[/img]Spotykasz garstkę żołnierzy z %randomnoblehouse%. Przechylają przed tobą czapki.%SPEECH_ON%Dobry wieczór, najemnicy.%SPEECH_OFF%Niepewny, czy zaraz nie zaatakują, posyłasz subtelny znak do %dude%. Sięga po broń, trzymając ją w zasięgu dłoni, i kiwa w odpowiedzi. Zwracasz uwagę z powrotem na żołnierzy, machając przyjaźnie. Ich porucznik robi krok do przodu, uśmiechając się krzywo.%SPEECH_ON%Ej, najemniku, teraz niewiele z waszego pożytku.%SPEECH_OFF%Powoli opuszczasz dłoń, trzymając ją nad rękojeścią miecza. Pytasz, co ma na myśli. Śmieje się.%SPEECH_ON%Nie słyszałeś? Wojna się skończyła. Zielonoskórni zostali rozbici pod %randomtown% zaledwie kilka dni temu. Zwiadowcy mówią, że te skurczybyki uciekają w góry na wszystkie strony, walczą między sobą, orki zabijają gobliny, gobliny zabijają orki, pełny pogrom. Więc tak, szlacheckie rody nie muszą już płacić waszych żałosnych tyłków, bo my, prawdziwi żołnierze, mamy to pod kontrolą. A teraz znikajcie wy i wasza żałosna zgraja z drogi. My, walczący, mamy gdzie być, rozumiesz?%SPEECH_OFF%",
			Image = "",
			Characters = [],
			Options = [
				{
					Text = "Ustąpmy, by ci bohaterowie królestwa mogli przejść.",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "Zajmij się nim, %dude%.",
					function getResult( _event )
					{
						return "C";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Dude.getImagePath());
				this.updateAchievement("GreenskinSlayer", 1, 1);

				if (this.World.Assets.isIronman())
				{
					this.updateAchievement("ManOfIron", 1, 1);
				}

				if (this.World.Assets.isIronman())
				{
					local defeated = this.getPersistentStat("CrisesDefeatedOnIronman");
					defeated = defeated | this.Const.World.GreaterEvilTypeBit.Greenskins;
					this.setPersistentStat("CrisesDefeatedOnIronman", defeated);

					if (defeated == this.Const.World.GreaterEvilTypeBit.All)
					{
						this.updateAchievement("Savior", 1, 1);
					}
				}
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_05.png[/img]%dude% sięga po broń, ale kręcisz głową. Porucznik kiwa w stronę najemnika.%SPEECH_ON%Lepiej trzymaj tego psa na smyczy, co?%SPEECH_OFF%Rozkładasz ramię, zapraszając żołnierzy do 'przejścia', które i tak mieli. Żołnierze ruszają, a porucznik uśmiecha się krzywo.%SPEECH_ON%Wiedziałem, że wybierzesz właściwie. My tylko tak się bawimy, co? Panienki, trzymajcie się.%SPEECH_OFF%Mężczyzna posyła buziaka, przechodząc obok. %dude% wstaje, wyglądając jak ktoś, komu właśnie uderzono matkę. Mówisz mu, by usiadł, i niechętnie to robi. To wszystko bzdury, te teatrzyki, ale nie jesteś kimś, kto traci zimną krew i przez to giną ludzie.\n\nIncydent sprawia jednak, że zastanawiasz się, czy nie czas już to wszystko zakończyć. Zielonoskórni zostali odparci, a ty zarobiłeś dość, by na zawsze porzucić ten fach, ale z drugiej strony nie chciałbyś spędzić reszty dni, zastanawiając się 'co by było, gdyby'...\n\n%OOC%Wygrałeś! Battle Brothers zostało zaprojektowane z myślą o regrywalności i kampaniach, które kończy się po pokonaniu jednego lub dwóch późnych kryzysów. Nowa kampania pozwoli ci spróbować różnych rzeczy w innym świecie.\n\nMożesz też kontynuować kampanię tak długo, jak chcesz. Pamiętaj jednak, że kampanie nie są przeznaczone do trwania wiecznie i w końcu zabraknie ci wyzwań.%OOC_OFF%",
			Image = "",
			Characters = [],
			Options = [
				{
					Text = "%companyname% potrzebuje swojego dowódcy!",
					function getResult( _event )
					{
						return 0;
					}

				},
				{
					Text = "Czas przejść na emeryturę z życia najemnika. (Zakończ kampanię)",
					function getResult( _event )
					{
						this.World.State.getMenuStack().pop(true);
						this.World.State.showGameFinishScreen(true);
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Dude.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_05.png[/img]Porucznik żołnierzy rzuca ci gniewne spojrzenie.%SPEECH_ON%Rób, co powiedziałem, najemniku, albo będą kłopoty.%SPEECH_OFF%Ignorując go, posyłasz kolejny znak do %dude%. Wstaje, a ostrze jego broni głośno szura po ziemi. Żołnierze odwracają się do najemnika. Chwyta broń oburącz i wpatruje się w nich. Gdy porucznik zaczyna mówić, %dude% bezceremonialnie mu przerywa.%SPEECH_ON%Cicho, mały człowieczku. Widzę miękkość w twojej skórze. Żadnej blizny. Oczy świeże jak w dniu narodzin. Dłonie gładkie jak nieużywane świece. Gdybyś był z walczącego sortu, byłbyś tam, w bitwach, o których mówisz, a nie tu, szczając pod wiatr. Dam ci dwie opcje, bo mam dobry humor. Pierwsza opcja, słuchasz? Pierwsza opcja jest taka. Idź tam, dokąd zmierzasz, i nie wypowiedz ani jednego cholernego słowa.%SPEECH_OFF%Pauzuje, unosząc dwa palce.%SPEECH_ON%Opcja druga to tajemnica. Odezwij się, a się dowiesz.%SPEECH_OFF%Oczy porucznika robią się nieco szersze, a usta nieskończenie cichsze. Spogląda na ciebie, ale możesz tylko wzruszyć ramionami. Po chwili żołnierze odchodzą w pospiesznym milczeniu.\n\n%dude% śmieje się z całego zajścia, ale incydent sprawia, że zastanawiasz się, czy to nie czas wreszcie przejść na emeryturę. Ile jeszcze takich wtop czeka cię w przyszłości? Ile jeszcze bitew? Ilu jeszcze martwych będziesz musiał pochować? Kompania dobrze stoi na fundamencie, który jej zbudowałeś. Ale z drugiej strony, gdybyś przeszedł na emeryturę teraz, jakich przygód byś nie przeżył?\n\n%OOC%Wygrałeś! Battle Brothers zostało zaprojektowane z myślą o regrywalności i kampaniach, które kończy się po pokonaniu jednego lub dwóch późnych kryzysów. Nowa kampania pozwoli ci spróbować różnych rzeczy w innym świecie.\n\nMożesz też kontynuować kampanię tak długo, jak chcesz. Pamiętaj jednak, że kampanie nie są przeznaczone do trwania wiecznie i w końcu zabraknie ci wyzwań.%OOC_OFF%",
			Image = "",
			Characters = [],
			Options = [
				{
					Text = "%companyname% potrzebuje swojego dowódcy!",
					function getResult( _event )
					{
						return 0;
					}

				},
				{
					Text = "Czas przejść na emeryturę z życia najemnika. (Zakończ kampanię)",
					function getResult( _event )
					{
						this.World.State.getMenuStack().pop(true);
						this.World.State.showGameFinishScreen(true);
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Dude.getImagePath());
			}

		});
	}

	function onUpdateScore()
	{
		if (this.World.Statistics.hasNews("crisis_greenskins_end"))
		{
			local currentTile = this.World.State.getPlayer().getTile();

			if (!currentTile.HasRoad)
			{
				return;
			}

			if (this.Const.DLC.Desert && currentTile.SquareCoords.Y <= this.World.getMapSize().Y * 0.15)
			{
				return;
			}

			local brothers = this.World.getPlayerRoster().getAll();
			local most_days_with_company = -9000.0;
			local most_days_with_company_bro;

			foreach( bro in brothers )
			{
				if (bro.getDaysWithCompany() > most_days_with_company)
				{
					most_days_with_company = bro.getDaysWithCompany();
					most_days_with_company_bro = bro;
				}
			}

			this.m.Dude = most_days_with_company_bro;
			this.m.Score = 6000;
		}
	}

	function onPrepare()
	{
		this.World.Statistics.popNews("crisis_greenskins_end");
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"dude",
			this.m.Dude.getNameOnly()
		]);
		local nobles = this.World.FactionManager.getFactionsOfType(this.Const.FactionType.NobleHouse);
		_vars.push([
			"randomnoblehouse",
			nobles[this.Math.rand(0, nobles.len() - 1)].getName()
		]);
	}

	function onClear()
	{
		this.m.Dude = null;
	}

});

