this.choose_ambition_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.choose_ambition";
		this.m.Title = "Podczas obozowania...";
		this.m.HasBigButtons = true;
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_58.png[/img]{Wieje dziś świeża, rześka bryza i czujesz, ze to dobry moment, aby kompania rozpoczęła coś nowego. Wzywasz ludzi, by się zebrali...\n\nCo im powiesz? | Dobrze się dziś czujesz i masz wrażenie, że jesteś gotowy poprowadzić kompanię przez każde wyzwanie, które na was czeka. Zbierasz ludzi; %randombrother% dostaje od ciebie kopniaka, by stanął na nogi, a %randombrother2% dostaje polecenie, by odłożył na później golenie włosów z karku. Kiedy już wreszcie kończą marudzić, przemawiasz do nich.\n\nCo powiesz ludziom, że kompania ma zamiar zrobić? | Jak to jest w zwyczaju, zbierasz ludzi, by wytłumaczyć im kolejne kroki kompanii.%SPEECH_ON%Bracia, musimy pokazać światu, że kompania %companyname% wykuta została w gorętszym żarze, niż inne bandy najemników. Wraz ze wzrostem naszej reputacji, wzrośnie też ilość koron w naszych kufrach. Wykarczujmy sobie ścieżkę do wspaniałości!%SPEECH_OFF%o powiesz ludziom, że kompania ma zrobi? | Gdy kompania odpoczywa, decydujesz się przemówić do ludzi.%SPEECH_ON%Bracia, chcę, żeby nazwa %companyname% była znana nie tylko zbirom i chłopcom na posyłki, ale także i pierwszorzędnym, zdolnym wojownikom. Wieść o naszych uczynkach musi się rozejść, aby zarówno kupcy, jak szlachcice błagali wręcz, byśmy przyjęli ich kontrakty.%SPEECH_OFF%Co powiesz ludziom, że kompania ma zamiar zrobić? | Podczas przesiadywania i dowcipkowania ze swymi ludźmi, gdy przeglądają swój sprzęt, ostrzą klingi i naprawiają pancerz, twój umysł na chwilę odlatuje, rozważając nad nowymi pomysłami ulepszenia kompanii i poprawienia jej reputacji w krainie.\n\nJakie wyciągnąłeś wnioski i co powiesz ludziom? | To na twoich barkach, dowódco, spoczywa odpowiedzialność, by kompania odnosiła sukcesy nie tylko na polu bitwy, ale i w sprawach sławy oraz bogactwa. Toteż spędzasz wieczory w swym namiocie na obmyślaniu większego planu dla kompanii, podczas gdy twoi ludzie gaworzą i śmieją się przy ognisku. Nigdy nie staniecie się legendą, jeśli będziecie jeno gonić bandytów i wykonywać jakieś nieistotne kontrakty.\n\nCo obwieścisz ludziom, że kompania zamierza zrobić?}",
			Image = "",
			List = [],
			Characters = [],
			Options = [],
			Banner = "",
			function start( _event )
			{
				this.Banner = "ui/banners/" + this.World.Assets.getBanner() + "s.png";
				local selection = this.World.Ambitions.getSelection();
				this.Options = [];

				foreach( i, s in selection )
				{
					this.Options.push(_event.createOption(s));
				}
			}

		});
	}

	function createOption( _s )
	{
		return {
			Text = _s.getButtonText(),
			Tooltip = _s.getButtonTooltip(),
			Icon = "ui/icons/ambition.png",
			function getResult( _event )
			{
				this.World.Ambitions.setAmbition(_s);
				return 0;
			}

		};
	}

	function onUpdateScore()
	{
		return;
	}

	function onPrepareVariables( _vars )
	{
	}

	function onClear()
	{
	}

});

