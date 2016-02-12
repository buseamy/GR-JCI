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
var limit = 5; //Author limit
function addInput(pName){
     if (counter == limit)  { //If limit is reached
          alert("You have reached the limit of " + counter + " authors"); //Limit reached message
     }
     else { //Add author
          var newp = document.createElement('p');
          newp.innerHTML = "<label for='author'> Author " + (counter + 1) + ": <span class='required'>*</span></label> <input type='text' id='author" + counter + "' size='30' maxlength='100'  name='authors[]'>";
          document.getElementById(pName).appendChild(newp); //Place after last author
          counter++;
     }
}

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
