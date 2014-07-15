$(function() {

    var editor,
        prompt,
        lastKey;

    var phone_number = $("#number").text();

	editor = CodeMirror.fromTextArea(document.getElementById("code"), {
	    mode: "text/x-ruby",
        keyMap: "sublime",
	    lineNumbers: true,
	    theme: "solarized light",
        autofocus: true
	});

    prompt = CodeMirror.fromTextArea(document.getElementById("prompt"), {
	    mode: "text/x-ruby",
	    lineNumbers: false,
	    theme: "xq-light",
	});

    editor.on("change", function() {
        $("#save-button").removeClass("saved");
        $("#save-button").addClass("save");
    });

    $("#keymap-change").click(function() {
        var $selected = $("#keymap-selected"),
            selection = "sublime";

        if ($selected.text() == "sublime") {
            selection = "vim";
        } else if ($selected.text() == "vim") {
            selection = "emacs";
        }

        $selected.text(selection);
        editor.setOption("vimMode", selection == "vim");
        editor.setOption("keyMap", selection);
        editor.focus();
    });

    $("#close").click(function() {
        $.post("/unset-number")
        .done(function(data) {
            window.location = data.url
        });
    });

	$(window).bind('keydown',function(e){
	    if(lastKey && ((lastKey == 91 || lastKey == 17) && e.keyCode == 83) 
            || (lastKey == 83 && (e.keyCode == 91 || e.keyCode == 17))) {
	        e.preventDefault();

            save();
	        return false;
	    }
        if (lastKey && ((lastKey == 91 || lastKey == 17) && e.keyCode == 13) 
            || (lastKey == 13 && (e.keyCode == 91 || e.keyCode == 17))) {
	        e.preventDefault();

            evaluate();
	        return false;
	    }
	    lastKey = e.keyCode;
	});

    $("#save-button").click(function () {
        save();
    });

    $("#run-button").click(function() {
        evaluate();
    });

    function save() {
        if ($("#save-button").hasClass("save")) {
            $.post("/save", {number: phone_number, code: editor.getValue()})
            .done(function(data) {
                $("#save-button").removeClass("save")
                $("#save-button").addClass("saved");
                appendEval(data.evaluation);
            });
        }
    }

    function evaluate(to_eval) {
        $.get("/evaluate", {number: phone_number, code: editor.getValue()} )
        .done(function(data) {
            appendEval(data.evaluation);
        });
    }

    function appendEval(evaluation) {
        var $promptScroll = $(".cm-s-xq-light .CodeMirror-scroll");

        if (prompt.getValue() == "") {
            prompt.setValue("\n\n\n\n\n\n\n\n\n\n\n\n")
        }

        $promptScroll.animate({ scrollTop: $promptScroll[0].scrollHeight}, 1000);
        prompt.setValue(prompt.getValue() + "\n" + evaluation)
    }

});
