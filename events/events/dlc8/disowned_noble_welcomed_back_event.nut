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
			Text = "[img]gfx/ui/events/event_20.png[/img]{Podczas pobytu w %townname% dostajesz list od posłańca. Prosi, byś go nie czytał, ale gdy tylko znika za rogiem, robisz to, łamiąc królewską pieczęć z wosku. Czytasz, że %disowned%, wygnany szlachcic, nie jest już na wygnaniu. Zamiast tego jego miejsce na rodowym tronie czeka, gdy tylko jego ciężko chory ojciec odejdzie.\n\nTrzymasz list w dłoni, niepewny, co z nim zrobić. %disowned% od dawna jest członkiem %companyname%. Dla niektórych jest coś kuszącego w mężczyźnie, który kiedyś bywał w królewskich komnatach, a teraz znalazł się w nizinach kompanii najemników. Ale choć linia krwi może wyschnąć, ród nigdy naprawdę nie umiera...}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Pokażę mu list.",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "Spalę list.",
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
			Text = "[img]gfx/ui/events/event_82.png[/img]{Wzdychając, świadomy tego, co może się wydarzyć, decydujesz się pokazać mu list. Czyta go przez chwilę, potem podnosi wzrok.%SPEECH_ON%Wiem, że to przeczytałeś.%SPEECH_OFF%Podaje ci list z powrotem.%SPEECH_ON%I wiem, że równie dobrze mogłeś go spalić. Ale tego nie zrobiłeś. To tylko potwierdza to, co już wiem: %companyname% to teraz moja rodzina. Jeśli chcesz, żebym został, zostanę; jeśli chcesz, żebym odszedł, odejdę.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Myślę, że powinieneś zostać z nami.",
					function getResult( _event )
					{
						return "C";
					}

				},
				{
					Text = "Powinieneś wrócić do rodziny.",
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
			Text = "[img]gfx/ui/events/event_82.png[/img]{Bierzesz list z powrotem i przystawiasz do pobliskiej świecy. Pali się szybko, popiół strzepuje się z palców, gdy ogień wspina się po papierze. %disowned% kiwa głową.%SPEECH_ON%Cieszę się, że to zrobiłeś. Jeśli moja ojczyzna mnie potrzebuje, wrócę dopiero, gdy zakończę pracę z %companyname%. Do tego czasu masz mój miecz, mój pot i moją krew.%SPEECH_OFF%Uśmiecha się.%SPEECH_ON%Za odpowiednią cenę, oczywiście. Wciąż jestem najemnikiem.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Oczywiście.",
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
						text = _event.m.Disowned.getName() + " jest teraz Regentem w nieobecności"
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
					text = _event.m.Disowned.getName() + " zyskuje [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + melee_defense_boost + "[/color] Obrony w Walce Wręcz"
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
			Text = "[img]gfx/ui/events/event_74.png[/img]{Podajesz mu list z powrotem.%SPEECH_ON%Uważam, że człowiek odsunięty od rodziny bardziej jej potrzebuje, gdy ta go wzywa, i na pewno potrzebują cię bardzo. Twój czas z %companyname% dobiegł końca.%SPEECH_OFF%Początkowo wygnany szlachcic wygląda na przybitego, ale potem zaczyna kiwać głową, zgadzając się, że rodzina go potrzebuje i nie powinien ich zostawiać. Żegna się z tobą i resztą kompanii, ale zanim odejdzie na dobre, przygotował dla ciebie list.%SPEECH_ON%Dziękuję ci, kapitanie. Nie myśl, że odszedłbym bez uznania, jak ważny byłeś w ocaleniu mojego życia, bo właśnie to zrobiłeś, czy zdajesz sobie z tego sprawę, czy nie.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Trzymaj się, %disowned%.",
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
					text = "Kompania zyskała sławę"
				});
			}

		});
		this.m.Screens.push({
			ID = "E",
			Text = "[img]gfx/ui/events/event_98.png[/img]{Nie ma mowy, żebyś pokazał to %disowned%. Natychmiast palisz list i wszystkie informacje o jego przyjęciu z powrotem do rodziny. W tym momencie pojawia się za rogiem. Wygląda na lekko zdezorientowanego i pyta, czy coś jest nie tak. Kręcisz głową i pytasz, czy chce pomóc liczyć zapasy. %disowned% uśmiecha się.%SPEECH_ON%Oczywiście. %companyname% nie może robić tego, co robi, bez dobrego ekwipunku ani bez twojego dowodzenia, kapitanie.%SPEECH_OFF%Gdy masz do niego dołączyć, widzisz posłańca z wcześniej ciągnącego coś ciężkiego. Zostawiasz %disowned% przy zadaniu i podchodzisz do mężczyzny, pytając, co to takiego. Ciągnie ciężką skrzynię i ociera czoło, mówiąc, że to także było przeznaczone dla wygnanego szlachcica. Otwierasz skrzynię kopniakiem i znajdujesz w niej bronie i zbroje, z których część ma rodzinny herb. Dziękujesz posłańcowi, odsyłasz go, po czym w pośpiechu odłamujesz herby i wrzucasz emblematy do rynsztoka, by szlachcic sam ich nie zobaczył. Zaciekawiony, krzyczy z daleka, czy coś jest nie tak. Kręcisz głową.%SPEECH_ON%Nie, nic się nie dzieje. Po prostu dostaliśmy nowy sprzęt, to wszystko.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Nie ma na co patrzeć.",
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

