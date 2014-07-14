require 'rubygems'
require 'twilio-ruby'
require 'sinatra'
require 'json'
require 'haml'
require_relative 'session'

enable :sessions

get '/sms-evaluate' do
    twiml = Twilio::TwiML::Response.new do |res|
        session = Session.for(params[:From])
        session.evaluate(params[:Body])
        session.remember(params[:Body])
        res.Message "=> #{session.evaluation}"
    end
    twiml.text
end

get '/evaluate' do
    session = Session.for(params[:number])
    session.evaluate(params[:code])
    content_type :json
    {:evaluation => session.evaluation}.to_json
end

get '/' do
    @number = session[:number]
    if @number
        @editor_text = Session.for(@number).file
    else
        redirect to('/login')
    end
    haml :index
end

post '/save' do
    session = Session.for(params[:number])
    session.save(params[:code])
    content_type :json
    {:evaluation => session.evaluation}.to_json
end

get '/login' do
    @number = session[:number]
    haml :login
end

post '/authenticate' do
    # DO STUFF TOMORROW
    # random word auth
    redirect to('/')
end

post '/set-number' do
    session[:number] = params[:number]
    redirect to('/login')
end

post '/unset-number' do
    session[:number] = nil
    content_type :json
    {:url => "/login"}.to_json
end
