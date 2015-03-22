$(document).ready(function(){
	$('#map').vectorMap({map: 'in_mill_en'});
	map = $("#map").vectorMap('get', 'mapObject');
	map.setBackgroundColor("#5A708C")
	// $("#cards").slick();		

	$('#map svg path').click(function () {
		
		map = $("#map").vectorMap('get', 'mapObject');
		region = map.getRegionName($(this).data("code"));
		$('.RegionName').html(region);
		$.getJSON("/api", function(data){
			console.log(data[region]);
    	});
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