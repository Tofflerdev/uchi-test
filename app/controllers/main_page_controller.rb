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
                  type: 'application/pdf'
            end
            format.zip do |format|
                require 'rubygems'
                require 'zip'
                @temp = []
                params[:names].each_with_index do |name, index|
                    t = Tempfile.new(["#{name}", ".pdf"])
                    pdf = DiplomaPdf.new(name, "#{index +1}")
                    t.binmode
                    t.write pdf.render
                    t.rewind
                    @temp << t
                end
                zip_stream = Zip::OutputStream.write_buffer do |stream|
                    @temp.each_with_index do |pdf, index|
                        stream.put_next_entry("#{index + 1}.pdf")
                        stream.write IO.read(pdf)
                    end
                end
                zip_stream.rewind
                send_data zip_stream.read,
                    filename: "diplomas.zip",
                    type: 'application/zip'   
            end
        end
    end
end
