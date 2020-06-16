# rubocop :disable Metrics/MethodLength, Layout/LineLength
require 'telegram_bot'
require_relative './news.rb'

class Bot
  TOKEN = '1261796457:AAHJFoxarJiJdGykfpMR_ReUMav47omJlQI'
  attr_reader :bot
  attr_accessor :get_updates
  def initialize
    @bot = TelegramBot.new(token: TOKEN)
    @get_updates = update
  end

  def update
    @bot.get_updates(fail_silently: true) do |message|
      # "@#{message.from.username}: #{message.text}"
      command = message.get_command_for(@bot)

      message.reply do |reply|
        reply.text = case command.downcase
                     when /start/i
                       "Hey, I\'m still unnder experimentation. But I can do quite a few interesting things. Try typing any of these commands:\n/hello\n/quote\n/latest news"
                     when /hello/i
                       "Hello, #{message.from.first_name}"
                     when /quote/i
                       quates = Quotes.new
                       quote = quates.select_random
                       "#{quote['text']}\n\t\t\t #{quote['author']}"
                     when /latest news/i
                       news = News.new
                       news.send_news
                     else
                       "Oops... I'm still learning. I have no idea what #{command.inspect} means. I suggest you type commands like\n/hello\n/quote\n/latest news for now."
                     end
        reply.send_with(@bot)
      end
    end
  end
end

# rubocop :enable Metrics/MethodLength, Layout/LineLength
