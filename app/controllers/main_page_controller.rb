class MainPageController < ApplicationController
    def start
    end
    def search
        client = Octokit::Client.new(:login => Rails.application.credentials.github[:login], :password => Rails.application.credentials.github[:password])
        begin
            @repo = Octokit::Repository.from_url(params[:q])
        rescue
            flash[:alert] = "Can't reach repo"
        else
            @contributors = client.contribs(@repo).first(3)
        end    
    end
end
