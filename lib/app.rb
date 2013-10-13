require 'idea_box'

class IdeaBoxApp < Sinatra::Base
  set :method_override, true
  set :root, 'lib/app'

  configure :development do
    register Sinatra::Reloader
  end

  not_found do
    haml :error
  end

  get '/' do
    haml :index, locals: { ideas: IdeaStore.all, idea: Idea.new }
  end

  post '/' do
    IdeaStore.create(params[:idea])
    redirect "/"
  end

  get '/:id/edit' do |id|
    idea = IdeaStore.find(id.to_i)
    haml :edit, locals: { id: id, idea: idea }
  end

  put '/:id' do |id|
    IdeaStore.update(id.to_i, params[:idea])
    redirect '/'
  end

  delete '/:id' do |id|
    IdeaStore.delete(id.to_i)
    redirect '/'
  end

end