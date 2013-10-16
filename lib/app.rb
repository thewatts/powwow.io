require './lib/idea_box'
require './lib/app/helpers/asset_handler'
require 'better_errors'
require 'sass'

class IdeaBoxApp < Sinatra::Base
#  use AssetHandler

  set :root, 'lib/app'
  set :method_override, true

  configure :development do
    use BetterErrors::Middleware
    BetterErrors.application_root = 'lib/app'
    register Sinatra::Reloader
  end

  not_found do
    haml :error
  end

  get '/' do
    haml :index, locals: { ideas: IdeaStore.all.sort, idea: Idea.new }
  end

  post '/' do
    IdeaStore.create(params[:idea])
    redirect "/"
  end

  get '/:id/edit' do |id|
    idea = IdeaStore.find(id.to_i)
    haml :edit, locals: { idea: idea }
  end

  put '/:id' do |id|
    #if request.headers["Content-Type"] == "application/json"
    #  # make json
    #else
    IdeaStore.update(id.to_i, params[:idea])
    redirect '/'
  end

  delete '/:id' do |id|
    IdeaStore.delete(id.to_i)
    redirect '/'
  end

  post '/:id/like' do |id|
    idea = IdeaStore.find(id.to_i)
    idea.like!
    IdeaStore.update(id.to_i, idea.to_h)
    redirect '/'
  end

  get '/tags' do
    ideas = Ideas.all
  end

end
