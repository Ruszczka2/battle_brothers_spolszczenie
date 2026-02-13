this.disowned_noble_welcomed_back_event <- this.inherit("scripts/events/event", {
	m = {
		Disowned = null,
		Town = null
	},
	function create()
	{
		this.m.ID = "event.disowned_noble_welcomed_back";
		this.m.Title = "W %townname%";
		this.m.Cooldown = 999999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_20.png[/img]{Podczas pobytu w %townname% dostajesz list od poslanca. Prosi, bys go nie czytal, ale gdy tylko znika za rogiem, robisz to, lamac krolewska pieczec z wosku. Czytasz, ze %disowned%, wygnany szlachcic, nie jest juz na wygnaniu. Zamiast tego jego miejsce na rodowym tronie czeka, gdy tylko jego ciezko chory ojciec odejdzie.\n\nTrzymasz list w dloni, niepewny, co z nim zrobic. %disowned% od dawna jest czlonkiem %companyname%. Dla niektorych jest cos kuszacego w mezczyznie, ktory kiedys bywal w krolewskich komnatach, a teraz znalazl sie w nizinach kompanii najemnikow. Ale choc linia krwi moze wyschnac, rod nigdy naprawde nie umiera...}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Pokaze mu list.",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "Spale list.",
					function getResult( _event )
					{
						return "E";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Disowned.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_82.png[/img]{Wzdychajac, swiadomy tego, co moze sie wydarzyc, decydujesz sie pokazac mu list. Czyta go przez chwile, potem podnosi wzrok.%SPEECH_ON%Wiem, ze to przeczytales.%SPEECH_OFF%Podaje ci list z powrotem.%SPEECH_ON%I wiem, ze rownie dobrze mogles go spalic. Ale tego nie zrobiles. To tylko potwierdza to, co juz wiem: %companyname% to teraz moja rodzina. Jesli chcesz, zebym zostal, zostane; jesli chcesz, zebym odszedl, odejde.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Mysle, ze powinienes zostac z nami.",
					function getResult( _event )
					{
						return "C";
					}

				},
				{
					Text = "Powinienes wrocic do rodziny.",
					function getResult( _event )
					{
						return "D";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Disowned.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_82.png[/img]{Bierzesz list z powrotem i przystawiasz do pobliskiej swiecy. Pali sie szybko, popiol strzepuje sie z palcow, gdy ogien wspina sie po papierze. %disowned% kiwa glowa.%SPEECH_ON%Ciesze sie, ze to zrobiles. Jesli moja ojczyzna mnie potrzebuje, wroce dopiero, gdy zakoncze prace z %companyname%. Do tego czasu masz moj miecz, moj pot i moja krew.%SPEECH_OFF%Usmiecha sie.%SPEECH_ON%Za odpowiednia cene, oczywiscie. Wciaz jestem najemnikiem.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Oczywiscie.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Disowned.getImagePath());
				local background = this.new("scripts/skills/backgrounds/regent_in_absentia_background");
				_event.m.Disowned.getSkills().removeByID("background.disowned_noble");
				_event.m.Disowned.getSkills().add(background);
				_event.m.Disowned.m.Background = background;
				background.buildDescription();
				this.List = [
					{
						id = 13,
						icon = background.getIcon(),
						text = _event.m.Disowned.getName() + " jest teraz Regentem w nieobecnosci"
					}
				];
				local resolve_boost = this.Math.rand(10, 15);
				local initiative_boost = this.Math.rand(6, 10);
				local melee_defense_boost = this.Math.rand(2, 4);
				local ranged_defense_boost = this.Math.rand(3, 5);
				_event.m.Disowned.getBaseProperties().Bravery += resolve_boost;
				_event.m.Disowned.getBaseProperties().Initiative += initiative_boost;
				_event.m.Disowned.getBaseProperties().MeleeDefense += melee_defense_boost;
				_event.m.Disowned.getBaseProperties().RangedDefense += ranged_defense_boost;
				_event.m.Disowned.getSkills().update();
				this.List.push({
					id = 16,
					icon = "ui/icons/bravery.png",
					text = _event.m.Disowned.getName() + " zyskuje [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + resolve_boost + "[/color] Determinacji"
				});
				this.List.push({
					id = 16,
					icon = "ui/icons/initiative.png",
					text = _event.m.Disowned.getName() + " zyskuje [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + initiative_boost + "[/color] Inicjatywy"
				});
				this.List.push({
					id = 16,
					icon = "ui/icons/melee_defense.png",
					text = _event.m.Disowned.getName() + " zyskuje [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + melee_defense_boost + "[/color] Obrony w Walce Wrecz"
				});
				this.List.push({
					id = 16,
					icon = "ui/icons/ranged_defense.png",
					text = _event.m.Disowned.getName() + " zyskuje [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + ranged_defense_boost + "[/color] Obrony w Walce Dystansowej"
				});
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_74.png[/img]{Podajesz mu list z powrotem.%SPEECH_ON%Uwazam, ze czlowiek odsuniety od rodziny bardziej jej potrzebuje, gdy ta go wzywa, i na pewno potrzebuja cie bardzo. Twoj czas z %companyname% dobiegł konca.%SPEECH_OFF%Poczatkowo wygnany szlachcic wyglada na przybitego, ale potem zaczyna kiwac glowa, zgadzajac sie, ze rodzina go potrzebuje i nie powinien ich zostawiac. Zegna sie z toba i reszta kompanii, ale zanim odejdzie na dobre, przygotowal dla ciebie list.%SPEECH_ON%Dziekuje ci, kapitanie. Nie mysl, ze odszedlbym bez uznania, jak wazny byles w ocaleniu mojego zycia, bo wlasnie to zrobiles, czy zdajesz sobie z tego sprawe, czy nie.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Trzymaj sie, %disowned%.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.List.push({
					id = 13,
					icon = "ui/icons/kills.png",
					text = _event.m.Disowned.getName() + " opuszcza " + this.World.Assets.getName()
				});
				_event.m.Disowned.getItems().transferToStash(this.World.Assets.getStash());
				_event.m.Disowned.getSkills().onDeath(this.Const.FatalityType.None);
				this.World.getPlayerRoster().remove(_event.m.Disowned);
				this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnAmbition);
				this.List.insert(0, {
					id = 10,
					icon = "ui/icons/special.png",
					text = "Kompania zyskala slawe"
				});
			}

		});
		this.m.Screens.push({
			ID = "E",
			Text = "[img]gfx/ui/events/event_98.png[/img]{Nie ma mowy, zebys pokazal to %disowned%. Natychmiast palisz list i wszystkie informacje o jego przyjeciu z powrotem do rodziny. W tym momencie pojawia sie za rogiem. Wyglada na lekko zdezorientowanego i pyta, czy cos jest nie tak. Krecisz glowa i pytasz, czy chce pomoc liczyc zapasy. %disowned% usmiecha sie.%SPEECH_ON%Oczywiscie. %companyname% nie moze robic tego, co robi, bez dobrego ekwipunku ani bez twojego dowodzenia, kapitanie.%SPEECH_OFF%Gdy masz do niego dolaczyc, widzisz poslańca z wczesniej ciagnacego cos ciezkiego. Zostawiasz %disowned% przy zadaniu i podchodzisz do mezczyzny, pytajac, co to takiego. Ciagnie ciezka skrzynie i ociera czolo, mowiac, ze to takze bylo przeznaczone dla wygnanego szlachcica. Otwierasz skrzynie kopniakiem i znajdujesz w niej bronie i zbroje, z ktorych czesc ma rodzinny herb. Dziekujesz poslancowi, odsylasz go, po czym w pospiechu odlamujesz herby i wrzucasz emblematy do rynsztoka, by szlachcic sam ich nie zobaczyl. Zaciekawiony, krzyczy z daleka, czy cos jest nie tak. Krecisz glowa.%SPEECH_ON%Nie, nic sie nie dzieje. Po prostu dostalismy nowy sprzet, to wszystko.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Nie ma na co patrzec.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local item;
				local stash = this.World.Assets.getStash();
				local armor_list = [
					"mail_hauberk",
					"reinforced_mail_hauberk"
				];

				if (this.Const.DLC.Unhold)
				{
					armor_list.extend([
						"footman_armor",
						"light_scale_armor",
						"sellsword_armor",
						"noble_mail_armor"
					]);
				}

				local weapons_list = [
					"noble_sword",
					"fighting_spear",
					"fighting_axe",
					"warhammer",
					"winged_mace",
					"arming_sword",
					"warbrand"
				];
				item = this.new("scripts/items/armor/" + armor_list[this.Math.rand(0, armor_list.len() - 1)]);
				stash.add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Zyskujesz " + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
				item = this.new("scripts/items/weapons/" + weapons_list[this.Math.rand(0, weapons_list.len() - 1)]);
				stash.add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Zyskujesz " + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
				item = this.new("scripts/items/weapons/" + weapons_list[this.Math.rand(0, weapons_list.len() - 1)]);
				stash.add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Zyskujesz " + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Paladins)
		{
			return;
		}

		local towns = this.World.EntityManager.getSettlements();
		local nearTown = false;
		local town;
		local playerTile = this.World.State.getPlayer().getTile();

		foreach( t in towns )
		{
			if (t.getTile().getDistanceTo(playerTile) <= 3 && t.isAlliedWithPlayer())
			{
				nearTown = true;
				town = t;
				break;
			}
		}

		if (!nearTown)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local disowned_candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.disowned_noble" && bro.getLevel() >= 6)
			{
				disowned_candidates.push(bro);
			}
		}

		if (disowned_candidates.len() == 0)
		{
			return;
		}

		this.m.Disowned = disowned_candidates[this.Math.rand(0, disowned_candidates.len() - 1)];
		this.m.Town = town;
		this.m.Score = 4 * disowned_candidates.len();
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"disowned",
			this.m.Disowned.getNameOnly()
		]);
		_vars.push([
			"townname",
			this.m.Town.getName()
		]);
	}

	function onClear()
	{
		this.m.Disowned = null;
		this.m.Town = null;
	}

});

