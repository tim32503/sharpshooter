# frozen_string_literal: true

require 'watir'

# Uncomment if you want to download
# require "open-uri"

# 活動頁面網址後方的英數字+特殊符號之代碼
# Ex: https://tixcraft.com/activity/detail/23_ameiasmr => 23_ameiasmr
TIXCRAFT_EVENT_ID = '23_lovelytw'

# 日期以 YYYY/MM/DD 格式輸入
EVENT_DATE = '2023/01/15'

# 指定區域標籤
SEAT_ZONE = ''

# 指定票價
SEAT_PRICE = 2_000

# browser = Watir::Browser.new :chrome, headless: true
browser = Watir::Browser.new

begin
  browser.goto('https://tixcraft.com/user/changeLanguage/lang/zh_tw')
  puts '===> 進入中文版頁面'

  # 處理 Cookie 彈窗
  accept_cookies = browser.button(id: 'onetrust-accept-btn-handler').wait_until(&:enabled?)
  if accept_cookies.enabled?
    accept_cookies.click
    puts "===> 已點選【#{accept_cookies.text}】"
  end

  # 購票流程
  # 1. 進入購票頁面
  browser.goto("https://tixcraft.com/activity/game/#{TIXCRAFT_EVENT_ID}")
  title = browser.h2.text
  puts "===> 已進入到【#{title}】活動頁面"

  # 2. 選擇指定日期
  date_select = browser.select(id: 'dateSearchGameList')
  date = Regexp.new(EVENT_DATE.gsub('/', '\/'))
  date_select.select(date)
  date_select.selected?(date)
  puts "===> 已選擇指定日期：#{date_select.text}"

  next_button = browser.buttons(class: 'btn btn-next')
  next_button.each do |button|
    button.click if button.visible?
  end

  # browser.goto('file:///Users/g02210/Downloads/tixCraft%E6%8B%93%E5%85%83%E5%94%AE%E7%A5%A8%E7%B3%BB%E7%B5%B1%20-%20BLACKPINK%20WORLD%20TOUR%20%5BBORN%20PINK%5D%20KAOHSIUNG%20-%20%E5%8D%80%E5%9F%9F.html')
  puts '===> 開始選擇區域'

  partial_label_text = SEAT_ZONE.empty? ? SEAT_PRICE.to_s : SEAT_ZONE
  label_text = browser.b(visible_text: Regexp.new(partial_label_text))
  zone_label = label_text.parent
  puts "===> 開始查詢【#{label_text.text}】的票種列表"

  list_id = zone_label.attribute('data-id')
  area_list = browser.ul(id: list_id).list_items
  area_list.each do |list_item|
    list_item.children.each do |child|
      next unless child.tag_name == 'a'

      child.click
      break
    end

    break
  end

  puts '===> 開始選擇張數'

  # event_list = browser.div(id: 'gameList')
  # puts event_list.enabled?
  # event_list = event_list.table.tbody.rows
  # puts event_list
  # event_list.each do |row|
  #   next unless row.attribute('style').empty?

  #   next_button = row.cells.last.button
  #   puts next_button.enabled?
  #   next_button.click
  # end
  # puts '===> 開始選擇票種及張數'

  # ticket_type = browser.h4(text: /200/)
  # puts ticket_type.text
end

# browser.button(id: 'onetrust-accept-btn-handler').wait_until(&:enabled?).click

# close_login_button = browser.button(class: ["Ls00D", "coreSpriteDismissLarge", "Jx1OT"])
# close_login_button.click if close_login_button.exist?
# items = browser.divs(class:["v1Nh3", "kIKUG", "_bz0w"])
# n = 0
# scrollHeight = browser.execute_script("return document.body.scrollHeight")
# new_scrollHeight = scrollHeight
# arr = []

# # Uncomment if you want to download
# # Dir.mkdir("./download") unless Dir.exist?("./download")

# begin
#   items.each do |item|
#     arr.include?(item.a.href) ? next : arr << item.a.href
#     n += 1
#     puts n
#     icon = item.div(class: ["u7YqG"])
#     if !icon.exist?
#       # Photo
#       item.click
#       sleep(2)
#       dom = browser.div(class: ["_97aPb"]).div(class: ["KL4Bh"])
#       puts dom.img.src

#       # Uncomment if you want to download
#       # File.open("./download/#{n}.jpg", 'wb') do |f|
#       #   f.write open(dom.img.src).read
#       # end
#     else
#       if item.div(class: ["Byj2F"]).exist?
#         # Video
#         item.click
#         sleep(2)
#         puts browser.video(class: "tWeCl").src

#         # Uncomment if you want to download
#         # File.open("./download/#{n}.mp4", 'wb') do |f|
#         #   f.write open(browser.video(class: "tWeCl").src).read
#         # end
#       elsif item.div(class: ["qFq_l"]).exist?
#         # Post
#         item.click
#         sleep(2)
#         lis = browser.div(class: ["_2dDPU", "vCf6V"]).lis(class: ["_-1_m6"])
#         lis.each.with_index(1) do |post, index|
#           puts post.img.src

#           # Uncomment if you want to download
#           # File.open("./download/#{n}.jpg", 'wb') do |f|
#           #   f.write open(post.img.src).read
#           # end
#           browser.button(class: ["  _6CZji"]).click if index < lis.size
#         end
#       end
#     end
#     modal = browser.button(class: "ckWGn")
#     modal.click if modal.exist?
#   end

#   scrollHeight = new_scrollHeight
#   browser.execute_script("window.scrollTo(0, document.body.scrollHeight);")
#   sleep(5)
#   new_scrollHeight = browser.execute_script("return document.body.scrollHeight")
#   items = browser.divs(class:["v1Nh3", "kIKUG", "_bz0w"])
# end while (new_scrollHeight - scrollHeight) != 0

browser.close
