class UsersController < ApplicationController
    rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity_response
    before_action :authorize
    skip_before_action :authorize, only:[:create]

    # POST /signup
    def create
        # user = User.create(user_params)
        # if user.valid?
        #     session[:user_id] = user.id
        #     render json: user, status: :created
        # else
        #     render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
        # end

        user = User.create!(user_params)
        session[:user_id] = user.id
        render json: user, status: :created
    end

    # GET /me
    def show
        user = User.find(session[:user_id])
        render json: user
    end

    private

    def user_params
        params.permit(:username, :password, :password_confirmation)
    end

    # error handling
    def render_unprocessable_entity_response(invalid)
        render json: { errors: invalid.record.errors }, status: :unprocessable_entity
    end

    def authorize
        return render json: { error: "Not authorized" }, status: :unauthorized unless session.include? :user_id
    end
end
