local dagger_1h = "Sztylet, Broń jednoręczna";
local sword_1h = "Miecz, Broń jednoręczna";
local sword_2h = "Miecz, Broń dwuręczna";
local cleaver_1h = "Tasak, Broń jednoręczna";
local cleaver_2h = "Tasak, Broń dwuręczna";
local axe_1h = "Topór, Broń jednoręczna";
local axe_2h = "Topór, Broń dwuręczna";
local spear_1h = "Włócznia, Broń jednoręczna";
local spear_2h = "Włócznia, Broń dwuręczna";
local flail_1h = "Cep, Broń jednoręczna";
local flail_2h = "Cep, Broń dwuręczna";
local mace_1h = "Maczuga, Broń jednoręczna";
local mace_2h = "Maczuga, Broń dwuręczna";
local hammer_1h = "Młot, Broń jednoręczna";
local hammer_2h = "Młot, Broń dwuręczna";
local thrown_1h = "Broń miotana, Jednoręczna";
local thrown_2h = "Broń miotana, Dwuręczna";
local pole_2h = "Broń drzewcowa, Dwuręczna";
local bow_2h = "Łuk, Broń dwuręczna";
local crossbow_2h = "Kusza, Broń dwuręczna";
local firearm_2h = "Broń palna, Dwuręczna";
local ancient_name = function ()
{
	if (this.Math.rand(1, this.m.PrefixList.len() + this.m.SuffixList.len()) <= this.m.PrefixList.len())
	{
		return this.Const.Strings.OldWeaponPrefix[this.Math.rand(0, this.Const.Strings.OldWeaponPrefix.len() - 1)] + " " + this.m.PrefixList[this.Math.rand(0, this.m.PrefixList.len() - 1)];
	}
	else
	{
		return this.Const.Strings.OldWeaponPrefixMale[this.Math.rand(0, this.Const.Strings.OldWeaponPrefixMale.len() - 1)] + " " + this.m.SuffixList[this.Math.rand(0, this.m.SuffixList.len() - 1)];
	}
};
local goblin_name = function ()
{
	if (this.Math.rand(1, this.m.PrefixList.len() + this.m.SuffixList.len()) <= this.m.PrefixList.len())
	{
		return this.Const.Strings.GoblinWeaponPrefix[this.Math.rand(0, this.Const.Strings.GoblinWeaponPrefix.len() - 1)] + " " + this.m.PrefixList[this.Math.rand(0, this.m.PrefixList.len() - 1)];
	}
	else
	{
		return this.Const.Strings.GoblinWeaponPrefixMale[this.Math.rand(0, this.Const.Strings.GoblinWeaponPrefixMale.len() - 1)] + " " + this.m.SuffixList[this.Math.rand(0, this.m.SuffixList.len() - 1)];
	}
};
local barbarian_name = function ()
{
	if (this.Math.rand(1, this.Const.Strings.BarbarianSuffix.len() + this.Const.Strings.BarbarianPrefix.len()) <= this.Const.Strings.BarbarianPrefix.len())
	{
		if (this.Math.rand(1, this.m.PrefixList.len() + this.m.SuffixList.len()) <= this.m.PrefixList.len())
		{
			return this.Const.Strings.BarbarianPrefix[this.Math.rand(0, this.Const.Strings.BarbarianPrefix.len() - 1)] + " " + this.m.PrefixList[this.Math.rand(0, this.m.PrefixList.len() - 1)];
		}
		else
		{
			return this.Const.Strings.BarbarianPrefixMale[this.Math.rand(0, this.Const.Strings.BarbarianPrefixMale.len() - 1)] + " " + this.m.SuffixList[this.Math.rand(0, this.m.SuffixList.len() - 1)];
		}
	}
	else
	{
		return this.m.NameList[this.Math.rand(0, this.m.NameList.len() - 1)] + " " + this.Const.Strings.BarbarianSuffix[this.Math.rand(0, this.Const.Strings.BarbarianSuffix.len() - 1)];
	}
};
local multi_name = function ()
{
	if (!this.m.UseRandomName || this.Math.rand(1, 100) <= 60)
	{
		return this.Const.Strings.RandomWeaponPrefixMulti[this.Math.rand(0, this.Const.Strings.RandomWeaponPrefixMulti.len() - 1)] + " " + this.m.NameList[this.Math.rand(0, this.m.NameList.len() - 1)];
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
local southern_name = function ()
{
	if ((!this.m.UseRandomName || this.Math.rand(1, 100) <= 60) && this.m.PrefixList.len() + this.m.SuffixList.len() > 0)
	{
		if (this.Math.rand(1, this.Const.Strings.SouthernSuffix.len() + this.Const.Strings.SouthernPrefix.len()) <= this.Const.Strings.SouthernPrefix.len())
		{
			if (this.Math.rand(1, this.m.PrefixList.len() + this.m.SuffixList.len()) <= this.m.PrefixList.len())
			{
				return this.Const.Strings.SouthernPrefix[this.Math.rand(0, this.Const.Strings.SouthernPrefix.len() - 1)] + " " + this.m.PrefixList[this.Math.rand(0, this.m.PrefixList.len() - 1)];
			}
			else
			{
				return this.Const.Strings.SouthernPrefixMale[this.Math.rand(0, this.Const.Strings.SouthernPrefixMale.len() - 1)] + " " + this.m.SuffixList[this.Math.rand(0, this.m.SuffixList.len() - 1)];
			}
		}
		else
		{
			return this.m.NameList[this.Math.rand(0, this.m.NameList.len() - 1)] + " " + this.Const.Strings.SouthernSuffix[this.Math.rand(0, this.Const.Strings.SouthernSuffix.len() - 1)];
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
local reload_text = function ()
{
	local result = this.weapon.getTooltip();

	if (!this.m.IsLoaded)
	{
		result.push({
			id = 10,
			type = "text",
			icon = "ui/tooltips/warning.png",
			text = "[color=" + this.Const.UI.Color.NegativeValue + "]Musi zostać przeładowana przed ponownym strzałem[/color]"
		});
	}

	return result;
};
::mods_hookNewObject("items/weapons/named/named_axe", function ( o )
{
	o.m.NameList = this.Const.Strings.AxeNames;
	o.m.PrefixList = [];
	o.m.SuffixList = this.Const.Strings.AxeNames;
	o.m.Description = "Dobrze wykonana i rzadka odmiana topora, stworzona głównie z myślą o walce z opancerzonymi przeciwnikami.";
	o.m.Categories = axe_2h;
});
::mods_hookNewObject("items/weapons/named/named_bardiche", function ( o )
{
	o.m.NameList = this.Const.Strings.AxeNames;
	o.m.PrefixList = [];
	o.m.SuffixList = this.Const.Strings.AxeNames;
	o.m.Description = "Ten ciężki berdysz wykonany został z rzadkiego stopu i ma ponadprzeciętną jakość.";
	o.m.Categories = axe_2h;
});
::mods_hookNewObject("items/weapons/named/named_battle_whip", function ( o )
{
	o.m.NameList = this.Const.Strings.WhipNames;
	o.m.PrefixList = [];
	o.m.SuffixList = this.Const.Strings.WhipNames;
	o.m.Description = "Bicz jest dość osobliwą bronią, choć ten egzemplarz wyszedł spod rąk prawdziwego mistrza. Jest znacznie bardziej wytrzymały i wyważony, niż wszystkie inne, które dane ci było zobaczyć.";
	o.m.Categories = cleaver_1h;
});
::mods_hookNewObject("items/weapons/named/named_billhook", function ( o )
{
	o.m.NameList = this.Const.Strings.BillNames;
	o.m.PrefixList = this.Const.Strings.BillNamesFemale;
	o.m.SuffixList = this.Const.Strings.BillNamesMale;
	o.m.Description = "Podobna do piki broń z ostrzem do zadawania ciosów na dystans i hakiem do przyciągania celów. Kowal, który wykuł tę broń z pewnością wiedział, co robi.";
	o.m.Categories = pole_2h;
});
::mods_hookNewObject("items/weapons/named/named_bladed_pike", function ( o )
{
	o.m.NameList = this.Const.Strings.PikeNames;
	o.m.PrefixList = this.Const.Strings.PikeNamesFemale;
	o.m.SuffixList = this.Const.Strings.PikeNamesMale;
	o.m.Description = "Ta partyzana pochodzi z legionów starożytnego imperium. Bardzo nieliczne bronie przetrwały w tak dobrym stanie, co ten egzemplarz.";
	o.m.Categories = pole_2h;
	o.createRandomName = ancient_name;
});
::mods_hookNewObject("items/weapons/named/named_cleaver", function ( o )
{
	o.m.NameList = this.Const.Strings.CleaverNames;
	o.m.PrefixList = [];
	o.m.SuffixList = this.Const.Strings.CleaverNames;
	o.m.Description = "Mistrzowski kowal zdołał stworzyć ten tasak wojskowy w taki sposób, że włada się nim niczym zwykłym mieczem, mimo iż nie traci nic ze swej niszczycielskiej mocy";
	o.m.Categories = cleaver_1h;
});
::mods_hookNewObject("items/weapons/named/named_crypt_cleaver", function ( o )
{
	o.m.NameList = this.Const.Strings.CleaverNames;
	o.m.PrefixList = [];
	o.m.SuffixList = this.Const.Strings.CleaverNames;
	o.m.Description = "Masywny tasak, który jest w stanie przeciąć tak ciało, jak i pancerz. Ten egzemplarz jest w dobrym stanie pomimo swej wiekowości.";
	o.m.Categories = cleaver_2h;
	o.createRandomName = ancient_name;
});
::mods_hookNewObject("items/weapons/named/named_dagger", function ( o )
{
	o.m.NameList = this.Const.Strings.DaggerNames;
	o.m.PrefixList = this.Const.Strings.DaggerNamesFemale;
	o.m.SuffixList = this.Const.Strings.DaggerNamesMale;
	o.m.Description = "Krótki, hartowany, mistrzowsko wykonany sztylet o szpiczastym ostrzu, służącym do przebijania się przez najmniejsze luki w pancerzu.";
	o.m.Categories = dagger_1h;
});
::mods_hookNewObject("items/weapons/named/named_fencing_sword", function ( o )
{
	o.m.NameList = this.Const.Strings.FencingSwordNames;
	o.m.PrefixList = this.Const.Strings.FencingSwordNamesFemale;
	o.m.SuffixList = this.Const.Strings.FencingSwordNamesMale;
	o.m.Description = "Wykucie odpowiedniego rapiera, który będzie zarówno delikatny, jak i giętki, jest równie trudne, co władanie nim. Kowal, który stworzył tę konkretną broń, musiał być jednym z najlepszych w swoim rzemiośle.";
	o.m.Categories = sword_1h;
});
::mods_hookNewObject("items/weapons/named/named_flail", function ( o )
{
	o.m.NameList = this.Const.Strings.FlailNames;
	o.m.PrefixList = this.Const.Strings.FlailNamesFemale;
	o.m.SuffixList = this.Const.Strings.FlailNamesMale;
	o.m.Description = "Metalowa głowica przytwierdzona do trzonka łańcuchem. Dość nieprzewidywalna broń, choć użyteczna do uderzania nad lub wokół tarcz. Ten konkretny egzemplarz wydaje się nawet bardziej przerażający z uwagi na swe nietypowe cechy";
	o.m.Categories = flail_1h;
});
::mods_hookNewObject("items/weapons/named/named_goblin_falchion", function ( o )
{
	o.m.NameList = this.Const.Strings.SwordNames;
	o.m.PrefixList = this.Const.Strings.SwordNamesFemale;
	o.m.SuffixList = this.Const.Strings.SwordNamesMale;
	o.m.Description = "To wykonane z zaostrzonej czarnej skały okrutne ostrze potrafi zadawać rany w mgnieniu oka. Prawdziwie niezwykły egzemplarz.";
	o.m.Categories = sword_1h;
	o.createRandomName = goblin_name;
});
::mods_hookNewObject("items/weapons/named/named_goblin_heavy_bow", function ( o )
{
	o.m.NameList = this.Const.Strings.BowNames;
	o.m.PrefixList = this.Const.Strings.BowNamesFemale;
	o.m.SuffixList = this.Const.Strings.BowNamesMale;
	o.m.Description = "Gobliny wiedzą jak wykonać skuteczne i lekkie łuki. Ten egzemplarz, stworzony z jakiegoś nieznanego jasnego drewna, ma wyjątkową siłę naciągu jak na swe niewielkie rozmiary.";
	o.m.Categories = bow_2h;
	o.createRandomName = goblin_name;
});
::mods_hookNewObject("items/weapons/named/named_goblin_pike", function ( o )
{
	o.m.NameList = this.Const.Strings.PikeNames;
	o.m.PrefixList = this.Const.Strings.PikeNamesFemale;
	o.m.SuffixList = this.Const.Strings.PikeNamesMale;
	o.m.Description = "Goblińskie piki ze swymi postrzępionymi grotami potrafią zadawać paskudne szarpane i krwawiące rany. Ten egzemplarz jest wyjątkowo dobrze wykonany.";
	o.m.Categories = pole_2h;
	o.createRandomName = goblin_name;
});
::mods_hookNewObject("items/weapons/named/named_goblin_spear", function ( o )
{
	o.m.NameList = this.Const.Strings.SpearNames;
	o.m.PrefixList = this.Const.Strings.SpearNamesFemale;
	o.m.SuffixList = this.Const.Strings.SpearNamesMale;
	o.m.Description = "Mistrzowsko wykonana goblińska włócznia. Celna, szybka i zabójcza w rękach każdego zdolnego wojownika.";
	o.m.Categories = spear_1h;
	o.createRandomName = goblin_name;
});
::mods_hookNewObject("items/weapons/named/named_greataxe", function ( o )
{
	o.m.NameList = this.Const.Strings.AxeNames;
	o.m.PrefixList = [];
	o.m.SuffixList = this.Const.Strings.AxeNames;
	o.m.Description = "Ciężki i długi dwuręczny topór, stworzony do bitew. Trudny i męczący we władaniu, acz zdolny do rozłupania człowieka na pół.";
	o.m.Categories = axe_2h;
});
::mods_hookNewObject("items/weapons/named/named_greatsword", function ( o )
{
	o.m.NameList = this.Const.Strings.GreatswordNames;
	o.m.PrefixList = this.Const.Strings.GreatswordNamesFemale;
	o.m.SuffixList = this.Const.Strings.GreatswordNamesMale;
	o.m.Description = "Ten dwuręczny miecz to prawdziwy majstersztyk, a jego ostrze jest zarówno giętkie, jak i niebywale wytrzymałe.";
	o.m.Categories = sword_2h;
});
::mods_hookNewObject("items/weapons/named/named_heavy_rusty_axe", function ( o )
{
	o.m.NameList = this.Const.Strings.AxeNames;
	o.m.PrefixList = [];
	o.m.SuffixList = this.Const.Strings.AxeNames;
	o.m.Description = "Ten ciężki, zdobiony topór należał do cenionego członka barbarzyńskiego plemienia. Jego dekoracje i względnie wysoka jakość wykonania to coś, co nieczęsto spotyka się wśród dzikich wojowników na północy.";
	o.m.Categories = axe_2h;
	o.createRandomName = barbarian_name;
});
::mods_hookNewObject("items/weapons/named/named_khopesh", function ( o )
{
	o.m.NameList = this.Const.Strings.CleaverNames;
	o.m.PrefixList = [];
	o.m.SuffixList = this.Const.Strings.CleaverNames;
	o.m.Description = "Eleganckie zakrzywione ostrze, przymocowane do bogato zdobionej rękojeści. Takie egzemplarze zostały utracone na wieki i ponoć datowane są na okres szczytowej potęgi imperium.";
	o.m.Categories = cleaver_1h;
	o.createRandomName = ancient_name;
});
::mods_hookNewObject("items/weapons/named/named_longaxe", function ( o )
{
	o.m.NameList = this.Const.Strings.LongaxeNames;
	o.m.PrefixList = [];
	o.m.SuffixList = this.Const.Strings.LongaxeNames;
	o.m.Description = "Względnie cienka głowica na bardzo długim drzewcu, używana do zadawania niszczycielskich cięć z pewnej odległości oraz do rozłupywania tarcz zza przedniej linii. Ten topór musiał wyjść spod rąk niezwykle utalentowanego rzemieślnika.";
	o.m.Categories = axe_2h;
});
::mods_hookNewObject("items/weapons/named/named_mace", function ( o )
{
	o.m.NameList = this.Const.Strings.MaceNames;
	o.m.PrefixList = this.Const.Strings.MaceNamesFemale;
	o.m.SuffixList = this.Const.Strings.MaceNamesMale;
	o.m.Description = "W pełni metalowa buława z krótkim trzonkiem i przepierzeniami. Zbrojmistrz, który ją wykonał, bez wątpienia znał się na swym fachu.";
	o.m.Categories = mace_1h;
});
::mods_hookNewObject("items/weapons/named/named_orc_axe", function ( o )
{
	o.m.NameList = this.Const.Strings.AxeNames;
	o.m.PrefixList = [];
	o.m.SuffixList = this.Const.Strings.AxeNames;
	o.m.Description = "Ciężki kawał metalu z ostrą głowicą. Nie nadaje się zbytnio do rąk ludzkich.";
	o.m.Categories = axe_1h;
});
::mods_hookNewObject("items/weapons/named/named_orc_cleaver", function ( o )
{
	o.m.NameList = this.Const.Strings.CleaverNames;
	o.m.PrefixList = [];
	o.m.SuffixList = this.Const.Strings.CleaverNames;
	o.m.Description = "Ostry i prymitywny kawał metalu z owiniętą rękojeścią. Przypomina nieco miecz, lecz jest o wiele cięższy. Nie nadaje się zbytnio do rąk ludzkich.";
	o.m.Categories = cleaver_1h;
});
::mods_hookNewObject("items/weapons/named/named_pike", function ( o )
{
	o.m.NameList = this.Const.Strings.PikeNames;
	o.m.PrefixList = this.Const.Strings.PikeNamesFemale;
	o.m.SuffixList = this.Const.Strings.PikeNamesMale;
	o.m.Description = "Długa pika używana do zadawania pchnięć z pewnej odległości i trzymania wroga na dystans. Ta konkretna pika została umiejętnie wykonana ze sprężystego drewna, które potrafi się wygiąć, ale nigdy się nie złamie, zaś metalowy grot jest stopem rzadko spotykanym w tych stronach świata.";
	o.m.Categories = pole_2h;
});
::mods_hookNewObject("items/weapons/named/named_polehammer", function ( o )
{
	o.m.NameList = this.Const.Strings.PolehammerNames;
	o.m.PrefixList = [];
	o.m.SuffixList = this.Const.Strings.PolehammerNames;
	o.m.Description = "Nawet tak prymitywna broń, jak młot na drzewcu może zostać wytworzona z pasją, wprawą i dbałością o detale, co pokazuje ten imponujący egzemplarz.";
	o.m.Categories = hammer_2h;
});
::mods_hookNewObject("items/weapons/named/named_polemace", function ( o )
{
	o.m.NameList = this.Const.Strings.MaceNames;
	o.m.PrefixList = this.Const.Strings.MaceNamesFemale;
	o.m.SuffixList = this.Const.Strings.MaceNamesMale;
	o.m.Description = "Nawet tak prymitywna broń, jak buława na drzewcu może zostać wytworzona z pasją, wprawą i dbałością o detale, co pokazuje ten imponujący egzemplarz.";
	o.m.Categories = mace_2h;
	o.createRandomName = southern_name;
});
::mods_hookNewObject("items/weapons/named/named_qatal_dagger", function ( o )
{
	o.m.NameList = this.Const.Strings.DaggerNames;
	o.m.PrefixList = this.Const.Strings.DaggerNamesFemale;
	o.m.SuffixList = this.Const.Strings.DaggerNamesMale;
	o.m.Description = "Doskonale wykonane zakrzywione ostrze, notorycznie używane przez skrytobójców z południowych pustyń. Szczególnie skuteczne przeciwko celom już osłabionym.";
	o.m.Categories = dagger_1h;
	o.createRandomName = southern_name;
});
::mods_hookNewObject("items/weapons/named/named_rusty_warblade", function ( o )
{
	o.m.NameList = this.Const.Strings.CleaverNames;
	o.m.PrefixList = [];
	o.m.SuffixList = this.Const.Strings.CleaverNames;
	o.m.Description = "To masywne i wyjątkowo dobrze wykonane ostrze wojenne jest pokryte runami i dekoracjami, typowymi dla barbarzyńskich plemion z północy.";
	o.m.Categories = cleaver_2h;
	o.createRandomName = barbarian_name;
});
::mods_hookNewObject("items/weapons/named/named_shamshir", function ( o )
{
	o.m.NameList = this.Const.Strings.SabreNames;
	o.m.PrefixList = this.Const.Strings.SabreNamesFemale;
	o.m.SuffixList = this.Const.Strings.SabreNamesMale;
	o.m.Description = "Szamszir już sam w sobie jest wspaniałą i egzotyczną bronią w tych stronach, jednak ten egzemplarz jest niebywałej jakości. Przetnie się przez ciało i kości z taką łatwością, jakby ciął melona.";
	o.m.Categories = sword_1h;
	o.createRandomName = southern_name;
});
::mods_hookNewObject("items/weapons/named/named_skullhammer", function ( o )
{
	o.m.NameList = this.Const.Strings.HammerNames;
	o.m.PrefixList = [];
	o.m.SuffixList = this.Const.Strings.HammerNames;
	o.m.Description = "Ten prymitywny i ciężki młot został udekorowany dodatkowymi czaszkami zwierząt, jakby sam w sobie był jeszcze zbyt mało imponujący. Niczym łeb barana, zmiażdży swój cel.";
	o.m.Categories = hammer_2h;
	o.createRandomName = barbarian_name;
});
::mods_hookNewObject("items/weapons/named/named_spear", function ( o )
{
	o.m.NameList = this.Const.Strings.SpearNames;
	o.m.PrefixList = this.Const.Strings.SpearNamesFemale;
	o.m.SuffixList = this.Const.Strings.SpearNamesMale;
	o.m.Description = "Mistrzowsko wykonana włócznia, która mimo iż jest zaskakująco lekka, to nie brakuje jej wytrzymałości.";
	o.m.Categories = spear_1h;
});
::mods_hookNewObject("items/weapons/named/named_spetum", function ( o )
{
	o.m.NameList = this.Const.Strings.SpetumNames;
	o.m.PrefixList = this.Const.Strings.SpetumNamesFemale;
	o.m.SuffixList = this.Const.Strings.SpetumNamesMale;
	o.m.Description = "Ta spisa została wykonana nad wyraz porządnie, a jej trzy wierzchołki zostały zaostrzone w idealnie szpiczaste kolce.";
	o.m.Categories = spear_2h;
});
::mods_hookNewObject("items/weapons/named/named_sword", function ( o )
{
	o.m.NameList = this.Const.Strings.SwordNames;
	o.m.PrefixList = this.Const.Strings.SwordNamesFemale;
	o.m.SuffixList = this.Const.Strings.SwordNamesMale;
	o.m.Description = "Dobrze zbalansowany długi miecz z obosieczną klingą. Ciężko znaleźć broń wykonaną tak dobrze, jak ta.";
	o.m.Categories = sword_1h;
});
::mods_hookNewObject("items/weapons/named/named_swordlance", function ( o )
{
	o.m.NameList = this.Const.Strings.SwordlanceNames;
	o.m.PrefixList = this.Const.Strings.SwordlanceNamesFemale;
	o.m.SuffixList = this.Const.Strings.SwordlanceNamesMale;
	o.m.Description = "Długi drąg przymocowany do ostrej, zakrzywionej klingi. Broń służąca do zadawania szerokich cięć z pewnej odległości.";
	o.m.Categories = pole_2h;
	o.createRandomName = southern_name;
});
::mods_hookNewObject("items/weapons/named/named_three_headed_flail", function ( o )
{
	o.m.NameList = this.Const.Strings.ThreeHeadedFlailNames;
	o.m.PrefixList = this.Const.Strings.ThreeHeadedFlailNamesFemale;
	o.m.SuffixList = this.Const.Strings.ThreeHeadedFlailNamesMale;
	o.m.Description = "Bardzo rzadka broń wykonana z cennych i wytrzymałych materiałów. Pomimo swego ceremonialnego wyglądu stanowi przerażające narzędzie zniszczenia.";
	o.m.Categories = flail_1h;
});
::mods_hookNewObject("items/weapons/named/named_two_handed_flail", function ( o )
{
	o.m.NameList = this.Const.Strings.TwoHandedFlailNames;
	o.m.PrefixList = [];
	o.m.SuffixList = this.Const.Strings.TwoHandedFlailNames;
	o.m.Description = "Ten imponujący dwuręczny cep ma niewiele wspólnego z narzędziem rolnym, od którego się wywodzi. Wygląda jakby był zaprojektowany przez doświadczonego wojownika i wykonany przez niebywale uzdolnionego rzemieślnika.";
	o.m.Categories = flail_2h;
});
::mods_hookNewObject("items/weapons/named/named_two_handed_hammer", function ( o )
{
	o.m.NameList = this.Const.Strings.HammerNames;
	o.m.PrefixList = [];
	o.m.SuffixList = this.Const.Strings.HammerNames;
	o.m.Description = "Masywny młot, który jest zaskakująco dobrze zbalansowany, pomimo swej ogromnej wagi. Swe braki w gracji nadrabia prymitywną siłą, gdyż używa się go do rozłupywania nawet najciężej opancerzonych linii wroga, odrzucając ludzi na boki, lub przybijając ich do ziemi.";
	o.m.Categories = hammer_2h;
});
::mods_hookNewObject("items/weapons/named/named_two_handed_mace", function ( o )
{
	o.m.NameList = this.Const.Strings.TwoHandedMaceNames;
	o.m.PrefixList = this.Const.Strings.TwoHandedMaceNamesFemale;
	o.m.SuffixList = this.Const.Strings.TwoHandedMaceNamesMale;
	o.m.Description = "Duża dwuręczna buława, zrodzona w ognistej kuźni prawdziwego mistrza. Pomimo swej masywnej głowicy, broń jest dobrze wyważona i względnie łatwa we władaniu dla przeciętnej osoby.";
	o.m.Categories = mace_2h;
});
::mods_hookNewObject("items/weapons/named/named_two_handed_scimitar", function ( o )
{
	o.m.NameList = this.Const.Strings.CleaverNames;
	o.m.PrefixList = [];
	o.m.SuffixList = this.Const.Strings.CleaverNames;
	o.m.Description = "Ogromny bułat dzierżony oburącz. Zakrzywiona klinga przerżnie się przez każdego wroga, a do tego jest zaskakująco dobrze wyważona, jak na swój rozmiar.";
	o.m.Categories = cleaver_2h;
	o.createRandomName = southern_name;
});
::mods_hookNewObject("items/weapons/named/named_two_handed_spiked_mace", function ( o )
{
	o.m.NameList = this.Const.Strings.TwoHandedMaceNames;
	o.m.PrefixList = this.Const.Strings.TwoHandedMaceNamesFemale;
	o.m.SuffixList = this.Const.Strings.TwoHandedMaceNamesMale;
	o.m.Description = "Ciężka, kolczasta maczuga utworzona tak, by przypominać ludzką czaszkę. Pomimo swego prymitywnego wyglądu stanowi dobrze wykonaną i zabójczą broń.";
	o.m.Categories = mace_2h;
	o.createRandomName = barbarian_name;
});
::mods_hookNewObject("items/weapons/named/named_warbow", function ( o )
{
	o.m.NameList = this.Const.Strings.BowNames;
	o.m.PrefixList = this.Const.Strings.BowNamesFemale;
	o.m.SuffixList = this.Const.Strings.BowNamesMale;
	o.m.Description = "Ten wystrugany z bardzo mocnego, acz giętkiego drewna łuk wojenny ma potężny naciąg i jest rzadkim przykładem umiejętnego rzemiosła.";
	o.m.Categories = bow_2h;
});
::mods_hookNewObject("items/weapons/named/named_warbrand", function ( o )
{
	o.m.NameList = this.Const.Strings.WarbrandNames;
	o.m.PrefixList = this.Const.Strings.WarbrandNamesFemale;
	o.m.SuffixList = this.Const.Strings.WarbrandNamesMale;
	o.m.Description = "Mistrzowsko wykonana i dość nietuzinkowa odmiana miecza o długiej, cienkiej, jednosiecznej klindze pozbawionej jelca. Można jej użyć zarówno do szybkich cięć, jak i zamaszystych ciosów.";
	o.m.Categories = sword_2h;
});
::mods_hookNewObject("items/weapons/named/named_warhammer", function ( o )
{
	o.m.NameList = this.Const.Strings.HammerNames;
	o.m.PrefixList = [];
	o.m.SuffixList = this.Const.Strings.HammerNames;
	o.m.Description = "Dobrze wykonany młot bojowy, który z łatwością przebija się przez płyty pancerza.";
	o.m.Categories = hammer_1h;
});
::mods_hookNewObject("items/weapons/named/named_warscythe", function ( o )
{
	o.m.NameList = this.Const.Strings.WarscytheNames;
	o.m.PrefixList = this.Const.Strings.WarscytheNamesFemale;
	o.m.SuffixList = this.Const.Strings.WarscytheNamesMale;
	o.m.Description = "Długi drąg przymocowany do zakrzywionego ostrza, służący do wykonywania zamaszystych cięć z pewnej odległości. Ten egzemplarz jest szczególnie dobrze wykonany.";
	o.m.Categories = pole_2h;
	o.createRandomName = southern_name;
});
::mods_hookNewObject("items/weapons/named/named_throwing_axe", function ( o )
{
	o.m.NameList = this.Const.Strings.ThrowingAxeNames;
	o.m.PrefixList = [];
	o.m.SuffixList = [];
	o.m.Description = "Niewielkie toporki, służące do miotania w kierunku celu. Te tutaj zostały szczególnie dobrze wyważone i są na tyle wytrzymałe, by z odległości zadać poważne uszkodzenia pancerzom i tarczom.";
	o.m.Categories = thrown_1h;
	o.createRandomName = multi_name;
});
::mods_hookNewObject("items/weapons/named/named_javelin", function ( o )
{
	o.m.NameList = this.Const.Strings.JavelinNames;
	o.m.PrefixList = [];
	o.m.SuffixList = [];
	o.m.Description = "Kilka lekkich włóczni do rzucania, które zostały umiejętnie wyważone, aby prosto latać. Mają ograniczony zasięg i miotanie nimi jest męczące, choć są w stanie zadawać niszczycielskie rany.";
	o.m.Categories = thrown_1h;
	o.createRandomName = multi_name;
});
::mods_hookNewObject("items/weapons/named/named_crossbow", function ( o )
{
	o.m.NameList = this.Const.Strings.CrossbowNames;
	o.m.PrefixList = this.Const.Strings.CrossbowNamesFemale;
	o.m.SuffixList = this.Const.Strings.CrossbowNamesMale;
	o.m.Description = "Kusza z lewarem, która potrafi miotać bełtami na średnie odległości. Skuteczna nawet w rękach prostego chłopa, choć wymaga niemal całej tury, by ją przeładować. Ta dobrze zbalansowana i posiadająca cięciwę z niebywale wytrzymałych ścięgien broń zaiste jest wytworem mistrza rzemiosła.";
	o.m.Categories = crossbow_2h;
	o.getTooltip = reload_text;
});
::mods_hookNewObject("items/weapons/named/named_handgonne", function ( o )
{
	o.m.NameList = this.Const.Strings.HandgonneNames;
	o.m.PrefixList = this.Const.Strings.HandgonneNamesFemale;
	o.m.SuffixList = this.Const.Strings.HandgonneNamesMale;
	o.m.Description = "Umiejętnie odlana żelazna lufa z długim drewnianym trzonkiem. Wypluwa z siebie odłamki po stożku i trafia wiele celów za jednym strzałem. Nie można używać, gdy wróg zbliżył się na odległość walki wręcz.";
	o.m.Categories = firearm_2h;
	o.createRandomName = southern_name;
	o.getTooltip = reload_text;
});

