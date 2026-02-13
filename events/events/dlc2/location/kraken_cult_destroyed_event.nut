this.kraken_cult_destroyed_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.location.kraken_cult_destroyed";
		this.m.Title = "Po bitwie";
		this.m.Cooldown = 999999.0 * this.World.getTime().SecondsPerDay;
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_105.png[/img]{Macki łańcuchem ciągną się przez bagno w skażonej masie, tak że nie tyle zabiłeś krakena, co unicestwiłeś samo miejsce, które nazywał domem. Każdy robaczywy szczątek okryty jest bagnistym mchem, żyzną połać dla grzybów, które widziałeś, jak kobieta jadła raz za razem. Kucasz przy jednej niezerwanej partii, szturchając ich kapelusze jak kot ćmę bez skrzydeł. Grzyby zapadają się pod dotykiem. %randombrother% przygląda się im.%SPEECH_ON%Mykolog mógłby wiedzieć, co to jest.%SPEECH_OFF%Kiwasz głową. Tak. Może. Idziesz dalej, miażdżąc grzyby pod stopami i brodząc przez kończyny oraz zakrwawione płaszcze unoszące się w bagnie, i bezkształtne głowy macek z ich liściastymi paszczami złożonymi na siebie i językami zwisającymi niczym bicze. Znajdujesz kobietę ukrytą za zasłoną kudzu, sam rozchylasz pnącza jak człowiek szukający swego szczęścia. Spogląda na ciebie z uśmiechem.%SPEECH_ON%Czy to słyszałeś? Słyszałeś jego piękno?%SPEECH_OFF%Wzdychając, mówisz jej, że grzyby przejęły jej umysł, że grzyby były tam zapewne po coś i że kraken miał ją w swych sidłach, zanim kiedykolwiek się wynurzył, że użył jej, by sprowadzić tu wszystkich. Uśmiechając się coraz szerzej, pyta tylko ponownie, czy słyszałeś jego piękno. Mówisz jej, że słyszałeś, jak umiera. Marszczy brwi.%SPEECH_ON%Krzyk śmierci? Tak myślisz? Ojej, o nie. Nieznajomy, to był krzyk o pomoc. Nie pojmujesz? To znaczy, że są tam inne! Więcej! Może setki! I teraz się obudziły! Teraz wszystkie się obudziły!%SPEECH_OFF%Robisz krok w tył i zamykasz zasłonę kudzu. %randombrother% mówi ci, że kompania coś znalazła. Przez chwilę myślisz, by ocalić tę kobietę, ale wiesz lepiej. Wiesz, w jakim jest uścisku, i zostawiasz ją.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Dobrze, pokażcie, co znaleźliście.",
					function getResult( _event )
					{
						if (this.World.Flags.get("IsWaterWheelVisited"))
						{
							return "C";
						}
						else
						{
							return "B";
						}
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_105.png[/img]{Stworzenie było niemal zbyt wielkie, by godnie paść na bok, więc przechyla się do przodu z obrzydliwą paszczą rozdziawioną jak dziura wybita w przechylonej baszcie. Jeden najemnik siedzi po turecku na kopule krakena jak mnich pogrążony w studiach. Inny dłubie stworzeniu w oczach, aż jedno pęka, a kąciki oczodołu zasysają płyn w pieniącym się bulgocie. Pytasz najemników, co ważnego znaleźli, a jeden macha, byś podszedł do paszczy. Gdy dziąsła zwiotczały, zęby zwisają w dół jak miękkie blanki wieży grozy, a cały zestaw brzytew pokrytych odzieżą i ciałem jest tak wielki, że między nie wklinowane są całe kończyny. I tak samo ostrze.\n\n Sięgasz do paszczy, wyrywasz ostrze i wycierasz je szmatą. Obracając klingę, dostrzegasz glify w zbroczu i liczby obok nich, sugestię kowalstwa wiecznego, lecz przeznaczonego na konkretny czas i miejsce. Stal jest tak żywa, że wygląda, jakby została wykuta w świetle samych gwiazd. Niestety, nie ma do niej rękojeści. Wspaniałość ostrza sugeruje, że nie da się go zadowolić byle jaką rękojeścią. Odkładając ostrze do ekwipunku, każesz ludziom zebrać, co się da, z \'Bestii Bestii\' i przygotować się do opuszczenia tego przeklętego miejsca.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Zwyciężyliśmy.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.Assets.getStash().makeEmptySlots(1);
				local item = this.new("scripts/items/special/legendary_sword_blade_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Zyskujesz " + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_105.png[/img]{Stworzenie było niemal zbyt wielkie, by godnie paść na bok, więc przechyla się do przodu z obrzydliwą paszczą rozdziawioną jak dziura wybita w przechylonej baszcie. Jeden najemnik siedzi po turecku na kopule krakena jak mnich pogrążony w studiach. Inny dłubie stworzeniu w oczach, aż jedno pęka, a kąciki oczodołu zasysają płyn w pieniącym się bulgocie. Pytasz najemników, co ważnego znaleźli, a jeden macha, byś podszedł do paszczy. Gdy dziąsła zwiotczały, zęby zwisają w dół jak miękkie blanki wieży grozy, a cały zestaw brzytew pokrytych odzieżą i ciałem jest tak wielki, że między nie wklinowane są całe kończyny. I tak samo ostrze.\n\n Sięgasz do paszczy, wyrywasz ostrze i wycierasz je szmatą. Obracając klingę, dostrzegasz glify w zbroczu i liczby obok nich, sugestię kowalstwa wiecznego, lecz przeznaczonego na konkretny czas i miejsce. Stal jest tak żywa, że wygląda, jakby została wykuta w świetle samych gwiazd. Niestety, nie ma do niej rękojeści i od razu to łączysz: miecz o niebywałej wspaniałości bez rękojeści i jeden dziwny starzec w odosobnionym młynie z rękojeścią bez ostrza. Myślisz, że wiesz, gdzie to zanieść. Wkładasz ostrze do ekwipunku i każesz kompanii złupić wszystko, co warte zabrania, także z tak zwanej \'Bestii Bestii\'.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Zwyciężyliśmy.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.Assets.getStash().makeEmptySlots(1);
				local item = this.new("scripts/items/special/legendary_sword_blade_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Zyskujesz " + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
			}

		});
	}

	function onUpdateScore()
	{
	}

	function onPrepare()
	{
		this.World.Flags.set("IsKrakenDefeated", true);
	}

	function onPrepareVariables( _vars )
	{
	}

	function onDetermineStartScreen()
	{
		return "A";
	}

	function onClear()
	{
	}

});

