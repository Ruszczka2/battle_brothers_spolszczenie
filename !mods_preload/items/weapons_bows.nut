local bow_2h = "Łuk, Broń dwuręczna";
::mods_hookNewObject("items/weapons/wonky_bow", function ( o )
{
	o.m.Name = "Zwichrowany Łuk";
	o.m.Description = "Jeden z najgorzej wykonanych łuków, jakie dane ci było widzieć. Drewno trzeszczy i skrzypi, gdy łuk pracuje, a cięciwa strzępi się i naciąga za każdym razem, gdy ją napinasz.";
	o.m.Categories = bow_2h;
});
::mods_hookNewObject("items/weapons/short_bow", function ( o )
{
	o.m.Name = "Krótki Łuk";
	o.m.Description = "Prosty drewniany łuk o średnim zasięgu. Wymaga nieco wprawy, aby skutecznie się nim posługiwać.";
	o.m.Categories = bow_2h;
});
::mods_hookNewObject("items/weapons/hunting_bow", function ( o )
{
	o.m.Name = "Łuk Myśliwski";
	o.m.Description = "Dopracowany łuk, używany zazwyczaj do polowań na zwierzynę. Zabójczy przeciwko nieopancerzonym celom, choć wymaga nieco wprawy, by skutecznie się nim posługiwać.";
	o.m.Categories = bow_2h;
});
::mods_hookNewObject("items/weapons/war_bow", function ( o )
{
	o.m.Name = "Łuk Wojenny";
	o.m.Description = "Długi łuk o potężnym naciągu. Zaprojektowany głównie z myślą o bitwach.";
	o.m.Categories = bow_2h;
});
::mods_hookNewObject("items/weapons/masterwork_bow", function ( o )
{
	o.m.Name = "Mistrzowski Łuk";
	o.m.Description = "Znakomicie wystrugany łuk, lekki w ręku i doskonale zbalansowany dla lepszej celności. Wytworzony z różnych gatunków drewna, mieni się ich różnymi kolorami, ciągnącymi się pięknie wzdłuż łuczyska. Zaiste jest to twór mistrza łuczarstwa.";
	o.m.Categories = bow_2h;
});
::mods_hookNewObject("items/weapons/oriental/composite_bow", function ( o )
{
	o.m.Name = "Łuk Kompozytowy";
	o.m.Description = "Krótki łuk wykonany z klejonych warstw, aby zwiększyć jego siłę naciągu.";
	o.m.Categories = bow_2h;
});
::mods_hookNewObject("items/weapons/greenskins/goblin_bow", function ( o )
{
	o.m.Name = "Prowincjonalny Łuk";
	o.m.Description = "Bardzo lekki krótki łuk używany przez Goblinów.";
	o.m.Categories = bow_2h;
});
::mods_hookNewObject("items/weapons/greenskins/goblin_heavy_bow", function ( o )
{
	o.m.Name = "Wzmocniony Prowincjonalny Łuk";
	o.m.Description = "Lekki, acz potężny łuk wykonany z różnych gatunków drzew.";
	o.m.Categories = bow_2h;
});

