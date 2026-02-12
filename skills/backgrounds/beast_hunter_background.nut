this.beast_hunter_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.beast_slayer";
		this.m.Name = "Pogromca Bestii";
		this.m.Icon = "ui/backgrounds/background_57.png";
		this.m.BackgroundDescription = "Pogromcy Bestii zawodowo zajmują się polowaniem na potworne bestie, z różnych odległości.";
		this.m.GoodEnding = "%name% retired from the company and bought the deed to an abandoned castle. There he commands a troop of fellow beast slayers who journey the land protecting it from monsters. Last you spoke to him he had a raven-haired lady friend who did not take kindly to your presence, nor the presence of anyone else for that matter. You\'re sure he\'s happy.";
		this.m.BadEnding = "After leaving the %companyname%, %name% retired from beast slaying altogether and last you heard he fathered an albino daughter. Unfortunately, rumors spread quickly about the girl having supernatural powers and her mother was executed by fire. The father and child were never caught nor seen again.";
		this.m.HiringCost = 150;
		this.m.DailyCost = 15;
		this.m.Excluded = [
			"trait.superstitious",
			"trait.weasel",
			"trait.fear_beasts",
			"trait.ailing",
			"trait.bleeder",
			"trait.dumb",
			"trait.fragile",
			"trait.night_blind",
			"trait.clubfooted",
			"trait.brute",
			"trait.short_sighted",
			"trait.fat",
			"trait.clumsy",
			"trait.gluttonous",
			"trait.asthmatic",
			"trait.craven",
			"trait.dastard"
		];
		this.m.Titles = [
			"Łowca Bestii",
			"Człowiek Lasu",
			"Pogromca Bestii",
			"Tropiciel",
			"Łowca Trofeów",
			"Myśliwy"
		];
		this.m.Faces = this.Const.Faces.AllMale;
		this.m.Hairs = this.Const.Hair.UntidyMale;
		this.m.HairColors = this.Const.HairColors.All;
		this.m.Beards = this.Const.Beards.Untidy;
		this.m.Bodies = this.Const.Bodies.Muscular;
		this.m.Level = this.Math.rand(2, 3);
		this.m.IsCombatBackground = true;
	}

	function getTooltip()
	{
		return [
			{
				id = 1,
				type = "title",
				text = this.getName()
			},
			{
				id = 2,
				type = "description",
				text = this.getDescription()
			}
		];
	}

	function onBuildDescription()
	{
		return "{{%name% nie miał zbyt ekstrawaganckiej przeszłości. | %name% podróżował po tych ziemiach od jakiegoś czasu, ale nie zawsze jako przedstawiciel swojej obecnej profesji. | Pomimo swojej makabrycznej pracy, %name% nie pochodził z niezwykłego rodu. | Długa lista pokonanych bestii oraz liczne skóry będące jej potwierdzeniem, wprowadzają nieco w błąd na temat tego, skąd %name% się wywodzi.} {Ten pogromca bestii był niegdyś zwykłym myśliwym, uzbrojonym zarówno w łuk, jak i mądrość. Jednak po odkryciu w jednej ze swoich pułapek potwornego wilkora, zasmakował w polowaniu na bardziej niebezpiecznych wrogów. | Jako że jego wioska była nieustannie nękana przez webknechty, zaczął uczyć się wszystkiego o polowaniu na bestie. A potem zaczął się tym parać... i robił to z dużym powodzeniem. | Podobno był wiejskim młynarzem, dopóki Alpy nie nawiedziły całego miasta. Nigdy nie sypiał zbyt wiele, więc spędzał noce ucząc się o tych potworach, aż w końcu je pokonał. | Służył jako poszukiwacz zwierzyny dla miejscowego lorda. Kiedy jednak polowanie niezbyt się powiodło, a świta lorda skończyła w paszczy unholda, zaczął studiować bestie oraz sposoby ich zabijania. | W sercu tego zwykłego drwala narodził się prawdziwy pogromca bestii, gdy wszyscy jego pobratymcy zostali wyrżnięci przez schrata, żywe drzewo. Pomścił swoich przyjaciół i przyrzekł nauczyć się wszystkiego, co zdoła o potworach i ich unicestwianiu. | Po tym jak nachzehrery spustoszyły jego klasztor, ten niegdyś zwykły mnich zaczął zgłębiać tajniki zarówno bestii, jak i miecza.} {Czasy się jednak zmieniają i nawet ten wytrawny łowca monstrum nie jest w stanie poradzić sobie sam. Pragnie dołączyć do jakiejś kompanii i zabić tyle bestii, ile tylko zdoła. | Dni są nietypowo krótkie, a księżyc co noc świeci jasnym blaskiem. Ten pogromca czuje zmiany w powietrzu i jeśli ma walczyć z tym, co nadchodzi, będzie potrzebował pomocy innych osób. | Choć nie przepada za towarzystwem, ów pogromca bestii chce zabić tyle stworów, ile tylko zdoła, a do tego będzie potrzebował pomocy kilku zdolnych kamratów. | W świecie, który staje się coraz bardziej niebezpieczny i zdesperowany, pogromca bestii poszukuje zarówno pieniędzy, jak i towarzystwa. | Zawodowy czeladnik, taki jak ten, mógłby okazać się niezwykle przydatny dla kompanii najemniczej i nie masz wątpliwości, że będzie on sumienny w swoim fachu szlachtowania potworów. | Niestety, przyjął pod swoje skrzydła ucznia tylko po to, by dzieciak niedługo potem został rozszarpany na strzępy przez wilkora. Załamany pogromca bestii szuka teraz wytrzymalszego towarzystwa.}}";
	}

	function onChangeAttributes()
	{
		local c = {
			Hitpoints = [
				0,
				3
			],
			Bravery = [
				13,
				10
			],
			Stamina = [
				5,
				7
			],
			MeleeSkill = [
				5,
				5
			],
			RangedSkill = [
				11,
				7
			],
			MeleeDefense = [
				0,
				0
			],
			RangedDefense = [
				0,
				0
			],
			Initiative = [
				7,
				5
			]
		};
		return c;
	}

	function onSetAppearance()
	{
		local actor = this.getContainer().getActor();
		local tattoo_body = actor.getSprite("tattoo_body");
		local tattoo_head = actor.getSprite("tattoo_head");

		if (this.Math.rand(1, 100) <= 75)
		{
			local body = actor.getSprite("body");
			tattoo_body.setBrush("scar_02_" + body.getBrush().Name);
			tattoo_body.Visible = true;
		}

		if (this.Math.rand(1, 100) <= 75)
		{
			tattoo_head.setBrush("scar_02_head");
			tattoo_head.Visible = true;
		}
	}

	function onAddEquipment()
	{
		local items = this.getContainer().getActor().getItems();
		local r;
		r = this.Math.rand(1, 4);

		if (r == 1)
		{
			items.equip(this.new("scripts/items/weapons/hunting_bow"));
			items.equip(this.new("scripts/items/ammo/quiver_of_arrows"));
			items.addToBag(this.new("scripts/items/weapons/knife"));
		}
		else if (r == 2)
		{
			items.equip(this.new("scripts/items/weapons/boar_spear"));
		}
		else if (r == 3)
		{
			items.equip(this.new("scripts/items/weapons/spetum"));
		}
		else if (r == 4)
		{
			items.equip(this.new("scripts/items/weapons/javelin"));
		}

		if (this.Math.rand(1, 100) <= 50 && items.getItemAtSlot(this.Const.ItemSlot.Offhand) == null)
		{
			items.equip(this.new("scripts/items/tools/throwing_net"));
		}

		r = this.Math.rand(0, 2);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/armor/ragged_surcoat"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/armor/thick_tunic"));
		}
		else if (r == 2)
		{
			items.equip(this.new("scripts/items/armor/leather_tunic"));
		}

		r = this.Math.rand(0, 1);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/helmets/hood"));
		}
		else if (r == 0)
		{
			items.equip(this.new("scripts/items/helmets/hunters_hat"));
		}
	}

});

