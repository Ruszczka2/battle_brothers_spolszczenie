this.beggar_begs_event <- this.inherit("scripts/events/event", {
	m = {
		Beggar = null,
		OtherGuy = null
	},
	function create()
	{
		this.m.ID = "event.beggar_begs";
		this.m.Title = "Podczas obozu...";
		this.m.Cooldown = 14.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_05.png[/img]{Gdy robisz przegląd ekwipunku, nie możesz nie zauważyć %beggar%, który kręci się na obrzeżach twojego pola widzenia. Wzdychasz, w końcu odwracasz się do byłego żebraka i pytasz, czego chce. Jak najbiedniejszy z biednych wyciąga rękę, pytając, czy mógłbyś mu odstąpić kilka koron. | Z wyćwiczoną teatralnością %beggar% podchodzi i zaczyna długą opowieść o kłopotach, kłótniach i pustych butelkach. Były żebrak ma, jak twierdzi, pecha i potrzebuje tylko kilku dodatkowych koron, by jakoś przetrwać. | %otherguy% mówi ci, że %beggar% chodzi po obozie i prosi o korony. Najwyraźniej byłemu żebrakowi brakuje tylko odrobiny, więc każdemu, kto zechce słuchać, snuje długą, żałosną opowieść. Słysząc to, sam idziesz do niego, ale zanim zdążysz cokolwiek powiedzieć, człowiek rozpoczyna swoją historię. Gdy kończy, patrzy ci w oczy, próbując wyczuć, czy coś mu dasz. | Najwyraźniej %beggar%, były żebrak, potrzebuje pomocy. Przyszedł do ciebie, prosząc o kilka koron, by jakoś przetrwać. Wygląda na kiepski stan, ale ma za sobą sporo praktyki w byciu biednym, więc trudno powiedzieć, czy mówi prawdę.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Wracaj do pracy!",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "Proszę, weź kilka koron.",
					function getResult( _event )
					{
						return "C";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Beggar.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_05.png[/img]{Mówisz żebrakowi, że przetniesz mu dłonie mieczem, jeśli nie wróci do pracy. Wzrusza ramionami i w zasadzie robi to, co mu kazałeś. Poszło łatwiej, niż się spodziewałeś. | Ramiona żebraka opadają, gdy każesz mu wrócić do pracy. Czujesz się trochę źle, ale potem przypominasz sobie, że tak właśnie cię podchodzą.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Dobrze.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Beggar.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_05.png[/img]{Żebrak bierze korony i z uśmiechem wraca do pracy. | Zmęczony jego gierkami, dajesz żebrakowi kilka koron i każesz mu wrócić do pracy. Kłania się i dziękuje, a co zaskakujące, naprawdę wraca do pracy.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Dobrze.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Beggar.getImagePath());
				this.World.Assets.addMoney(-10);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Wydajesz [color=" + this.Const.UI.Color.NegativeEventValue + "]10[/color] koron"
				});
				_event.m.Beggar.improveMood(0.5, "Dostał od ciebie kilka dodatkowych koron");

				if (_event.m.Beggar.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Beggar.getMoodState()],
						text = _event.m.Beggar.getName() + this.Const.MoodStateEvent[_event.m.Beggar.getMoodState()]
					});
				}
			}

		});
	}

	function onUpdateScore()
	{
		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 2)
		{
			return;
		}

		local candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.beggar")
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() == 0)
		{
			return;
		}

		this.m.Beggar = candidates[this.Math.rand(0, candidates.len() - 1)];
		this.m.Score = candidates.len() * 5;

		do
		{
			local bro = brothers[this.Math.rand(0, brothers.len() - 1)];

			if (bro.getID() != this.m.Beggar.getID())
			{
				this.m.OtherGuy = bro;
			}
		}
		while (this.m.OtherGuy == null);
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"beggar",
			this.m.Beggar.getNameOnly()
		]);
		_vars.push([
			"otherguy",
			this.m.OtherGuy.getName()
		]);
	}

	function onDetermineStartScreen()
	{
		return "A";
	}

	function onClear()
	{
		this.m.Beggar = null;
		this.m.OtherGuy = null;
	}

});

