this.shepherd_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.shepherd";
		this.m.Name = "Pasterz";
		this.m.Icon = "ui/backgrounds/background_44.png";
		this.m.BackgroundDescription = "Pasterze przyzwyczajeni są do fizycznej pracy i znani z tego, że czasami odganiają wilki za pomocą swych proc.";
		this.m.GoodEnding = "To dość niezwykłe, że pasterz taki jak %name% trafił do kompanii najemników, ale okazał się sprawnym wojownikiem. Gdy obrażenia zaczęły się piętrzyć, w końcu odszedł, wrócił na łąkę z laską w dłoni i pasł owce aż do swych ostatnich, spokojnych dni.";
		this.m.BadEnding = "Można by pomyśleć, że pasterz nie ma miejsca w kompanii najemników i w końcu %name% się z tym zgodził. Opuścił %companyname% niedługo po tobie i ostatnio słyszałeś, że znów dogląda swoich owiec. Gdy większość ludzi odchodziła w kiepskich nastrojach, obrażenia %name% nie zachwiały jego łagodnym stylem życia polegającym na wpatrywaniu się w białe, puchate stworzenia równie groźne co zły sen.";
		this.m.HiringCost = 60;
		this.m.DailyCost = 6;
		this.m.Excluded = [
			"trait.hate_undead",
			"trait.impatient",
			"trait.iron_jaw",
			"trait.athletic",
			"trait.deathwish",
			"trait.sure_footing",
			"trait.disloyal",
			"trait.greedy",
			"trait.drunkard",
			"trait.fearless",
			"trait.brave",
			"trait.iron_lungs",
			"trait.strong",
			"trait.tough",
			"trait.cocky",
			"trait.brute",
			"trait.bloodthirsty"
		];
		this.m.Titles = [
			"Pastuch",
			"Skromny",
			"Spokojny",
			"Koziarz",
			"Owczarz",
			"Owca"
		];
		this.m.Faces = this.Const.Faces.AllMale;
		this.m.Hairs = this.Const.Hair.CommonMale;
		this.m.HairColors = this.Const.HairColors.All;
		this.m.Beards = this.Const.Beards.All;
		this.m.Bodies = this.Const.Bodies.Skinny;
		this.m.IsOffendedByViolence = true;
		this.m.IsLowborn = true;
	}

	function onBuildDescription()
	{
		return "{%name% był po prostu prostym pasterzem z prostego miasteczka, spędzając wiele lat na doglądaniu swej trzody. | Tak piękne miejsce jak %townname% zasługiwało na tak pięknego pasterza jak %name%. | %name% odziedziczył trzodę tego samego dnia, w którym pochował ojca. | Jako dziecko %name% natknął się na martwego pasterza i ospałą trzodę obok. Chłopak podniósł pasterską laskę i przez wiele lat wykonywał jego pracę. | Bardziej daltonistyczny niż pies, %name% zawsze lubił towarzystwo przyjaznych barwom owiec. | Gdy %name% spadł z wieży, stado owiec złagodziło upadek. Przyrzekł odpłacić ich poświęcenie, zostając najbezpieczniejszym pasterzem w krainie. | %name% znalazł zysk w przepędzaniu owiec z miasta do miasta, sprzedając ich wełnę krawcom i skóry garbarzom. | Doglądanie owiec było najłatwiejszą pracą, jaką %name% mógł znaleźć. | Tak niegroźny jak owce, którymi się zajmuje, %name% został pasterzem, by znaleźć spokój w okrutnym świecie. | Nigdy nie znajdował dobrej kompanii wśród ludzi, %name% wolał posępną mądrość owiec. | Gnębiony w dzieciństwie, %name% znalazł spokój w doglądaniu stad owiec. | Figlarnie posłuszne owce w życiu %name% dały mu spokój i ukojenie po ciężkim dzieciństwie. | Kiedyś wzięty za {proroka | nowego mesjasza}, %name% uciekł przed {religijnymi hordami | wściekłymi inkwizytorami}, znikając w zawodzie pasterza. | Patrzenie, jak {owce | białe kłęby wełny} cały dzień skubią trawę brzmi nudno, ale dla %name% było błogością. | Oczarowany zawodami w pasieniu owiec, %name% podjął się pasterstwa jako zaskakująco rywalizującego fachu. | Zawsze łagodny i dobry chłopak, %name% naturalnie został pasterzem. | Uciekając przed przemocą ze strony {matki | ojca | sióstr | braci | wujka | ciotki}, %name% wybrał spokój życia pasterza.} {Uwikłany w religijny konflikt między wyznawcami bogów a kultystami, jego trzoda padła ofiarą tych, którzy szukali kozłów ofiarnych i ofiar. | Gdy raz odpędzał {bandytów | wilki} pasterską laską, pasterz zaczął się zastanawiać, czy nie jest sprawniejszy, niż myślał. | Z czasem mężczyzna poczuł {jakby jego powołanie go ominęło. | jakby już nie miał do tego serca.} {Z żalem przeszedł na emeryturę | Odwiesił pasterską laskę} i poszukał innej pracy. | Czując, że ogląda piękno świata, ale nie doświadcza go w pełni, porzucił pasterstwo. | Gdy wielkie, kudłate bestie wyrżnęły jego trzodę, pasterz zapragnął zemsty. | Niestety, jedyny towarzysz mężczyzny, pasterski pies, został zabity przez {bandytów | orków | wilki}, zostawiając spokojnego człowieka żądnego odwetu. | Wplątany w machinacje lichwiarza, pasterz nagle potrzebował więcej koron, niż jego trzoda mogła przynieść. | Jednak samotność w końcu go dopadła. | Długie dni i noce w samotności wyczerpały pasterza jak każdego człowieka. | Nie potrafił uciec od męskości, której oczekiwał ojciec, więc pewnego dnia odłożył laskę i poszukał bardziej męskiego zajęcia. | Pewnego dnia, zajęty tkaniem podczas pasienia, zaprowadził każdą owcę prosto w przepaść. | Pewnego deszczowego popołudnia usłyszał jedno beczenie za wiele: musiał robić coś więcej, niż tylko gapić się na owce. | Pewnego ranka obudził się cały we krwi owiec, wnętrznościach i zakrwawionej wełnie. W oddali radośnie wyły wilki. Okazało się, że tej nocy przeliczył owce o jedną za dużo. | Niestety, plotki o tym, co robił w prywatności swojej trzody, były zbyt zawstydzające, więc musiał uciec na zieleńsze, bardziej wyrozumiałe pastwiska. | Niestety, bandyci pijani przemocą natknęli się na jego trzodę. Bessie, Mała Ada, a nawet nowo narodzony Goatsieg zostali krwawo zgładzeni.} {Zatrzymawszy się w mieście, by przemyśleć sprawy, %name% natknął się na zaciąg do najemników. Nie mając nic do stracenia, jest gotów się zapisać. | W tej krainie nie było miejsca dla spokojnego pasterza. Pora na nowe życie. | Mały, zardzewiały od krwi dzwoneczek zwisa pod szyją %name%. To relikt poprzedniego życia i być może znak nowego. | Przysięga, że wciąż słyszy beczenie trzody. Z jakiegoś powodu nie napawa to zaufaniem do jego umiejętności bojowych. | Choć spokojny jak nikt, bez trzody mężczyzna jest zagubiony. | Choć nie jest wojownikiem, wie, jak utrzymać ciasny szyk. | %name% zaskakująco dobrze zna gwiazdy i potrafi namierzyć dźwięk w ciemności niczym ślepy pies węszący smakołyk. | Ciągłe chodzenie dało %name% mocne nogi, ale jego największe doświadczenie bojowe to kij. | Świat zwykle nie zwraca się do pasterzy w potrzebie, ale to wyjątkowo potrzebujący świat. | Patrząc na pasterza, zastanawiasz się, jak źle musiało się stać, że stoi właśnie tutaj. | %name% nosi prawie każdą broń jak pasterską laskę i ma zły nawyk uderzania innych po nogach, by ich poganiać. | Pokora %name% jest miłą odmianą od zwykłych gorączkowych braci, którzy zostają najemnikami. | %name% wygląda, jakby nie skrzywdził muchy, ale przy dobrym treningu możesz sprawić, że skrzywdzi ich znacznie więcej. | %name% nie nosi w sobie morderczej determinacji innych najemników, ale jak każdego można go wyszkolić. | Niektórzy ludzie z %companyname% niewiele lepsi są od owiec. Może %name% jednak ma tu swoje miejsce.}";
	}

	function onChangeAttributes()
	{
		local c = {
			Hitpoints = [
				0,
				0
			],
			Bravery = [
				5,
				0
			],
			Stamina = [
				0,
				5
			],
			MeleeSkill = [
				0,
				0
			],
			RangedSkill = [
				5,
				7
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
				0
			]
		};
		return c;
	}

	function onAddEquipment()
	{
		local items = this.getContainer().getActor().getItems();
		local r;

		if (this.Const.DLC.Wildmen)
		{
			if (this.Math.rand(1, 100) <= 66)
			{
				items.equip(this.new("scripts/items/weapons/staff_sling"));
			}
		}

		r = this.Math.rand(0, 2);

		if (r == 0)
		{
			local item = this.new("scripts/items/armor/linen_tunic");
			item.setVariant(this.Math.rand(6, 7));
			items.equip(item);
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/armor/sackcloth"));
		}
		else if (r == 2)
		{
			items.equip(this.new("scripts/items/armor/leather_tunic"));
		}

		r = this.Math.rand(0, 0);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/helmets/straw_hat"));
		}
	}

});

