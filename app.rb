require 'rubygems'
require 'twilio-ruby'
require 'sinatra'
require 'json'
require 'haml'
require 'token_phrase'
require_relative 'eval/evaluator'
require_relative 'lib/sms'
require_relative 'lib/json_lib'

include JSONLib
default_key(:evaluation)

enable :sessions
set :session_secret, ENV['DIALRB_SESSION_SECRET']

get '/sms-evaluate' do
    twiml = Twilio::TwiML::Response.new do |res|
        res.Message Evaluator.with(params[:From]).evaluate(params[:Body], true)
    end

    twiml.text
end

get '/evaluate' do
    content_type :json
    wrap Evaluator.with(params[:number]).evaluate(params[:code])
end

post '/save' do
    Evaluator.with(params[:number]).store(params[:code])

    content_type :json
    wrap "code saved"
end

get '/' do
    @number = session[:number]
    if @number && session[:token]
        @editor_text = Evaluator.with(@number).file()
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
    content_type :json
    session.clear
    wrap "/login", :url
end
