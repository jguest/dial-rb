$(function() {

    // TODO js
    // evaluate function should have some line(s) changes to indicate eval
    // vim mode should be an option, I guess...
    // cleanup the keydown function. Those conditionals are nasty.
    // prompt should copy value to clipboard (ZeroClipboard)

    // TODO style
    // dig into base16-dark css and remove that goddamn cursor
    // get css out of index.haml!
    // open that markdown/login shit in the top right corner (icon for info if phone number cookied)
    // dial-rb should probably be somewhere on the page

    // TODO ruby
    // logout/exit feature to uncookie phone number
    // when returning an exception, remove the filename for the love of god.
    // work on that is_assignment method so comparison operators not considered assignment
    // we're going to need a donation feature. ugh.
    // there needs to be some massive cleanup/organization.
    // Session might not be such a good class name due to sinatra sessions

    // TODO misc
    // rename text-ruby directory to dial-rb
    // git repo dude seriously
    // push to heroku or rackspace slice
    // get some people to do a beta
    // facebook/reddit announcement. ugh.

    var editor,
        prompt,
        lastKey;

    var phone_number = $("#number").text();

	editor = CodeMirror.fromTextArea(document.getElementById("code"), {
	    mode: "text/x-ruby",
	    vimMode: true,
	    lineNumbers: true,
	    theme: "base16-light",
        autofocus: true
	});

    prompt = CodeMirror.fromTextArea(document.getElementById("prompt"), {
	    mode: "text/x-ruby",
	    lineNumbers: false,
	    theme: "base16-dark",
        readOnly: true
	});

    editor.on("change", function() {
        $("#save-button").removeClass("saved");
        $("#save-button").addClass("save");
    });

	$(window).bind('keydown',function(e){
	  if( lastKey && ((lastKey == 91 || lastKey == 17) && e.keyCode == 83) || (lastKey == 83 && (e.keyCode == 91 || e.keyCode == 17)) ){
	    e.preventDefault();
        save();
	    return false;
	  }
	  if( lastKey && ((lastKey == 91 || lastKey == 17) && e.keyCode == 13) || (lastKey == 13 && (e.keyCode == 91 || e.keyCode == 17)) ){
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
                prompt.setValue("=> " + data.evaluation)
            });
        }
    }

    function evaluate() {
        var to_eval = editor.somethingSelected() ?
            editor.getSelection() : editor.getLine(editor.getCursor().line);

        $.get("/evaluate", {number: phone_number, code: to_eval} )
        .done(function(data) {
            prompt.setValue("=> " + data.evaluation)
        });
    }
})
