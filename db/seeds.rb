require 'open-uri'
require 'nokogiri'

url = "https://www.exito.com/mercado"
html_file = open(url, 'Cookie' => 'selectedCity=ML').read
page = Nokogiri::HTML(html_file)
results = []
links = []
page.search(".nav-main-item").map do |element|
  links.push(
                {
                  category:  element.text.strip,
                  href: element.attribute("href").value,
                  link_components: element.attribute("href").value.split("-")
                }
              )
end
links.keep_if { |hash| hash[:href][0..6] != "/browse" && hash[:href][0..7] == "/Mercado"}
links.each do |section|
  p "#{section}"
  url = "https://www.exito.com#{section[:href]}?Nrpp=80"
  category = section[:category]
  html_file = open(url, 'Cookie' => 'selectedCity=ML').read
  page = Nokogiri::HTML(html_file)
  limit = page.search(".plp-pagination-result > p").text
  limit = limit.split(/[^\d]/).map{|e| e.to_i}.max
  i = 0

  until i >= limit
    base_url = url
    if i % 80 == 0  && limit > i
      url = "#{url}&No=#{i}"
      html_file = open(url, 'Cookie' => 'selectedCity=ML').read
      page = Nokogiri::HTML(html_file)
      page.search(".product.grocery").map do |element|
        puts "thiiiiiiiiiiiiiiiiiiiiiiiiiiiiiis is i: #{i}"
        puts "#{url}"
        Product.create(
                      {
                        num: i += 1,
                        position: element.attribute('data-position').value,
                        category: category,
                        skuid: element.attribute('data-skuid').value,
                        prd_id: element.attribute('data-prdid').value,
                        name: element.search(".name").text,
                        brand: element.search(".brand").text,
                        price: element.search(".before > .money").text.blank? ? element.search(".money").text.strip.to_i : element.search(".before > .money").text.strip.to_i,
                        link_com_1:section[:link_components][0],
                        link_com_2:section[:link_components][1],
                        link_com_3:section[:link_components][2],
                        link_com_4:section[:link_components][3],
                        link_com_5:section[:link_components][4],
                        link_com_6:section[:link_components][5]
                      }
                    )
      end
      url = base_url
    end
  end
end
