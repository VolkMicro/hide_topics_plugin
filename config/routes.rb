# frozen_string_literal: true

MyPluginModule::Engine.routes.draw do
  get "/test" => "test#index"
end

Discourse::Application.routes.draw { mount ::MyPluginModule::Engine, at: "/hide_topics" }
