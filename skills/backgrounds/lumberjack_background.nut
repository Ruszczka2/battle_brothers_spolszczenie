this.lumberjack_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.lumberjack";
		this.m.Name = "Drwal";
		this.m.Icon = "ui/backgrounds/background_04.png";
		this.m.BackgroundDescription = "Drwale przyzwyczajeni są do ciężkiej fizycznej pracy. I toporów.";
		this.m.GoodEnding = "%name%, krzepki drwal, w końcu odszedł z kompanii i wrócił do lasu. Założył własny interes drzewny i pracuje przez cały rok. Szczęśliwie trafił w czas: szlachta ostatnio naprawdę zafiksowała się na domkach z bali i sypie koronami każdemu, kto je potrafi postawić.";
		this.m.BadEnding = "%name% miał dość życia najemnika i wrócił do ścinki. Ostatnio słyszałeś, że uczestniczył w wypadku przy ścinaniu drzewa i jego ciało można było zwinąć jak dywan, bo kości były tak dokładnie zmiażdżone.";
		this.m.HiringCost = 100;
		this.m.DailyCost = 13;
		this.m.Excluded = [
			"trait.weasel",
			"trait.hate_undead",
			"trait.night_blind",
			"trait.ailing",
			"trait.clubfooted",
			"trait.asthmatic",
			"trait.clumsy",
			"trait.fat",
			"trait.craven",
			"trait.fainthearted",
			"trait.bright",
			"trait.bleeder",
			"trait.fragile",
			"trait.tiny"
		];
		this.m.Titles = [
			"Tęgi",
			"Topór",
			"Człowiek Lasu"
		];
		this.m.Faces = this.Const.Faces.AllMale;
		this.m.Hairs = this.Const.Hair.CommonMale;
		this.m.HairColors = this.Const.HairColors.All;
		this.m.Beards = this.Const.Beards.Untidy;
		this.m.Bodies = this.Const.Bodies.Muscular;
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
		return "Będąc drwalem, %fullname% {większość swoich dni spędził w lasach, ścinając drzewa | zarabiał na życie ścinając drzewa na opał | nigdy nie był widywany bez topora lub drewna niesionego na ramieniu | zawsze był cichym człowiekiem, który wolał spokój lasów o towarzystwa ludzi | nierzadko przykuwał wzrok młodych niewiast, ze względu na swą solidną posturę i muskularne ręce | zawsze fantazjował o byciu rycerzem i machaniu swym toporem nie przeciwko drzewom, ale orkom i trollom}. {Dla tak rosłego tęgiego mężczyzny, praca w terenie przychodziła z łatwością | Uwielbiał swoją kolekcję toporów, nazywając każdy z nich imionami swych dawnych kochanek | Każdy dzień pełen był ciężkiej, ale za to uczciwej pracy | Gdy był sam pośród drzew, rozmawiał z nimi i zmuszał je do przyznania się, które z nich dadzą mu najlepsze drewno | Niewielu potrafiło tak machać toporem, jak on, powalając drzewa dokładnie w taki sposób, w jaki sobie zażyczył | Dzięki swej rosłej i krępej budowie, potrafił dźwigać na swych barkach ciężary, które innych ludzi by zmiażdżyły}. {Jak większość ludzi, przejął zawód po swym ojcu. Jednak z biegiem lat olśniło go, że chciałby od życia coś więcej, niż każdego kolejnego dnia oglądać te same lasy. Po długich i ciężkich przemyśleniach, zdecydował | Całe życie zawaliło mu się w chwili, gdy jego ukochana żona zmarła w połogu. Po tym, jak los odebrał mu wszystko, powoli stawał się coraz większym odludkiem, aż w końcu nawet ciche knieje nie były już w stanie ukoić jego duszy. Chcąc uciec od tego wszystkiego, postanowił | Pewnego razu, wracając z boru, z daleka dostrzegł dym. Płonęła jego wieś. Wszystkich mieszkańców wyrżnięto bądź pojmano. Zniszczono jego dom. Pełen gniewu wyruszył w drogę i postanowił | Z biegiem czasu, dziwne stwory zaczęły pojawiać się w lasach. Wieśniacy znikali, jeden po drugim, niektórzy się wyprowadzili. Po długiej, bezsennej nocy, uznał, że już czas, aby i on opuścił to miejsce. Nie mając z czego żyć, nie zostało mu nic innego jak | O dziwo, wyglądało na to, że %name% z biegiem czasu stracił zainteresowanie drzewami, coraz częściej mówiąc o wyruszeniu w nieznane, o ile w ogóle się odzywał. Pewnego brzemiennego skutki dnia, ujrzano go jak opuszcza swą chatę, by | Któregoś niefortunnego dnia, ścięte przez niego drzewo zabiło jelenia. %name% nie chciał, aby mięso się zmarnowało, więc zabrał zwierzynę do swego domu, nie spodziewając się, że zostanie oskarżony o kłusownictwo. Zanim zdążono wydać wyrok, w pośpiechu opuścił wioskę, aby} dołączyć do wędrownej kompanii najemników.";
	}

	function onChangeAttributes()
	{
		local c = {
			Hitpoints = [
				10,
				10
			],
			Bravery = [
				0,
				5
			],
			Stamina = [
				10,
				15
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
				-5,
				0
			]
		};
		return c;
	}

	function onAddEquipment()
	{
		local items = this.getContainer().getActor().getItems();
		local r;
		r = this.Math.rand(0, 2);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/weapons/hand_axe"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/weapons/hatchet"));
		}
		else if (r == 2)
		{
			items.equip(this.new("scripts/items/weapons/woodcutters_axe"));
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
			local item = this.new("scripts/items/armor/linen_tunic");
			item.setVariant(6);
			items.equip(item);
		}

		r = this.Math.rand(0, 1);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/helmets/hood"));
		}
	}

});

