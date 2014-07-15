require 'rubygems'
require 'twilio-ruby'
require 'sinatra'
require 'json'
require 'haml'
require 'token_phrase'
require_relative 'session'
require_relative 'lib/sms'

enable :sessions

get '/sms-evaluate' do
    twiml = Twilio::TwiML::Response.new do |res|
        res.Message Session.for(params[:From]).evaluate(params[:Body], true)
    end
    twiml.text
end

get '/evaluate' do
    content_type :json
    {:evaluation => Session.for(params[:number]).evaluate(params[:code])}.to_json
end

post '/save' do
    content_type :json
    Session.for(params[:number]).save(params[:code])
    {:evaluation => "code saved"}.to_json
end

get '/' do
    @number = session[:number]
    if @number && session[:token]
        @editor_text = Session.for(@number).file()
    else
        redirect to('/login')
    end

    haml :index
end

get '/login' do
    @number = session[:number]
    @error = params[:error] == 'true'

    haml :login
end

post '/authenticate' do
    if params[:token] == session[:token]
        redirect to('/')
    end
   
    session.clear
    redirect to('/login?error=true')
end

post '/set-number' do
    session[:number] = params[:number]
    session[:token] = TokenPhrase.generate(' ', :numbers => false)

    SMS.send(session[:number], session[:token])
    redirect to('/login')
end

post '/unset-number' do
    session.clear

    content_type :json
    {:url => "/login"}.to_json
end
