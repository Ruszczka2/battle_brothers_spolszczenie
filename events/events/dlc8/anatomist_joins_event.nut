this.anatomist_joins_event <- this.inherit("scripts/events/event", {
	m = {
		Dude = null
	},
	function create()
	{
		this.m.ID = "event.anatomist_joins";
		this.m.Title = "W drodze...";
		this.m.Cooldown = 30.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_184.png[/img]{Podchodzi mężczyzna w wyblakłym, szarym odzieniu. Zamiast broni i zbroi ma ze sobą zwoje i papiery, a także bandolier fiolek i sakiewek pełnych dziwnego mięsa i futra. Pozdrawia cię.%SPEECH_ON%Ach, %companyname%. Szukałem ludzi o takich... cechach. Widzisz, jestem anatomistą i-%SPEECH_OFF%Zatrzymujesz go w pół słowa. Nie masz czasu na ludzi, którzy obsesyjnie zajmują się dziwactwami. Albo chce dołączyć, albo nie, i mówisz mu to krótko. | Napotykasz mężczyznę klęczącego nad martwym psem. Bada pysk długim patykiem i przytakuje.%SPEECH_ON%Jak widzisz, jestem sławnym anatomistą.%SPEECH_OFF%Podnosi głowę jak jakiś upiorny marionetka i twierdzi, że %companyname% powoli zyskuje sławę dzięki studiom - i że chce dołączyć. | Znajdujesz na skale płaszcz, spodnie i parę butów. Obok leżą bandoliery, stosy papieru i osobliwe rysunki. Spoglądasz dalej i widzisz staw, a w nim pluskającego się mężczyznę. Drga na twój widok i wskazuje palcem.%SPEECH_ON%Nie dotykaj tego! Hej, ty, niczego nie dotykaj!%SPEECH_OFF%Wychodzi z wody, niezdarnie chlapiąc nogami po powierzchni. Gdy się podnosi, widzisz, że na szczęście jest absurdalnie owłosiony, a woda zamienia jego futrzaste krocze w szary, filcowy przepaski. Dobywasz miecza, a mężczyzna staje w miejscu.%SPEECH_ON%Odłóż stal, wędrowcze. Widzę teraz, że masz dociekliwy umysł, tak jak ja! A ja, mój drogi wędrowcze ze stalą, bardzo potrzebuję równych sobie. Co powiesz na to, żebym dołączył?%SPEECH_OFF%Próbujesz trzymać wzrok powyżej szyi, ale zrywa się silny wiatr i słyszysz, jak woda strząsa się z jego krocza jak z mokrego psa. Spojrzenie w dół, które potem następuje, jest dość niefortunne. | Napotykasz mężczyznę siedzącego na skale. Naprzeciw niego leży płyta kamienia przykryta rozciętymi zwierzętami. Szczenięta, kocięta, chyba żaba, jakiś gryzoń i... kaczka. Mężczyzna zrywa się na nogi.%SPEECH_ON%Spójrz, wędrowcze, na efekt moich badań. Wciąż jednak brakuje mi wielu obserwacji. Widzę, że masz dociekliwy umysł, choć bez wątpienia jesteś brutusem. Chciałbym zaoferować ci swoje usługi, ale muszę ostrzec: postępy, jakie tu poczyniłem, są dla mnie i tylko dla mnie.%SPEECH_OFF%Osłania ramieniem rozcięte zwierzęta, jakbyś miał się nimi interesować.}",
			Banner = "",
			Characters = [],
			Options = [
				{
					Text = "Tak, przyjmiemy cię.",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "Nie potrzebujemy twojej pomocy.",
					function getResult( _event )
					{
						return "C";
					}

				}
			],
			function start( _event )
			{
				local roster = this.World.getTemporaryRoster();
				_event.m.Dude = roster.create("scripts/entity/tactical/player");
				_event.m.Dude.setStartValuesEx([
					"anatomist_background"
				]);
				this.Characters.push(_event.m.Dude.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_184.png[/img]{Mężczyzna krótko się kłania.%SPEECH_ON%Ach, dobrze jest być wśród moich intelektualnych równych, choć przypomnę, że niektórzy są bardziej równi niż inni, i jeśli pragną czytać moje prace, mogą złożyć stosowną prośbę.%SPEECH_OFF%Tak. Jasne.}",
			Banner = "",
			Characters = [],
			Options = [
				{
					Text = "Po prostu wsiadaj na wóz.",
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
				this.Characters.push(_event.m.Dude.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_184.png[/img]{Mężczyzna przytakuje.%SPEECH_ON%W porządku. Wiem, że gdy spotkałem swego intelektualnego przełożonego, poczułem zazdrość i odrzuciłem wszelką pomoc, jaką oferował. Cóż, dobry panie, podróżuj bezpiecznie i dogoń mnie oraz moje odkrycia!%SPEECH_OFF%}",
			Banner = "",
			Characters = [],
			Options = [
				{
					Text = "Taa, ty też spadaj.",
					function getResult( _event )
					{
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
		if (!this.Const.DLC.Paladins)
		{
			return;
		}

		if (this.World.Assets.getOrigin().getID() != "scenario.anatomists")
		{
			return;
		}

		if (this.World.getPlayerRoster().getSize() >= this.World.Assets.getBrothersMax())
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local numAnatomists = 0;

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.anatomist")
			{
				numAnatomists++;
			}
		}

		local comebackBonus = numAnatomists < 3 ? 8 : 0;
		this.m.Score = 2 + comebackBonus;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
	}

	function onClear()
	{
		this.m.Dude = null;
	}

});

