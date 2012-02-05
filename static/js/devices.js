(function() {
  var root;

  root = window;

  root.isIpad = navigator.userAgent.match(/iPad/i) !== null;

  var deviceIphone = "iphone";
var deviceIpod = "ipod";

//Initialize our user agent string to lower case.
  var uagent = navigator.userAgent.toLowerCase();

  //**************************
    // Detects if the current device is an iPhone.
    function DetectIphone()
    {
       if (uagent.search(deviceIphone) > -1)
          return true;
       else
          return false;
    }

    //**************************
      // Detects if the current device is an iPod Touch.
      function DetectIpod()
      {
         if (uagent.search(deviceIpod) > -1)
            return true;
         else
            return false;
      }

      //**************************
        // Detects if the current device is an iPhone or iPod Touch.
        function DetectIphoneOrIpod()
        {
            if (DetectIphone())
               return true;
            else if (DetectIpod())
               return true;
            else
               return false;
        };

  root.detectIphoneOrIpod = DetectIphoneOrIpod;

}).call(this);
