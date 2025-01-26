# frozen_string_literal: true

MyPluginModule::Engine.routes.draw do
  get "/examples" => "examples#index"
  get "/admin/plugins/hide-topics" => "admin/plugins#index"
end

Discourse::Application.routes.draw { mount ::MyPluginModule::Engine, at: "/hide_topics" }
