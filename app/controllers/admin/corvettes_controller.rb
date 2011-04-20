class Admin::CorvettesController < Admin::AdminController
  before_filter :find_corvette

  corvetteS_PER_PAGE = 15

  def index
    @corvettes = corvette.paginate(:page => params[:page], :per_page => corvetteS_PER_PAGE)
    respond_to do |format|
      format.html
      format.xml { render :xml => @corvettes }
    end
  end

  def show
    respond_to do |format|
      format.html
      format.xml { render :xml => @corvette }
    end
  end

  def new
    @corvette = corvette.new
    respond_to do |format|
      format.html
      format.xml { render :xml => @corvette }
    end
  end

  def create
    @corvette = corvette.new(params[:corvette])
    respond_to do |format|
      if @corvette.save
        flash[:notice] = 'corvette was successfully created.'
        format.html { redirect_to admin_corvette_path(@corvette) }
        format.xml { render :xml => @corvette, :status => :created, :location => @corvette }
      else
        format.html { render :action => "new" }
        format.xml { render :xml => @corvette.errors, :status => :unprocessable_entity }
      end
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if @corvette.update_attributes(params[:corvette])
        flash[:notice] = 'corvette was successfully updated.'
        format.html { redirect_to admin_corvette_path(@corvette) }
        format.xml { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml { render :xml => @corvette.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    respond_to do |format|
      if @corvette.destroy
        flash[:notice] = 'corvette was successfully destroyed.'
        format.html { redirect_to admin_corvettes_path }
        format.xml { head :ok }
      else
        flash[:error] = 'corvette could not be destroyed.'
        format.html { redirect_to @corvette }
        format.xml { head :unprocessable_entity }
      end
    end
  end


  private

  def find_corvette
    @corvette = corvette.find(params[:id]) if params[:id]
  end

end