require 'sinatra'
require 'sinatra/reloader' if development?
require 'sqlite3'

enable :sessions

get '/' do
  erb :index
end

post '/shipping' do
  session[:subscription] = params[:subscription] == 'on'
  session[:weight] = params[:weight].to_f
  session[:total_price] = params[:price].to_f
  session[:zipcode] = params[:zipcode]
  session[:city] = params[:city]
  session[:address] = params[:address]

  redirect '/shipping-methods'
end

helpers do
  def get_delivery_methods(subscription, weight, total_price, zipcode)
    db = SQLite3::Database.new('balto.db')
    row = db.execute("SELECT * FROM delivery_coverage WHERE zip_code=?", zipcode).first

    delivery_methods = {
      'pickup_point' => [],
      'home_delivery' => []
    }

    if weight < 20
      if weight <= 10
        delivery_methods['pickup_point'] << 'Mondial Relay' if row[1] == 1
        delivery_methods['pickup_point'] << 'Chrono Relais' if row[1] == 1
      else
        delivery_methods['pickup_point'] << 'Chrono Relais' if row[1] == 1
      end
    end

    if row[1] == 1
      delivery_methods['home_delivery'] << 'Chronopost'
    end
    if row[2] == 1
      delivery_methods['home_delivery'] << 'DPD'
    end
    if row[3] == 1
      delivery_methods['home_delivery'] << 'GLS'
    end

    if delivery_methods['home_delivery'].empty?
      delivery_methods['home_delivery'] << 'Colissimo'
    end

    delivery_methods
  end
end

get '/shipping-methods' do
  delivery_methods = get_delivery_methods(session[:subscription], session[:weight], session[:total_price], session[:zipcode])
  erb :shipping_methods, locals: { subscription: session[:subscription], weight: session[:weight], total_price: session[:total_price], zipcode: session[:zipcode], city: session[:city], address: session[:address], delivery_methods: delivery_methods }
end

post '/confirm' do
  session[:selected_pickup_point] = params[:selected_pickup_point]
  session[:selected_home_delivery] = params[:selected_home_delivery]

  # Here you can add logic to store the selected delivery method or process the order
  # For the sake of this example, we will just display the selected methods

  "Selected pick-up point: #{session[:selected_pickup_point]}<br>" +
  "Selected home delivery: #{session[:selected_home_delivery]}"
  session[:service_point_id] = params[:code]
end
