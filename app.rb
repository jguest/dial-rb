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
    haml :login
end

post '/set-number' do
    session[:number] = params[:number]
    redirect to('/')
end

post '/unset-number' do
    session[:number] = nil
    redirect to('/login')
end
