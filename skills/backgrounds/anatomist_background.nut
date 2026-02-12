this.anatomist_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.anatomist";
		this.m.Name = "Anatom";
		this.m.Icon = "ui/backgrounds/background_70.png";
		this.m.BackgroundDescription = "Będąc po części naukowcami, a po części medykami, anatomowie nie są przyzwyczajeni do walki, choć dobrze służy im posiadanie pewnej ręki.";
		this.m.GoodEnding = "Out of all the men you came to know in the %companyname%, it was %name% the anatomist who is perhaps the most difficult to forget. An unending stream of letters only helps ensure you never will. You skim over his latest, one-sided correspondence: \"Captain! I\'ve managed to...\" skimming, skimming, \"...the greatest invention! The most...\" skimming, skimming. \"I\'m going to be famous! My brain will be studied for its weight is surely...\" Nothing new, it seems, though you are glad he\'s still in good health, albeit perhaps more so in body than mind.";
		this.m.BadEnding = "Having fled the %companyname%, %name% the anatomist continued his studies elsewhere. He was admonished by his peers for venturing out in such an uncouth manner and found himself suffering in intellectual mediocrity. Some years later, he made a small contribution to the study of beetles after which he promptly threw himself off a seaside cliff, donating his brain to the rocks and his body to the ocean.";
		this.m.HiringCost = 130;
		this.m.DailyCost = 12;
		this.m.Excluded = [
			"trait.ailing",
			"trait.asthmatic",
			"trait.bleeder",
			"trait.craven",
			"trait.huge",
			"trait.determined",
			"trait.fear_beasts",
			"trait.hate_beasts",
			"trait.fear_greenskins",
			"trait.hate_greenskins",
			"trait.fear_undead",
			"trait.hate_undead",
			"trait.teamplayer",
			"trait.impatient",
			"trait.clumsy",
			"trait.iron_jaw",
			"trait.dumb",
			"trait.athletic",
			"trait.brute",
			"trait.fragile",
			"trait.iron_lungs",
			"trait.irrational",
			"trait.cocky",
			"trait.strong",
			"trait.tough",
			"trait.superstitious"
		];
		this.m.Titles = [
			"Sęp",
			"Wrona",
			"Magistrat",
			"Kruk",
			"Grabarz",
			"Ponury",
			"Anatomik",
			"Ciekawski",
			"Splamiony"
		];
		this.m.Faces = this.Const.Faces.SmartMale;
		this.m.Hairs = this.Const.Hair.TidyMale;
		this.m.HairColors = this.Const.HairColors.All;
		this.m.Beards = this.Const.Beards.Tidy;
		this.m.Bodies = this.Const.Bodies.Skinny;
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
		return "{%name% jest bystrym mężczyzną z cerą zniszczoną przez ciągłe i zjadliwe testy. Masz nadzieję, że jego metodologia może być lepiej zastosowana do jego wrogów niż do niego samego. | Krążą plotki, że %name% szukał sposobu, aby nauczyć się latać. Nie przy pomocy maszyny, a poprzez wyhodowanie skrzydeł. Nie wiadomo, jak dokładnie zamierzał to zrobić, ani co stało się z jego eksperymentami. Ale oto jest, dość ewidentnie przyziemiony i co rusz nerwowo oglądający się za siebie. | Jak wielu anatomów, %name% wyruszył w świat na własną rękę. Oczywiście, jak wielu, został szybko przygaszony przez tych, dla których nauka nic nie znaczy. Na razie zamierza walczyć u boku najemników, choćby po to, by kupić sobie dodatkowy czas, aby w końcu naprawdę oddać się nauce. | %name% jest cynicznie nastawiony do świata, zdenerwowany tym, że niektórzy z jego rówieśników mogą w pełni zadbać o swoją edukację, podczas gdy on musi zarabiać pieniądze tylko po to, aby utrzymać się na studiach. Niech swój gniew wyzwoli na polu bitwy. | Można by się spodziewać, że człowiek taki jak %name% pojawi się dopiero po bitwie, a nie że będzie w niej uczestniczył. Fakt, że tak inteligentna, choć dziwaczna postać nadal potrzebuje zarobków najemnika, sprawia, że \x200b\x200bzastanawiasz się, czy twoje własne perspektywy osiągnięcia czegokolwiek na tym świecie nie są nawet gorsze, niż początkowo zakładałeś. | Nie da się przecenić intelektu, jakim dysponuje %name%. Jest takim typem nikczemnie inteligentnego człowieka, który sprawia, że zaczynasz się zastanawiać po co bogowie w ogóle dali ci własny rozum, skoro jest on tak skarłowaciały. Jednakże, z najemniczego punktu widzenia, będzie tylko kolejnym wojownikiem. Miejmy nadzieję, że jego zmysły bojowe będą równie wyostrzone, co jego spryt. | Nigdy nie miałeś pewności co do tego, czy to przez ciężkie czasy %name% został zmuszony do żywota najemnika, czy też po prostu kontynuuje on swoje badania naukowe zmierzając inną, znacznie okrutniejszą ścieżką. To, że spędza wieczory na sekcjach zmiażdżonych przez wozy psów i pozbawionych skrzydeł motyli, skłania cię do wielu refleksji na temat tego osobliwego jegomościa. | To przez ciekawość, a nie pieniądze, %name% podjął się pracy najemnej. Żywi nadzwyczajne zainteresowanie odkrywaniem różnorakich stworów tego świata oraz ciekawi go, jak wyglądają one od środka. Tak długo, jak wypruwa im flaki na zewnątrz, niezbyt cię obchodzi, co jeszcze innego z nimi robi.}";
	}

	function onChangeAttributes()
	{
		local c = {
			Hitpoints = [
				-4,
				-4
			],
			Bravery = [
				10,
				10
			],
			Stamina = [
				0,
				-5
			],
			MeleeSkill = [
				7,
				7
			],
			RangedSkill = [
				9,
				9
			],
			MeleeDefense = [
				1,
				0
			],
			RangedDefense = [
				1,
				0
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
		r = this.Math.rand(0, 3);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/weapons/knife"));
		}
		else if (r <= 2)
		{
			items.equip(this.new("scripts/items/weapons/dagger"));
		}
		else if (r == 3)
		{
			items.equip(this.new("scripts/items/weapons/butchers_cleaver"));
		}

		r = this.Math.rand(0, 5);

		if (r < 3)
		{
			items.equip(this.new("scripts/items/armor/undertaker_apron"));
		}
		else if (r < 5)
		{
			items.equip(this.new("scripts/items/armor/wanderers_coat"));
		}
		else if (r == 5)
		{
			items.equip(this.new("scripts/items/armor/reinforced_leather_tunic"));
		}

		r = this.Math.rand(0, 5);

		if (r < 3)
		{
			items.equip(this.new("scripts/items/helmets/undertaker_hat"));
		}
		else if (r < 5)
		{
			items.equip(this.new("scripts/items/helmets/physician_mask"));
		}
		else if (r == 5)
		{
			items.equip(this.new("scripts/items/helmets/masked_kettle_helmet"));
		}
	}

});

