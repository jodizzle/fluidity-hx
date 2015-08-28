
// Load the API

// var callback = function()
// {
// }
  kongregateAPI.loadAPI(onComplete);

// window.onload = function() {
//     // var s = document.createElement('script');
//     // s.type = 'text/javascript';
//     // var code = 'alert("hello world!");';
//     // try {
//     //   s.appendChild(document.createTextNode(code));
//     //   document.body.appendChild(s);
//     // } catch (e) {
//     //   s.text = code;
//     //   document.body.appendChild(s);
//     // }

//     // Adding the script tag to the head as suggested before
//     var head = document.getElementsByTagName('head')[0];
//     var script = document.createElement('script');
//     script.type = 'text/javascript';
//     script.src = 'https://cdn1.kongregate.com/javascripts/kongregate_api.js';

//     // Then bind the event to the callback function.
//     // There are several events for cross browser compatibility.
//     script.onreadystatechange = callback;
//     script.onload = callback;

//     // Fire the loading
//     head.appendChild(script);
//   }
//   // function loadScript(url, callback)
//   // {
//   // }

// var kongregate;
var loaded = false;
var submitThese = [];

// Callback function
function onComplete(){
  // Set the global kongregate API object
  kongregate = kongregateAPI.getAPI();
  loaded = true;
  for(i in submitThese)
  {
    kongSubmit(submitThese[i].stat,submitThese[i].amount);
    submitThese = [];
  }
}

function kongSubmit(stat,amount)
{
    if(loaded)
    {
        kongregate.stats.submit(stat,amount);
    }
    else
    {
        submitThese.push({stat:stat,amount:amount});
    }
}