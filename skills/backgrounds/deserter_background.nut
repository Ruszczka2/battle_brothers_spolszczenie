this.deserter_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.deserter";
		this.m.Name = "Dezerter";
		this.m.Icon = "ui/backgrounds/background_07.png";
		this.m.BackgroundDescription = "Dezerterzy otrzymali nieco szkolenia bitewnego, choć zazwyczaj nie są zbyt chętni, by je wykorzystać.";
		this.m.GoodEnding = "%name%, dezerter, nadal walczył dla %companyname%, wciąż próbując odkupić swe imię. Mówi się, że podczas brutalnej bitwy z orkami skoczył głową wprost w tłum zielonoskórych, sunąc po czubkach ich zaskoczonych głów. Jego bohaterstwo porwało ludzi do niewiarygodnego zwycięstwa, a teraz spędza dni, pijąc w każdej gospodzie, do której wejdzie.";
		this.m.BadEnding = "Słyszałeś, że %name%, dezerter, naprawdę odnowił swój przydomek i uciekł z bitwy %companyname% przeciw zielonoskórym. Gobliny dorwały go w lesie i zrobiły z jego głowy puchar dla orczego wodza.";
		this.m.HiringCost = 85;
		this.m.DailyCost = 11;
		this.m.Excluded = [
			"trait.teamplayer",
			"trait.impatient",
			"trait.clubfooted",
			"trait.fearless",
			"trait.sure_footing",
			"trait.brave",
			"trait.loyal",
			"trait.deathwish",
			"trait.cocky",
			"trait.determined",
			"trait.fragile",
			"trait.optimist",
			"trait.bloodthirsty"
		];
		this.m.ExcludedTalents = [
			this.Const.Attributes.Bravery
		];
		this.m.Titles = [
			"Dezerter",
			"Zbieg",
			"Zdrajca",
			"Uciekinier",
			"Pies",
			"Robak"
		];
		this.m.Faces = this.Const.Faces.AllMale;
		this.m.Hairs = this.Const.Hair.CommonMale;
		this.m.HairColors = this.Const.HairColors.All;
		this.m.Beards = this.Const.Beards.All;
		this.m.Bodies = this.Const.Bodies.Skinny;
		this.m.Level = this.Math.rand(1, 2);
		this.m.IsCombatBackground = true;
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
			},
			{
				id = 16,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Nigdy nie przeszkadza mu bycie w rezerwie"
			}
		];
	}

	function onBuildDescription()
	{
		return "{%name% był pospolitym żołdakiem w armii lorda, ale ponosząc stratę za stratą, | Będąc dawniej wartownikiem na obrzeżach %randomtown%, %name% na własne oczy widział, jak wszyscy jego przyjaciele giną z rąk czających się w tamtejszych rejonach bestii. Po tak wielu stratach | Kiedy dwóch lordów pokłóciło się o drobnostkę, co do własności lokalnego stawu, %name% został zwerbowany do pomocy w rozstrzygnięciu sprawy. Był nikim, więc dla szlachty jego życie nie miało znaczenia. Jedną rzeź później, | Gdy był żołnierzem w zawodowej armii lorda, na niego i jego towarzyszy spadła straszna zaraza. Obawiając się jej gniewu |  Podczas długiej kampanii wojskowej, %name% poczuł, że za dużo w tym maszerowania, a za mało zdobywania cennych łupów. Więc} {wbił swą broń w ziemię i odszedł. | zaczekał do nocy, by zdezerterować ze swego oddziału. | on i jeszcze kilku innych odeszło w proteście. | zgłosił się na ochotnika do patrolu i przy pierwszej okazji porzucił swoją żołnierską karierę.} {Nie jest tajemnicą, że dezerterami powszechnie się gardzi - a %name% nie wychyla się, by nie rzucać się nikomu w oczy. | Większość dezerterów spędza resztę swoich dni starając się uniknąć stryczka, a %name% nie stanowi wyjątku. | Przybierając strój zwykłego człowieka, %name% przez pewien czas unikał kary za dezercję. | Tylko jakimś cudem, %name% jak do tej pory uniknął kary za swe przestępstwo.} {Teraz jednak, bez grosza przy duszy i perspektyw na lepsze jutro, stara się powrócić do swego dawnego zajęcia. | Być może zmuszony przez depczących mu po piętach stróżów prawa, dołącza do innej grupy bojowej. | Niestety, do najmądrzejszych nie należy. Nie mając dość wyobraźni, aby poszukać bezpieczniejszego zajęcia, %name% ponownie wraca do wojaczki. | Czując się winnym opuszczenia swoich towarzyszy broni, szuka teraz odkupienia walcząc dla innego oddziału. Kto jednak da gwarancję, że znów nie ucieknie? | Roztrwoniwszy resztę swych koron w karczmach, starając się utopić swe wspomnienia w kuflu, rozważa teraz każdą okazję, aby jakoś zarobić na życie}.";
	}

	function onChangeAttributes()
	{
		local c = {
			Hitpoints = [
				0,
				0
			],
			Bravery = [
				-15,
				-10
			],
			Stamina = [
				0,
				0
			],
			MeleeSkill = [
				5,
				5
			],
			RangedSkill = [
				7,
				0
			],
			MeleeDefense = [
				3,
				5
			],
			RangedDefense = [
				3,
				5
			],
			Initiative = [
				0,
				0
			]
		};
		return c;
	}

	function onAddEquipment()
	{
		local items = this.getContainer().getActor().getItems();
		local r;
		r = this.Math.rand(1, 4);

		if (r == 1)
		{
			items.equip(this.new("scripts/items/weapons/bludgeon"));
		}
		else if (r == 2)
		{
			items.equip(this.new("scripts/items/weapons/militia_spear"));
		}
		else if (r == 3)
		{
			items.equip(this.new("scripts/items/weapons/hatchet"));
		}
		else if (r == 4)
		{
			items.equip(this.new("scripts/items/weapons/short_bow"));
			items.equip(this.new("scripts/items/ammo/quiver_of_arrows"));
		}

		r = this.Math.rand(0, 3);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/shields/wooden_shield"));
		}

		r = this.Math.rand(0, 2);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/armor/padded_surcoat"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/armor/leather_tunic"));
		}
		else if (r == 2)
		{
			items.equip(this.new("scripts/items/armor/gambeson"));
		}

		r = this.Math.rand(0, 5);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/helmets/hood"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/helmets/aketon_cap"));
		}
		else if (r == 2)
		{
			items.equip(this.new("scripts/items/helmets/full_aketon_cap"));
		}
		else if (r == 3)
		{
			items.equip(this.new("scripts/items/helmets/open_leather_cap"));
		}
	}

	function onUpdate( _properties )
	{
		this.character_background.onUpdate(_properties);
		_properties.IsContentWithBeingInReserve = true;
	}

});

