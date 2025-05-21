class SearchController < ApplicationController
  def index
    search_term = params[:q_all]

    # Ransack for title and user/customer fields
    @query = @site.posts.ransack(
      title_or_user_email_or_user_name_or_customer_email_or_customer_name_cont_any: search_term
    )
    ransack_results = @query.result(distinct: true)

    # Custom scope for ActionText body again older version of ransack i followed in tutorial
    body_results = @site.posts.with_body_text(search_term) if search_term.present?

    # Combine results (union), remove duplicates
    if search_term.present?
      @posts = (ransack_results.to_a + body_results.to_a).uniq
    else
      @posts = @site.posts.all.includes(:user, :customer)
    end
  end
end
