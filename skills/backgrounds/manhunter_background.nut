this.manhunter_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.manhunter";
		this.m.Name = "Łowca Głów";
		this.m.Icon = "ui/backgrounds/background_62.png";
		this.m.BackgroundDescription = "Łowcy głów są przyzwyczajeni do polowania na ludzi w surowym środowisku południowych kresów.";
		this.m.GoodEnding = "%name% trzymał się %companyname% długo po twoim odejściu. Niewiele o nim słyszałeś poza tym, że w świecie najemników zarabia znacznie więcej niż na tropieniu zadłużonych.";
		this.m.BadEnding = "%name%, rozczarowany tym, jak potoczył się jego czas w %companyname%, zdezerterował i wrócił na południe. Trudno powiedzieć, co się z nim stało, ale tropienie i polowanie na ludzi niesie niekończące się niebezpieczeństwa. Jedyne wieści, jakie masz, są poboczne: liczne powstania zadłużonych, podczas których wielu łowców głów zakopano żywcem albo nakarmiono rozmaitymi pustynnymi bestiami.";
		this.m.HiringCost = 120;
		this.m.DailyCost = 10;
		this.m.Excluded = [
			"trait.bleeder",
			"trait.bright",
			"trait.clumsy",
			"trait.fainthearted",
			"trait.iron_lungs",
			"trait.tiny",
			"trait.optimist",
			"trait.dastard",
			"trait.asthmatic",
			"trait.craven",
			"trait.insecure",
			"trait.short_sighted"
		];
		this.m.Titles = [
			"Łowca Głów",
			"Łowca Ludzi",
			"Myśliwy",
			"Bezwzględny",
			"Łowca Nagród",
			"Brutal",
			"Okrutny",
			"Niewybaczający",
			"Bezlitosny",
			"Tropiciel",
			"Łapacz",
			"Bezduszny",
			"Wieprz",
			"Łowca Niewolników"
		];
		this.m.Faces = this.Const.Faces.SouthernMale;
		this.m.Hairs = this.Const.Hair.SouthernMale;
		this.m.HairColors = this.Const.HairColors.Southern;
		this.m.Beards = this.Const.Beards.Southern;
		this.m.BeardChance = 90;
		this.m.Bodies = this.Const.Bodies.SouthernThick;
		this.m.Ethnicity = 1;
		this.m.Names = this.Const.Strings.SouthernNames;
		this.m.LastNames = this.Const.Strings.SouthernNamesLast;
		this.m.IsLowborn = true;
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
		return "{Liczna populacja niewolników, jeńców wojennych, przestępców oraz zadłużonych sług na południu wytworzyła cały rynek pełen sprzedawców, kupujących, oraz, z uwagi na paskudną naturę tego towaru, myśliwych. | Południowe miasta-państwa muzą mieć olbrzymie rezerwy pracowników, aby zasilić swe wyrosłe na pustyniach ekonomie. Choć wielu już rodzi rodzi się w niewoli, by niestrudzenie pracować dla Wezyrów, niektórych trzeba nakłonić do życia w poddaństwie. | Pustynie są tak ubogie w zasoby naturalne, że zwykle to na barkach licznych pojmanych przestępców oraz zadłużonych spoczywa południowa ekonomia. A biznes polowania na tych potencjalnych sługusów jest bardzo lukratywny. | Południowi Wezyrowie tak bardzo lękają się buntów, że powstał cały zastęp łowców głów, aby zadusić je w zarodku.} {%name% wstąpił do łowców głów z bardzo mściwym nastawieniem: jego cała rodzina została wyrżnięta w niewolniczym powstaniu. | %name% był dawniej zwykłym pomocnikiem karawany, jednak zaczął polować z łowcami głów na koczowników, którzy próbowali napadać na jego konwoje. Gdy okazało się, że z handlu ludźmi jest znacznie więcej zysku, przy tym zawodzie pozostał. | %name% jest łowcą głów z dobrym nosem do tropienia przestępców, dezerterów, jeńców wojennych i tym podobnych. Czasami zastanawiasz się, że czy nie wyostrzył mu się węch na specyficzny zapach potu wywoływanego przez strach. | Dawniej polując na grubego zwierza, %name% z czasem nabrał ochoty na ściganie najtrudniejszej zwierzyny: człowieka. Jest doświadczonym tropicielem i umie wywąchać desperację.} {Pracę dla kompanii najemników %name% postrzega jako bardziej stabilne zatrudnienie, niż gonienie za przestępcami i zakuwanie ich w łańcuchy. | %name% to surowy, podejrzany osobnik i całkiem możliwe, że jest równie lekkomyślny, co ludzie, na których polował. | Myśliwi tacy jak %name% posiadają cechy i umiejętności, które są przydatne w kompanii najemników. Jednak dla niektórych ich przeszłość może być wiecznie obecną zniewagą. Nie wszyscy łowcy głów są postrzegani w dobrym świetle. | Łapanie ludzi, by zmuszać ich do pracy, jest przez wielu źle postrzegane. Podobnie jest z łapaniem tych, którzy tylko pragną wolności. Łowcy głów tacy jak %name% z pewnością mają przydatne umiejętności, ale samą swą obecnością mogą niektórych drażnić. | Nic dziwnego, że wielu postrzega ludzi takich jak %name% jako oportunistyczne szuje. Jeśli uda mu się dostać zatrudnienie w kompanii, może minąć sporo czasu, zanim niektórzy zmienią zdanie na temat jego przeszłości.}";
	}

	function onChangeAttributes()
	{
		local c = {
			Hitpoints = [
				2,
				3
			],
			Bravery = [
				7,
				5
			],
			Stamina = [
				3,
				5
			],
			MeleeSkill = [
				5,
				5
			],
			RangedSkill = [
				0,
				0
			],
			MeleeDefense = [
				2,
				2
			],
			RangedDefense = [
				-1,
				-1
			],
			Initiative = [
				3,
				5
			]
		};
		return c;
	}

	function onAddEquipment()
	{
		local items = this.getContainer().getActor().getItems();
		local r;
		r = this.Math.rand(0, 3);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/weapons/battle_whip"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/weapons/wooden_stick"));
		}
		else if (r == 2)
		{
			items.equip(this.new("scripts/items/weapons/bludgeon"));
		}
		else if (r == 3)
		{
			items.equip(this.new("scripts/items/weapons/oriental/saif"));
		}

		items.equip(this.new("scripts/items/tools/throwing_net"));
		r = this.Math.rand(0, 1);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/armor/oriental/nomad_robe"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/armor/oriental/thick_nomad_robe"));
		}

		r = this.Math.rand(0, 1);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/helmets/oriental/southern_head_wrap"));
		}
	}

});

