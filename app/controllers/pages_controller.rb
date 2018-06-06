class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home]

  def home
    require 'open-uri'
    require 'nokogiri'
    # ?Nrpp=80
    url = "https://www.exito.com/Mercado-Alimentos_y_bebidas/_/N-2amh?Nrpp=80"
    html_file = open(url, 'Cookie' => 'selectedCity=ML').read
    page = Nokogiri::HTML(html_file)
    limit = page.search(".plp-pagination-result > p").text
    limit = limit.gsub("Mostrando  1 - 80 de ","")
    limit = limit.gsub(" resultados","").to_i
    i = 0
    html_file = open(url, 'Cookie' => 'selectedCity=ML').read
    page = Nokogiri::HTML(html_file)
    results = []
    page.search(".product.grocery").map do |element|
      results.push(
                    {
                      num: i += 1,
                      skuid: element.attribute('data-skuid').value,
                      id: element.attribute('data-prdid').value,
                      name: element.search(".name").text,
                      brand: element.search(".brand").text,
                      price: element.search(".money").text
                    }
                  )
    end
    until i >= limit
      puts "thiiiiiiiiiiiiiiiiiiiiiiiiiiiiiis is i: #{i}"
      puts "#{url}"
      if i % 80 == 0  && limit > i
        url = "https://www.exito.com/Mercado-Alimentos_y_bebidas/_/N-2amh?No=#{i}&Nrpp=80"
        html_file = open(url, 'Cookie' => 'selectedCity=ML').read
        page = Nokogiri::HTML(html_file)
        page.search(".product.grocery").map do |element|
          results.push(
                        {
                          num: i += 1,
                          skuid: element.attribute('data-skuid').value,
                          id: element.attribute('data-prdid').value,
                          name: element.search(".name").text,
                          brand: element.search(".brand").text,
                          price: element.search(".money").text
                        }
                      )
        end
      end
    end
    render json: results
  end
end
