this.oathtakers_all_oaths_complete_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.oathtakers_all_oaths_complete";
		this.m.Title = "Po drodze...";
		this.m.Cooldown = 999999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_180.png[/img]{Ostatnie Sluby Mlodego Anselma zostaly wypelnione. Swietobiorcy naprawde zasluzyli na swoje imie! Pozostaje tylko jedno pytanie: co dalej? Nigdy nie byliscie pewni, co sie stanie, gdy sluby Pierwszego Swietobiorcy zostana wypelnione, a teraz, gdy to zrobiliscie, cos dociera do ciebie i reszty kompani: trzeba isc dalej. Czemu zawracac teraz? Kto chce wracac do starego, nieprowadzonego zycia? Otepialego i bezwolnego, dryfujacego bez celu? Na pewno nie o to chodzilo Mlodego Anselmowi, gdy zaczynal Ostateczna Sciezke. Mowisz ludziom, ze kazdy Slub ma swoje znaczenie, a moze to wszystkie Sluby razem tworza znaczenie wlasne. Sciezka Swietobiorcy konczy sie wtedy, gdy Swietobiorca tego chce. Patrzysz na grupe ludzi.%SPEECH_ON%Jesli uwazacie sie za wolnych od potrzeby Slubow, prosze, odejdzcie.%SPEECH_OFF%Fala zamyslonych spojrzen na ziemie przechodzi przez grupe. W koncu jeden podnosi wzrok.%SPEECH_ON%Jest tylko jeden sposob, by wyjsc spod przewodnictwa Mlodego Anselma, a to dolaczyc do niego!%SPEECH_OFF%Grupa wiwatuje. Za Mlodego Anselma, za odnalezienie jego szczeki i za zabicie wszystkich Slubodawcow!}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Za Mlodego Anselma!",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					bro.improveMood(2.0, "Ukonczyl wszystkie sluby Mlodego Anselma");

					if (bro.getMoodState() >= this.Const.MoodState.Neutral)
					{
						this.List.push({
							id = 10,
							icon = this.Const.MoodStateIcon[bro.getMoodState()],
							text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
						});
					}

					bro.getBaseProperties().Bravery += 1;
					this.List.push({
						id = 16,
						icon = "ui/icons/bravery.png",
						text = bro.getName() + " zyskuje [color=" + this.Const.UI.Color.PositiveEventValue + "]+1[/color] Determinacji"
					});
				}
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Paladins)
		{
			return;
		}

		if (this.World.Assets.getOrigin().getID() != "scenario.paladins")
		{
			return;
		}

		local all_oaths_complete = this.World.Ambitions.getAmbition("ambition.oath_of_camaraderie").isDone() && this.World.Ambitions.getAmbition("ambition.oath_of_distinction").isDone() && this.World.Ambitions.getAmbition("ambition.oath_of_dominion").isDone() && this.World.Ambitions.getAmbition("ambition.oath_of_endurance").isDone() && this.World.Ambitions.getAmbition("ambition.oath_of_fortification").isDone() && this.World.Ambitions.getAmbition("ambition.oath_of_honor").isDone() && this.World.Ambitions.getAmbition("ambition.oath_of_humility").isDone() && this.World.Ambitions.getAmbition("ambition.oath_of_righteousness").isDone() && this.World.Ambitions.getAmbition("ambition.oath_of_sacrifice").isDone() && this.World.Ambitions.getAmbition("ambition.oath_of_valor").isDone() && this.World.Ambitions.getAmbition("ambition.oath_of_vengeance").isDone() && this.World.Ambitions.getAmbition("ambition.oath_of_wrath").isDone();

		if (!all_oaths_complete)
		{
			return;
		}

		this.m.Score = 600;
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

