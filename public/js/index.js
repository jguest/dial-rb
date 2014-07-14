$(function() {

    // TODO js
    // evaluate function should have some line(s) changes to indicate eval
    // vim mode should be an option, I guess...
    // cleanup the keydown function. Those conditionals are nasty.

    // TODO style
    // revert to middle of page style
    // small nav up top 
    // keymap (shortcuts and vim/emacs) | donation | contribute | about

    // TODO ruby
    // when returning an exception, remove the filename for the love of god.
    // work on that is_assignment method so comparison operators not considered assignment
    // there needs to be some massive cleanup/organization.
    // Session might not be such a good class name due to sinatra sessions

    // TODO misc
    // configure rackspace slice nginx and deploy v1

    var editor,
        prompt,
        lastKey;

    var phone_number = $("#number").text();

	editor = CodeMirror.fromTextArea(document.getElementById("code"), {
	    mode: "text/x-ruby",
	    vimMode: true,
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

    $("#logout-button").click(function() {
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
	  if(lastKey && ((lastKey == 91 || lastKey == 17) && e.keyCode == 13) 
          || (lastKey == 13 && (e.keyCode == 91 || e.keyCode == 17))) {
	    e.preventDefault();
        evaluate()
	    return false;
	  }
	  lastKey = e.keyCode;
	});

    $("#save-button").click(function () {
        save();
    })

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

    function evaluate() {
        var to_eval = editor.somethingSelected() ?
            editor.getSelection() : editor.getLine(editor.getCursor().line);

        $.get("/evaluate", {number: phone_number, code: to_eval} )
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
        prompt.setValue(prompt.getValue() + "\n=> " + evaluation)
    }

});
