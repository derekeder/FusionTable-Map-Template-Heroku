require "sinatra/base"
require "sinatra/reloader"
require "sinatra-initializers"
require "sinatra/r18n"

module FusionTemplate
  class Application < Sinatra::Base
    enable :logging, :sessions
    enable :dump_errors, :show_exceptions if development?

    configure :development do
      register Sinatra::Reloader
    end
    
    register Sinatra::Initializers
    register Sinatra::R18n

    before do
      session[:locale] = params[:locale] if params[:locale]
    end

    use Rack::Logger
    use Rack::Session::Cookie

    helpers FusionTemplate::HtmlHelpers

    FusionTableId = '1NuGpwXnzeyfBZcN-_GCwRzM_F4kh7EZzOnzyOUA'
    
    get "/" do
      # uncomment this line to cache this route
      # cache_control :public, max_age: 1800  # 30 min
      
      @current_menu = "home"
      haml :index
    end

    # utility for flushing cache
    get "/flush_cache" do
      require 'dalli'
      dc = Dalli::Client.new
      dc.flush
      redirect "/"
    end

    # note: the fusion_tables gem can only access tables based on the numeric ID of the table
    get "/location_list" do
      @current_menu = "location_list"
      if defined? FT
        # uncomment this line to cache this route
        # cache_control :public, max_age: 1800  # 30 min
        
        # note: the fusion_tables gem can only access tables based on the numeric ID of the table
        @condom_dist_locations = FT.execute("SELECT * FROM #{FusionTableId};")
        @sti_clinics = FT.execute("SELECT * FROM #{FusionTableId};")
        @abortion_clinics = FT.execute("SELECT * FROM #{FusionTableId};")
        haml :location_list
      else
        "fusion_tables gem not setup yet! You need to set your Google account and password in config/config.yml"
      end
    end
    
    # catchall for static pages
    get "/:page/?" do
      begin 
        # uncomment this line to cache this route
        # cache_control :public, max_age: 1800  # 30 min
        
        @current_menu = params[:page]
        @title = params[:page].capitalize.gsub(/[_-]/, " ") + " - Searchable Map Template - Heroku Ready"
        @page_path = params[:page]
        haml params[:page].to_sym
      rescue Errno::ENOENT
        haml :not_found
      end
    end

    error do
      'Sorry there was a nasty error - ' + env['sinatra.error'].name
    end
  end
end
