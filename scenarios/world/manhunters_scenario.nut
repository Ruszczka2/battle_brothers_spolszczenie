this.manhunters_scenario <- this.inherit("scripts/scenarios/world/starting_scenario", {
	m = {},
	function create()
	{
		this.m.ID = "scenario.manhunters";
		this.m.Name = "Łowcy Głów";
		this.m.Description = "[p=c][img]gfx/ui/events/event_172.png[/img][/p][p]Dzięki ciągłym konfliktom pomiędzy koczownikami, państwami-miastami i włóczęgami interes kwitnie. Trzonem twej grupy są pojmani, zmuszeni do walki, by zasłużyć sobie na wolność.\n\n[color=#bcad8c]Armia Pojmanych:[/color] Zaczynasz z dwoma łowcami głów i czterema zadłużonymi. Możesz wystawić do bitwy 16 ludzi. Gdy w grupie będzie połowa lub mniej zadłużonych, twoi ludzie będą niezadowoleni.\n[color=#bcad8c]Nadzorcy:[/color] Wszyscy nie-zadłużeni mogą biczować zadłużonych w walce, by poprawić ich statystyki.\n[color=#bcad8c]Jeńcy:[/color] Zadłużeni otrzymują o 25% mniej dośw., awansują do maks. 7 poziomu i zginą, gdy zostaną powaleni.[/p]";
		this.m.Difficulty = 3;
		this.m.Order = 89;
		this.m.IsFixedLook = true;
	}

	function isValid()
	{
		return this.Const.DLC.Desert;
	}

	function onSpawnAssets()
	{
		local roster = this.World.getPlayerRoster();
		local names = [];

		for( local i = 0; i < 6; i = i )
		{
			local bro;
			bro = roster.create("scripts/entity/tactical/player");
			bro.m.HireTime = this.Time.getVirtualTimeF();
			i = ++i;
		}

		local bros = roster.getAll();
		local talents;
		bros[0].setStartValuesEx([
			"manhunter_background"
		]);
		bros[0].setTitle("Stoicki");
		bros[0].getBackground().m.RawDescription = "{W pewnym sensie %name% jest ci obojętny. Nie jest ani nienawistny, ani pobłażliwy wobec jeńców wojennych, przestępców i tym podobnych. Po prostu zajmuje się swoim fachem. Jest też jednak wobec ciebie dziwnie spokojny i uporczywy, co jest dość krępujące. Ma w sobie mnóstwo potencjału, dlatego właśnie wziąłeś go ze sobą, choć chciałbyś, aby od czasu do czasu przejawiał nieco zapału.}";
		bros[0].setPlaceInFormation(12);
		local items = bros[0].getItems();
		items.unequip(items.getItemAtSlot(this.Const.ItemSlot.Mainhand));
		items.unequip(items.getItemAtSlot(this.Const.ItemSlot.Head));
		items.equip(this.new("scripts/items/weapons/oriental/light_southern_mace"));
		bros[0].getSkills().add(this.new("scripts/skills/actives/whip_slave_skill"));
		bros[0].m.Talents = [];
		talents = bros[0].getTalents();
		talents.resize(this.Const.Attributes.COUNT, 0);
		talents[this.Const.Attributes.MeleeSkill] = 1;
		talents[this.Const.Attributes.Bravery] = 2;
		talents[this.Const.Attributes.RangedDefense] = 1;
		local traits = bros[0].getSkills().getAllSkillsOfType(this.Const.SkillType.Trait);

		foreach( t in traits )
		{
			if (!t.isType(this.Const.SkillType.Special) && !t.isType(this.Const.SkillType.Background))
			{
				bros[0].getSkills().remove(t);
			}
		}

		bros[1].setStartValuesEx([
			"manhunter_background"
		]);
		bros[1].setTitle("Bicz");
		bros[1].getBackground().m.RawDescription = "{%name% jest jednym z najgorszych ludzi, jakie dane ci było poznać. Jego brutalność jest niepohamowana, nawet według twoich standardów, a nawet sam jest bezpośrednio odpowiedzialny za zabicie kilku świeżo pojmanych. Znaczy, że jego podłość dobrze przysłuży się kompanii. Do tego kilkukrotnie osobiście wybatożyłeś go za starty w inwentarzu, więc wiesz, że nieźle znosi ból.}";
		bros[1].setPlaceInFormation(13);
		local items = bros[1].getItems();
		items.unequip(items.getItemAtSlot(this.Const.ItemSlot.Mainhand));
		items.unequip(items.getItemAtSlot(this.Const.ItemSlot.Offhand));
		items.unequip(items.getItemAtSlot(this.Const.ItemSlot.Head));
		items.equip(this.new("scripts/items/helmets/oriental/southern_head_wrap"));
		items.equip(this.new("scripts/items/weapons/battle_whip"));
		bros[1].getSkills().add(this.new("scripts/skills/actives/whip_slave_skill"));
		bros[1].worsenMood(0.0, "Zirytowany twoją reprymendą, żeby nie znęcać się nad pojmanymi");
		bros[1].m.Talents = [];
		talents = bros[1].getTalents();
		talents.resize(this.Const.Attributes.COUNT, 0);
		talents[this.Const.Attributes.Fatigue] = 2;
		talents[this.Const.Attributes.MeleeSkill] = 1;
		talents[this.Const.Attributes.Hitpoints] = 1;
		bros[2].setStartValuesEx([
			"slave_southern_background"
		]);
		bros[2].setTitle("Uczony");
		bros[2].getBackground().m.RawDescription = "{Gdy go znalazłeś, %name% był otoczony przez strażników miejskich. Wyglądało na to, że chcą zabawić się w grę zwaną \'złap bułata\' z jego nadgarstkami, póki im nie przerwałeś, twierdząc, że ten człowiek ma dług przede wszystkim wobec Złotnika. Miałeś nadzieję odsprzedać go za dobrą sumkę któremuś z Wezyrów, lecz nikt nie chciał go kupić, bo był zbyt \'uczony\' i sprawiał wrażenie kogoś, kto mógłby rozpocząć bunt. Co dość nietypowe dla ludzi jego pokroju, wydaje się mieć wobec ciebie sporo szacunku..}";
		bros[2].setPlaceInFormation(2);
		bros[2].getSkills().removeByID("trait.dumb");
		bros[2].getSkills().add(this.new("scripts/skills/traits/bright_trait"));
		bros[2].getSprite("miniboss").setBrush("bust_miniboss_indebted");
		local items = bros[2].getItems();
		items.unequip(items.getItemAtSlot(this.Const.ItemSlot.Mainhand));
		items.equip(this.new("scripts/items/weapons/wooden_stick"));
		items.equip(this.new("scripts/items/helmets/oriental/nomad_head_wrap"));
		bros[2].worsenMood(0.0, "Tęskni za swymi księgami");
		bros[3].setStartValuesEx([
			"slave_background"
		]);
		bros[3].setTitle("z Północy");
		bros[3].getBackground().m.RawDescription = "{Niezbyt przyjacielski typ, ale od czego są kajdany? %name% był już na pieńku za szereg przestępstw, gdy się na niego natknąłeś. Zapłaciłeś za niego, traktując to jako inwestycję i zaznaczając, że teraz musi ciężko pracować, by w oczach Złotnika zasłużyć na odkupienie. Nie jest do końca przekonany, czy sam w to wierzysz, ale zapłaciłeś kapłanowi w ramach potwierdzenia, że zaiste jego życie i znój należą teraz do wyższych podniosłości.}";
		bros[3].setPlaceInFormation(3);
		bros[3].getSprite("miniboss").setBrush("bust_miniboss_indebted");
		local items = bros[3].getItems();
		items.unequip(items.getItemAtSlot(this.Const.ItemSlot.Mainhand));
		items.equip(this.new("scripts/items/weapons/bludgeon"));
		bros[3].worsenMood(2.0, "Prawie został ścięty");
		bros[3].improveMood(2.0, "Ulżyło mu, że uniknął egzekucji");
		bros[3].worsenMood(0.0, "Niepokoi się tym, co go czeka");
		bros[4].setStartValuesEx([
			"slave_southern_background"
		]);
		bros[4].setTitle("Dezerter");
		bros[4].getBackground().m.RawDescription = "{%name% jest dziedzictwem herezji, człowiekiem podarowanym ci przez jednego z kapłanów Wezyra. Był dezerterem z armii księcia, lecz dzięki swym bogatym koneksjom uniknął katowskiego topora. Jednakże jest tylko jeden sposób, by uniknąć ogni piekielnych, czyli spłacenie długu wdzięczności. Będzie pracował dla ciebie, aż odnajdzie swe odkupienie. Zaś kiedy to odkupienie nastąpi, zależy wyłącznie od ciebie.}";
		bros[4].setPlaceInFormation(4);
		bros[4].getSprite("miniboss").setBrush("bust_miniboss_indebted");
		local items = bros[4].getItems();
		items.unequip(items.getItemAtSlot(this.Const.ItemSlot.Mainhand));
		items.equip(this.new("scripts/items/weapons/militia_spear"));
		bros[4].worsenMood(0.5, "Czuje się przeklęty, że zdezerterował z jednej armii, by skończyć jako niewolnik w innej");
		bros[5].setStartValuesEx([
			"slave_southern_background"
		]);
		bros[5].setTitle("Żebrak");
		bros[5].getBackground().m.RawDescription = "{Znaleziony na ulicach, %name% nigdy nie miał żadnych szans. Jako że był żebrakiem, fizycznie łatwo było zakuć go w kajdany, a społecznie każdy miał to gdzieś. Złotnik krzywo patrzy na tych, którzy nie pracują, a ten człowiek mitrężył każdy kolejny dzień, przez co uzbierał mu się dług. Teraz ten dług musi spłacić, inaczej posmakuje pustynnego ognia na wieczność. Właściwie to teraz wygląda na zdrowszego, niż gdy go znalazłeś, choć nigdy ci za to nie podziękował.}";
		bros[5].setPlaceInFormation(5);
		bros[5].getSprite("miniboss").setBrush("bust_miniboss_indebted");
		local items = bros[5].getItems();
		items.unequip(items.getItemAtSlot(this.Const.ItemSlot.Mainhand));
		items.equip(this.new("scripts/items/weapons/wooden_stick"));
		this.World.Assets.m.BusinessReputation = 100;
		this.World.Assets.getStash().add(this.new("scripts/items/supplies/rice_item"));
		this.World.Assets.getStash().add(this.new("scripts/items/supplies/rice_item"));
		this.World.Assets.getStash().add(this.new("scripts/items/supplies/rice_item"));
		this.World.Assets.getStash().add(this.new("scripts/items/misc/manhunters_ledger_item"));
		this.World.Assets.getStash().resize(this.World.Assets.getStash().getCapacity() + 9);
		this.World.Assets.m.Money = this.World.Assets.m.Money;
		this.World.Assets.m.ArmorParts = this.World.Assets.m.ArmorParts / 2;
		this.World.Assets.m.Medicine = this.World.Assets.m.Medicine / 2;
		this.World.Assets.m.Ammo = this.World.Assets.m.Ammo / 2;
	}

	function onSpawnPlayer()
	{
		local randomVillage;

		for( local i = 0; i != this.World.EntityManager.getSettlements().len(); i = i )
		{
			randomVillage = this.World.EntityManager.getSettlements()[i];

			if (!randomVillage.isIsolatedFromRoads() && randomVillage.isSouthern())
			{
				break;
			}

			i = ++i;
		}

		local randomVillageTile = randomVillage.getTile();
		local navSettings = this.World.getNavigator().createSettings();
		navSettings.ActionPointCosts = this.Const.World.TerrainTypeNavCost_Flat;

		do
		{
			local x = this.Math.rand(this.Math.max(2, randomVillageTile.SquareCoords.X - 4), this.Math.min(this.Const.World.Settings.SizeX - 2, randomVillageTile.SquareCoords.X + 4));
			local y = this.Math.rand(this.Math.max(2, randomVillageTile.SquareCoords.Y - 4), this.Math.min(this.Const.World.Settings.SizeY - 2, randomVillageTile.SquareCoords.Y + 4));

			if (!this.World.isValidTileSquare(x, y))
			{
			}
			else
			{
				local tile = this.World.getTileSquare(x, y);

				if (tile.Type == this.Const.World.TerrainType.Ocean || tile.Type == this.Const.World.TerrainType.Shore || tile.IsOccupied)
				{
				}
				else if (tile.getDistanceTo(randomVillageTile) <= 1)
				{
				}
				else
				{
					local path = this.World.getNavigator().findPath(tile, randomVillageTile, navSettings, 0);

					if (!path.isEmpty())
					{
						randomVillageTile = tile;
						break;
					}
				}
			}
		}
		while (1);

		this.countIndebted();
		this.World.State.m.Player = this.World.spawnEntity("scripts/entity/world/player_party", randomVillageTile.Coords.X, randomVillageTile.Coords.Y);
		this.World.Assets.updateLook(18);
		this.World.getCamera().setPos(this.World.State.m.Player.getPos());
		this.Time.scheduleEvent(this.TimeUnit.Real, 1000, function ( _tag )
		{
			this.Music.setTrackList([
				"music/worldmap_11.ogg"
			], this.Const.Music.CrossFadeTime);
			this.World.Events.fire("event.manhunters_scenario_intro");
		}, null);
	}

	function onInit()
	{
		this.World.Assets.m.BrothersMax = 25;
		this.World.Assets.m.BrothersMaxInCombat = 16;
		this.World.Assets.m.BrothersScaleMax = 14;
	}

	function onHired( _bro )
	{
		if (_bro.getBackground().getID() != "background.slave")
		{
			_bro.getSkills().add(this.new("scripts/skills/actives/whip_slave_skill"));
		}
		else
		{
			_bro.getSprite("miniboss").setBrush("bust_miniboss_indebted");
		}

		this.countIndebted();
	}

	function onCombatFinished()
	{
		this.countIndebted();
		return true;
	}

	function onUnlockPerk( _bro, _perkID )
	{
		if (_bro.getLevel() == 7 && _bro.getBackground().getID() == "background.slave" && _perkID == "perk.student")
		{
			_bro.setPerkPoints(_bro.getPerkPoints() + 1);
		}
	}

	function onUpdateLevel( _bro )
	{
		if (_bro.getLevel() == 7 && _bro.getBackground().getID() == "background.slave" && _bro.getSkills().hasSkill("perk.student"))
		{
			_bro.setPerkPoints(_bro.getPerkPoints() + 1);
		}
	}

	function onGetBackgroundTooltip( _background, _tooltip )
	{
		if (_background.getID() != "background.slave")
		{
			if (_background.getID() == "background.wildman")
			{
				_tooltip.pop();
				_tooltip.push({
					id = 16,
					type = "text",
					icon = "ui/icons/xp_received.png",
					text = "[color=" + this.Const.UI.Color.NegativeValue + "]-25%[/color] zdobywanego doświadczenia"
				});
			}
			else if (_background.getID() == "background.apprentice")
			{
				_tooltip.pop();
			}
			else if (_background.getID() == "background.historian")
			{
				_tooltip.pop();
				_tooltip.push({
					id = 16,
					type = "text",
					icon = "ui/icons/xp_received.png",
					text = "[color=" + this.Const.UI.Color.PositiveValue + "]+5%[/color] zdobywanego doświadczenia"
				});
			}
			else
			{
				_tooltip.push({
					id = 16,
					type = "text",
					icon = "ui/icons/xp_received.png",
					text = "[color=" + this.Const.UI.Color.NegativeValue + "]-10%[/color] zdobywanego doświadczenia"
				});
			}
		}
		else
		{
			_tooltip.push({
				id = 16,
				type = "text",
				icon = "ui/icons/xp_received.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+10%[/color] zdobywanego doświadczenia"
			});
			_tooltip.push({
				id = 17,
				type = "text",
				icon = "ui/icons/xp_received.png",
				text = "Ograniczony do 7. poziomu postaci"
			});
			_tooltip.push({
				id = 18,
				type = "text",
				icon = "ui/icons/days_wounded.png",
				text = "Umiera, gdy zostanie powalony w bitwie i nie przeżyje, gdy otrzyma trwałą kontuzję"
			});
		}
	}

	function countIndebted()
	{
		local roster = this.World.getPlayerRoster().getAll();
		local indebted = 0;
		local nonIndebted = [];

		foreach( bro in roster )
		{
			if (bro.getBackground().getID() == "background.slave")
			{
				indebted++;
			}
			else
			{
				nonIndebted.push(bro);
			}
		}

		this.World.Statistics.getFlags().set("ManhunterIndebted", indebted);
		this.World.Statistics.getFlags().set("ManhunterNonIndebted", nonIndebted.len());
	}

});

