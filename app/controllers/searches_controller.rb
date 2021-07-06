class SearchesController < ApplicationController

  def search
    @model_name = params[:model]
    model = @model_name.constantize
    search_method = params[:search_method]
    @word = params[:word]
    @contents = model.search(search_method,@word)
  end

end
