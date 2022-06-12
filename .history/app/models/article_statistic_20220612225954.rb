class ArticleStatistic < ApplicationRecord
  belongs_to :article


  def self.whenever_test
    p "動作中ver5/30#{Time.now}"
  end

  class << self
    # スクレイピングをしてDBに保存するメソッド
    def scraping_yahoo(url_page_number)
      # スクレイピングの部分（yahooニュース仕様）
      scraping(url_page_number)
      # DBに保存する部分（バルクインサートを使用する）
      bulk_insert
    end

    # yahooに対するスクレイピング機能
    def scraping(url_page_number)
      require 'nokogiri'
      require 'open-uri'
      # 大元のサイト取得
      puts url_page_number
      url = "https://news.yahoo.co.jp/topics/top-picks?page=#{url_page_number.to_i}"
  
      sleep(3)
  
      # ニュースが一覧になっているページを開く
      doc = Nokogiri::HTML(URI.open(url))
  
      # 各ニュースのURL取得
      news_list = []
      doc.xpath('//a[@class="newsFeed_item_link"]').each do |page|
        news_list << page['href']
      end

      ## 各ニュースごとに情報収集編
      # バルクインサートと、そのためのリストの準備
      @list_article_update = []
      @list_article_statictics_update = []
      check_unique_url = ['']

      # 各ニュースごと、1記事ごとにタイトルやコメント数を情報収集していく
      news_list.each do |the_url|
        sleep(3)

        ## エラーが起きたら1記事飛ばす処理の集合
        # 記事削除の404などエラーが起きたら1記事飛ばす
        begin
          doc = Nokogiri::HTML(URI.open(the_url))
          # コメントとurl収集、この後DBにバルクインサートする
          # @comments = doc.xpath('//*[@id="uamods-pickup"]/div[2]/a/span[2]').text.to_i
          @url = doc.xpath('//*[@id="uamods-pickup"]/div[2]/div/p/a')[0]['href']
          # タイトル収集、この後DBにバルクインサートする
          title = doc.search('title').text
          #  - Yahoo!ニュース の文字を取り除く
          @title = title.slice(0..title.size - 14)
          p title
          sleep(3)
          doc = Nokogiri::HTML(URI.open(@url))
          # タイトルがないか で1記事飛ばす
          next if doc.search('title').text.blank? 
  
          # urlがダブってないかチェック。yahoo上で同じ記事が連続で掲載されてたことがあり、ダブるとupsertがエラーるために処理
          check_unique_url << @url
          next if check_unique_url.uniq!
        rescue => e
          p e
          next
        end

        # created_at用に記事が入稿した時間を取得する。upsert_allは現時点全ての項目をupdateしてしまい入稿時間がわからなくなるため
        begin
          time = doc.xpath('//*[@id="uamods"]/header/div/div[1]/div/p/time').text
          @time_created_article = Time.parse(time)
          p @time_created_article
          @time_created_article = Time.parse(time)
          if Time.parse(time) == nil
            raise
          end
        rescue => exception
          p exception
          next
        end
  
        ## 記事内いいねがややこしい場所にあるため、膨大な情報から絞り込みしていき、最後scanで数字だけ取り出す
        # 記事詳細ページの中からscript関連の場所だけ抜き取り、配列の形で保存
        ## 追加：ページ仕様が変更されコメントの取得が元仕様では困難になったため、ここでコメントを取るように変更
        begin
          list_scripttag_of_page = []
          doc.xpath('//script').each do |page|
            list_scripttag_of_page << page
          end

          # 取りたい情報が配列の何番目にあるか
          num_reaction = list_scripttag_of_page.find_index { |n| n.content.index('window.__PRELOADED_STATE__') }

          # 取りたい情報がその文字列の何字目にあるか
          num_slice = list_scripttag_of_page[num_reaction].content.index('articleReactions')

          # ヤフーのリアクションボタンの数字の抽出して合計値を算出
          @sum_reaction = 0
          list_scripttag_of_page[num_reaction].content.slice(num_slice..num_slice + 60).scan(/\d+/).each do |reaction|
            @sum_reaction += reaction.to_i
          end

          # コメント編
          num_slice = doc.xpath('//script').text.index('totalCommentCount')
          comments = doc.xpath('//script').text.slice(num_slice..num_slice + 30).scan(/\d+/)[0].to_i

          # コメントがないか || コメントが0なら飛ばす。
          # 0も判定に入れたのはコメ機能なしなのに「0」が埋め込まれていた記事があったため
          next if comments.blank? || comments == 0

        rescue => exception
          p exception
        end

        # upsert_allの形式に合わせ、[{},{}] の形式で各情報を入れていく。Timeのto_sは変換しないとエラーになるため
        @time_zone = Time.now.to_s
        @list_article_update << {title: @title, link: @url, created_at: @time_created_article,
                                 updated_at: @time_zone }
        @list_article_statictics_update << { comment: comments, fav: @sum_reaction, created_at: @time_created_article,
                                            updated_at: @time_zone }

      end
    end
    
  ## バルクインサート部分
    def bulk_insert
    # 更新作業と同時に、戻り値としてidとtitleをもらう。statisticsは外部キー制約のためarticleのidが必要で、titleはデバッグ用
    for_foreignkey_article_statistics = Article.upsert_all(@list_article_update.uniq ,unique_by: :link, returning: %i[id title])

    # article_statisticsのupsert
    # 外部キー制約のために一つずつidを入れていく。
    num = 0
    for_foreignkey_article_statistics.rows.each do |f|
      @list_article_statictics_update[num][:article_id] = f[0]
      num += 1
    end
    ArticleStatistic.upsert_all(@list_article_statictics_update, unique_by: :article_id)
    puts Time.now
    end

  end
end
