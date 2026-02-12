local thrown_1h = "Broń miotana, Jednoręczna";
local thrown_2h = "Broń miotana, Dwuręczna";
::mods_hookNewObject("items/weapons/staff_sling", function ( o )
{
	o.m.Name = "Proca";
	o.m.Description = "Skórzana proca na kiju, używana by miotać kamieniami we wroga. Jako że kamienie są wszędzie, nigdy nie skończy jej się amunicja.";
	o.m.Categories = thrown_2h;
});
::mods_hookNewObject("items/weapons/oriental/nomad_sling", function ( o )
{
	o.m.Name = "Proca Koczownika";
	o.m.Description = "Skórzana proca na wzmocnionym żelazem kiju, używana by miotać kamieniami we wroga. Jako że kamienie są wszędzie, nigdy nie skończy jej się amunicja.";
	o.m.Categories = thrown_2h;
});
::mods_hookNewObject("items/weapons/throwing_axe", function ( o )
{
	o.m.Name = "Pęk Toporów do Rzucania";
	o.m.Description = "Niewielkie toporki, służące do miotania w kierunku celu. Wystarczająco ciężkie, by zadać z odległości poważne obrażenia pancerzom i tarczom.";
	o.m.Categories = thrown_1h;
	o.setAmmo = function ( _a )
	{
		this.weapon.setAmmo(_a);

		if (this.m.Ammo > 0)
		{
			this.m.Name = "Pęk Toporów do Rzucania";
			this.m.IconLarge = "weapons/ranged/throwing_axes_01.png";
			this.m.Icon = "weapons/ranged/throwing_axes_01_70x70.png";
			this.m.ShowArmamentIcon = true;
		}
		else
		{
			this.m.Name = "Pęk Toporów do Rzucania (Pusty)";
			this.m.IconLarge = "weapons/ranged/throwing_axes_01_bag.png";
			this.m.Icon = "weapons/ranged/throwing_axes_01_bag_70x70.png";
			this.m.ShowArmamentIcon = false;
		}

		this.updateAppearance();
	};
});
::mods_hookNewObject("items/weapons/javelin", function ( o )
{
	o.m.Name = "Pęk Oszczepów";
	o.m.Description = "Kilka lekkich włóczni do rzucania, używanych zazwyczaj przez harcowników. Mają ograniczony zasięg i miotanie nimi jest męczące, choć są w stanie zadawać niszczycielskie rany.";
	o.m.Categories = thrown_1h;
	o.setAmmo = function ( _a )
	{
		this.weapon.setAmmo(_a);

		if (this.m.Ammo > 0)
		{
			this.m.Name = "Pęk Oszczepów";
			this.m.IconLarge = "weapons/ranged/javelins_01.png";
			this.m.Icon = "weapons/ranged/javelins_01_70x70.png";
			this.m.ShowArmamentIcon = true;
		}
		else
		{
			this.m.Name = "Pęk Oszczepów (Pusty)";
			this.m.IconLarge = "weapons/ranged/javelins_01_bag.png";
			this.m.Icon = "weapons/ranged/javelins_01_bag_70x70.png";
			this.m.ShowArmamentIcon = false;
		}

		this.updateAppearance();
	};
});
::mods_hookNewObject("items/weapons/throwing_spear", function ( o )
{
	o.m.Name = "Włócznia Do Rzucania";
	o.m.Description = "Lżejsza niż przeciętna włócznia, choć cięższa niż oszczep, ta broń służy do miotania na niewielkie odległości. Grot zegnie się po trafieniu, potencjalnie sprawiając, że tarcza będzie bezużyteczna. Może być używana również przeciwko celom nie chronionym przez tarcze.";
	o.m.Categories = thrown_1h;
	o.getTooltip = function ()
	{
		local result = this.weapon.getTooltip();
		result.push({
			id = 4,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Ulega zniszczeniu po użyciu"
		});
		return result;
	};
});
::mods_hookNewObject("items/weapons/barbarians/heavy_javelin", function ( o )
{
	o.m.Name = "Pęk Ciężkich Oszczepów";
	o.m.Description = "Zestaw ciężkich, prymitywnie wyglądających oszczepów. Trudniej nimi rzucać i trafiać, ale zadają większe obrażenia.";
	o.m.Categories = thrown_1h;
	o.setAmmo = function ( _a )
	{
		this.weapon.setAmmo(_a);

		if (this.m.Ammo > 0)
		{
			this.m.Name = "Pęk Ciężkich Oszczepów";
			this.m.IconLarge = "weapons/ranged/javelins_heavy_01.png";
			this.m.Icon = "weapons/ranged/javelins_heavy_01_70x70.png";
			this.m.ShowArmamentIcon = true;
		}
		else
		{
			this.m.Name = "Pęk Ciężkich Oszczepów (Pusty)";
			this.m.IconLarge = "weapons/ranged/javelins_01_bag.png";
			this.m.Icon = "weapons/ranged/javelins_01_bag_70x70.png";
			this.m.ShowArmamentIcon = false;
		}

		this.updateAppearance();
	};
});
::mods_hookNewObject("items/weapons/barbarians/heavy_throwing_axe", function ( o )
{
	o.m.Name = "Pęk Ciężkich Toporów do Rzucania";
	o.m.Description = "Ciężkie i nieporęczne topory do rzucania, używane przez północnych barbarzyńców. Trudno się nimi miota i jeszcze trudniej trafia, są jednak zabójcze.";
	o.m.Categories = thrown_1h;
	o.setAmmo = function ( _a )
	{
		this.weapon.setAmmo(_a);

		if (this.m.Ammo > 0)
		{
			this.m.Name = "Pęk Ciężkich Toporów do Rzucania";
			this.m.IconLarge = "weapons/ranged/throwing_axes_heavy_01.png";
			this.m.Icon = "weapons/ranged/throwing_axes_heavy_01_70x70.png";
			this.m.ShowArmamentIcon = true;
		}
		else
		{
			this.m.Name = "Pęk Ciężkich Toporów do Rzucania (Pusty)";
			this.m.IconLarge = "weapons/ranged/throwing_axes_01_bag.png";
			this.m.Icon = "weapons/ranged/throwing_axes_01_bag_70x70.png";
			this.m.ShowArmamentIcon = false;
		}

		this.updateAppearance();
	};
});
::mods_hookNewObject("items/weapons/greenskins/goblin_spiked_balls", function ( o )
{
	o.m.Name = "Pęk Kolczastych Bolas";
	o.m.Description = "Małe i ciężkie żelazne kule z metalowymi kolcami, służące do miotania we wrogów.";
	o.m.Categories = thrown_1h;
});
::mods_hookNewObject("items/weapons/greenskins/orc_javelin", function ( o )
{
	o.m.Name = "Pęk Prymitywnych Oszczepów";
	o.m.Description = "Pęk prymitywnie wykonanych oszczepów do rzucania w cele. Mają ograniczony zasięg i miotanie nimi jest męczące, choć są w stanie zadawać niszczycielskie rany.";
	o.m.Categories = thrown_1h;
	o.setAmmo = function ( _a )
	{
		function setAmmo( _a )
		{
			this.weapon.setAmmo(_a);

			if (this.m.Ammo > 0)
			{
				this.m.Name = "Pęk Prymitywnych Oszczepów";
				this.m.IconLarge = "weapons/ranged/orc_javelins.png";
				this.m.Icon = "weapons/ranged/orc_javelins_70x70.png";
				this.m.ShowArmamentIcon = true;
			}
			else
			{
				this.m.Name = "Pęk Prymitywnych Oszczepów (Pusty)";
				this.m.IconLarge = "weapons/ranged/orc_javelins_bag_140x70.png";
				this.m.Icon = "weapons/ranged/orc_javelins_bag_70x70.png";
				this.m.ShowArmamentIcon = false;
			}

			this.updateAppearance();
		}

	};
});

