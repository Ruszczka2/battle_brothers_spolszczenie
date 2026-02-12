this.squire_vs_hedge_knight_event <- this.inherit("scripts/events/event", {
	m = {
		Squire = null,
		HedgeKnight = null
	},
	function create()
	{
		this.m.ID = "event.squire_vs_hedge_knight";
		this.m.Title = "Podczas obozu...";
		this.m.Cooldown = 45.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_82.png[/img]%squire%, młody giermek, obserwuje %hedgeknight% z bezpiecznej odległości. Wolny rycerz ostrzy ostrza, przeciągając osełkę po krawędziach i polerując metal, by nadać mu blask. Kiedy zauważa wpatrzonego giermka, %hedgeknight% opuszcza narzędzia.%SPEECH_ON%Więc chcesz być rycerzem, tak?%SPEECH_OFF%%squire% kiwa głową i odpowiada dumnie.%SPEECH_ON%To moje marzenie, tak, i pewnego dnia się spełni.%SPEECH_OFF%Wolny rycerz wstaje i podchodzi, górując nad młodzieńcem.%SPEECH_ON%Jak myślisz, co robi rycerz? Ratuje damy? Rządzi lennami, by być kochanym przez chłopów? Ślubuje wierność swemu panu? Cóż, powiem ci, to wszystko bzdury. Delikatniacy tacy jak ty to nic więcej niż larwy mącznika. Chcesz być rycerzem, musisz nauczyć się zabijać.%SPEECH_OFF%Giermek prostuje się i odciąga ramiona.%SPEECH_ON%Nie mam problemu z zabijaniem.%SPEECH_OFF%Wolny rycerz odpycha go jednym palcem.%SPEECH_ON%Doprawdy? A czy rozciąłeś człowieka i zamordowałeś jego rodzinę, kiedy wykrwawiał się na ziemi? Co z roztrzaskaniem głowy dziecka w twoich rękach, bo twój senior tak rozkazał? Wyłupiłbyś kobiecie oczy, bo twój pan uznał to za należytą karę za kradzież bochenka chleba? Za kogo mnie masz, giermku? Myślisz, że urodziłem się wielki, zły i dziki? Nie, mały giermku, będziesz musiał zabijać, a pierwszym, kogo zabijesz, będziesz ty sam. Tak zostaje się rycerzem w tych ziemiach, w tych czasach.%SPEECH_OFF%Wolny rycerz wraca do pracy. Giermek jest wyraźnie wstrząśnięty, ale zdaje się szczerze rozważać to, co właśnie usłyszał.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Życie to nie rycerska opowieść.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Squire.getImagePath());
				this.Characters.push(_event.m.HedgeKnight.getImagePath());
				_event.m.Squire.getFlags().set("squire_vs_hedge_knight", true);
				local resolve = this.Math.rand(1, 4);
				_event.m.Squire.getBaseProperties().Bravery += resolve;
				_event.m.Squire.getSkills().update();
				this.List.push({
					id = 16,
					icon = "ui/icons/bravery.png",
					text = _event.m.Squire.getName() + " zyskuje [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + resolve + "[/color] determinacji"
				});
				_event.m.Squire.worsenMood(1.5, "Zachwiano jego przekonaniami");
				this.List.push({
					id = 10,
					icon = this.Const.MoodStateIcon[_event.m.Squire.getMoodState()],
					text = _event.m.Squire.getName() + this.Const.MoodStateEvent[_event.m.Squire.getMoodState()]
				});
			}

		});
	}

	function onUpdateScore()
	{
		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 2)
		{
			return;
		}

		local squire_candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getLevel() <= 4 && bro.getBackground().getID() == "background.squire" && !bro.getFlags().has("squire_vs_hedge_knight"))
			{
				squire_candidates.push(bro);
			}
		}

		if (squire_candidates.len() == 0)
		{
			return;
		}

		local hk_candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getSkills().hasSkill("trait.player"))
			{
				continue;
			}

			if (bro.getBackground().getID() == "background.hedge_knight")
			{
				hk_candidates.push(bro);
			}
		}

		if (hk_candidates.len() == 0)
		{
			return;
		}

		this.m.Squire = squire_candidates[this.Math.rand(0, squire_candidates.len() - 1)];
		this.m.HedgeKnight = hk_candidates[this.Math.rand(0, hk_candidates.len() - 1)];
		this.m.Score = (squire_candidates.len() + hk_candidates.len()) * 3;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"squire",
			this.m.Squire.getNameOnly()
		]);
		_vars.push([
			"hedgeknight",
			this.m.HedgeKnight.getNameOnly()
		]);
	}

	function onClear()
	{
		this.m.Squire = null;
		this.m.HedgeKnight = null;
	}

});

