/*
 * @File Name:      logo.js
 * @Description:    javascript to animate site logo
 * @Author(s):		Jacob Cole <colej28@ferris.edu>
 * @Organization:   Ferris State University
 * @Last updated:   02/05/2016
 */

 /*
  * The purpose of this file is to animate the 
  * site logo similarly to the way it is hidden 
  * on old site without using the deprecated 
  * Adobe Flash plugin
  */

 //Animate yellow square
$(document).ready(function(){ //After page loads
    $(".jci_logo_yellow").hide(); //Shape starts hidden
	setTimeout( function(){ //Set length for animation
		$(".jci_logo_yellow").fadeIn("slow"); //Object, type of animation, speed
	}  , 1000 ); //Length of animation
});
$(document).ready(function(){ //After page loads
    $(".jci_logo_blue").hide(); //Shape starts hidden
	setTimeout( function(){ //Set length for animation
		$(".jci_logo_blue").fadeIn("slow"); //Object, type of animation, speed
	}  , 500 ); //Length of animation
});
$(document).ready(function(){ //After page loads
    $(".jci_logo_red").hide(); //Shape starts hidden
	setTimeout( function(){ //Set length for animation
		$(".jci_logo_red").fadeIn("slow"); //Object, type of animation, speed
	}  , 100 ); //Length of animation
});