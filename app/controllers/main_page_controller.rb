class MainPageController < ApplicationController
    def start
    end
    def search
        client = Octokit::Client.new(:login => Rails.application.credentials.github[:login], :password => Rails.application.credentials.github[:password])
        begin
            @repo = Octokit::Repository.from_url(params[:q])
        rescue
            flash[:warning] = "Can't reach repo"
            redirect_to root_url
        else
            @contributors = client.contribs(@repo).first(3)
            @names = []
            @contributors.each {|c| @names << c.login} 
        end    
    end
    def download
        respond_to do |format|
            format.pdf do
                pdf = DiplomaPdf.new(params[:name], params[:index]) 
                send_data pdf.render,
                  filename: "diploma_#{params[:index]}.pdf",
                  type: 'application/pdf',
                  disposition: 'inline'
            end
        end
    end
end
