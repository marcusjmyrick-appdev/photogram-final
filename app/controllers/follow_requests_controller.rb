class FollowRequestsController < ApplicationController
  def user_index
    matching_users = User.all
    @list_of_users = matching_users.order(:username)
    render({ :template => "users/index.html.erb" })
  end
  
  def user_show
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
  
  
  def index
    matching_follow_requests = FollowRequest.all

    @list_of_follow_requests = matching_follow_requests.order({ :created_at => :desc })

    render({ :template => "follow_requests/index.html.erb" })
  end

  def show
    the_id = params.fetch("path_id")

    matching_follow_requests = FollowRequest.where({ :id => the_id })

    @the_follow_request = matching_follow_requests.at(0)

    render({ :template => "follow_requests/show.html.erb" })
  end

  def create
    the_follow_request = FollowRequest.new
    the_follow_request.recipient_id = params.fetch("query_recipient_id")
    the_follow_request.sender_id = @current_user.id

    recipient = User.where({ :id => the_follow_request.recipient_id }).first

    if recipient.private == true
      the_follow_request.status = "pending"
    else
      the_follow_request.status = "accepted"
    end

    if the_follow_request.valid?
      the_follow_request.save

      if the_follow_request.status == "accepted"
        redirect_to("/users/" + the_follow_request.recipient.username, { :notice => "Follow request created successfully." })
      else
        redirect_to("/users/", { :notice => "Follow request sent successfully." })

      end
    else
      redirect_to("/users", { :alert => the_follow_request.errors.full_messages.to_sentence })
    end
  end

  def update
    the_id = params.fetch("path_id")
    the_follow_request = FollowRequest.where({ :id => the_id }).at(0)

    the_follow_request.sender_id = params.fetch("query_sender_id")
    the_follow_request.recipient_id = params.fetch("query_recipient_id")

    if the_follow_request.valid?
      the_follow_request.save
      redirect_to("/follow_requests/#{the_follow_request.id}", { :notice => "Follow request updated successfully."} )
    else
      redirect_to("/follow_requests/#{the_follow_request.id}", { :alert => the_follow_request.errors.full_messages.to_sentence })
    end
  end

  def destroy
    the_id = params.fetch("path_id")
    the_follow_request = FollowRequest.where({ :id => the_id }).at(0)

    the_follow_request.destroy

    redirect_back(fallback_location: "/", notice: "Follow request deleted successfully.")
  end
end
