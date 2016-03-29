/*
* @File Name:       form.js
* @Description:     General javascript for JCI website forms
* @Author(s):       Jacob Cole <colej28@ferris.edu>
* @Organization:    Ferris State University
* @Last updated:    02/12/2016
*/

/*
 * The purpose of this file is to contain
 * general scripts to be used on JCI forms.
 */

 //Add aditional authors
 var counter = 1; //Starting Number
 function addInput(dName){
 //Add author
 var newd = document.createElement('div');
 newd.innerHTML = "<h3>Author " + (counter + 1) + "</h3><input class='regular required' placeholder='SCR Member Code' type='text' name='memberCode" + (counter + 1) + "' id='memberCode" + (counter + 1) + "' size='30' maxlength='60'><input class='regular required' placeholder='Email' type='text' id='email" + (counter + 1) + "' size='30' maxlength='100' name='email" + (counter + 1) + "'><input class='regular required' placeholder='First Name' type='text' id='authorFirst" + (counter + 1) + "' size='30' maxlength='100' name='authorFirst" + (counter + 1) + "'><input class='regular required' placeholder='Last Name' type='text' id='authorLast" + (counter + 1) + "' size='30' maxlength='100' name='authorLast" + (counter + 1) + "'></p>"
           document.getElementById(dName).appendChild(newd); //Place after last author
           counter++;
           document.getElementById("counter").value = counter;
 };

//Count and display remaining characters
$(document).ready(function() {
    var text_max = 300;
    $('#remaining_characters').html('There is a 300 Character limit'); //Starting message

    $('#abstract').keyup(function() { //After typing
        var text_length = $('#abstract').val().length; //find length
        var text_remaining = text_max - text_length; //find remaining

        $('#remaining_characters').html(text_remaining + ' characters remaining'); //display new message
    });
});
