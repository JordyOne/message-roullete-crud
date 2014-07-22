require "sinatra"
require "active_record"
require "gschool_database_connection"
require "rack-flash"

class App < Sinatra::Application
  enable :sessions
  use Rack::Flash

  def initialize
    super
    @database_connection = GschoolDatabaseConnection::DatabaseConnection.establish(ENV["RACK_ENV"])
  end

  get "/" do
    messages = @database_connection.sql("SELECT * FROM messages")
    comments = @database_connection.sql("SELECT * FROM comments")
    erb :home, locals: {messages: messages,
                        comments: comments}
  end

  post "/messages" do
    message = params[:message].gsub("'", "''")
    if message.length <= 140
      @database_connection.sql("INSERT INTO messages (message) VALUES ('#{message}')")
    else
      flash[:error] = "Message must be less than 140 characters."
    end
    redirect "/"
  end

  get "/edit/:id" do
    id = params[:id]
    message = @database_connection.sql("Select * from messages where id = #{id}").first
    erb :edit, locals: {:message => message,
                        :id => id}
  end

  patch "/edit/:id" do
    message = params["message"]
    if message.length <= 140
      @database_connection.sql("UPDATE messages SET message='#{message}' WHERE id= #{params[:id]}")
      redirect "/"
    else
      flash[:error] = "Message must be less than 140 characters."
      redirect "/edit/#{params[:id]}"
    end
  end

  get "/delete/:id" do
    @database_connection.sql("DELETE FROM messages WHERE id = #{params[:id]}")
    redirect "/"
  end

  get "/comment/:id" do
    message = @database_connection.sql("SELECT * FROM messages where id = #{params[:id]}").first
    erb :comment, locals: {message: message}
  end

  post "/comment/:id" do
    @database_connection.sql("INSERT INTO comments (comment, message_id) VALUES ('#{params[:comment]}', #{params[:id]})")
    redirect "/"
  end

  get "/message/:id" do
    id = params[:id]
    message = @database_connection.sql("Select message from messages where id = #{id}").first
    comments = @database_connection.sql("Select * from comments where message_id = '#{id}'")
    erb :message, locals: {original_message: message,
                            comments: comments}
  end

end
