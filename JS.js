function printPage (url) {
    var xhr = new XMLHttpRequest;
    xhr.open("GET", url);
    xhr.onreadystatechange = function() {
        if (xhr.readyState == XMLHttpRequest.DONE) {
            console.log(xhr.responseText);
        }
    }
    xhr.send();
}

function getLanguageColor(language) {
    var table = {
        "Arduino": "#bd79d1",
        "Java": "#b07219",
        "VHDL": "#543978",
        "Scala": "#7dd3b0",
        "Emacs Lisp": "#c065db",
        "Delphi": "#b0ce4e",
        "Ada": "#02f88c",
        "VimL": "#199c4b",
        "Perl": "#0298c3",
        "Lua": "#fa1fa1",
        "Rebol": "#358a5b",
        "Verilog": "#848bf3",
        "Factor": "#636746",
        "Ioke": "#078193",
        "R": "#198ce7",
        "Erlang": "#949e0e",
        "Nu": "#c9df40",
        "AutoHotkey": "#6594b9",
        "Clojure": "#db5855",
        "Shell": "#5861ce",
        "Assembly": "#a67219",
        "Parrot": "#f3ca0a",
        "C#": "#5a25a2",
        "Turing": "#45f715",
        "AppleScript": "#3581ba",
        "Eiffel": "#946d57",
        "Common Lisp": "#3fb68b",
        "Dart": "#cccccc",
        "SuperCollider": "#46390b",
        "CoffeeScript": "#244776",
        "XQuery": "#2700e2",
        "Haskell": "#29b544",
        "Racket": "#ae17ff",
        "Elixir": "#6e4a7e",
        "HaXe": "#346d51",
        "Ruby": "#701516",
        "Self": "#0579aa",
        "Fantom": "#dbded5",
        "Groovy": "#e69f56",
        "C": "#555",
        "JavaScript": "#f15501",
        "D": "#fcd46d",
        "ooc": "#b0b77e",
        "C++": "#f34b7d",
        "Dylan": "#3ebc27",
        "Nimrod": "#37775b",
        "Standard ML": "#dc566d",
        "Objective-C": "#f15501",
        "Nemerle": "#0d3c6e",
        "Mirah": "#c7a938",
        "Boo": "#d4bec1",
        "Objective-J": "#ff0c5a",
        "Rust": "#dea584",
        "Prolog": "#74283c",
        "Ecl": "#8a1267",
        "Gosu": "#82937f",
        "FORTRAN": "#4d41b1",
        "ColdFusion": "#ed2cd6",
        "OCaml": "#3be133",
        "Fancy": "#7b9db4",
        "Pure Data": "#f15501",
        "Python": "#3581ba",
        "Tcl": "#e4cc98",
        "Arc": "#ca2afe",
        "Puppet": "#cc5555",
        "Io": "#a9188d",
        "Max": "#ce279c",
        "Go": "#8d04eb",
        "ASP": "#6a40fd",
        "Visual Basic": "#945db7",
        "PHP": "#6e03c1",
        "Scheme": "#1e4aec",
        "Vala": "#3581ba",
        "Smalltalk": "#596706",
        "Matlab": "#bb92ac",
        "C#": "#bb92af"
    };

    if (table.hasOwnProperty(language))
        return table[language]
    // else
    return "#ffffff";
}

var lastSearch = ""

