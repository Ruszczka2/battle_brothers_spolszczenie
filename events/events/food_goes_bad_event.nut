this.food_goes_bad_event <- this.inherit("scripts/events/event", {
	m = {
		FoodAmount = 0
	},
	function create()
	{
		this.m.ID = "event.food_goes_bad";
		this.m.Title = "W obozie...";
		this.m.Cooldown = 21.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Przydałoby się to...",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local food = this.World.Assets.getFoodItems();
				food = food[this.Math.rand(0, food.len() - 1)];
				this.World.Assets.getStash().remove(food);

				if (food.getID() == "supplies.bread")
				{
					this.Text = "[img]gfx/ui/events/event_52.png[/img]{Podczas inwentaryzacji %randombrother% przekazuje ci przykrą wiadomość: spora część jedzenia się zepsuła. Krótko i na temat, kiwasz głową i dziękujesz mu za szybkie ostrzeżenie. | %randombrother% podchodzi do ciebie, pocierając szczękę. Mówi, że prawie połamał sobie zęby na kawałku chleba. Podobno znalazł go na dnie skrzyni z jedzeniem i wygląda na to, że leżał tam od dawna. Bierzesz miecz i przecinasz bochenek na pół, a kilku braci wiwatuje z ironiczną odwagą. Podnosisz połówki chleba i pokazujesz ludziom wnętrze: ciemny, czarny rdzeń. Tak będzie wyglądał wasz żołądek, jeśli to zjecie, mówisz, po czym wyrzucasz chleb w krzaki, gdzie słychać, jak turla się niczym ciężki kamień.}";
				}
				else if (food.getID() == "supplies.dried_fish")
				{
					this.Text = "[img]gfx/ui/events/event_52.png[/img]{Podczas inwentaryzacji %randombrother% przekazuje ci przykrą wiadomość: spora część jedzenia się zepsuła. Krótko i na temat, kiwasz głową i dziękujesz mu za szybkie ostrzeżenie. | %randombrother% wrzeszczy i zrywa się z kłody, na której siedział. Podchodzisz i widzisz, że odrzucił na bok rybę i nie może przestać na nią wskazywać. Ostrzega cię, byś się do niej nie zbliżał, ale ty postanawiasz podejść. Okazuje się, że wodny pająk złożył w brzuchu ryby kokon jaj. Teraz patrzysz, jak małe pajączki bulgoczą na zewnątrz w chmurze ruchliwych nóg i ciał.\n\nWrzucając całość do ognia, prosisz brata, by sprawdził resztę ryb. Niestety, wszystkie są w podobnym stanie i nikt nie chce zastąpić rybnego jedzenia pajączym.}";
				}
				else if (food.getID() == "supplies.dried_fruits")
				{
					this.Text = "[img]gfx/ui/events/event_52.png[/img]{Podczas inwentaryzacji %randombrother% przekazuje ci przykrą wiadomość: spora część jedzenia się zepsuła. Krótko i na temat, kiwasz głową i dziękujesz mu za szybkie ostrzeżenie. | Przeglądasz kilka skrzyń z żywnością i znajdujesz całe pudło jabłek pokrytych czymś, co wygląda jak szare futro. %randombrother% ma na to słowo, ale nigdy go nie słyszałeś. Tak czy inaczej, nic z tego nie da się uratować i wyrzucasz zgniłe owoce.}";
				}
				else if (food.getID() == "supplies.smoked_ham" || food.getID() == "supplies.cured_venison")
				{
					this.Text = "[img]gfx/ui/events/event_52.png[/img]{Podczas inwentaryzacji %randombrother% przekazuje ci przykrą wiadomość: spora część jedzenia się zepsuła. Krótko i na temat, kiwasz głową i dziękujesz mu za szybkie ostrzeżenie. | Larwy wiją się na kilku kawałkach mięsa. Ludzie wpatrują się w jedzenie, a niektórzy wyglądają, jakby byli gotowi zaryzykować chorobę, byle tylko ugryźć kawałek. Karcisz wszystkich i sam pozbywasz się mięsa, zanim ktoś zrobi coś głupiego.}";
				}
				else
				{
					this.Text = "{[img]gfx/ui/events/event_52.png[/img]Podczas inwentaryzacji %randombrother% przekazuje ci przykrą wiadomość: spora część jedzenia się zepsuła. Krótko i na temat, kiwasz głową i dziękujesz mu za szybkie ostrzeżenie. | [img]gfx/ui/events/event_36.png[/img]Dziecięcy chichot budzi cię z drzemki. Podnosisz się i widzisz, że część jedzenia zniknęła, a jedyną wskazówką jest pole wciąż poruszającej się wysokiej trawy. Myśląc szybko, chwytasz miecz i podążasz śladem. Niestety, niedługo później gubisz się pośród ogromnych, zielonych źdźbeł, które uderzają w twoją twarz przy każdym podmuchu wiatru. Chichot jednak nie ustaje, słyszysz też tupot kroków przebiegających za tobą, a potem przed tobą. Odzywa się głos, brzmiący jak dziecko głęboko w studni.%SPEECH_ON%Gonić nas! Tutaj! Gonić nas! Gonić nas... GONIĆ NAS. GONIĆ NAS TERAZ!%SPEECH_OFF%Nagle nie masz ochoty odzyskiwać ziarna. Powoli wsuwasz miecz do pochwy i wycofujesz się z pola. Gdy wpatrujesz się w wysoką trawę, zaczyna się ona rozsuwać, powoli, jak kawałek skóry rozrywany na szwach. Słyszysz okropne trzaski, gdy każde źdźbło pęka na pół.\n\n%randombrother% wystrasza cię, gdy pyta, co robisz. Odwracasz się do niego, po czym znów patrzysz na pole, które łagodnie faluje na wietrze. Zamiast odpowiadać, mówisz mu tylko, by był gotów, bo wkrótce znów ruszacie. Na szczęście najemnik nie dopytuje o zniknięte jedzenie.}";
				}

				this.List = [
					{
						id = 10,
						icon = "ui/items/" + food.getIcon(),
						text = "Tracisz " + food.getName()
					}
				];
			}

		});
	}

	function onUpdateScore()
	{
		if (this.World.getTime().Days <= 10)
		{
			return;
		}

		if (this.World.Assets.getFood() < 70)
		{
			return;
		}

		if (this.World.Retinue.hasFollower("follower.cook"))
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();

		if (currentTile.Type != this.Const.World.TerrainType.Plains && currentTile.Type != this.Const.World.TerrainType.Swamp && currentTile.Type != this.Const.World.TerrainType.Farmland && currentTile.Type != this.Const.World.TerrainType.Steppe && currentTile.Type != this.Const.World.TerrainType.Hills)
		{
			return;
		}

		this.m.Score = this.World.Assets.getFood() / 10;
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
		this.m.FoodAmount = 0;
	}

});

