class FlatBookingsController < ApplicationController

  # Public: renders form for choosing filters
  #
  def home
  end
  
  # Public: generates the data for given start date, end date and type of report
  #
  # returns results hash
	def get_report
    @results = []
    flat_sales = Hash.new
    @start_date = DateTime.parse(params["flat_booking"]["start_date(1i)"] + "-" + params["flat_booking"]["start_date(2i)"] + "-" + params["flat_booking"]["start_date(3i)"])
    @end_date = DateTime.parse(params["flat_booking"]["end_date(1i)"] + "-" + params["flat_booking"]["end_date(2i)"] + "-" + params["flat_booking"]["end_date(3i)"])
    
    flats = FlatBooking.where("date_of_booking < ? AND date_of_booking >= ?", @end_date, @start_date)
    
    if params["flat_booking"]["report_type"] == "monthly_sales"
      flat_sales = flats.group_by {|e| e.date_of_booking.strftime('%Y-%b')}
    elsif params["flat_booking"]["report_type"] == "yearly_sales"
      flat_sales = flats.group_by {|e| e.date_of_booking.strftime('%Y')}
    end
    flat_sales.each{|k,v| @results << {"#{k}" => v.inject(0){|sum,x| sum + (x.agreement_amount + (x.area * x.base_price))} }}
    redirect_to action: 'show_data', results: @results
  end

  # Public - displays the results
  #
  def show_data
    @results = params[:results]
  end
end
