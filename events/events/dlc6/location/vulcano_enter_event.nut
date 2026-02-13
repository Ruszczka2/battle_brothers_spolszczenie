this.vulcano_enter_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.location.vulcano_enter";
		this.m.Title = "Gdy się zbliżasz...";
		this.m.Cooldown = 999999.0 * this.World.getTime().SecondsPerDay;
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_151.png[/img]{Koniec Imperium. Metropolia Popiołu. Anihilacja.\n\nJak by tego nie nazwać, starożytne miasto jest dziś rozległą, szarą ruiną. Leży u stóp góry bez szczytu, jej niegdyś wspaniały kształt został zniszczony przez ogromną erupcję. Wybuch uderzył z taką siłą, że fale uderzeniowe rozrywały brukowane ulice i posyłały grad cegieł nad właściwe miasto. Ogromne granitowe głazy kraterowały całe dzielnice, a wrzące szczątki parowały wszystko na swojej drodze. Na końcu przyszła lawa, tląc znaczną część miasta w czarnej brei, której krawędzie puchły i wybrzuszały się, aż wyglądało to tak, jakby chmura czarnego dymu stężała. To straszliwy widok, po części dlatego, że ziemska furia uwięziła wielu ofiar na wieczność: szare odlewy dawnych ludzi stoją do dziś, zastygłe w żywych pozach - pary ściskające dłonie, ktoś pochylony nad piecem, ktoś inny głaszczący psa.\n\nOczywiście leży to w naturze człowieka, by widząc takie relikty zniszczenia i, choć odległe od jego codzienności, gromadzić się przy ich szczątkach i pośrednio ożywiać przemoc przez wiarę. Wyznawcy Gildera widzą w tym ostrzeżenie, by nie popaść w rozrzutność i chciwość. Północniacy widzą w tym starcie starych bogów, rzadkość od zarania dziejów. Jedna wiara czy druga, obie trwają tutaj we wzajemnym szacunku dla tych, którzy stracili życie... przynajmniej na razie.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Los w końcu znów nas tu przywiedzie.",
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

