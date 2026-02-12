this.all_naked_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.all_naked";
		this.m.Title = "W drodze...";
		this.m.Cooldown = 9999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_16.png[/img]Maszerując, dostrzegasz podróżnego, który pochyla się do przodu, potem do tyłu i znów do przodu, a przy tym jego dłoń nie wie, czy zasłonić słońce, czy odsunąć się, by oślepnąć. Kręci głową i spluwa.%SPEECH_ON%Słyszałem o was, ludkowie. Banda bezspodniaków w krainie zła, jakby diabelski żart ożył. Kim wy do diabła jesteście?%SPEECH_OFF%Wzruszasz ramionami i mówisz, że jak dotąd nie masz problemu z mierzeniem się z kłopotami bez skóry, płyty czy choćby przepaski. Podróżny znów kręci głową i spluwa.%SPEECH_ON%Cholera jasna. Człowiek w bitwie bez niczego na sobie jest bardziej nagi niż w dniu, w którym się urodził! Ironia chyba polega na tym, że jeśli my - i mówię tu o kimkolwiek - znajdziemy was martwych na polach, to pewnie ubierzemy was do grobu lepiej, niż wy ubieracie się teraz. A to nie będzie trudne, skoro nie ubieracie się wcale.%SPEECH_OFF%Z lekkim skinieniem dziękujesz podróżnemu za jego miłe słowa i ruszasz dalej w wesołym marszu.",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Jaki piękny dzień!",
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
		if (this.World.getTime().Days < 14)
		{
			return;
		}

		if (!this.World.getTime().IsDaytime)
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();

		if (!currentTile.HasRoad)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();

		foreach( bro in brothers )
		{
			if (bro.getItems().getItemAtSlot(this.Const.ItemSlot.Body) != null)
			{
				return;
			}
		}

		this.m.Score = 25;
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

