class CommentsController < ApplicationController

  def property
    if request.post?
      comment = Comment.create(comment: params[:comment], commentable_id: params[:commentable_id], commentable_type: 'Procedure::Action', user_id: current_user.id)      
      render text: 'ok'
    end
  end

  def list
    @xhr_request = request.xhr?
    comment_arel   = Comment.arel_table
    id             = params[:id].to_i rescue 0
    commentable_id = params[:commentable_id].to_i rescue 0
    @action        = Procedure::Action.find(commentable_id)
    @comments = Comment.where(comment_arel[:id].gt(id)).where(commentable_type: 'Procedure::Action', commentable_id: commentable_id, deleted: false).order(id: :asc)
    render layout: false
  end

  def edit
    @comment = Comment.find(params[:id])
    respond_to do |format|
      format.json { render json: @comment }
    end
  end

  def update
    @comment = Comment.find(params[:id])
    @comment.update(:comment => params[:comment])
    respond_to do |format|
      format.json { render json: { status: true } }
    end
  end

  def destroy
    Comment.destroy(params[:id])
    respond_to do |format|
      format.json { render json: {success: true} }
    end
  end
end
