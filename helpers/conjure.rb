module Conjure
  def conjure view, ingredients = nil
  	context = App.settings.original_caller

  	context.title = ingredients[:title] if ingredients[:title]
    context.erb view.to_sym, :locals => ingredients
  end
end