class MainPageController < ApplicationController
    def start
    end
    def search
        @query = params[:q]
    end
end
