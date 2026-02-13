this.lucky_finds_something_event <- this.inherit("scripts/events/event", {
	m = {
		Lucky = null,
		FoundItem = null
	},
	function create()
	{
		this.m.ID = "event.lucky_finds_something";
		this.m.Title = "Po drodze...";
		this.m.Cooldown = 35.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "%terrainImage%{%lucky%, jak zawsze szczęśliwy najemnik, znalazł coś interesującego. Pytasz, jak natknął się na ten przedmiot. Wzrusza ramionami.%SPEECH_ON%{Szłem i nagle na to nadepnąłem. Proste. | Spojrzałem w górę i ptak narobił, ledwo mnie minęło. Gdy spojrzałem, gdzie spadło, no i było. Ptasia kupa i to coś, co masz w rękach. | Poczułem mrowienie w palcach, a potem mrowienie w fiucie. Potem rozejrzałem się za czymś nudnym, żeby się uspokoić, i zobaczyłem to leżące tam. | Zobaczyłem podkowę leżącą na ziemi i pomyślałem, żeby ją podnieść, a pod spodem było to. | No widzisz, zauważyłem tę czterolistną koniczynę i miałem ją wrzucić do sakwy, mam ich mnóstwo, a kiedy już się schyliłem, zobaczyłem ten przedmiot leżący obok. Sprytne, co?}%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Ale masz szczęście.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Lucky.getImagePath());
				this.World.Assets.getStash().add(_event.m.FoundItem);
				this.List.push({
					id = 10,
					icon = "ui/items/" + _event.m.FoundItem.getIcon(),
					text = "Zyskujesz " + this.Const.Strings.getArticle(_event.m.FoundItem.getName()) + _event.m.FoundItem.getName()
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

		if (!this.World.getTime().IsDaytime)
		{
			return;
		}

		if (!this.World.Assets.getStash().hasEmptySlot())
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getSkills().hasSkill("trait.lucky"))
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() == 0)
		{
			return;
		}

		this.m.Lucky = candidates[this.Math.rand(0, candidates.len() - 1)];
		this.m.Score = 5;
	}

	function onPrepare()
	{
		local item;
		local r = this.Math.rand(1, 19);

		if (r == 1)
		{
			item = this.new("scripts/items/weapons/militia_spear");
		}
		else if (r == 2)
		{
			item = this.new("scripts/items/armor/patched_mail_shirt");
		}
		else if (r == 3)
		{
			item = this.new("scripts/items/helmets/dented_nasal_helmet");
		}
		else if (r == 4)
		{
			item = this.new("scripts/items/helmets/mail_coif");
		}
		else if (r == 5)
		{
			item = this.new("scripts/items/helmets/cultist_hood");
		}
		else if (r == 6)
		{
			item = this.new("scripts/items/helmets/full_leather_cap");
		}
		else if (r == 7)
		{
			item = this.new("scripts/items/armor/ragged_surcoat");
		}
		else if (r == 8)
		{
			item = this.new("scripts/items/armor/noble_tunic");
		}
		else if (r == 9)
		{
			item = this.new("scripts/items/misc/ghoul_horn_item");
		}
		else if (r == 10)
		{
			item = this.new("scripts/items/weapons/knife");
		}
		else if (r == 11)
		{
			item = this.new("scripts/items/misc/wardog_armor_upgrade_item");
		}
		else if (r == 12)
		{
			item = this.new("scripts/items/armor_upgrades/joint_cover_upgrade");
		}
		else if (r == 13)
		{
			item = this.new("scripts/items/tools/throwing_net");
		}
		else if (r == 14)
		{
			item = this.new("scripts/items/weapons/throwing_spear");
		}
		else if (r == 15)
		{
			item = this.new("scripts/items/weapons/hatchet");
		}
		else if (r == 16)
		{
			item = this.new("scripts/items/weapons/lute");
		}
		else if (r == 17)
		{
			item = this.new("scripts/items/armor/thick_dark_tunic");
		}
		else if (r == 18)
		{
			item = this.new("scripts/items/armor_upgrades/mail_patch_upgrade");
		}
		else if (r == 19)
		{
			item = this.new("scripts/items/misc/paint_black_item");
		}

		if (item.getConditionMax() > 1)
		{
			item.setCondition(this.Math.max(1, item.getConditionMax() * this.Math.rand(10, 40) * 0.01));
		}

		this.m.FoundItem = item;
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"lucky",
			this.m.Lucky.getNameOnly()
		]);
		_vars.push([
			"finding",
			this.Const.Strings.getArticle(this.m.FoundItem.getName()) + this.m.FoundItem.getName()
		]);
	}

	function onClear()
	{
		this.m.Lucky = null;
		this.m.FoundItem = null;
	}

});

