this.graverobber_finds_item_event <- this.inherit("scripts/events/event", {
	m = {
		Graverobber = null,
		Historian = null,
		UniqueItemName = null,
		NobleName = null
	},
	function create()
	{
		this.m.ID = "event.graverobber_finds_item";
		this.m.Title = "Po drodze...";
		this.m.Cooldown = 9999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_33.png[/img]Pogoda jest piękna. Drobny wieczór, jeśli w ogóle jakiś, dla księżyca, by znajdował się tam, gdzie jest: pomarańczowa skórka przesuwająca się między chmurami - chmurami, które mijają jakby z pozornie niewinnego gestu lekkiego wiatru. Ten sierp księżyca świeci tak jasno, że zastanawiasz się, czy nie zakwitną jakieś kwiaty, biorąc wieczorne światło za jaśniejszego krewnego. Zastanawiasz się, czy ćmy, muchy i chrząszcze w pancerzach widzą księżyc i tańczą ku niemu jak do świecy czy pochodni. Czy mają tę cichą desperację? Tę nieuniknioną okrutność uświadomienia sobie, że gdy twoje życie zestawić z większą całością, to masz i jesteś niczym... oraz nienawiść, jaką to uświadomienie może zrodzić, i zazdrość...\n\nNagle obok ciebie pojawia się %graverobber%, grabarz. Jego zapach przeszywa twoje myśli mroczną skutecznością. To właściwie nie człowiek, lecz golemo-podobna postać, oblepiona błotem i trawą, z dwiema białymi oczami patrzącymi spod osadu. Wzdychasz i pytasz, czego chce. Kciukiem wskazuje za siebie, drugą ręką trzymając łopatę.%SPEECH_ON%Kopałem w jednym czy trzech grobach. Znalazłem coś, i nie mówię tylko o tym, po co są groby. Chcesz zobaczyć?%SPEECH_OFF%Oczywiście, że chcesz...",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Zobaczmy...",
					function getResult( _event )
					{
						return "B";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Graverobber.getImagePath());

				if (_event.m.Historian != null)
				{
					this.Options.push({
						Text = "Sprowadźmy %historian%, historyka, będzie wiedział o skarbach w grobach.",
						function getResult( _event )
						{
							return "C";
						}

					});
				}
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_33.png[/img]%graverobber% prowadzi cię do dużej dziury w ziemi. Na dnie leży górna połowa szkieletu, z ramionami luźno rozłożonymi na ziemi, jakby nocował tu na spoczynku. Puste oczodoły spoglądają w górę. Grabarz kuca i coś wyciąga. Odciera z tego błoto i robaki, po czym podaje ci przedmiot.%SPEECH_ON%Myślę, że możemy to wykorzystać.%SPEECH_OFF%Kiwasz głową, ale mówisz mu, żeby szybko zasypał grób, zanim ktoś zobaczy, co zrobił.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Jemu już się to nie przyda.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Graverobber.getImagePath());
				local r = this.Math.rand(1, 8);
				local item;

				if (r == 1)
				{
					item = this.new("scripts/items/weapons/bludgeon");
				}
				else if (r == 2)
				{
					item = this.new("scripts/items/weapons/falchion");
				}
				else if (r == 3)
				{
					item = this.new("scripts/items/weapons/knife");
				}
				else if (r == 4)
				{
					item = this.new("scripts/items/weapons/dagger");
				}
				else if (r == 5)
				{
					item = this.new("scripts/items/weapons/shortsword");
				}
				else if (r == 6)
				{
					item = this.new("scripts/items/weapons/woodcutters_axe");
				}
				else if (r == 7)
				{
					item = this.new("scripts/items/weapons/scramasax");
				}
				else if (r == 8)
				{
					item = this.new("scripts/items/weapons/hand_axe");
				}

				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Otrzymujesz " + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_33.png[/img]Gdy przyglądasz się znalezisku, %historian%, bystry uczony i historyk, podchodzi obok. Pociera brodę, a z głębi wydobywa się cichy pomruk namysłu.%SPEECH_ON%Tak, tak...%SPEECH_OFF%Odwracasz się do niego, pytając, o co chodzi. Pstryka palcami i wskazuje na to, co znalazł grabarz. Wyjaśnia, że to nie jest zwykła zbroja ani broń, lecz rzeczy słynnego wojownika, szlachcica i kobieciarza, %noblename%.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Fascynujące.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Historian.getImagePath());
				local item;
				local i = this.Math.rand(1, 8);

				if (i == 1)
				{
					item = this.new("scripts/items/shields/named/named_bandit_kite_shield");
				}
				else if (i == 2)
				{
					item = this.new("scripts/items/shields/named/named_bandit_heater_shield");
				}
				else if (i == 3)
				{
					item = this.new("scripts/items/shields/named/named_dragon_shield");
				}
				else if (i == 4)
				{
					item = this.new("scripts/items/shields/named/named_full_metal_heater_shield");
				}
				else if (i == 5)
				{
					item = this.new("scripts/items/shields/named/named_golden_round_shield");
				}
				else if (i == 6)
				{
					item = this.new("scripts/items/shields/named/named_red_white_shield");
				}
				else if (i == 7)
				{
					item = this.new("scripts/items/shields/named/named_rider_on_horse_shield");
				}
				else if (i == 8)
				{
					item = this.new("scripts/items/shields/named/named_wing_shield");
				}

				item.m.Name = _event.m.UniqueItemName;
				this.World.Assets.getStash().makeEmptySlots(1);
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Otrzymujesz " + item.getName()
				});
			}

		});
	}

	function onUpdateScore()
	{
		if (this.World.getTime().IsDaytime)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local candidates_graverobber = [];
		local candidates_historian = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.graverobber")
			{
				candidates_graverobber.push(bro);
			}
			else if (bro.getBackground().getID() == "background.historian")
			{
				candidates_historian.push(bro);
			}
		}

		if (candidates_graverobber.len() == 0)
		{
			return;
		}

		this.m.Graverobber = candidates_graverobber[this.Math.rand(0, candidates_graverobber.len() - 1)];

		if (candidates_historian.len() != 0)
		{
			this.m.Historian = candidates_historian[this.Math.rand(0, candidates_historian.len() - 1)];
		}

		this.m.Score = 5;
	}

	function onPrepare()
	{
		this.m.NobleName = this.Const.Strings.KnightNames[this.Math.rand(0, this.Const.Strings.KnightNames.len() - 1)];
		this.m.UniqueItemName = this.m.NobleName + "\'s Shield";
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"graverobber",
			this.m.Graverobber.getNameOnly()
		]);
		_vars.push([
			"historian",
			this.m.Historian != null ? this.m.Historian.getNameOnly() : ""
		]);
		_vars.push([
			"noblename",
			this.m.NobleName
		]);
		_vars.push([
			"uniqueitem",
			this.m.UniqueItemName
		]);
	}

	function onDetermineStartScreen()
	{
		return "A";
	}

	function onClear()
	{
		this.m.Graverobber = null;
		this.m.Historian = null;
		this.m.UniqueItemName = null;
		this.m.NobleName = null;
	}

});

