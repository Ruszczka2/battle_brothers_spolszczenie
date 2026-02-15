this.gladiator_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.gladiator";
		this.m.Name = "Gladiator";
		this.m.Icon = "ui/backgrounds/background_61.png";
		this.m.BackgroundDescription = "Gladiatorzy są kosztowni, choć życie na arenie przekuło ich w zdolnych wojowników.";
		this.m.GoodEnding = "Sądziłeś, że %name%, gladiator, wróci na areny, jak przewidywałeś. Tymczasem wieści z południa mówią o powstaniu Zadłużonych i gladiatorów. W odróżnieniu od wcześniejszych buntów ten sprawił, że wezyrowie wiszą z dachów, a handlarzy niewolników linczuje się na ulicach. Ogólne zamieszanie najwyraźniej ma uczynić niegdysiejszego wojownika areny prawowitym rozgrywającym w regionie.";
		this.m.BadEnding = "Zew tłumu był dla gladiatora %name% zbyt silny. Po twojej szybkiej emeryturze z nieudanej %companyname% wojownik wrócił na areny południowych królestw. Niestety trudy czasu spędzonego wśród najemników spowolniły go o krok i został śmiertelnie ugodzony przez na wpół zagłodzonego niewolnika z widłami i siecią.";
		this.m.HiringCost = 200;
		this.m.DailyCost = 35;
		this.m.Excluded = [
			"trait.superstitious",
			"trait.fear_beasts",
			"trait.fear_greenskins",
			"trait.fear_undead",
			"trait.weasel",
			"trait.night_blind",
			"trait.ailing",
			"trait.asthmatic",
			"trait.clubfooted",
			"trait.hesitant",
			"trait.loyal",
			"trait.tiny",
			"trait.fragile",
			"trait.clumsy",
			"trait.fainthearted",
			"trait.craven",
			"trait.bleeder",
			"trait.dastard",
			"trait.insecure"
		];
		this.m.Bodies = this.Const.Bodies.Gladiator;
		this.m.Faces = this.Const.Faces.SouthernMale;
		this.m.Hairs = this.Const.Hair.SouthernMale;
		this.m.HairColors = this.Const.HairColors.Southern;
		this.m.Beards = this.Const.Beards.Southern;
		this.m.BeardChance = 60;
		this.m.Ethnicity = 1;
		this.m.Names = this.Const.Strings.SouthernNames;
		this.m.LastNames = this.Const.Strings.SouthernNamesLast;
		this.m.Level = this.Math.rand(2, 4);
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
		return "{Południe roi się od niewolników wszelkiej maści, zwanych Zadłużonymi z powodu długu wobec Gildii. Choć większość trafia na pola, nielicznych zabiera się do jam walk, by toczyli boje. | Choć północniacy urządzają turnieje, nic nie dorównuje przemocy i rzezi południowych aren gladiatorów. | Na Południu zarówno bogaci, jak i biedni lubią dopingować gladiatorów na arenach walk. | Południowe areny są pełne zarówno Zadłużonych, jak i ochotniczych zabójców. | Krwawe domy walk i zakładów, areny gladiatorów są jedynym miejscem na Południu, gdzie bogaci i biedni gromadzą się razem.} {%name% wywodzi się z tych szeregów. Szybko się w nich wspiął i zdołał wykupić się z aren do takiej wolności, jaką można znaleźć po takim życiu. | Ulubieniec tłumu, %name% zakończył swój czas jako gladiator po ułaskawieniu przez bogatych patronów. Jednak we wczesnej emeryturze czuł, że życie go nie wypełnia. | Skuteczni zabójcy tacy jak %name% mogą wykupić sobie wolność, lecz żądza krwi wciąż go nie opuściła. | %name% uczestniczył w incydencie zwanym \"nurkowaniem\" i otrzymał roczny zakaz wstępu na areny. | Gladiatorzy tacy jak %name% cieszą się popularnością nie tylko wśród gawiedzi, ale szczególnie u niewiast. Pikantny romans z żoną szlachcica sprawił, że wojownika wywieziono nocą, by nie został wykastrowany. | Najpopularniejszy wojownik areny to zwykle mieszanka zabójczej urody i śmiercionośnych rąk, a %name% miał tylko te drugie. Zniechęcony brakiem sławy, którą, jak sądził, zasłużył, wykupił wolność i odszedł od krwawego sportu.} {Gladiatorzy zwykle przenoszą się z areny na arenę, więc krzepki i biegły wojownik taki jak %name% rzadko spotykany jest w terenie. A jednak tu stoi, z bliznami, które zawstydziłyby biczownika. | Spotkałeś wielu wojowników, lecz rzadko takiego o umiejętnościach wojownika areny jak %name%. Zderzenia na arenach uczyniły go naprawdę sprytnym wojownikiem, ale też takim, który ma tyle blizn i ran, ile przystało na jego czas w jamach. | Na świecie wiele rzeczy idzie w parze, a gladiator z nietkniętym ciałem do nich nie należy. %name% jest utalentowanym wojownikiem, ale te doświadczenia okupił własną krwią i ciałem. | Imponujące gladiatorskie CV, jakie ma %name%, sugeruje człowieka biegłego w zabijaniu. Liczne blizny jednak dobitnie mówią, że czas w arenach miał własną, nieodwracalną cenę. | Gladiatorzy tacy jak %name% mogliby być najzdolniejszymi wojownikami w całej krainie, lecz areny walk pełne są gier i zaprojektowano je tak, by krzywdzić wszystkich uczestników. To utalentowany wojownik, lecz nosi blizny i rany całej kariery na arenie.}";
	}

	function onSetAppearance()
	{
		local actor = this.getContainer().getActor();
		local tattoo_body = actor.getSprite("tattoo_body");
		local tattoo_head = actor.getSprite("tattoo_head");

		if (this.Math.rand(1, 100) <= 25)
		{
			local body = actor.getSprite("body");
			tattoo_body.setBrush("scar_02_" + body.getBrush().Name);
			tattoo_body.Visible = true;
		}

		if (this.Math.rand(1, 100) <= 30)
		{
			tattoo_head.setBrush("scar_02_head");
			tattoo_head.Visible = true;
		}
	}

	function updateAppearance()
	{
		local actor = this.getContainer().getActor();
		local tattoo_body = actor.getSprite("tattoo_body");

		if (tattoo_body.HasBrush)
		{
			local body = actor.getSprite("body");
			tattoo_body.setBrush("scar_02_" + body.getBrush().Name);
		}
	}

	function onChangeAttributes()
	{
		local c = {
			Hitpoints = [
				0,
				0
			],
			Bravery = [
				5,
				5
			],
			Stamina = [
				0,
				0
			],
			MeleeSkill = [
				13,
				10
			],
			RangedSkill = [
				8,
				6
			],
			MeleeDefense = [
				5,
				8
			],
			RangedDefense = [
				5,
				8
			],
			Initiative = [
				0,
				0
			]
		};
		return c;
	}

	function onAdded()
	{
		this.character_background.onAdded();

		if (this.Math.rand(1, 2) == 2)
		{
			local actor = this.getContainer().getActor();
			actor.setTitle(this.Const.Strings.GladiatorTitles[this.Math.rand(0, this.Const.Strings.GladiatorTitles.len() - 1)]);
		}
	}

	function onAddEquipment()
	{
		local items = this.getContainer().getActor().getItems();
		local r;

		if (items.hasEmptySlot(this.Const.ItemSlot.Mainhand))
		{
			local weapons = [
				"weapons/shamshir",
				"weapons/shamshir",
				"weapons/oriental/two_handed_scimitar",
				"weapons/oriental/heavy_southern_mace",
				"weapons/oriental/heavy_southern_mace",
				"weapons/oriental/swordlance",
				"weapons/oriental/polemace",
				"weapons/fighting_axe",
				"weapons/fighting_spear"
			];

			if (this.Const.DLC.Wildmen)
			{
				weapons.extend([
					"weapons/two_handed_flail",
					"weapons/two_handed_flanged_mace",
					"weapons/bardiche"
				]);
			}

			items.equip(this.new("scripts/items/" + weapons[this.Math.rand(0, weapons.len() - 1)]));
		}

		if (items.hasEmptySlot(this.Const.ItemSlot.Offhand))
		{
			local offhand = [
				"tools/throwing_net",
				"shields/oriental/metal_round_shield"
			];
			items.equip(this.new("scripts/items/" + offhand[this.Math.rand(0, offhand.len() - 1)]));
		}

		local a = this.new("scripts/items/armor/oriental/gladiator_harness");
		local u;
		r = this.Math.rand(1, 2);

		if (r == 1)
		{
			u = this.new("scripts/items/armor_upgrades/light_gladiator_upgrade");
		}
		else if (r == 2)
		{
			u = this.new("scripts/items/armor_upgrades/heavy_gladiator_upgrade");
		}

		a.setUpgrade(u);
		items.equip(a);
		r = this.Math.rand(2, 3);

		if (r == 2)
		{
			items.equip(this.new("scripts/items/helmets/oriental/gladiator_helmet"));
		}
	}

});

