require 'twilio-ruby'

module SMS
    
    APP_PHONE_NUMBER = "+18329812713"

    def self._client()
        Twilio::REST::Client.new ENV['TWILIO_SID'], ENV['TWILIO_TOKEN']
    end

    def self.send(to_number, text)
        _client().account.messages.create({
            :from => APP_PHONE_NUMBER,
            :to => to_number,
            :body => text
        })
    end

end
