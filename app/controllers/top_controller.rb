class TopController < ApplicationController
  layout 'top'

  # メッセージの保存ファイル
  MESSAGE_FILE_PATH = 'data/messages.json'

  def initialize
    super
    begin
      @messages = JSON.parse(File.read(MESSAGE_FILE_PATH))
    rescue
      @messages = Hash.new
    end
    @messages.each do |post_time, message|
      if Time.now.to_i - post_time.to_i > 24*60*60
        @messages.delete(post_time)
      end
    end

    File.write('messages.txt', @messages.to_json)
  end

  def index
    if request.post?
      if params['message'].empty?
        # メッセージが無い時は何もしない
        return
      end
      message = Message.new(message: params['message'], name: params['name'], mail: params['mail'])
      @messages[Time.now.to_i] = message
      File.write(MESSAGE_FILE_PATH, @messages.to_json)

      @messages = JSON.parse(@messages.to_json)
    end
  end
end

class Message
  attr_accessor :name
  attr_accessor :mail
  attr_accessor :message

  def initialize(name: name, mail: mail, message: message)
    self.name = name
    self.mail = mail
    self.message = message
  end
end
