class Api::V1::QuotesController < Api::V1::BaseController
require "open-uri"

  # def index
  #   @sources = policy_scope(Source)
  # end

  def create
    if api_quote_params[:url_of_quote].nil?
      current_user = User.find(api_user_params[:user_id])

      if Quote.where(content: api_quote_params[:content], user_id: current_user.id, source_id: api_source_params[:id])[0].nil?
        @quote = Quote.new(api_quote_params)
        authorize @quote
        @source = Source.find(api_source_params[:id])
        @quote.source = @source
        @quote.url_of_quote = @source.url_of_website
        @quote.user = current_user
        @quote.save!
      end

      if !api_comment_params.nil?
        @comment = Comment.new(api_comment_params)
        @comment.quote = @quote
        @comment.user = current_user
        @comment.save!
      end


    else
      current_user = User.find(api_user_params[:user_id])
      @quote = Quote.new(api_quote_params)
      @quote.user = current_user
      authorize @quote
      @source = Source.where(user: current_user).find { |source| source.url_of_website == @quote.url_of_quote } # refactor line 11

      if @source
        @quote.source_id = @source.id
      else
        @source = Source.new(api_source_params)
        file = URI.open(api_photo_params[:photo_url])
        @source.photo.attach(io: file, filename: 'test.jpg', content_type: 'image/jpg')
        @source.folder = current_user.folders.first
        @source.user = current_user
        @source.date_of_article = "2.Sep.2020"
        @source.save!
        @quote.source = @source
      end
        @quote.save!
        render :show
    end
  end

  def api_quote_params
    params.require(:quote).permit(:content, :url_of_quote)
  end #

  def api_source_params
    params.require(:source).permit(:id, :title, :website, :date_of_article, :url_of_website)
  end

  def api_comment_params
    params.require(:comment).permit(:content)
  end

  def api_photo_params
    params.require(:photo).permit(:photo_url)
  end

  def api_user_params
    params.require(:user).permit(:user_id)
  end

  def render_error
    render json: { errors: @source.errors.full_messages },
      status: :unprocessable_entity
  end
end
