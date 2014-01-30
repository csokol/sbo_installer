require 'httparty'
require 'nokogiri'

class SBoInstaller
  def install(url)
    name = url.split('/').last
    response = HTTParty.get(url)
    document = Nokogiri::HTML(response.body)
    links = document.css(".center a")
    source = links[1].attr('href')
    slackbuild = links[2].attr('href')

    system(%{ 
      mkdir #{name}
      cd #{name}
      wget #{slackbuild}
      tar xzf #{name}.tar.gz
      cd #{name}
      wget #{source}
      chmod +x ./#{name}.SlackBuild
      ./#{name}.SlackBuild
    })

  end

end


installer = SBoInstaller.new
installer.install(ARGV[0])
