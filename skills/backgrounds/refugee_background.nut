this.refugee_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.refugee";
		this.m.Name = "Uchodźca";
		this.m.Icon = "ui/backgrounds/background_38.png";
		this.m.BackgroundDescription = "Uchodźcom brakowało przekonania, by walczyć o swe domy, lecz teraz przyzwyczajeni są już do długich i męczących podróży.";
		this.m.GoodEnding = "%name% uchodźca dowiódł, że jest urodzonym wojownikiem, ale ostatecznie odszedł z kompanii %companyname%. Wieść niesie, że wrócił do swych rodzinnych stron i obecnie wszystkie swe zarobione korony poświęca, aby pomóc w odbudowie.";
		this.m.BadEnding = "Widmo upadku kompanii %companyname% było niemal pewne, więc %name% się od niej oddzielił. Za tę garść koron, które mu zostały, kupił nową parę butów i wyruszył do swego rodzinnego domu, aby spróbować go odbudować. Podczas tej wędrówki jakiś nieoczytany dzikus napadł go, zamordował, a buty zjadł.";
		this.m.HiringCost = 40;
		this.m.DailyCost = 4;
		this.m.Excluded = [
			"trait.impatient",
			"trait.iron_jaw",
			"trait.athletic",
			"trait.tough",
			"trait.strong",
			"trait.loyal",
			"trait.cocky",
			"trait.fat",
			"trait.bright",
			"trait.fearless",
			"trait.brave",
			"trait.determined",
			"trait.deathwish",
			"trait.greedy",
			"trait.bloodthirsty"
		];
		this.m.Titles = [
			"Uchodźca",
			"Ocalały",
			"Zbiegły",
			"Bezdomny",
			"Włóczęga"
		];
		this.m.Faces = this.Const.Faces.AllMale;
		this.m.Hairs = this.Const.Hair.UntidyMale;
		this.m.HairColors = this.Const.HairColors.All;
		this.m.Beards = this.Const.Beards.Untidy;
		this.m.Bodies = this.Const.Bodies.Skinny;
		this.m.IsOffendedByViolence = true;
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
		return "{Katastrofy są tanie. | Zarazy, zabójcza niewidzialna dłoń. | Wygrana lub przegrana wojna, wszystko jedno.} %name% pochodzi z maleńkiej wioski, która {istnieje już tylko w słownych przekazach, będąc o jedno pokolenie od całkowitego zapomnienia. | została unicestwiona, zwięźle mówiąc. | jest teraz jeno krótką notatką, marnującą odrobinę tuszu historyka. | odczuła na sobie gniew świata.} Jednak %name% jest ocalałym. {Uciekł przed zagładą i ostało mu się zaledwie tylko odzienie, które właśnie miał na sobie. | Jego dom płonął, więc ocalił to, co zdołał i uciekł. | Natknąwszy się na zwłoki swojej rodziny, zebrał, co naprędce zdołał i dał nogę. | Wojna, głód, zaraza. Teraz to dla niego tylko mgliste wspomnienia.} {%name% jest tylko człowiekiem, który woli patrzeć wprzód, niźli oglądać się za siebie. | %name% ma w sobie niewiele poza stalową determinacją, lecz to dość pożądana cecha. | Tragiczna przeszłość pokryła bliznami jego ciało i da się ją dostrzec w jego oczach, jednak łatwo go zmotywować do robienia wszystkiego, aby tamtych dawnych wydarzeń już nigdy nie doświadczyć. | Jakiekolwiek nieszczęście spadło na jego osadę, nie zdołało dopaść jego samego, a z plotek, które słyszałeś, to już o czymś świadczy. | Nie jest biegły w sztuce wojennej, ale z pewnością twardy z niego sukinsyn i ma potężną wolę życia. | Czymkolwiek wcześniej się zajmował, teraz to już przepadło. Jak wielu innych, szuka pracy jako najemnik, aby jakoś przetrwać w tym coraz bardziej krwawym świecie. | To kolejny spotkany przez ciebie uchodźca, który w końcu zdecydował się przestać uciekać i zacząć walczyć.}";
	}

	function onChangeAttributes()
	{
		local c = {
			Hitpoints = [
				-8,
				-5
			],
			Bravery = [
				-5,
				-5
			],
			Stamina = [
				7,
				5
			],
			MeleeSkill = [
				0,
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
		r = this.Math.rand(0, 4);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/weapons/knife"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/weapons/wooden_stick"));
		}

		r = this.Math.rand(0, 1);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/armor/tattered_sackcloth"));
		}

		if (r == 1)
		{
			items.equip(this.new("scripts/items/armor/sackcloth"));
		}
	}

});

