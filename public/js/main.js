function createhealth (argument) {
	// body...
	// console.log(argument);
	obj1 = $("#use-health");
	obj2 = $("#not-use-health");
	health1 = '<i class="fa fa-user-plus"></i>';
	health2 = '<i class="fa fa-user-times"></i>';
	obj1.html(health1);
	obj2.html(health2);
	arg = 100 - argument;
	$('.use-health-text').html(argument);
	$('.not-use-health-text').html(arg);
	while(arg > 1) {
		obj2.html(obj2.html() + health2);
		arg = arg - 1;
	}
	while(argument > 1) {
		obj1.html(obj1.html() + health1);
		argument = argument - 1;
	}
}

function createedu (argument) {
	// body...
	// console.log(argument);
	obj1 = $("#literate");
	obj2 = $("#illiterate");
	l = '<i class="fa fa-graduation-cap"></i>';
	obj1.html(l);
	obj2.html(l);
	arg = 100 - argument;

	$('.lit-text').html(argument);
	$('.illit-text').html(arg);
	while(arg > 1) {
		obj2.html(obj2.html() + l);
		arg = arg - 1;
	}
	while(argument > 1) {
		obj1.html(obj1.html() + l);
		argument = argument - 1;
	}
}
function createlab (argument) {
	// body...
	// console.log(argument);
	obj1 = $("#labor");
	l = '<i class="fa fa-child"></i>';
	obj1.html(l);
	$('.labor-text').html(argument);
	while(argument > 1) {
		obj1.html(obj1.html() + l);
		argument = argument - 1;
	}
}


function setData(data){
	//  male,female,literate,illiterate,rural,urban, child_labour, health, total_toilet, urban_toilet, rural_toilet
	//  urban_unemployed, rural_unemployed , child_marriage_girl, child_marriage_boy, hindu, muslim, christian, others

	//Toilet card
	// mulandcreate($("#have_toilet"),data.total_toilet/10);
	$('#have-toilet').html(data.total_toilet);
	$('#not-have-toilet').html(100 - data.total_toilet);
	createhealth(data.health);
	createedu(data.literate);
	createlab(data.child_labour);
	$('#urban').html(data.urban);
	$('#rural').html(data.rural);
	$('#male').html(data.male);
	$('#female').html(data.female);
	unemployed = Math.round((data.urban_unemployed + data.rural_unemployed)/2);
	$('.employed').html(100 - unemployed);
	$('.unemployed').html(unemployed);
	//religions

	$('.hindu').html(data.hindu);
	$('.muslim').html(data.muslim);
	$('.christian').html(data.christian);
	$('#others').html(data.others);

	// age
	$('.young').html(data.young);
	$('.adult').html(data.adult);
	$('.old').html(data.old);
}



$(document).ready(function(){
	$('#map').vectorMap({map: 'in_mill_en'});
	map = $("#map").vectorMap('get', 'mapObject');
	map.setBackgroundColor("#5A708C")
	// $("#cards").slick();		
	var api;
	$.getJSON("/api", function(data){
		api = data;
		setData(api.India);
		$("#people").click(function(){

			$('.RegionName').html("India");
			setData(api.India);
		});	
	});
	$('#map svg path').click(function () {
		
		map = $("#map").vectorMap('get', 'mapObject');
		region = map.getRegionName($(this).data("code"));
		$('.RegionName').html(region);
		console.log(api[region]);
		setData(api[region]);
	});


	$('#cards').slick({
  slidesToShow: 1,
  slidesToScroll: 1,
  arrows: false,
  // fade: true,
  asNavFor: '#scroller'
});
$('#scroller').slick({
  slidesToShow: 3,
  slidesToScroll: 1,
  asNavFor: '#cards',
  // dots: true,
  arrows: false,
  centerMode: true,
  focusOnSelect: true,
  vertical: true
});
});