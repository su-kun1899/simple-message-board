class TopController < ApplicationController
  layout 'top'

  # メッセージの保存ファイル
  MESSAGE_FILE_PATH = 'data/messages.json'
  # メッセージの有効期限
  EXPIRATION_TERM = 24*60*60

  def initialize
    super

    if File.exist? MESSAGE_FILE_PATH
      messages = JSON.parse(File.read(MESSAGE_FILE_PATH))
      # 期限の切れたメッセージは削除
      messages.each do |post_time, message|
        if Time.now.to_i - post_time.to_i > EXPIRATION_TERM
          messages.delete(post_time)
        end
      end
      File.write(MESSAGE_FILE_PATH, messages.to_json)
    end
    @messages = JSON.parse(File.read(MESSAGE_FILE_PATH))
  end

  def index
    # 新規メッセージの保存
    if request.post?
      if params['message'].empty?
        # メッセージが無い時は何もしない
        return
      end
      message = Message.new(content: params['message'], name: params['name'], mail: params['mail'])
      @messages[Time.now.to_i] = message
      File.write(MESSAGE_FILE_PATH, @messages.to_json)
      @messages = JSON.parse(@messages.to_json)
    end
  end

  def save
    if params['message'].present?
      message = Message.new(content: params['message'], name: params['name'], mail: params['mail'])
      @messages[Time.now.to_i] = message
      # 上書き保存
      File.write(MESSAGE_FILE_PATH, @messages.to_json)
    end

    redirect_to action: :index
  end
end

class Message
  attr_accessor :name
  attr_accessor :mail
  attr_accessor :content

  def initialize(name: name, mail: mail, content: content)
    self.name = name
    self.mail = mail
    self.content = content
  end
end
