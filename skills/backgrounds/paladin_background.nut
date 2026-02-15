this.paladin_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.paladin";
		this.m.Name = "Przysięgający";
		this.m.Icon = "ui/backgrounds/background_69.png";
		this.m.BackgroundDescription = "Przysięgający to dzielni wojownicy, którym nieobca walka i których wiąże rygorystyczny kodeks.";
		this.m.GoodEnding = "%name% Przysięgający pozostał w %companyname%, dzierżąc czaszkę Młodego Anzelma i nawracając świat na rycerskie cnoty. Większość widzi w nim raczej zawalidrogę, ale jest też urok w człowieku, który do końca wierzy w honor, dumę i czynienie dobra. Ostatnio słyszałeś, że w pojedynkę uratował córkę lorda z rąk bandy zaułkowych złodziei. Na uczczenie tego poślubił pannę, choć krążą plotki, że jest niezadowolona w łożu, twierdząc, iż Przysięgający nalega, by czaszka Młodego Anzelma spoglądała z kąta. Cokolwiek się dzieje, cieszy cię, że ten człowiek wciąż robi swoje na całego.";
		this.m.BadEnding = "Niegdyś Przysięgający do szpiku kości, %name% rozczarował się współwyznawcami i pewnej nocy śniło mu się, że to oni są prawdziwymi heretykami. Zabił każdego Przysięgającego w zasięgu i uciekł, by w końcu dołączyć do Przysięgonosicieli. Ostatnie wieści mówią, że odzyskał czaszkę Młodego Anzelma i roztrzaskał ją młotem. Rozwścieczeni nowi bracia Przysięgonosiciele natychmiast go zabili. Zwłoki %name% znaleziono przebite ponad sto razy, a popiołowe odłamki czaszki osiadały na zakrwawionej, obłąkańczo uśmiechniętej twarzy.";
		this.m.HiringCost = 150;
		this.m.DailyCost = 22;
		this.m.Titles = [
			"Krzyżowiec",
			"Fanatyk",
			"Pobożny",
			"Oddany",
			"Paladyn",
			"Prawy",
			"Związany Przysięgą",
			"Przysięgający",
			"Cnotliwy"
		];
		this.m.Excluded = [
			"trait.ailing",
			"trait.asthmatic",
			"trait.bleeder",
			"trait.bright",
			"trait.clubfooted",
			"trait.clumsy",
			"trait.craven",
			"trait.dastard",
			"trait.disloyal",
			"trait.drunkard",
			"trait.fainthearted",
			"trait.fear_beasts",
			"trait.fear_greenskins",
			"trait.fear_undead",
			"trait.fragile",
			"trait.greedy",
			"trait.hesitant",
			"trait.insecure",
			"trait.paranoid",
			"trait.tiny",
			"trait.tough",
			"trait.weasel"
		];
		this.m.ExcludedTalents = [
			this.Const.Attributes.Hitpoints,
			this.Const.Attributes.RangedSkill
		];
		this.m.Bodies = this.Const.Bodies.Muscular;
		this.m.Faces = this.Const.Faces.AllMale;
		this.m.Hairs = this.Const.Hair.AllMale;
		this.m.HairColors = this.Const.HairColors.Young;
		this.m.Beards = this.Const.Beards.All;
		this.m.BeardChance = 60;
		this.m.Level = this.Math.rand(1, 3);
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
		return "{Przysięgonosiciele. Przysięgonosiciele. Przysięgonosiciele. Przysięgonosiciele. Przysięgonosiciele. Przysięgonosiciele. Przysięgonosiciele. Przysięgonosiciele. Przysięgonosiciele. Przysięgonosiciele. Przysięgonosiciele. Przysięgonosiciele!\n\nPrzysięgonosiciele Przysięgonosiciele Przysięgonosiciele Przysięgonosiciele Przysięgonosiciele Przysięgonosiciele!!!\n\nPRZYSIĘGONOSICIELE PRZYSIĘGONOSICIELE PRZYSIĘGONOSICIELE!!! | %name% jest gorliwym wyznawcą słynnego założyciela Przysięgających, Młodego Anzelma. Wierzy, że jest błogosławiony, mogąc przebywać wśród podobnie myślących ludzi, którzy, choć nie bez wad, starają się czynić dobro w świecie. | Niektórzy mówią, że %name% był Przysięgającym od chwili narodzin. Najczęściej powtarza to on sam, co rodzi przypuszczenia, że wcześniej był potwornym degeneratem i dopiero teraz nadrabia straszną przeszłość. | Gdy myślisz o Przysięgającym, %name% jest takim, jakich niewielu. Utrzymuje mundur i zbroję w nienagannym stanie. Szanuje przełożonych, ale nie jest przesadnie ckliwy. I jest absolutnie znakomity w kierowaniu stali w twarz Przysięgonosiciela. Prawdziwie wybitny Przysięgający, jeśli kiedykolwiek taki istniał. | Mieszkając w odległej krainie, ścigając honor i niosąc śmierć Przysięgonosicielom, %name% usłyszał o sławie %companyname% i musiał ją odnaleźć i dołączyć. To człowiek o niezwykłej determinacji i, co najważniejsze, nie znosi Przysięgonosicieli. | Duch Młodego Anzelma sprowadził %name% do %companyname%. Przynajmniej tak twierdzi. Cokolwiek go tu przywiodło, to utalentowany wojownik i dobrze posłuży kompanii. | Wspaniałość ducha Młodego Anzelma nie może być lekceważona. Tak przynajmniej uważa %name%. Twierdzi, że walczy w imieniu zmarłego Przysięgającego. Młody Anzelm musiał być naprawdę pełen ducha, skoro ten człowiek ma nieprzyzwoity talent do każdej stali. | Jak wielu Przysięgających, %name% zna trzy boskie prawdy: duch Młodego Anzelma jest do czczenia, przysięgi należy traktować poważnie, a wszyscy Przysięgonosiciele muszą zginąć. Dorobienie paru koron na boku też jest miłe, dlatego czwartym 'elementem' uczynił walkę dla kompanii takich jak %companyname%. | To trochę osobliwe, że Przysięgający zarabia żołd najemnika, ale %name% twierdzi, że nauki Młodego Anzelma tego nie zakazują. Zamiast tego to osobista odpowiedzialność każdego Przysięgającego, by dotrzymać przysiąg, co on z łatwością robi, rąbiąc wrogów dla %companyname%. | %name% nosi księgę poświęconą tylko jednemu rodzajowi inwentarza: ilu Przysięgonosicieli zabił. Ma nawet listę kiedy i gdzie to zrobił, i oczywiście jak. Wpisy 'jak' są wyjątkowo rozbudowane, z liniami dokładnie opisującymi, jak rozprawił się ze znienawidzonymi wrogami. Szczerze mówiąc, lubisz jego zapał. | %name%, Przysięgający, ma tak jednolity umysł, że niemal się martwisz, co zrobi bez wskazówek Młodego Anzelma. Z drugiej strony, ciekawi cię, jak poradziłby sobie, poświęcając się innemu fachowi. Z jego determinacją i zacięciem mógłby tkać nieprawdopodobne kosze, być może nawet robić to pod wodą jak owi uczeni specjaliści. | %name% ma wszystko, czego pragniesz w człowieku honoru: rozum, kondycję i sporą biegłość w machaniu stalą. Jego oddanie Przysięgom dorównuje tylko zdolność miażdżenia tych, którzy stają mu na drodze. Idealny dla %companyname%, prawdziwie. | Wraz z rosnącą sławą %companyname% staje się jedną z bardziej znanych kompanii w krainie. Naturalnie, utalentowany i honorowy człowiek jak %name% chce dołączyć, choć za cenę. Służba sprawie Młodego Anzelma oznacza, że jego uwaga jest rozdzielona, ale nawet pochłonięty prawością pozostaje nieznużonym wojownikiem wartym miejsca w %companyname%.}";
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
				10,
				6
			],
			Bravery = [
				13,
				16
			],
			Stamina = [
				0,
				-4
			],
			MeleeSkill = [
				13,
				10
			],
			RangedSkill = [
				-2,
				-3
			],
			MeleeDefense = [
				4,
				5
			],
			RangedDefense = [
				-10,
				-5
			],
			Initiative = [
				13,
				12
			]
		};
		return c;
	}

	function onAddEquipment()
	{
		local items = this.getContainer().getActor().getItems();
		local r;

		if (items.hasEmptySlot(this.Const.ItemSlot.Mainhand))
		{
			local weapons = [
				"weapons/arming_sword",
				"weapons/fighting_axe",
				"weapons/winged_mace",
				"weapons/military_pick",
				"weapons/warhammer",
				"weapons/billhook",
				"weapons/longaxe",
				"weapons/greataxe",
				"weapons/greatsword"
			];

			if (this.Const.DLC.Unhold)
			{
				weapons.extend([
					"weapons/longsword",
					"weapons/polehammer",
					"weapons/two_handed_flail",
					"weapons/two_handed_flanged_mace"
				]);
			}

			if (this.Const.DLC.Wildmen)
			{
				weapons.extend([
					"weapons/bardiche"
				]);
			}

			items.equip(this.new("scripts/items/" + weapons[this.Math.rand(0, weapons.len() - 1)]));
		}

		if (items.hasEmptySlot(this.Const.ItemSlot.Offhand) && this.Math.rand(1, 100) <= 75)
		{
			local shields = [
				"shields/wooden_shield",
				"shields/wooden_shield",
				"shields/heater_shield",
				"shields/kite_shield"
			];
			items.equip(this.new("scripts/items/" + shields[this.Math.rand(0, shields.len() - 1)]));
		}

		r = this.Math.rand(0, 5);

		if (r < 3)
		{
			items.equip(this.new("scripts/items/armor/adorned_mail_shirt"));
		}
		else if (r < 5)
		{
			items.equip(this.new("scripts/items/armor/adorned_warriors_armor"));
		}
		else if (r == 5)
		{
			items.equip(this.new("scripts/items/armor/adorned_heavy_mail_hauberk"));
		}

		r = this.Math.rand(0, 5);

		if (r < 3)
		{
			items.equip(this.new("scripts/items/helmets/heavy_mail_coif"));
		}
		else if (r < 5)
		{
			items.equip(this.new("scripts/items/helmets/adorned_closed_flat_top_with_mail"));
		}
		else if (r == 5)
		{
			items.equip(this.new("scripts/items/helmets/adorned_full_helm"));
		}
	}

});

