class Api::V1::ReviewsController < ApplicationController
  before_action :load_book, only: [:index]
  before_action :load_review, only: [:show, :update, :destroy]
  before_action :authenticate_with_token!, only: [:create, :update, :destroy]

  def index
    @reviews = @book.reviews
    reviews_serializer = parse_json(@reviews)
    json_response "Index reviews success", true, {reviews: reviews_serializer}, :ok
  end

  def show
    review_serializer = parse_json @review
    json_response "Show review successfully", true, {review: review_serializer}, :ok
  end

  def create
    review = Review.new review_params
    review.user_id = current_user.id
    review.book_id = params[:book_id]
    if review.save
      review_serializer = parse_json review
      json_response "Create Review success", true, {review: review_serializer} , :ok
    else
      json_response "Create Review failed", false, {} , :unprocessable_entity
    end
  end

  def update
    if correct_user @review.user
      if @review.update review_params
        review_serializer = parse_json @review
        json_response "Update Review success", true, {review: review_serializer}, :ok
      else
        json_response "Update Review failed", false, {}, :unprocessable_entity
      end
    else
      json_response  "Don't have permission", false, {}, :unauthorized
    end
  end

  def destroy
    if correct_user @review.user
      if @review.destroy
        json_response "Delete Review success", true, {review: @review}, :ok
      else
        json_response "Delete Review failed", false, {}, :unprocessable_entity
      end
    else
      json_response  "Don't have permission", false, {}, :unauthorized
    end
  end

  private

  def load_book
    @book = Book.find_by id: params[:book_id]
    unless @book.present?
      json_response "Cannot find any book",false, {},:not_found
    end
  end

  def load_review
    @review = Review.find_by id: params[:id]
    unless @review.present?
      json_response "Cannot find any Review",false, {},:not_found
    end
  end

  def review_params
    params.require(:review).permit :title,:content_rating, :recommend_rating, :image_review
  end
end