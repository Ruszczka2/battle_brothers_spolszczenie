this.unhold_graveyard_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.location.unhold_graveyard";
		this.m.Title = "Gdy się zbliżasz...";
		this.m.Cooldown = 999999.0 * this.World.getTime().SecondsPerDay;
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_117.png[/img]{Kości palców jak upadłe totemy, uda odrąbane od kolan, jakby drwale podjęli się ponurej pracy, zakrzywione żebra rozrzucone po ziemi jak pod okiem szkutnika, a czaszki, chwiejące się na klinach żuchw, uniesione niczym animistyczne domostwa szamanów, trzonowce wielkości tarcz i każdy człowiek mógłby przeczołgać się przez ich oczodoły.\n\n Spoglądając poza szczątki szkieletu unholda, znajdujesz ich znacznie więcej, rozciągniętych w dolinie. Najcięższe kości zostały tam, gdzie ich właściciel wydał ostatnie tchnienie, podczas gdy najmniejsze dawno stoczyły się do rowu w dolinie i osiadły tam w białym potoku okrytym resztkami mięsa i futra.\n\nNie masz powodu sądzić, że ktokolwiek inny niż same unholdy zaplanował ich śmierć. Przemoc nie leży w ich naturze. Siedzą lub leżą w spokojnych wiecznościach, i faktycznie %randombrother% wskazuje wielkiego olbrzyma, który wygląda na to, że niedawno położył się do spoczynku. Jest wtulony w ziemną niszę z dłońmi owiniętymi wokół kolan i głową przechyloną na ramię. Patrzył na zachód słońca i będzie to robił przez wiele kolejnych lat. Nie żeby cię to obchodziło. Każesz ludziom rozproszyć się i zebrać, co się da. Część tych kości, skór lub czegoś jeszcze, co ze sobą przynieśli, może być dla kompanii bardzo użyteczna.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Zabierz wszystko.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.Assets.getStash().makeEmptySlots(5);
				local item;
				item = this.new("scripts/items/misc/unhold_bones_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Zyskujesz " + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
				item = this.new("scripts/items/misc/unhold_bones_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Zyskujesz " + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
				item = this.new("scripts/items/misc/unhold_bones_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Zyskujesz " + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
				item = this.new("scripts/items/misc/unhold_hide_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Zyskujesz " + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
				item = this.new("scripts/items/misc/frost_unhold_fur_item");
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

