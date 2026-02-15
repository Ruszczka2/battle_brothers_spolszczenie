this.swordmaster_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.swordmaster";
		this.m.Name = "Mistrz Miecza";
		this.m.Icon = "ui/backgrounds/background_30.png";
		this.m.BackgroundDescription = "Mistrz miecza nie ma sobie równych w walce bronią białą, choć może być podatny na ataki z dystansu. Wiek odbił się już na jego atrybutach fizycznych i w miarę upływu czasu może być coraz gorzej.";
		this.m.GoodEnding = "Najlepszy szermierz, jakiego widziałeś, stary mistrz miecza %name% był naturalnym wzmocnieniem dla %companyname%. Ale człowiek nie może walczyć wiecznie. Mimo rosnących sukcesów kompanii szybko stało się oczywiste, że mistrz nie jest już w stanie dać sobie rady fizycznie. Odszedł na ładny skrawek ziemi i cieszy się czasem dla siebie. A przynajmniej tak myślałeś. Poszedłeś go odwiedzić i zastałeś, jak potajemnie szkoli córkę pewnego szlachcica. Obiecałeś zachować to w tajemnicy.";
		this.m.BadEnding = "Szkoda, że mistrz miecza %name% musiał spędzić schyłek życia w podupadającej kompanii najemników. Odszedł, twierdząc, że fizycznie nie da już rady. Uważasz, że tylko oszczędzał %companyname%, bo tydzień później bez najmniejszego wysiłku zabił dziesięciu rzezimieszków przy drodze. Ostatnio słyszałeś, że szkoli niewdzięcznych książąt w sztuce szermierki.";
		this.m.HiringCost = 400;
		this.m.DailyCost = 35;
		this.m.Excluded = [
			"trait.huge",
			"trait.weasel",
			"trait.fear_undead",
			"trait.fear_beasts",
			"trait.fear_greenskins",
			"trait.paranoid",
			"trait.impatient",
			"trait.clubfooted",
			"trait.irrational",
			"trait.athletic",
			"trait.gluttonous",
			"trait.dumb",
			"trait.bright",
			"trait.clumsy",
			"trait.tiny",
			"trait.insecure",
			"trait.fainthearted",
			"trait.craven",
			"trait.bleeder",
			"trait.dastard",
			"trait.hesitant",
			"trait.fragile",
			"trait.iron_lungs",
			"trait.tough",
			"trait.strong",
			"trait.bloodthirsty"
		];
		this.m.ExcludedTalents = [
			this.Const.Attributes.RangedSkill
		];
		this.m.Titles = [
			"Legenda",
			"Stary Gwardzista",
			"Mistrz"
		];
		this.m.Faces = this.Const.Faces.SmartMale;
		this.m.Hairs = this.Const.Hair.TidyMale;
		this.m.HairColors = this.Const.HairColors.Old;
		this.m.Beards = this.Const.Beards.All;
		this.m.Bodies = this.Const.Bodies.Muscular;
		this.m.Level = this.Math.rand(3, 5);
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
		return "{%name% walczy tak, jak ryba pływa. | %name% to nie tylko imię człowieka, to mit. Imię używane zamiast słów takich jak wojna, walka i śmierć. | Powiedzieć 'Poruszasz się jak %name%' to być może największy honor, jaki wojownik może oddać innemu. | Uważa się, że %name% jest jednym z najgroźniejszych szermierzy, jacy stąpali po ziemi.} {Wiele jego życia opiera się na legendzie: jak to rozmontował królestwo, wyzywając króla i wszystkich jego strażników na pojedynek - i pokonując ich jedną ręką. | Podobno walczył z dwudziestoma ludźmi we własnym ogrodzie, spokojnie przy tym przycinając pomidory tym samym ostrzem, którym zabijał. | Niektórzy mówią, że został pozostawiony na morzu na trzysta dni i tam, balansując na kawałku szczątków, nauczył się, jak się poruszać, walczyć i przetrwać. | Mówi się, że jego rodzinę zamordowano, a on nie wiedział przez kogo. Chcąc być gotowym, gdy spotka winnych, nauczył się tak władać ostrzem, by móc zabić każdego. | Wychowany przez jednorękiego ojca, najpierw nauczył się walczyć z ograniczeniami. Gdy zaczął używać obu rąk, potrafił już zabić każdego jedną.} {Niestety, czas i wiek wysuszyły %name% do skorupy dawnego siebie. | Podczas najazdów orków %name% zabił w pojedynkę tuzin zielonoskórych. Niestety, wyczyn ma cenę: dłoń dzierżąca miecz straciła trzy palce, a ścięgno Achillesa w wiodącej nodze zostało przecięte. | Niestety, horda pijaków napadła na jego dom, każdy marząc o sławie dzięki zabiciu słynnego szermierza. Zabił ich wszystkich, ale nie zanim odniósł nieodwracalne obrażenia. | Legenda głosi, że starł się z plugawą bestią potwornych rozmiarów. Zbywa to bezpalczastą dłonią i bliznowatym mrugnięciem. | Gdy uczył królewską rodzinę walki, przewrót ogarnął całe królestwo i musiał uciekać z życiem. | Zatrudniony do szkolenia szlacheckich dziedziców, szybko wplątał się w intrygi i noże w plecy, więc musiał odejść, póki mógł.} {Teraz stary szermierz chce spożytkować resztę swojej wiedzy na polu. | Choć stracił pazur, wciąż jest groźny i podobno szuka ucznia, zanim umrze. | Mistrzem sztuk walki może i jest, ale każdy ruch odbija się trzaskiem starych kości. | Przygnębiony i bez celu, %name% znajduje sens w byciu wśród ludzi, których kiedyś uczył. | Nie sposób przebić jego obrony, kontrował wszystko, ale brak mu już sprężystości, by kontratakować. Godne podziwu, lecz smutne. | Daj mu miecz, a stary gwardzista zakręci nim w imponującym popisie. Gdy wbije go w ziemię, opiera się na głowicy, by złapać oddech. Już mniej imponujące. | Stracił atletyzm, ale jego wiedza zamieniła szermierkę w matematykę.";
	}

	function onChangeAttributes()
	{
		local c = {
			Hitpoints = [
				-12,
				-12
			],
			Bravery = [
				12,
				10
			],
			Stamina = [
				-15,
				-10
			],
			MeleeSkill = [
				25,
				20
			],
			RangedSkill = [
				-5,
				-5
			],
			MeleeDefense = [
				10,
				15
			],
			RangedDefense = [
				0,
				0
			],
			Initiative = [
				-10,
				-10
			]
		};
		return c;
	}

	function onAdded()
	{
		this.character_background.onAdded();

		if (this.Math.rand(0, 3) == 3)
		{
			local actor = this.getContainer().getActor();
			actor.setTitle(this.Const.Strings.SwordmasterTitles[this.Math.rand(0, this.Const.Strings.SwordmasterTitles.len() - 1)]);
		}
	}

	function onAddEquipment()
	{
		local items = this.getContainer().getActor().getItems();
		local r;

		if (this.Const.DLC.Unhold)
		{
			r = this.Math.rand(0, 2);

			if (r == 0)
			{
				items.equip(this.new("scripts/items/weapons/noble_sword"));
			}
			else if (r == 1)
			{
				items.equip(this.new("scripts/items/weapons/arming_sword"));
			}
			else if (r == 2)
			{
				items.equip(this.new("scripts/items/weapons/fencing_sword"));
			}
		}
		else
		{
			r = this.Math.rand(0, 1);

			if (r == 0)
			{
				items.equip(this.new("scripts/items/weapons/noble_sword"));
			}
			else if (r == 1)
			{
				items.equip(this.new("scripts/items/weapons/arming_sword"));
			}
		}

		r = this.Math.rand(0, 3);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/armor/padded_leather"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/armor/leather_tunic"));
		}
		else if (r == 2)
		{
			items.equip(this.new("scripts/items/armor/linen_tunic"));
		}
		else if (r == 3)
		{
			items.equip(this.new("scripts/items/armor/padded_surcoat"));
		}

		if (this.Math.rand(1, 100) <= 33)
		{
			items.equip(this.new("scripts/items/helmets/greatsword_hat"));
		}
	}

});

