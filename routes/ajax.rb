# encoding: utf-8
class App < Sinatra::Application
  post '/validate/:context/:entity_type' do
    input_data = params
    context = URI.decode(params[:context])
    entity_type = URI.decode(params[:entity_type])

    @user = User.new unless @user

#=begin
    if context == 'update'
      validation_type = ValidateWithUpdate.new
    elsif context == 'create'
      validation_type = ValidateWithCreate.new
    end

    validate_user = ValidateProperties.new(validation_type,context,input_data,@user)
    validate_user.process_validation

    if validate_user.valid_with_context?
      return validate_user.return_valid_messages[entity_type.to_sym]
    else 
      if error_message = validate_user.return_error_messages[entity_type.to_sym]
        return error_message
      else
        return validate_user.return_valid_messages[entity_type.to_sym]
      end
    end
#=end
  end
end