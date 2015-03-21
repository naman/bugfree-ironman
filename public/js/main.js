$(document).ready(function(){
	$('#map').vectorMap({map: 'in_mill_en'});
	map = $("#map").vectorMap('get', 'mapObject');
	map.setBackgroundColor("#5A708C")
	$("#cards").slick();
});