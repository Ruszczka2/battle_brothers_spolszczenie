this.alp_nightmare1_event <- this.inherit("scripts/events/event", {
	m = {
		Victim = null,
		Other = null
	},
	function create()
	{
		this.m.ID = "event.alp_nightmare1";
		this.m.Title = "W obozie...";
		this.m.Cooldown = 300.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_26.png[/img]{Ludzie rozmawiają przy ognisku, gdy %spiderbro% nagle zrywa się z krzykiem na nogi. Odruchowo odskakuje, a w świetle płomieni widzisz pająka wielkości hełmu przyczepionego do jego buta!}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Niech ktoś go odetnie!",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "Spalić go w ognisku!",
					function getResult( _event )
					{
						return "D";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Victim.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_26.png[/img]{Dobytasz miecza, ale %otherbro% już cię uprzedził. Krzyczy do %spiderbro%, by stał nieruchomo, na co ten niechętnie przystaje. Uzbrojony najemnik zamachuje się jednak zbyt wysoko i przecina mężczyźnie szyję. Bezgłowe ciało ugina się, a reszta kompanii krzyczy z przerażenia i wściekłości.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Co do cholery!",
					function getResult( _event )
					{
						return "C";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Victim.getImagePath());
				this.Characters.push(_event.m.Other.getImagePath());
				this.List.push({
					id = 13,
					icon = "ui/icons/kills.png",
					text = _event.m.Victim.getName() + " zginął"
				});
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getID() == _event.m.Victim.getID())
					{
						continue;
					}

					if (this.Math.rand(1, 100) <= 50)
					{
						continue;
					}

					local mood = this.Math.rand(0, 1);
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[mood],
						text = bro.getName() + this.Const.MoodStateEvent[mood]
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_39.png[/img]{Ruszając na %otherbro% z zamiarem uduszenia go, czujesz, jak dłonie przesuwają się przez ciało niczym palce przez mgłę, a impet wbija cię w ziemię.%SPEECH_ON%Eee, wszystko w porządku, kapitanie?%SPEECH_OFF%Gdy się rozglądasz, widzisz zupełnie zdrowego %spiderbro% siedzącego obok ognia. Daleko w oddali coś bladego i smukłego cofa się za pień drzewa. Gdy mrugasz, znika. Mówisz ludziom, by pilnowali obwodu, po czym wracasz do namiotu, kręcąc głową i pocierając oczy.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Tylko zły sen.",
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
			Text = "[img]gfx/ui/events/event_26.png[/img]{%spiderbro% kiwa głową i sztywno idzie w stronę ogniska, a pajączek spogląda na niego dziwnie ufnie. Wrzuca stwora do paleniska i ten natychmiast staje w płomieniach. Na początku wydaje się, że jest po sprawie, ale płonący pajączek wbiega po nogawce mężczyzny, zapalając jego ubranie, i przyczepia się do głowy. Ogarnięty ogniem, mężczyzna wymachuje rękami i zaczyna biegać, wołając o pomoc. Bestia wbija kły w jego czaszkę, krzyk nagle zamiera w paraliżu, a najemnik wpada do ogniska jak deska.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Wyciągnijcie go stamtąd!",
					function getResult( _event )
					{
						return "E";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Victim.getImagePath());
				this.List.push({
					id = 13,
					icon = "ui/icons/kills.png",
					text = _event.m.Victim.getName() + " zginął"
				});
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getID() == _event.m.Victim.getID())
					{
						continue;
					}

					if (this.Math.rand(1, 100) <= 50)
					{
						continue;
					}

					local mood = this.Math.rand(0, 1);
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[mood],
						text = bro.getName() + this.Const.MoodStateEvent[mood]
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "E",
			Text = "[img]gfx/ui/events/event_39.png[/img]{Krzyczysz na najemników, by wzięli się do roboty, ale gdy skaczesz w stronę ogniska i %spiderbro%, widzisz tylko zmytkę żaru i iskier, a gdy one gasną, znajdujesz najemnika spokojnie siedzącego obok płomieni.%SPEECH_ON%Ach, kapitanie, mówiłeś coś?%SPEECH_OFF%Rozglądając się, widzisz resztę kompanii pogrążoną w bezczynnej gadce. Kiedy spoglądasz z powrotem na %spiderbro%, wydaje ci się, że widziałeś białą smugę przemykającą za nim, ale przy drugim spojrzeniu już jej nie ma. Każesz ludziom zachować czujność wobec intruzów, po czym wracasz do namiotu.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Muszę więcej odpoczywać.",
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
		if (!this.Const.DLC.Unhold)
		{
			return;
		}

		if (this.World.getTime().IsDaytime)
		{
			return;
		}

		if (this.World.getTime().Days < 20)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();

		foreach( i, bro in brothers )
		{
			if (bro.getSkills().hasSkill("trait.player"))
			{
				brothers.remove(i);
				break;
			}
		}

		if (brothers.len() < 3)
		{
			return;
		}

		this.m.Victim = brothers[this.Math.rand(0, brothers.len() - 1)];
		local other_candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getID() != this.m.Victim.getID())
			{
				other_candidates.push(bro);
			}
		}

		this.m.Other = other_candidates[this.Math.rand(0, other_candidates.len() - 1)];
		this.m.Score = 3;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"spiderbro",
			this.m.Victim.getName()
		]);
		_vars.push([
			"otherbro",
			this.m.Other.getName()
		]);
	}

	function onClear()
	{
		this.m.Victim = null;
		this.m.Other = null;
	}

});

