class CorvettesController < ApplicationController

  CORVETTES_PER_PAGE = 15

  def index
    @corvettes = Corvette.paginate(:page => params[:page], :per_page => CORVETTES_PER_PAGE)
    respond_to do |format|
      format.html
      format.xml { render :xml => @corvettes }
    end
  end

  def show
    @corvette = Corvette.find(params[:id]) if params[:id]
    respond_to do |format|
      format.html
      format.xml { render :xml => @corvette }
    end
  end

end