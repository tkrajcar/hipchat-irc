require 'hipchat'
require 'digest'

class HipchatMessenger
  def initialize(token, room)
    @hipchat_client = HipChat::Client.new(token, api_version: 'v2')
    @hipchat_room = @hipchat_client[room]
  end

  def message(message)
    hipchat_html_message = "<b>#{message.user.nick}</b>: #{message.message}"
    message_options = {
      notify: false,
      color: color_for(message.user.nick)
    }

    @hipchat_room.send('IRC', hipchat_html_message, message_options)
  end

  def color_for(nick)
    %w{yellow red green purple gray}[Digest::MD5.hexdigest(nick.to_s).to_i(16) % 5]
  end
end
