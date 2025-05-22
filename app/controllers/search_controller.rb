class SearchController < ApplicationController
  include Pagy::Backend

  def index
    search_term = params[:q_all]

    # Ransack for title and user/customer fields
    @query = Post.ransack(
      title_or_user_email_or_user_name_or_customer_email_or_customer_name_cont_any: search_term
    )
    ransack_results = @query.result(distinct: true)

    # Custom scope for ActionText body
    if search_term.present?
      # Combine both queries using UNION, no pagy array here since this is an Active Record query
      @posts = Post.from("(#{ransack_results.to_sql} UNION #{Post.with_body_text(search_term).to_sql}) AS posts")
                  .includes(:user, :customer)
                  .distinct
    else
      @posts = Post.all.includes(:user, :customer)
    end

    @pagy, @posts = pagy(@posts, items: 10)
  end
end
