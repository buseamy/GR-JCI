document.addEventListener("touchstart", function(){}, true);
//Badge adder//

var clicks = 0;
   function clickME() {
       clicks += 1;
       document.getElementById("clicks").innerHTML = clicks;
}

$(document).ready(function() {

 $('.badge').hide();

  $('#badgebutton').click(function() {
   $('.badge').show();

   });
 }); 
 //How To Page Nav//
 $(".howtonav li a").click(function() {
     $(this).parent().addClass('active').siblings().removeClass('active');
     });
 
//Login and Search Dropdown//	  
       $(function() {
           $('#togglelogin').click(function() {
               $('.loginbar').toggle();
               return false;
           });        
       });
	   
       $(function() {
           $('.loggedinname').click(function() {
               $('.logoutbar').toggle();
               return false;
           });        
       });
	   
       $(function() {
           $('#search-box').click(function() {
               $('.searchdrop').toggle();
               return false;
           });        
       });
	   
	   $("body").click(function() {
		   if($('.searchdrop').is(':visible'))
			{
	   	  	 $('.searchdrop').hide();
	   	  	 return false;
			}   
	   });
	   
//Popups//	   
     $(".path").click(function() {
   	$(".overlay,.popup,.popup2.edit").show();
   		return false;
   	});
 	$(".path2").click(function() {
	$(".overlay,.popup2").show();
	return false;
});
   	$(".close").click(function() {
   		$(".overlay,.popup,.popup2").hide();
   		return false;
   	});
	
	
//How To Slider//	
	$("a#confsub").click(function() {
		$("div#confsub").removeClass('howtohidden').siblings().addClass('howtohidden');
	});
	
	$("a#author").click(function() {
		$("div#author").removeClass('howtohidden').siblings().addClass('howtohidden');
	});
	
	$("a#review").click(function() {
		$("div#review").removeClass('howtohidden').siblings().addClass('howtohidden');
	});
	
	$("a#reviewer").click(function() {
		$("div#reviewer").removeClass('howtohidden').siblings().addClass('howtohidden');
	});
	
	$("a#editor").click(function() {
		$("div#editor").removeClass('howtohidden').siblings().addClass('howtohidden');
	});
	
	$("a#journal").click(function() {
		$("div#journal").removeClass('howtohidden').siblings().addClass('howtohidden');
	});