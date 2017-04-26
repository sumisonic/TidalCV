autowatch = 1;
inlets = 1;
outlets = 1;

function list() {
  var a = arrayfromargs(arguments);
  post("received list " + a + "\n");
}

function anything() {
  // post(arguments)
  var args = arrayfromargs(arguments);
  switch (messagename) {
    case "/cv":
      parseOSC(arguments)
      break;
  }
}

function parseOSC(arguments) {
  var args = arrayfromargs(arguments);
  var params = {}
  for (i=0; i<args.length; i+=2) {
    // post(args[i], args[i+1], "\n")
    params[args[i]] = args[i+1]
  }

  var ch = params["ch"]
  var delta = params["delta"]
  var cv = params["cv"]
  if (ch == null || delta == null || cv == null) { return }

  var gate = params["gate"] != null ? params["gate"] : 1.0
  var glide = params["glide"] != null ? params["glide"] : 0.0
  var curve = params["curve"] != null ? params["curve"] : 0.0
  var gain = params["gain"] != null ? params["gain"] : 1.0
  
  // post("parse: " + args + "\n")
  outlet(0, [cv*gain, gate, glide, curve, delta, ch])
}
