class PagesController < ApplicationController
    def home
        if params[:status] == "error"
            if params[:code] != nil
                head params[:code]
            else
                head 500
            end
        end
    end
end