this.training_accident_event <- this.inherit("scripts/events/event", {
	m = {
		ClumsyGuy = null,
		OtherGuy1 = null,
		OtherGuy2 = null
	},
	function create()
	{
		this.m.ID = "event.training_accident";
		this.m.Title = "Podczas obozu...";
		this.m.Cooldown = 16.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Przynajmniej się nie zabił.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.ClumsyGuy.getImagePath());
				local r = this.Math.rand(1, 6);
				local injury;

				if (r == 1)
				{
					this.Text = "[img]gfx/ui/events/event_19.png[/img]Podczas treningu %clumsyguy%, nie będąc najzręczniejszym z ludzi, zdołał zranić się własną bronią.";
					injury = _event.m.ClumsyGuy.addInjury(this.Const.Injury.Accident1);
					this.List = [
						{
							id = 10,
							icon = injury.getIcon(),
							text = _event.m.ClumsyGuy.getName() + " doznaje " + injury.getNameOnly()
						}
					];
				}
				else if (r == 2)
				{
					this.Text = "[img]gfx/ui/events/event_34.png[/img]W trakcie podróży lubisz utrzymywać ludzi w formie okazjonalnymi ćwiczeniami. Niestety, podczas treningu riposty %clumsyguy% wbił sobie broń w stopę. Wygląda na to, że jeszcze bardziej bolał go wstyd.";
					_event.m.ClumsyGuy.addLightInjury();
					this.List.push({
						id = 10,
						icon = "ui/icons/days_wounded.png",
						text = _event.m.ClumsyGuy.getName() + " odnosi lekkie rany"
					});
				}
				else if (r == 3)
				{
					this.Text = "[img]gfx/ui/events/event_34.png[/img]Podczas spisywania zapasów prosisz %clumsyguy%, by przeniósł kołczan strzał. Krótka, prosta droga kończy się potknięciem o kamień i zamienieniem siebie w poduszkę na szpilki.";
					injury = _event.m.ClumsyGuy.addInjury(this.Const.Injury.Accident2);
					this.List = [
						{
							id = 10,
							icon = injury.getIcon(),
							text = _event.m.ClumsyGuy.getName() + " doznaje " + injury.getNameOnly()
						}
					];
				}
				else if (r == 4)
				{
					this.Text = "[img]gfx/ui/events/event_34.png[/img]Zastajesz mocno pijanego %clumsyguy%, który trzyma się za bok twarzy. %otherguy1% wyjaśnia, że ten idiota próbował tańczyć po serii kamieni, tylko po to, by się przewrócić i rozwalić sobie twarz. Świetnie.";
					injury = _event.m.ClumsyGuy.addInjury(this.Const.Injury.Accident3);
					this.List = [
						{
							id = 10,
							icon = injury.getIcon(),
							text = _event.m.ClumsyGuy.getName() + " doznaje " + injury.getNameOnly()
						}
					];
				}
				else if (r == 5)
				{
					this.Text = "[img]gfx/ui/events/event_34.png[/img]Gdy %otherguy1% i %otherguy2% trenują, %clumsyguy% wchodzi między nich, wykładając, jak robić to poprawnie, jednocześnie nie patrząc, gdzie idzie. Zabłąkany drewniany miecz spotyka się z jego twarzą i chwilę później idiota jest nieprzytomny.";
					injury = _event.m.ClumsyGuy.addInjury(this.Const.Injury.Accident3);
					this.List = [
						{
							id = 10,
							icon = injury.getIcon(),
							text = _event.m.ClumsyGuy.getName() + " doznaje " + injury.getNameOnly()
						}
					];
				}
				else
				{
					this.Text = "[img]gfx/ui/events/event_34.png[/img]Wygląda na to, że %clumsyguy% wypił trochę za dużo, zanim wziął udział w dzisiejszym sparingu. Jak ci wyjaśniono, pijak pomylił drzewo z wrogim wojownikiem. Następnie, jak głosi opowieść, ruszył na nie z szarżą i przy okazji się znokautował.";
					_event.m.ClumsyGuy.addLightInjury();
					this.List.push({
						id = 10,
						icon = "ui/icons/days_wounded.png",
						text = _event.m.ClumsyGuy.getName() + " odnosi lekkie rany"
					});
				}
			}

		});
	}

	function onUpdateScore()
	{
		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 3)
		{
			return;
		}

		local candidates = [];

		foreach( bro in brothers )
		{
			if ((bro.getSkills().hasSkill("trait.clumsy") || bro.getSkills().hasSkill("trait.drunkard") || bro.getSkills().hasSkill("trait.addict")) && !bro.getSkills().hasSkillOfType(this.Const.SkillType.TemporaryInjury))
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() == 0)
		{
			return;
		}

		this.m.ClumsyGuy = candidates[this.Math.rand(0, candidates.len() - 1)];
		this.m.Score = candidates.len() * 8;

		foreach( bro in brothers )
		{
			if (bro.getID() != this.m.ClumsyGuy.getID())
			{
				this.m.OtherGuy1 = bro;
				break;
			}
		}

		foreach( bro in brothers )
		{
			if (bro.getID() != this.m.ClumsyGuy.getID() && bro.getID() != this.m.OtherGuy1.getID())
			{
				this.m.OtherGuy2 = bro;
				break;
			}
		}
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"clumsyguy",
			this.m.ClumsyGuy.getName()
		]);
		_vars.push([
			"otherguy1",
			this.m.OtherGuy1.getName()
		]);
		_vars.push([
			"otherguy2",
			this.m.OtherGuy2.getName()
		]);
	}

	function onClear()
	{
		this.m.ClumsyGuy = null;
		this.m.OtherGuy1 = null;
		this.m.OtherGuy2 = null;
	}

});

