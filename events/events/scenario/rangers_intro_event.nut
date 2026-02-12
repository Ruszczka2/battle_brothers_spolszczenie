this.rangers_intro_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.rangers_scenario_intro";
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_10.png[/img]Wbrew opowieściom o samotnych myśliwych, chcących jeno wyżywić swoją rodzinę, kłusownicy często pracują w grupach i tworzą całe branże związane z handlem kradzionymi futrami i mięsem.\n\nJednak miejscowego lorda, którym jest %noble%, coraz bardziej irytowali kłusownicy grasujący w jego lasach. Z jego rozkazów większość okolicznych grup myśliwskich została złapana, okaleczona i powieszona. Zostałeś tylko ty, %hunter1%, %hunter2% oraz %hunter3%, i trzeba było podjąć decyzję - jak zarabiać na życie, gdy jedyne co potraficie, to posługiwanie się łukiem?\n\nUznaliście, że wasze wspólne talenty wykorzystacie w pracy najemniczej, a ciebie szybko wyznaczono na kapitana nowej jednostki.%SPEECH_ON%Masz z nas wszystkich najostrzejszy wzrok.%SPEECH_OFF%%hunter2% rzekł, a %hunter3% przytaknął, choć powściągliwie.%SPEECH_ON%Jesteś też, oczywiście, najgorszym strzelcem z całej grupy. Nie każ mnie za to wychłostać, KAPITANIE, ha-haaa!%SPEECH_OFF%Oczywiście, twoja wesoła kompania kłusowników ma różne wyjątkowe talenty - twoi ludzie preferują podróżowanie z minimalnym bagażem, przez co są szybcy, świetnie też szyją z łuków i są doskonałymi zwiadowcami, zdolnymi uniknąć niepożądanych spotkań.",
			Image = "",
			Banner = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Poradzimy sobie.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Banner = "ui/banners/" + this.World.Assets.getBanner() + "s.png";
				local brothers = this.World.getPlayerRoster().getAll();
				this.Characters.push(brothers[1].getImagePath());
				this.Characters.push(brothers[2].getImagePath());
			}

		});
	}

	function onUpdateScore()
	{
		return;
	}

	function onPrepare()
	{
		this.m.Title = "Banda Kłusowników";
	}

	function onPrepareVariables( _vars )
	{
		local brothers = this.World.getPlayerRoster().getAll();
		local settlements = this.World.EntityManager.getSettlements();
		local closest;
		local distance = 9999;

		foreach( s in settlements )
		{
			local d = s.getTile().getDistanceTo(this.World.State.getPlayer().getTile());

			if (d < distance)
			{
				closest = s;
				distance = d;
			}
		}

		local f = closest.getFactionOfType(this.Const.FactionType.NobleHouse);
		_vars.push([
			"hunter1",
			brothers[0].getName()
		]);
		_vars.push([
			"hunter2",
			brothers[1].getName()
		]);
		_vars.push([
			"hunter3",
			brothers[2].getName()
		]);
		_vars.push([
			"noble",
			f.getRandomCharacter().getName()
		]);
	}

	function onClear()
	{
	}

});

