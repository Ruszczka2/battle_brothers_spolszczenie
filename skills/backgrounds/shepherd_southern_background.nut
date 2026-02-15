this.shepherd_southern_background <- this.inherit("scripts/skills/backgrounds/shepherd_background", {
	m = {},
	function create()
	{
		this.shepherd_background.create();
		this.m.Bodies = this.Const.Bodies.SouthernSkinny;
		this.m.Faces = this.Const.Faces.SouthernMale;
		this.m.Hairs = this.Const.Hair.SouthernMale;
		this.m.HairColors = this.Const.HairColors.Southern;
		this.m.Beards = this.Const.Beards.Southern;
		this.m.BeardChance = 90;
		this.m.Ethnicity = 1;
		this.m.Excluded = [
			"trait.superstitious",
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
		this.m.Names = this.Const.Strings.SouthernNames;
		this.m.LastNames = this.Const.Strings.SouthernNamesLast;
	}

	function onBuildDescription()
	{
		return "{%name% był po prostu prostym pasterzem z prostego miasteczka, spędzając wiele lat na doglądaniu swej trzody. | Tak piękne miejsce jak %townname% zasługiwało na tak pięknego pasterza jak %name%. | %name% odziedziczył trzodę tego samego dnia, w którym pochował ojca. | Jako dziecko %name% natknął się na martwego pasterza i ospałą trzodę obok. Chłopak podniósł pasterską laskę i przez wiele lat wykonywał jego pracę. | Bardziej daltonistyczny niż pies, %name% zawsze lubił towarzystwo przyjaznych barwom owiec. | Gdy %name% spadł z wieży, stado owiec złagodziło upadek. Przyrzekł odpłacić ich poświęcenie, zostając najbezpieczniejszym pasterzem w krainie. | %name% znalazł zysk w przepędzaniu owiec z miasta do miasta, sprzedając ich wełnę krawcom i skóry garbarzom. | Doglądanie owiec było najłatwiejszą pracą, jaką %name% mógł znaleźć. | Tak niegroźny jak owce, którymi się zajmuje, %name% został pasterzem, by znaleźć spokój w okrutnym świecie. | Nigdy nie znajdował dobrej kompanii wśród ludzi, %name% wolał posępną mądrość owiec. | Gnębiony w dzieciństwie, %name% znalazł spokój w doglądaniu stad owiec. | Figlarnie posłuszne owce w życiu %name% dały mu spokój i ukojenie po ciężkim dzieciństwie. | Kiedyś wzięty za {proroka | nowego mesjasza}, %name% uciekł przed {religijnymi hordami | wściekłymi inkwizytorami}, znikając w zawodzie pasterza. | Patrzenie, jak {owce | białe kłęby wełny} cały dzień skubią trawę brzmi nudno, ale dla %name% było błogością. | Oczarowany zawodami w pasieniu owiec, %name% podjął się pasterstwa jako zaskakująco rywalizującego fachu. | Zawsze łagodny i dobry chłopak, %name% naturalnie został pasterzem. | Uciekając przed przemocą ze strony {matki | ojca | sióstr | braci | wujka | ciotki}, %name% wybrał spokój życia pasterza.} {Uwikłany w religijny konflikt między wyznawcami bogów a kultystami, jego trzoda padła ofiarą tych, którzy szukali kozłów ofiarnych i ofiar. | Gdy raz odpędzał {bandytów | wilki} pasterską laską, pasterz zaczął się zastanawiać, czy nie jest sprawniejszy, niż myślał. | Z czasem mężczyzna poczuł {jakby jego powołanie go ominęło. | jakby już nie miał do tego serca.} {Z żalem przeszedł na emeryturę | Odwiesił pasterską laskę} i poszukał innej pracy. | Czując, że ogląda piękno świata, ale nie doświadcza go w pełni, porzucił pasterstwo. | Gdy wielkie, kudłate bestie wyrżnęły jego trzodę, pasterz zapragnął zemsty. | Niestety, jedyny towarzysz mężczyzny, pasterski pies, został zabity przez {bandytów | orków | wilki}, zostawiając spokojnego człowieka żądnego odwetu. | Wplątany w machinacje lichwiarza, pasterz nagle potrzebował więcej koron, niż jego trzoda mogła przynieść. | Jednak samotność w końcu go dopadła. | Długie dni i noce w samotności wyczerpały pasterza jak każdego człowieka. | Nie potrafił uciec od męskości, której oczekiwał ojciec, więc pewnego dnia odłożył laskę i poszukał bardziej męskiego zajęcia. | Pewnego dnia, zajęty tkaniem podczas pasienia, zaprowadził każdą owcę prosto w przepaść. | Pewnego deszczowego popołudnia usłyszał jedno beczenie za wiele: musiał robić coś więcej, niż tylko gapić się na owce. | Niestety, plotki o tym, co robił w prywatności swojej trzody, były zbyt zawstydzające, więc musiał uciec na zieleńsze, bardziej wyrozumiałe pastwiska. | Niestety, bandyci pijani przemocą natknęli się na jego trzodę. Bessie, Mała Ada, a nawet nowo narodzony Goatsieg zostali krwawo zgładzeni.} {Zatrzymawszy się w mieście, by przemyśleć sprawy, %name% natknął się na zaciąg do najemników. Nie mając nic do stracenia, jest gotów się zapisać. | W tej krainie nie było miejsca dla spokojnego pasterza. Pora na nowe życie. | Mały, zardzewiały od krwi dzwoneczek zwisa pod szyją %name%. To relikt poprzedniego życia i być może znak nowego. | Przysięga, że wciąż słyszy beczenie trzody. Z jakiegoś powodu nie napawa to zaufaniem do jego umiejętności bojowych. | Choć spokojny jak nikt, bez trzody mężczyzna jest zagubiony. | Choć nie jest wojownikiem, wie, jak utrzymać ciasny szyk. | %name% zaskakująco dobrze zna gwiazdy i potrafi namierzyć dźwięk w ciemności niczym ślepy pies węszący smakołyk. | Ciągłe chodzenie dało %name% mocne nogi, ale jego największe doświadczenie bojowe to kij. | Świat zwykle nie zwraca się do pasterzy w potrzebie, ale to wyjątkowo potrzebujący świat. | Patrząc na pasterza, zastanawiasz się, jak źle musiało się stać, że stoi właśnie tutaj. | %name% nosi prawie każdą broń jak pasterską laskę i ma zły nawyk uderzania innych po nogach, by ich poganiać. | Pokora %name% jest miłą odmianą od zwykłych gorączkowych braci, którzy zostają najemnikami. | %name% wygląda, jakby nie skrzywdził muchy, ale przy dobrym treningu możesz sprawić, że skrzywdzi ich znacznie więcej. | %name% nie nosi w sobie morderczej determinacji innych najemników, ale jak każdego można go wyszkolić. | Niektórzy ludzie z %companyname% niewiele lepsi są od owiec. Może %name% jednak ma tu swoje miejsce.}";
	}

	function onAddEquipment()
	{
		local items = this.getContainer().getActor().getItems();
		local r;

		if (this.Math.rand(1, 100) <= 66)
		{
			items.equip(this.new("scripts/items/weapons/oriental/nomad_sling"));
		}

		r = this.Math.rand(1, 2);

		if (r == 1)
		{
			items.equip(this.new("scripts/items/armor/sackcloth"));
		}
		else if (r == 2)
		{
			items.equip(this.new("scripts/items/armor/oriental/cloth_sash"));
		}

		items.equip(this.new("scripts/items/helmets/oriental/southern_head_wrap"));
	}

});

