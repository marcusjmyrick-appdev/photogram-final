class UserController < ApplicationController
  def index
    matching_users = User.all
  @list_of_users = matching_users.order(:username)
  render({ :template => "users/index.html.erb" })
  end

  def show
    the_id = params.fetch("path_id")

    matching_users = User.where({ :username => the_id })

    @the_user = matching_users.at(0)

    matching_follow_requests = FollowRequest.all

    @list_of_follow_requests = matching_follow_requests.order({ :created_at => :desc })

    if @current_user == nil
      redirect_to("/user_sign_in", { :notice => "You have to sign in first." })
    else
    render({ :template => "users/show.html.erb" })
    end
  end
end
