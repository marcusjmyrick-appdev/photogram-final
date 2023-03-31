class PhotosController < ApplicationController
  def discover
    the_id = params.fetch("path_id")
  
    matching_users = User.where({ :username => the_id })
  
    @the_user = matching_users.at(0)
    matching_users = User.all
    @list_of_users = matching_users.order(:username)

    render({ :template => "photos/discover.html.erb" })
  end
  def feed
    the_id = params.fetch("path_id")
  
    matching_users = User.where({ :username => the_id })
  
    @the_user = matching_users.at(0)
    accepted_follow_requests = @the_user.sentfollowrequests.where(status: "accepted")

  # Get the followed users
    @followed_users = accepted_follow_requests.map { |request| User.find(request.recipient_id) }

    render({ :template => "photos/feed.html.erb" })
  end
  def index
    matching_photos = Photo.all

    @list_of_photos = matching_photos.order({ :created_at => :desc })

    render({ :template => "photos/index.html.erb" })
  end

  def show
    the_id = params.fetch("path_id")

    matching_photos = Photo.where({ :id => the_id })

    @the_photo = matching_photos.at(0)

    if @current_user == nil
      redirect_to("/user_sign_in", { :notice => "You have to sign in first." })
    else
    render({ :template => "photos/show.html.erb" })
    end
  end

  def create
    the_photo = Photo.new
    the_photo.caption = params.fetch("query_caption")
    the_photo.comments_count = 0
    the_photo.image = params.fetch(:image)
    the_photo.likes_count = 0
    the_photo.owner_id = @current_user.id

    if the_photo.valid?
      the_photo.save
      redirect_to("/photos", { :notice => "Photo created successfully." })
    else
      redirect_to("/photos", { :alert => the_photo.errors.full_messages.to_sentence })
    end

  end

  def update
    the_id = params.fetch("path_id")
    the_photo = Photo.where({ :id => the_id }).at(0)

    the_photo.caption = params.fetch("query_caption")
    the_photo.comments_count = params.fetch("query_comments_count")
    the_photo.image = params.fetch("query_image")
    the_photo.likes_count = params.fetch("query_likes_count")
    the_photo.owner_id = params.fetch("query_owner_id")

    if the_photo.valid?
      the_photo.save
      redirect_to("/photos/#{the_photo.id}", { :notice => "Photo updated successfully."} )
    else
      redirect_to("/photos/#{the_photo.id}", { :alert => the_photo.errors.full_messages.to_sentence })
    end
  end

  def destroy
    the_id = params.fetch("path_id")
    the_photo = Photo.where({ :id => the_id }).at(0)

    the_photo.destroy

    redirect_to("/photos", { :notice => "Photo deleted successfully."} )
  end

end
