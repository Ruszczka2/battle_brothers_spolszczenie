this.oathbreaker_event <- this.inherit("scripts/events/event", {
	m = {
		Dude = null
	},
	function create()
	{
		this.m.ID = "event.oathbreaker";
		this.m.Title = "W drodze...";
		this.m.Cooldown = 999999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_180.png[/img]{Natrafiasz na mężczyznę w dziwnym stanie: z jednej strony ma na sobie ozdobną zbroję, jakby w sam raz dla człowieka siedzącego na koniu gotowego do turniejowego starcia. Z drugiej strony leży na ziemi, nogi tną na krzyż w pijackim oszołomieniu, ręce rozłożone, jakby obejmowały ramiona przyjaciół, lecz zamiast tego znajdują tylko błotny komfort.%SPEECH_ON%Błagam cię, wędrowcze, kup moją zbroję i moje bronie, a zostaw mi korony odpowiednie dla obu, abym mógł szukać odkupienia innym sposobem, bo sprawy wojenne nie są już bliskie mojej ścieżce na tym świecie, a -hic- wolałbym wykupić sobie drogę do łask Młodego Anselma niż zajmować się tym machaniem mieczem; niech starzy bogowie mnie porażą za przyznanie się do tego, ale i tak się przyznaję!%SPEECH_OFF%Wygląda na to, że oferuje broń i zbroję za cenę, jeśli dobrze zrozumiałeś jego bełkot, 9,000 koron.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Weźmiemy zbroję za 9,000 koron.",
					function getResult( _event )
					{
						return "BuyArmor";
					}

				},
				{
					Text = "Nie jesteśmy zainteresowani.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				if (this.World.Assets.getOrigin().getID() == "scenario.paladins")
				{
					this.Options.push({
						Text = "Młody Anselm ma dla ciebie inne plany. Dołącz do nas!",
						function getResult( _event )
						{
							return "Oathtaker";
						}

					});
				}
			}

		});
		this.m.Screens.push({
			ID = "BuyArmor",
			Text = "[img]gfx/ui/events/event_180.png[/img]{Kucasz z sakiewką koron w dłoni.%SPEECH_ON%Zdejmij to.%SPEECH_OFF%Mężczyzna kiwa głową i zaczyna zrzucać zbroję, wije się, od czasu do czasu pociąga nosem. Podaje wszystko, łącznie ze zbroją. Zlecasz, by wszystko zabrano i schowano do ekwipunku, po czym dajesz umówione pieniądze. Jego palce ściskają i obmacują sakiewkę jak pajęcze nogi oplatające zdobycz, a pijane oczy biegają z lewa na prawo. Wstaje i chwiejnie odchodzi. Masz wrażenie, że nie znajdzie odkupienia, którego szuka, za te pieniądze. %randombrother% kładzie ci dłoń na ramieniu.%SPEECH_ON%Nie rozpamiętuj go, kapitanie. Są na świecie tacy ludzie, o których nie chcesz być ostatnim, kto o nich zapomniał, rozumiesz?%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Bezpiecznej drogi.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local item;
				local stash = this.World.Assets.getStash();
				local weapons = [
					"weapons/arming_sword",
					"weapons/military_pick",
					"weapons/hand_axe",
					"weapons/pike",
					"weapons/warbrand"
				];
				item = this.new("scripts/items/" + weapons[this.Math.rand(0, weapons.len() - 1)]);
				item.setCondition(item.getConditionMax() / 3 - 1);
				stash.add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Zyskujesz " + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
				item = this.new("scripts/items/armor/adorned_heavy_mail_hauberk");
				item.setCondition(item.getConditionMax() / 3 - 1);
				stash.add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Zyskujesz " + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
				item = this.new("scripts/items/helmets/adorned_full_helm");
				item.setCondition(item.getConditionMax() / 3 - 1);
				stash.add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Zyskujesz " + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
				this.World.Assets.addMoney(-9000);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Tracisz [color=" + this.Const.UI.Color.NegativeEventValue + "]9,000[/color] Koron"
				});
			}

		});
		this.m.Screens.push({
			ID = "Oathtaker",
			Text = "[img]gfx/ui/events/event_183.png[/img]{Zamiast podać dłoń, sam podajesz dłoń.%SPEECH_ON%Panie, Młody Anselm dobrze wiedział, że nie da się dochować żadnego ślubu na zawsze. Zachwianie to życie, a życie to zachwianie. Czy myślisz, że bycie tutaj w błocie to błąd? Czy sądzisz, że twoje porażki da się naprawić pieniędzmi?%SPEECH_OFF%Mężczyzna podnosi wzrok. Pyta, czy ty też znasz Młodego Anselma. Wciąż nie wziął twojej ręki, więc chwytasz jego i stawiasz go na nogi.%SPEECH_ON%Świętobiorco, jak myślisz, kto mnie przysłał?%SPEECH_OFF%Mężczyzna chwieje się przez chwilę, patrząc na ciebie z niedowierzaniem. Potem szeroko się uśmiecha i mocno cię obejmuje, obejmując ciebie i kompanię naraz. Gdziekolwiek na świecie jest Świętobiorca, nie jest sam - to było pierwsze przesłanie Młodego Anselma.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Witaj na pokładzie!",
					function getResult( _event )
					{
						this.World.getPlayerRoster().add(_event.m.Dude);
						this.World.getTemporaryRoster().clear();
						_event.m.Dude.onHired();
						_event.m.Dude = null;
						return 0;
					}

				}
			],
			function start( _event )
			{
				local roster = this.World.getTemporaryRoster();
				_event.m.Dude = roster.create("scripts/entity/tactical/player");
				_event.m.Dude.setStartValuesEx([
					"paladin_background"
				]);
				_event.m.Dude.setTitle("Łamacz Ślubów");
				_event.m.Dude.getBackground().m.RawDescription = "Jak wielu ludzi, %name% znaleziono w nędzy. Ale na ustach, brud w uszach, mocz i kał, przynajmniej gdzieś na sobie. Lecz w sercu był Świętobiorca, a z opatrzności Młodego Anselma na pewno nie były to zwykłe okoliczności, które przywróciły go do wiary. Oczywiście wciąż będzie łączył piwo z wiarą, ale od czasu do czasu trzeba pozwolić człowiekowi na jego wady, zwłaszcza gdy dzieli zainteresowanie zabijaniem Ślubodawców.";
				_event.m.Dude.getBackground().buildDescription(true);
				_event.m.Dude.m.PerkPoints = 0;
				_event.m.Dude.m.LevelUps = 0;
				_event.m.Dude.m.Level = 1;
				_event.m.Dude.m.XP = this.Const.LevelXP[_event.m.Dude.m.Level - 1];
				local trait = this.new("scripts/skills/traits/drunkard_trait");
				_event.m.Dude.getSkills().add(trait);
				local dudeItems = _event.m.Dude.getItems();

				if (dudeItems.getItemAtSlot(this.Const.ItemSlot.Mainhand) != null)
				{
					dudeItems.getItemAtSlot(this.Const.ItemSlot.Mainhand).removeSelf();
				}

				if (dudeItems.getItemAtSlot(this.Const.ItemSlot.Offhand) != null)
				{
					dudeItems.getItemAtSlot(this.Const.ItemSlot.Offhand).removeSelf();
				}

				if (dudeItems.getItemAtSlot(this.Const.ItemSlot.Head) != null)
				{
					dudeItems.getItemAtSlot(this.Const.ItemSlot.Head).removeSelf();
				}

				if (dudeItems.getItemAtSlot(this.Const.ItemSlot.Body) != null)
				{
					dudeItems.getItemAtSlot(this.Const.ItemSlot.Body).removeSelf();
				}

				local weapons = [
					"weapons/arming_sword",
					"weapons/military_pick",
					"weapons/hand_axe",
					"weapons/pike",
					"weapons/warbrand"
				];
				local item = this.new("scripts/items/" + weapons[this.Math.rand(0, weapons.len() - 1)]);
				item.setCondition(item.getConditionMax() / 3 - 1);
				dudeItems.equip(item);
				item = this.new("scripts/items/helmets/adorned_full_helm");
				item.setCondition(item.getConditionMax() / 3 - 1);
				dudeItems.equip(item);
				item = this.new("scripts/items/armor/adorned_heavy_mail_hauberk");
				item.setCondition(item.getConditionMax() / 3 - 1);
				dudeItems.equip(item);
				this.Characters.push(_event.m.Dude.getImagePath());
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Paladins)
		{
			return;
		}

		if (this.World.Assets.getMoney() < 10500)
		{
			return;
		}

		if (this.World.Assets.getStash().getNumberOfEmptySlots() < 3)
		{
			return;
		}

		if (this.World.Assets.getOrigin().getID() == "scenario.paladins" && this.World.getPlayerRoster().getSize() >= this.World.Assets.getBrothersMax())
		{
			return;
		}

		this.m.Score = 5;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
	}

	function onClear()
	{
		this.m.Dude = null;
	}

});

