## dial-rb

### About

This project started out of pure laziness. I wanted a way to do mundane, day-to-day things like
calculate a tip, lookup words in a dictionary, or simply generate some repeating text to spam 
my friends with. Given that the only device on me at all times is my phone, I thought "hmmm, what
if I could do all of that via SMS." Then it hit me like a stack (haha get it?) of bricks -- I want
a programming language at my fingertips. And not just any programming language or DSL or whatever, 
I want Ruby. I then thought of the possibilites as a career and hobby programmer. The entire Ruby
language would be in my pocket everywhere I go. The possibilies! Oh my.

I thought a little bit more about how I could make this dream come true. A typical SMS interface
on smart phone stores a conversation thread which has a typical flow of send->recieve (∞). Sounds 
pretty similar to a read-eval-print loop, right? Ruby's built in REPL is called IRB and it is 
an amazingly useful tool for learning the language at any level and an incredibly fun ruby sandbox
environment if you know what you're doing. 

IRB over SMS just made sense in my head. One problem though: if my original goal was to have mini
programs at my fingertips to do those things I didn't want to do on my own (mental math, ugh. open 
my phone's web browser and lookup something, ugh.), I realized very quickly that defining methods
and classes via this SMS version of IRB was pretty awful. It's awful in IRB too. Just give me a 
text editor and let me write some functions there -- functions that I could invoke via text message 
but remained long after I *exited* my SMS IRB session. 

So the web editor idea became a thing. I worked on it for a few days straight with virtually no 
sleep and at the end of it all, it just felt right to me. I was defining functions, classes and 
modules that did some neat at home, in the browser, and using them in a conversation thread on my 
iPhone. And here it is. I never really planned to share this anyone but after I saw it working, I 
couldn't *not* share. 

This is meant to be a fun playground for a programmer of any level, where he or she can refine their 
skills in a creative way. On that note, write some code, have fun and don't kill my server.

### Contribute

If you have written some badass code for yourself and you think everyone should be able to use it, 
you'll need to clone this repo and put your stuff in `user_lib/`. Actual method definitions have to 
be in `user_lib/available_methods.rb` (or included). Or just work on the actual app if you want to. 
There's a big pile of todos and I'm sure there are some bugs. Probably even features I haven't thought 
about. Submit a pull request for any changes.

### Donate

Like all wonderful things in life, **dial-rb** has a cost. It's like a fraction of a fraction of cent 
per text and obviously, keeping my server alive has some overhead. That stuff adds up but I don't want 
to charge anyone for what should be free. If you feel up for it, even 10 cents would help keep this  
thing alive -- more information [here](https://www.gittip.com/jguest/).

### TODO ideas
* when returning an exception, remove the filename
* link to ruby docs
* js - cleanup the keydown function. Those conditionals are nasty.
* separate git repo for codemirror-fork and remove from project
* YARD documentation server for user lib
* optionally validate code with some kind of ruby lint thing
