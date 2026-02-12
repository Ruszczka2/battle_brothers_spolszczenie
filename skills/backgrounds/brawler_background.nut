this.brawler_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.brawler";
		this.m.Name = "Rozrabiaka";
		this.m.Icon = "ui/backgrounds/background_27.png";
		this.m.BackgroundDescription = "Rozrabiacy są niezrównani w walce na gołe pięści, a dzięki ćwiczeniom fizycznym są zazwyczaj w dobrej formie.";
		this.m.GoodEnding = "A brawler like %name% is dangerous with just his fists, and proved himself similarly savage with weapons. Before you left the %companyname%, you talked to the fighter about whether or not he\'d stay in the band. He said he had no desire to return to prizefighting, shook your hand, and thanked you for giving him the opportunity. Last you heard, the company chose him for a one-on-one, winner take all fight to settle compensation differences with a competing mercenary band. He won in the first round.";
		this.m.BadEnding = "%name% the brawler left the company when it became clear it would soon dissolve and probably end up killing everyone who stayed onboard. He returned to prizefighting, grinding out the following years in brutal, weekly bouts. As he got older, his chin disappeared, as did his speed and power. He was left jobbing, intentionally taking falls and losing badly when he didn\'t. Eventually, no one would give him a fight. A nobleman offered him a large sum to wrestle a bear and the desperate %name% took him up on it. When the \'fight\' was over, the brawler lay dead, mangled beyond recognition, being dragged around the mud by a ferocious beast as drunken highborn cheered and clapped.";
		this.m.HiringCost = 125;
		this.m.DailyCost = 13;
		this.m.Excluded = [
			"trait.weasel",
			"trait.fear_undead",
			"trait.hate_undead",
			"trait.ailing",
			"trait.clubfooted",
			"trait.irrational",
			"trait.asthmatic",
			"trait.clumsy",
			"trait.fat",
			"trait.craven",
			"trait.insecure",
			"trait.dastard",
			"trait.fainthearted",
			"trait.bright",
			"trait.bleeder",
			"trait.fragile",
			"trait.tiny"
		];
		this.m.ExcludedTalents = [
			this.Const.Attributes.RangedSkill
		];
		this.m.Faces = this.Const.Faces.AllMale;
		this.m.Hairs = this.Const.Hair.UntidyMale;
		this.m.HairColors = this.Const.HairColors.All;
		this.m.Beards = this.Const.Beards.Untidy;
		this.m.Bodies = this.Const.Bodies.Muscular;
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
				id = 12,
				type = "text",
				icon = "ui/icons/regular_damage.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+100%[/color] do obrażeń walcząc bez broni"
			}
		];
	}

	function onBuildDescription()
	{
		return "%name% jest waleczny i zdaje sie mieć dzwony kościelne zamiast pięści. Większość ostatniego roku spędził szlifując swoje umiejętności bokserskie na twarzach swoich bliźnich. | Nietrudno się zorientować, że %name% jest zawodowym wojownikiem. Zdradza to jego zdeformowana twarz, na której odcisnęły się kształty cudzych knykci. | %name% uwielbia pić, tak samo jak uwielbia dać komuś w mordę, co stanowi dość silne połączenie. | Surowe wychowanie przez ojca i braci sprawiło, że %name% stał się naturalnym wojownikiem. | Prześladowania w młodości uczyniły z niego człowieka, który woli sam poszukać walki, niż czekać, aż ona poszuka jego. | %name% miał tylko jeden prawdziwy talent: używanie pięści do przemieniania nosów innych mężczyzn w krwawą miazgę oraz nie poddawanie się bez względu na wszystko. | Dorastając, %name% walczył z bykami na rodzinnej farmie. Miejscowi mężczyźni mieli tego pecha, że czasami lubił też zapuszczać się do miasta.} {Przez ostatni rok pracował dla miejscowego lorda, paradując z nim i walcząc na pięści z królewskimi czempionami. | Jako miłośnik karczemnych bijatyk, został najwyraźniej wykluczony ze zbyt wielu oberży, by móc je wszystkie zliczyć. | Zdobycie sławy jako wojownik w %randomtown% oznaczało, że musiał walczyć z każdym napuszonym, chełpliwym i pijanym człowiekiem, który stanął na jego drodze. | Chociaż został niepokonanym zawodnikiem, zarabiał tyle, że ledwo starczało mu na życie. | Ognisty w duchu, zawsze chętny do podjęcia walki. Miejscowi mawiają, że miał niezły lewy sierpowy.} {Słysząc, że są jakieś większe walki do stoczenia, %name% złożył rękawice, by zająć się bardziej lukratywnym zawodem - pracą najemnika. | Zdołała go pokonać tylko jedna osoba: jego żona. Po tym, jak zganiła go za to, że jest żenujący i nie ma żadnych ambicji, postanowił zająć się bardziej prestiżową dziedziną, czyli pracą najemnika. | Lata walki praktycznie zniszczyły jego pamięć. Niektórzy uważają, że pomylił obóz najemników z pozycją na liście zakupów. | Mając mało koron i ledwo mogąc rozewrzeć swe połamane ramiona, aby przytulić własnego syna, a co dopiero mówić o wyprowadzeniu skutecznego ciosu, %name% szuka nowej kariery. | Po latach trudów obietnica regularnego wynagrodzenia za pracę najemnika jest dla niego kuszącą ofertą, nawet jeśli ma niewielkie pojęcie o prawdziwej wojnie. | Ten człowiek zdołałby zamordować głaz i zranić kamień - dobry dodatek do każdej kompanii.}";
	}

	function onChangeAttributes()
	{
		local c = {
			Hitpoints = [
				5,
				10
			],
			Bravery = [
				7,
				5
			],
			Stamina = [
				10,
				5
			],
			MeleeSkill = [
				5,
				0
			],
			RangedSkill = [
				0,
				0
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
				5,
				0
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
			actor.setTitle(this.Const.Strings.BrawlerTitles[this.Math.rand(0, this.Const.Strings.BrawlerTitles.len() - 1)]);
		}
	}

	function onAddEquipment()
	{
		local items = this.getContainer().getActor().getItems();
		local r;
		r = this.Math.rand(0, 2);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/armor/sackcloth"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/armor/tattered_sackcloth"));
		}
		else if (r == 2)
		{
			items.equip(this.new("scripts/items/armor/leather_wraps"));
		}
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (_skill.getID() == "actives.hand_to_hand")
		{
			_properties.DamageTotalMult *= 2.0;
		}
	}

});

