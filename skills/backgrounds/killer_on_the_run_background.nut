this.killer_on_the_run_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.killer_on_the_run";
		this.m.Name = "Zbiegły Zabójca";
		this.m.Icon = "ui/backgrounds/background_02.png";
		this.m.BackgroundDescription = "Uciekający zabójca znów może zabić, a wie gdzie uderzyć.";
		this.m.GoodEnding = "Zawsze lubiłeś ryzyko i %name% został przez ciebie przyjęty do kompanii, mimo iż był zbiegłym mordercą. Opłaciło się, bo dowiódł, że jest zdolnym i dzielnym najemnikiem. Z tego co wiesz, pozostał w kompanii i cieszy się z każdek \'biznesowej\' okazji, jaka mu nadarzy.";
		this.m.BadEnding = "Choć wielu wątpiło w sens werbowania zbiegłego mordercy takiego jak %name%, dowiódł on jednak, że jest zdolnym najemnikiem. Niestety, widma poprzedniego życia w końcu go dopadły i jednej nocy został porwany przez łowców nagród. Jego szkielet można znaleźć upchnięty w stalowej klatce, wiszącej jakieś pięćdziesiąt stóp nad ziemią.";
		this.m.HiringCost = 60;
		this.m.DailyCost = 6;
		this.m.Excluded = [
			"trait.teamplayer",
			"trait.hate_undead",
			"trait.lucky",
			"trait.clubfooted",
			"trait.cocky",
			"trait.clumsy",
			"trait.loyal",
			"trait.hesitant",
			"trait.bright",
			"trait.brave",
			"trait.determined",
			"trait.deathwish",
			"trait.fainthearted",
			"trait.craven",
			"trait.fearless",
			"trait.optimist"
		];
		this.m.Titles = [
			"Czarnoduszny",
			"Czarne Ostrze",
			"Podrzynacz Gardeł",
			"Zbieg",
			"Poszukiwany",
			"Morderca"
		];
		this.m.Faces = this.Const.Faces.AllMale;
		this.m.Hairs = this.Const.Hair.UntidyMale;
		this.m.HairColors = this.Const.HairColors.All;
		this.m.Beards = this.Const.Beards.Untidy;
		this.m.Bodies = this.Const.Bodies.Skinny;
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
			},
			{
				id = 11,
				type = "text",
				icon = "ui/icons/chance_to_hit_head.png",
				text = "Wyższa szansa na trafienie w głowę"
			}
		];
	}

	function onBuildDescription()
	{
		return "{%fullname% ma twarz, jakiej nikt by nie chciał - taką, która nadaje się tylko na plakaty z osobami poszukiwanymi. | Mając krew na rękach, %name% przypomina ci człowieka, którego ostatnio opisywali ci łowcy nagród. | %name% wygląda na gotowego dołączyć do dowolnej grupy - albo raczej skryć się w jej szeregach. | Poznając nowych ludzi, %name% wyjąkuje swoje imię tak niechętnie, jakby nie chciał się z nimi rozstać.} {Imię %name% rzuciło ci się już w uszy: jest on bowiem mordercą i to powszechnie znanym, na rękach ma krew zarówno swej niewiernej żony, jak i jej kochanka. | Jego oczy są ciemne i ruchliwe. Kryje się za nimi zbrodnia, ale też i iskierka człowieczeństwa, jakby wiedział, że postąpił źle i szuka odkupienia. | Nogi ma całe ubłocone i drżące od wysiłku. Ucieka już od dłuższego czasu. Jego dłonie również drżą, wszak nogi uciekają od tego, co dłonie zrobiły. | Mawiają, że zabił swoją nowonarodzoną córkę, bo zawsze chciał mieć syna. | Niektórzy mówią, że zabił człowieka w samoobronie. | Będąc szantażowanym skandalicznymi informacjami, ciężko go obwiniać za to, co zrobił.} {Nawet jeśli uczynił źle, to grupce zabijaków przydał by się ktoś taki, jak on. Ale czy można mu zaufać? | %name% unika twego wzroku. Gdy pytasz go jak radzi sobie z bronią, wymrukuje, że wystarczy jak walnie \'gościa\' raz. | Ktoś z posturą taką, jaką ma %name%, na pewno by się kompanii przydał, ale jak bardzo można polegać na człowieku, którego dotychczasowe życie polegało na ucieczce? | Wgryza się w swoje paznokcie, jak bóbr w drzewo. Jest nerwowy, choć w takim świecie może to i zaleta. | Kompanie najemników są idealne dla ludzi takich, jak on.}";
	}

	function onChangeAttributes()
	{
		local c = {
			Hitpoints = [
				0,
				0
			],
			Bravery = [
				-5,
				-5
			],
			Stamina = [
				0,
				0
			],
			MeleeSkill = [
				4,
				0
			],
			RangedSkill = [
				2,
				3
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
				0,
				5
			]
		};
		return c;
	}

	function onAddEquipment()
	{
		local items = this.getContainer().getActor().getItems();
		local r;
		r = this.Math.rand(0, 1);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/weapons/dagger"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/weapons/knife"));
		}

		r = this.Math.rand(1, 2);

		if (r == 1)
		{
			items.equip(this.new("scripts/items/armor/linen_tunic"));
		}
		else if (r == 2)
		{
			items.equip(this.new("scripts/items/armor/leather_tunic"));
		}

		r = this.Math.rand(0, 0);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/helmets/hood"));
		}
	}

	function onUpdate( _properties )
	{
		this.character_background.onUpdate(_properties);
		_properties.HitChance[this.Const.BodyPart.Head] += 10;
	}

});

