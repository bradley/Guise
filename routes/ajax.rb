# encoding: utf-8
class App < Sinatra::Application
  post '/validate/:context/:entity_type' do
    input_data = params
    context = URI.decode(params[:context])
    entity_type = URI.decode(params[:entity_type])

    #@user = User.new unless @user

    @tester = Tester.new
    @tester.user = 'ted'
    if @tester
      return 'asd'
    else
      return 'ad'
    end
   #thing = DeleteMe.new
   #return thing.return_thing

=begin
    if context == 'update'
      validation_type = ValidateWithUpdate.new
    elsif context == 'create'
      validation_type = ValidateWithCreate.new
    end

    validate_user = ValidateProperties.new(validation_type,context,input_data,@user)
    validate_user.process_validation

    if validate_user.valid_with_context?
      return 'asd'#validate_user.return_valid_messages[entity_type.to_sym]
    else 
      if error_message = validate_user.return_error_messages[entity_type.to_sym]
        return 'as'#error_message
      else
        return 'ad'#validate_user.return_valid_messages[entity_type.to_sym]
      end
    end
=end
  end
end