class ArticleStatistic < ApplicationRecord
  belongs_to :article

  def self.scraping_yahoo
    require 'nokogiri'
    require 'open-uri'
    # 大元のサイト取得

    sleep(2)
    url = 'https://news.yahoo.co.jp/topics/domestic'

    doc = Nokogiri::HTML(URI.open(url))

    # 各ニュースのURL取得
    root_list = []
    doc.xpath('//a[@class="newsFeed_item_link"]').each do |page|
      root_list << page['href']
    end


    # 各ニュースごとに情報収集編
    #バルクインサートと、そのためのリストの準備
    list_article_update = []
    list_article_statictics_update = []
    

    # 各ニュースごとに情報収集
    root_list.each do |url|
      sleep(2)

      #記事削除の404などエラーが起きたら1記事飛ばす
      begin
        doc = Nokogiri::HTML(URI.open(url))
      rescue StandardError => e
        p e
        next
      end

      comments = doc.xpath('//*[@id="uamods-pickup"]/div[2]/a/span[2]').text.to_i

      list_reaction = []
      url = doc.xpath('//*[@id="uamods-pickup"]/div[2]/div/p/a')[0]['href']
      sleep(2)

      # 記事削除の404などエラーが起きたら1記事飛ばす
      begin
        doc = Nokogiri::HTML(URI.open(url))
      rescue => e
        p e
        next
      end
      next if doc.search('title').text.blank? || comments.blank?

      title = doc.search('title').text
      puts title

      doc.xpath('//script').each do |page|
        list_reaction << page
      end

      # 取りたい情報が配列の何番目にあるか
      num_reaction = list_reaction.find_index { |n| n.content.index('window.__PRELOADED_STATE__') }

      # 取りたい情報がその文字列の何字目にあるか
      num_slice = list_reaction[num_reaction].content.index('articleReactions')

      # ヤフーのリアクションボタンの数字の抽出して合計値を算出
      sum_reaction = 0
      list_reaction[num_reaction].content.slice(num_slice..num_slice + 60).scan(/\d+/).each do |t|
        sum_reaction += t.to_i
      end

      list_article_update << {title: title, link: url, created_at: Time.now.to_s,
                               updated_at: Time.now.to_s }
      list_article_statictics_update << { comment: comments, fav: sum_reaction, created_at: Time.now.to_s,
                                          updated_at: Time.now.to_s }


      
    end
    
    for_foreignkey_article_statistics = Article.upsert_all(list_article_update,unique_by: :link, returning: %i[id title])

    # article_statisticsのupsert
    num = 0
    for_foreignkey_article_statistics.rows.each do |f|
      list_article_statictics_update[num][:article_id] = f[0]
      num += 1
    end
    ArticleStatistic.upsert_all(list_article_statictics_update, unique_by: :article_id)
  end
end
