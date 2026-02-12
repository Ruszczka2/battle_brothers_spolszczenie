::mods_hookNewObject("items/shields/named/named_bandit_heater_shield", function ( o )
{
	o.m.Description = "Wytrzymała trójkątna tarcza, dobra do walki w zwarciu. Ten egzemplarz jest niezwykle dobrze wykonany i zbalansowany.";
});
::mods_hookNewObject("items/shields/named/named_bandit_kite_shield", function ( o )
{
	o.m.Description = "Długa drewniana tarcza, osłaniająca całe ciało i zapewniająca dobrą ochronę przed atakami z dystansu. Ten konkretny egzemplarz jest niebywale dobrze wykonany i nieczęsto się takie napotyka.";
});
::mods_hookNewObject("items/shields/named/named_dragon_shield", function ( o )
{
	o.m.Description = "Duża tarcza migdałowa zdobiona malowidłami. Jest to twór nadzwyczajnego rzemiosła.";
});
::mods_hookNewObject("items/shields/named/named_full_metal_heater_shield", function ( o )
{
	o.m.Description = "Przednia tarcza rycerska, wykonana niemal w całości z metalu. Ciężka i trwała, choć lżejsza niż można by się spodziewać. Rzemieślnik, który ją wykonał, zaiste musiał być mistrzem w swoim fachu.";
});
::mods_hookNewObject("items/shields/named/named_golden_round_shield", function ( o )
{
	o.m.Description = "W pełni metalowa okrągła tarcza nadzwyczajnej jakości. Musiała być dumą tego, ktokolwiek ją dzierżył.";
});
::mods_hookNewObject("items/shields/named/named_orc_heavy_shield", function ( o )
{
	o.m.Description = "Masywna metalowa tarcza, niemal niemożliwa do zniszczenia, lecz bardzo ciężka i nieporęczna dla każdego człowieka.";
});
::mods_hookNewObject("items/shields/named/named_red_white_shield", function ( o )
{
	o.m.Description = "Duża i gruba tarcza wykonana w jakimś zagranicznym stylu. Zapewnia doskonałą ochronę pomimo swego osobliwego kształtu.";
});
::mods_hookNewObject("items/shields/named/named_rider_on_horse_shield", function ( o )
{
	o.m.Description = "Tarcza rycerska pokryta ikonograficznymi malunkami i będąca swego rodzaju relikwią. Wydaje się stara, lecz nadal jest wytrzymała i łatwo się nią włada.";
});
::mods_hookNewObject("items/shields/named/named_undead_heater_shield", function ( o )
{
	o.m.Description = "Trójkątna drewniana tarcza, pokryta skórą i płótnem. Stara, ale bardzo dobrze zbalansowana.";
});
::mods_hookNewObject("items/shields/named/named_undead_kite_shield", function ( o )
{
	o.m.Description = "Pociągła drewniana tarcza, zapewniająca dobrą ochronę także dolnym partiom ciała, pomimo swej wiekowości. Dość masywna i mniej poręczna w bezpośrednich starciach.";
});
::mods_hookNewObject("items/shields/named/named_wing_shield", function ( o )
{
	o.m.Description = "Wzmocniona drewniana tarcza rycerska, wykonana z najprzedniejszych materiałów i bez wątpienia jest dziełem mistrza w tym rzemiośle.";
});
::mods_hookNewObject("items/shields/named/named_sipar_shield", function ( o )
{
	o.m.Description = "W pełni metalowa okrągła tarcza wykonana na południową modłę ze skomplikowanymi zdobieniami. Dość ciężka, lecz też wytrzymała.";
	o.m.PrefixList = this.Const.Strings.SouthernPrefix;
	o.m.SuffixList = this.Const.Strings.SouthernSuffix;
	o.createRandomName = function ()
	{
		if (!this.m.UseRandomName || this.Math.rand(1, 100) <= 60)
		{
			if (this.m.SuffixList.len() == 0 || this.Math.rand(1, 100) <= 70)
			{
				if (this.Math.rand(1, 100) <= 50)
				{
					return this.m.PrefixList[this.Math.rand(0, this.m.PrefixList.len() - 1)] + " " + this.Const.Strings.ShieldNamesFemale[this.Math.rand(0, this.Const.Strings.ShieldNamesFemale.len() - 1)];
				}
				else
				{
					return this.Const.Strings.SouthernPrefixMale[this.Math.rand(0, this.Const.Strings.SouthernPrefixMale.len() - 1)] + " " + this.Const.Strings.ShieldNamesMale[this.Math.rand(0, this.Const.Strings.ShieldNamesMale.len() - 1)];
				}
			}
			else
			{
				return this.m.NameList[this.Math.rand(0, this.m.NameList.len() - 1)] + " " + this.m.SuffixList[this.Math.rand(0, this.m.SuffixList.len() - 1)];
			}
		}
		else if (this.Math.rand(1, 2) == 1)
		{
			return this.m.NameList[this.Math.rand(0, this.m.NameList.len() - 1)] + " " + this.getRandomCharacterName(this.Const.Strings.SouthernNamesLastGenitive);
		}
		else
		{
			return this.m.NameList[this.Math.rand(0, this.m.NameList.len() - 1)] + " " + this.getRandomCharacterName(this.Const.Strings.NomadChampionStandaloneGenitive);
		}
	};
});
::mods_hookNewObject("items/shields/named/named_lindwurm_shield", function ( o )
{
	o.m.Description = "Solidna drewniana rama stanowi bazę dla lśniących rzędów rzadkich łusek Lindwurma, a razem stanowią ochronę nie do przebicia.";
	o.m.PrefixList = [
		"Lindwurmia",
		"Gadzia",
		"Smocza",
		"Wężołuska",
		"Łuskowata",
		"Wężoskóra",
		"Gadzioskóra",
		"Łuskowa"
	];
	o.m.SuffixList = [
		"Lindwurmi",
		"Gadzi",
		"Smoczy",
		"Wężołuski",
		"Łuskowaty",
		"Wężoskóry",
		"Gadzioskóry",
		"Łuskowy"
	];
	o.createRandomName = function ()
	{
		if (this.Math.rand(1, 100) <= 50)
		{
			return this.m.PrefixList[this.Math.rand(0, this.m.PrefixList.len() - 1)] + " " + this.Const.Strings.ShieldNamesFemale[this.Math.rand(0, this.Const.Strings.ShieldNamesFemale.len() - 1)];
		}
		else
		{
			return this.m.SuffixList[this.Math.rand(0, this.m.SuffixList.len() - 1)] + " " + this.Const.Strings.ShieldNamesMale[this.Math.rand(0, this.Const.Strings.ShieldNamesMale.len() - 1)];
		}
	};
});
::mods_hookBaseClass("items/shields/named/named_shield", function ( o )
{
	while (!("createRandomName" in o))
	{
		o = o[o.SuperName];
	}

	o.createRandomName = function ()
	{
		if (!this.m.UseRandomName || this.Math.rand(1, 100) <= 60)
		{
			if (this.m.SuffixList.len() == 0 || this.Math.rand(1, 100) <= 70)
			{
				if (this.Math.rand(1, 100) <= 50)
				{
					return this.m.PrefixList[this.Math.rand(0, this.m.PrefixList.len() - 1)] + " " + this.Const.Strings.ShieldNamesFemale[this.Math.rand(0, this.Const.Strings.ShieldNamesFemale.len() - 1)];
				}
				else
				{
					return this.Const.Strings.RandomShieldPrefixMale[this.Math.rand(0, this.Const.Strings.RandomShieldPrefixMale.len() - 1)] + " " + this.Const.Strings.ShieldNamesMale[this.Math.rand(0, this.Const.Strings.ShieldNamesMale.len() - 1)];
				}
			}
			else
			{
				return this.m.NameList[this.Math.rand(0, this.m.NameList.len() - 1)] + " " + this.m.SuffixList[this.Math.rand(0, this.m.SuffixList.len() - 1)];
			}
		}
		else if (this.Math.rand(1, 2) == 1)
		{
			return this.m.NameList[this.Math.rand(0, this.m.NameList.len() - 1)] + " " + this.getRandomCharacterName(this.Const.Strings.KnightNames) + "a";
		}
		else
		{
			return this.m.NameList[this.Math.rand(0, this.m.NameList.len() - 1)] + " " + this.getRandomCharacterName(this.Const.Strings.BanditLeaderNamesGenitive);
		}
	};

	while (!("onEquip" in o))
	{
		o = o[o.SuperName];
	}

	o.onEquip = function ()
	{
		this.shield.onEquip();

		if (this.m.Name.len() == 0)
		{
			if (this.Math.rand(1, 100) <= 25)
			{
				this.setName(this.m.NameList[this.Math.rand(0, this.m.NameList.len() - 1)] + " - " + this.getContainer().getActor().getName());
			}
			else
			{
				this.setName(this.createRandomName());
			}
		}
	};
});

