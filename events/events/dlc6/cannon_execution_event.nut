this.cannon_execution_event <- this.inherit("scripts/events/event", {
	m = {
		Dude = null
	},
	function create()
	{
		this.m.ID = "event.cannon_execution";
		this.m.Title = "Na drodze...";
		this.m.Cooldown = 99999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_177.png[/img]{Napotykasz mężczyznę w wojskowym stroju z parą podobnie ubranych strażników. Pomiędzy nimi jest człowiek z rękami i nogami rozpostartymi i przywiązanymi do ogromnego moździerza, tułowiem zwrócony do lufy, z głową opartą na celownikach. Spogląda na ciebie z ukosa.%SPEECH_ON%Ach, wędrowcze. Jestem w niemałej opresji. Widzisz, ci zacni, milczący panowie chcą rozchlapać mnie po piaskach, używając największego technicznego cudu naszych czasów. Choć widzę zaletę w uniknięciu zardzewiałego miecza kata, muszę przyznać, że mieć ostatnią chwilę na oglądaniu, jak moje własne części ciała bombardują pustynne stwory, to niezła kompromitacja. Słuszna kara za pewne zbrodnie, bez wątpienia, ale ja jestem zwykłym złodziejem.%SPEECH_OFF%Wojskowy kat spogląda na ciebie, ale, jak powiedział złodziej, wygląda na niemego. Albo głuchego, jak sugerowałaby sama rola moździerzowego.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Jakie dokładnie masz przestępstwo?",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "To nas nie dotyczy.",
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
			ID = "B",
			Text = "[img]gfx/ui/events/event_177.png[/img]{Kat, ku zaskoczeniu, odpowiada, zatykając jedno ucho palcem, gdy mówi.%SPEECH_ON%Koronniku, to nie twoja sprawa. Idź dalej.%SPEECH_OFF%Złodziej znów próbuje obrócić głowę.%SPEECH_ON%Ach, ach! Mówi! Wspaniale. Rozstrzygnijmy to jak dobrzy dżentelmeni o wrażliwości miłej, choć wyprzedzającej nasze czasy.%SPEECH_OFF%Kat ignoruje elokwentne błagania złodzieja.%SPEECH_ON%Zaproponuję układ w zamian za twoją neutralność, Koronniku. Gdy ten złodziej zostanie rozchlapany po pustyni, możesz zabrać cokolwiek jest w jego środku, bo, widzisz, mówi się, że nosi złote serce.%SPEECH_OFF%Złodziej nerwowo odzywa się.%SPEECH_ON%To znaczy coś innego tam, skąd pochodzę.%SPEECH_OFF%Prosisz kata o wyjaśnienie. Twierdzi, że Gilder \"dotyka\" tych, którzy mu się sprzeciwiają, potępiając i skazując znienawidzonych na wnętrzności ze złota. To potępienie wykracza poza zwykłe zadłużenie. Brzmi dość fantastycznie, nawet dla ciebie.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "W takim razie kontynuujcie egzekucję.",
					function getResult( _event )
					{
						return "C";
					}

				},
				{
					Text = "Musisz przerwać tę egzekucję.",
					function getResult( _event )
					{
						return "D";
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_177.png[/img]{Chcesz sprawdzić, czy kat ma rację, więc stajesz z boku. Złodziej wzdycha.%SPEECH_ON%Cóż. No to dobrze. Tylko dopilnujcie, żeby kiedy będą o mnie pisać, ta egzekucja nie była kanonem. To \"kanon\" przez jedno-%SPEECH_OFF%Wybuch rozrywa mężczyznę, a miażdżąca siła wypycha falę piasku z samego moździerza, wyrzucając chmurę pyłu i krwi, wirującą w powietrzu jak burza wnętrzności, a po chwili części ciała zaczynają stukać o ziemię. Żaden z tych kawałków nie jest złoty. Właściwie większość jest zwęglona na czarno lub jaskrawoczerwona, świeżo odsłonięta na widok świata. Kat ociera twarz z prochu.%SPEECH_ON%Wygląda na to, że się myliliśmy. Złodziej zostanie wynagrodzony przez samego Gildera, ach, mieć takie szczęście.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "No to po sprawie.",
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
			ID = "D",
			Text = "[img]gfx/ui/events/event_177.png[/img]{Informujesz strażników i kata, że przerwiesz egzekucję. Natychmiast odsuwają się od moździerza. Kat znów zatyka ucho.%SPEECH_ON%Wstrzymanie egzekucji? Czy powiedziałeś, żeby ją rozpocząć?%SPEECH_OFF%Złodziej nerwowo się śmieje.%SPEECH_ON%Tak, Koronniku, proszę wyjaśnić to naszemu przyjacielowi.%SPEECH_OFF%Sprawę rozstrzygacie powoli i tak, by wszyscy usłyszeli. Ku zaskoczeniu, strażnicy się zgadzają. Nie widzą w tobie przypadkowej interwencji, lecz kogoś zesłanego przez samego Gildera - bo dlaczego inaczej miałbyś tu być? Złodziej zostaje uwolniony z urządzenia i oddany kompanii. Wyciąga dłoń.%SPEECH_ON%Pomijając całe to zamieszanie, będę walczył dla ciebie, uh, hmmm... %companyname%. Urocze. Ale nie jestem zwykłym złodziejem, jestem człowiekiem dumy, człowiekiem obowiązku i człowiekiem koron!%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Witaj w kompanii, jak mniemam.",
					function getResult( _event )
					{
						this.World.getPlayerRoster().add(_event.m.Dude);
						this.World.getTemporaryRoster().clear();
						_event.m.Dude.onHired();
						_event.m.Dude = null;
						return 0;
					}

				},
				{
					Text = "Uratowaliśmy ci życie. To nie znaczy, że jesteś u nas mile widziany.",
					function getResult( _event )
					{
						this.World.getTemporaryRoster().clear();
						_event.m.Dude = null;
						return 0;
					}

				}
			],
			function start( _event )
			{
				local roster = this.World.getTemporaryRoster();
				_event.m.Dude = roster.create("scripts/entity/tactical/player");
				_event.m.Dude.setStartValuesEx([
					"thief_southern_background"
				]);
				_event.m.Dude.getBackground().m.RawDescription = "Tylko dzięki twojej szybkiej interwencji %name% został ocalony przed egzekucją, podczas której miał zostać wystrzelony z ogromnego moździerza. Ekscentryczny złodziej, jego ostatnia nieudana próba okradzenia pałacu wezyra została uznana za dobry powód, by ustanowić bardzo wyraźne ostrzeżenie dla każdego, kto ma podobne plany.";
				_event.m.Dude.getBackground().buildDescription(true);
				_event.m.Dude.getItems().unequip(_event.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand));
				_event.m.Dude.getItems().unequip(_event.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Offhand));
				_event.m.Dude.getItems().unequip(_event.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Head));
				_event.m.Dude.worsenMood(1.0, "O mało nie został spektakularnie stracony przez techniczny cud");
				this.Characters.push(_event.m.Dude.getImagePath());
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Desert)
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();

		if (currentTile.Type != this.Const.World.TerrainType.Desert && currentTile.TacticalType != this.Const.World.TerrainTacticalType.DesertHills)
		{
			return;
		}

		if (!currentTile.HasRoad)
		{
			return;
		}

		if (this.World.getPlayerRoster().getSize() >= this.World.Assets.getBrothersMax())
		{
			return;
		}

		this.m.Score = 5;
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

