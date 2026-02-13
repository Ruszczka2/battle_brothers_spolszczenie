this.glutton_eats_apple_event <- this.inherit("scripts/events/event", {
	m = {
		Glutton = null,
		Other = null
	},
	function create()
	{
		this.m.ID = "event.glutton_eats_apple";
		this.m.Title = "W obozie...";
		this.m.Cooldown = 60.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_18.png[/img]{Trafiasz na zamieszanie między %glutton%em, żarłokiem, a wiadrem. Wymiotuje do niego tak mocno, że plecy wyginają mu się jak u kota, a odgłosy zwracania brzmią jak nieumarła krowa rodząca cielę. Gdy podnosi głowę, jego twarz wygląda jak dynia, policzki ma nabrzmiałe, a usta wciąż bulgoczą. Podchodzi %otherbrother%.%SPEECH_ON%Zjadł jabłko wiedźmy.%SPEECH_OFF%Unosząc brew, pytasz żarłoka, czemu zrobił coś takiego. Nitki wymiocin wiją się z jego nadgarstka, gdy przeciera oczy.%SPEECH_ON%{Bo ja zawsze jestem głod-hurgh, uh, głodnerrrghhh! | Nie wiem, panie, czy nie mogę po prostu cierpieć bez tłumaczenia mojego czynu-iiiherrrghh! | Czy musiałbym się tłumaczyć, gdybym nie rzygerrrghhhh! | Bo kazałeś mi jeść zdrowo, a to było jabbłerrrghghh!}%SPEECH_OFF%Wkłada głowę z powrotem do wiadra jak człowiek, który wrzucił do studni milion koron. Każesz najemnikom mieć go na oku, dopóki to nie wyjdzie z jego organizmu, o ile w ogóle.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Dlaczego...?",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Glutton.getImagePath());
				local stash = this.World.Assets.getStash().getItems();

				foreach( i, item in stash )
				{
					if (item != null && item.getID() == "misc.poisoned_apple")
					{
						stash[i] = null;
						this.List.push({
							id = 10,
							icon = "ui/items/" + item.getIcon(),
							text = "Tracisz " + item.getName()
						});
						break;
					}
				}

				local effect = this.new("scripts/skills/injury/sickness_injury");
				_event.m.Glutton.getSkills().add(effect);
				this.List.push({
					id = 10,
					icon = effect.getIcon(),
					text = _event.m.Glutton.getName() + " jest chory"
				});
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Unhold)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 2)
		{
			return;
		}

		local candidates_glutton = [];
		local candidates_other = [];

		foreach( bro in brothers )
		{
			if (bro.getSkills().hasSkill("trait.player"))
			{
				continue;
			}

			if (bro.getSkills().hasSkill("trait.gluttonous"))
			{
				candidates_glutton.push(bro);
			}
			else
			{
				candidates_other.push(bro);
			}
		}

		if (candidates_glutton.len() == 0 || candidates_other.len() == 0)
		{
			return;
		}

		local stash = this.World.Assets.getStash().getItems();
		local hasItem = false;

		foreach( item in stash )
		{
			if (item != null && item.getID() == "misc.poisoned_apple")
			{
				hasItem = true;
				break;
			}
		}

		if (!hasItem)
		{
			return;
		}

		this.m.Glutton = candidates_glutton[this.Math.rand(0, candidates_glutton.len() - 1)];
		this.m.Other = candidates_other[this.Math.rand(0, candidates_other.len() - 1)];
		this.m.Score = candidates_glutton.len() * 5;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"glutton",
			this.m.Glutton.getNameOnly()
		]);
		_vars.push([
			"otherbrother",
			this.m.Other.getName()
		]);
	}

	function onClear()
	{
		this.m.Glutton = null;
		this.m.Other = null;
	}

});

