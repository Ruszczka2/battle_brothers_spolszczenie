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
			Text = "[img]gfx/ui/events/event_180.png[/img]{Natrafiasz na mezczyzne w dziwnym stanie: z jednej strony ma na sobie ozdobna zbroje, jakby w sam raz dla czlowieka siedziacego na koniu gotowego do turniejowego starcia. Z drugiej strony lezy na ziemi, nogi tna na krzyz w pijackim oszolomieniu, rece rozlozone, jakby obejmowaly ramiona przyjaciol, lecz zamiast tego znajduja tylko blotny komfort.%SPEECH_ON%Blagam cie, wedrowcze, kup moja zbroje i moje bronie, a zostaw mi korony odpowiednie dla obu, abym mogl szukac odkupienia innym sposobem, bo sprawy wojenne nie sa juz bliskie mojej sciezce na tym swiecie, a -hic- wolalbym wykupic sobie droge do lask Mlodego Anselma niz zajmowac sie tym machaniem mieczem; niech starzy bogowie mnie poraza za przyznanie sie do tego, ale i tak sie przyznaje!%SPEECH_OFF%Wyglada na to, ze oferuje bron i zbroje za cene, jesli dobrze zrozumiales jego bekot, 9,000 koron.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Wezmiemy zbroje za 9,000 koron.",
					function getResult( _event )
					{
						return "BuyArmor";
					}

				},
				{
					Text = "Nie jestesmy zainteresowani.",
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
						Text = "Mlody Anselm ma dla ciebie inne plany. Dolacz do nas!",
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
			Text = "[img]gfx/ui/events/event_180.png[/img]{Kucasz z sakiewka koron w dloni.%SPEECH_ON%Zdejmij to.%SPEECH_OFF%Mezczyzna kiwa glowa i zaczyna zrzucac zbroje, wije sie, od czasu do czasu pociaga nosem. Podaje wszystko, lacznie ze zbroja. Zlecasz, by wszystko zabrano i schowano do ekwipunku, po czym dajesz umowione pieniadze. Jego palce sciskaja i obmacuja sakiewke jak pajecze nogi oplatajace zdobycz, a pijane oczy biegaja z lewa na prawo. Wstaje i chwiejnie odchodzi. Masz wrazenie, ze nie znajdzie odkupienia, ktorego szuka, za te pieniadze. %randombrother% kladzie ci dlon na ramieniu.%SPEECH_ON%Nie rozpamietuj go, kapitanie. Sa na swiecie tacy ludzie, o ktorych nie chcesz byc ostatnim, kto o nich zapomnial, rozumiesz?%SPEECH_OFF%}",
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
			Text = "[img]gfx/ui/events/event_183.png[/img]{Zamiast podac dlon, sam podajesz dlon.%SPEECH_ON%Panie, Mlody Anselm dobrze wiedzial, ze nie da sie dochowac zadnego slubu na zawsze. Zachwianie to zycie, a zycie to zachwianie. Czy myslisz, ze bycie tutaj w blocie to blad? Czy sadzisz, ze twoje porazki da sie naprawic pieniedzmi?%SPEECH_OFF%Mezczyzna podnosi wzrok. Pyta, czy ty tez znasz Mlodego Anselma. Wciaz nie wzial twojej reki, wiec chwytasz jego i stawiasz go na nogi.%SPEECH_ON%Swietobiorco, jak myslisz, kto mnie przyslal?%SPEECH_OFF%Mezczyzna chwieje sie przez chwile, patrzac na ciebie z niedowierzaniem. Potem szeroko sie usmiecha i mocno cie obejmuje, obejmujac ciebie i kompanie naraz. Gdziekolwiek na swiecie jest Swietobiorca, nie jest sam - to bylo pierwsze przeslanie Mlodego Anselma.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Witaj na pokladzie!",
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
				_event.m.Dude.setTitle("Lamacz Slubow");
				_event.m.Dude.getBackground().m.RawDescription = "Jak wielu ludzi, %name% znaleziono w nedzy. Ale na ustach, brud w uszach, mocz i kal, przynajmniej gdzies na sobie. Lecz w sercu byl Swietobiorca, a z opatrznosci Mlodego Anselma na pewno nie byly to zwykle okolicznosci, ktore przywrocily go do wiary. Oczywiscie wciaz bedzie laczyl piwo z wiara, ale od czasu do czasu trzeba pozwolic czlowiekowi na jego wady, zwlaszcza gdy dzieli zainteresowanie zabijaniem Slubodawcow.";
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

