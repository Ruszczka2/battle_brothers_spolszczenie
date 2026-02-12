this.anatomists_intro_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.anatomists_scenario_intro";
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_181.png[/img]{Na początku myślałeś, że są pogromcami potworów, ale szybko cię poprawili, mówiąc, że są \'badaczami,\' a nie \'zabijaczami.\' Kiedy dalej czułeś się zmieszany, wytłumaczyli, że są \'anatomami\', co i tak niezbyt pomogło. Zirytowani, nazwali cię \'literalnym imbecylem,\' na co z dumą odpowiedziałeś, że wiesz, co oznacza \'literalny\'. Oni wybuchnęli śmiechem i rzekli, że źle zrozumiałeś. Gdy śmiali ci się w twarz, dobyłeś miecza i w tym momencie wszyscy, jak jeden mąż, podnieśli ręce do góry, każdy trzymając sakiewkę wypełnioną koronami.\n\nPo dalszej rozmowie zorientowałeś się, że są jajogłowymi z żywym zainteresowaniem zwłokami. Jako że sam jesteś dość utalentowany w sztuce generowania zwłok, uznali za stosowne zatrudnić cię, abyś dokładnie to dla nich robił. Będziesz przemierzał krainę, zatrudniając potężną bandę najemników i pomagał tym osobliwym indywiduom w wykonywaniu ich zadań naukowych. Jedyne, o co prosisz, to aby nie robili żadnych dziwnych rzeczy z twoim ciałem, jeśli zdarzy ci się umrzeć. Anatomowie uśmiechają się serdecznie i obiecują, że nigdy nie uczyniliby czegoś takiego mężczyźnie, z którym robią interesy. Każdy z nich ma przy tym minę taką, jakby uśmiechania uczyli się od trupa, ale chyba nie masz wyjścia i będziesz musiał zaufać im na słowo.}",
			Image = "",
			Banner = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Po namyśle, obiecajcie też zostawić moje ciało w spokoju, póki jeszcze żyję.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Banner = "ui/banners/" + this.World.Assets.getBanner() + "s.png";
			}

		});
	}

	function onUpdateScore()
	{
		return;
	}

	function onPrepare()
	{
		this.m.Title = "Anatomowie";
	}

	function onPrepareVariables( _vars )
	{
	}

	function onClear()
	{
	}

});

