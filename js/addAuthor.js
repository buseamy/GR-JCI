var counter = 1;
var limit = 5;
function addInput(pName){
     if (counter == limit)  {
          alert("You have reached the limit of " + counter + " authors");
     }
     else {
          var newp = document.createElement('p');
          newp.innerHTML = "<label for='author'> Author " + (counter + 1) + ": <span class='required'>*</span></label> <input type='text' id='author" + counter + "' size='30' maxlength='100'  name='authors[]'>";
          document.getElementById(pName).appendChild(newp);
          counter++;
     }
}