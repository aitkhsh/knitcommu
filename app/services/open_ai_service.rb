class OpenAiService
  include HTTParty

  base_uri "https://api.openai.com/v1"

  def self.generate_image(prompt, size = "1024x1024", quality = "standard", n = 1)
    begin
      response = post("/images/generations",
                      headers: {
                        "Authorization" => "Bearer #{ENV["OPENAI_API_KEY"]}",
                        "Content-Type" => "application/json"
                      },
                      body: {
                        model: "dall-e-3",
                        prompt: "A stuffed animal made of woolen yarn wearing woolen clothes, reflecting the following as a specific motif. #{prompt}", # コントローラーから渡されたプロンプトを使用
                        size: size,
                        quality: quality,
                        n: n
                      }.to_json)
      raise "Error: #{response.code} - #{response.message}" unless response.success?

      Rails.logger.info "API Response: #{response.parsed_response}"
      response.parsed_response
    rescue => e
      { error: e.message }
    end
  end

  # 一時URLから画像をダウンロードするメソッド
  def self.download_image_from_url(url)
    begin
      Rails.logger.info "Attempting to download image from URL: #{url}"

      # 一時ファイルの作成
      tempfile = Tempfile.new([ "openai_image", ".jpg" ])
      tempfile.binmode

      # URLから画像データを読み込み
      tempfile.write(URI.open(url).read) # 一時ファイルに画像を書き込み
      tempfile.rewind # ファイルの読み取り位置を先頭に戻す

      Rails.logger.info "Image downloaded successfully to tempfile: #{tempfile.path}"

      return tempfile # 正常にダウンロードできた場合、一時ファイルを返す

    rescue OpenURI::HTTPError => e
      Rails.logger.error "Image download failed (HTTP Error): #{e.message}"
      tempfile&.close! # 一時ファイルが存在すれば閉じて削除
      nil # ダウンロード失敗時はnilを返すか、エラーメッセージを含むハッシュを返してもよい

    rescue StandardError => e
      Rails.logger.error "An unexpected error occurred: #{e.message}"
      tempfile&.close!
      nil # 予期しないエラーが発生した場合もnilを返す

      # ensureブロックを削除し、エラー時のみファイルを削除
    end
  end
end
