# frozen_string_literal: true

# name: hide_topics
# about: Automatically hide topics based on categories with flexible visibility settings
# version: 0.2
# authors: MicroVolk
# url: https://github.com/VolkMicro/hide_topics_plugin
# required_version: 2.7.0

enabled_site_setting :hide_topics_enabled

module ::MyPluginModule
  PLUGIN_NAME = "hide_topics"

  class Engine < ::Rails::Engine
    engine_name PLUGIN_NAME
    isolate_namespace MyPluginModule
  end
end

require_relative "lib/my_plugin_module/engine"

add_admin_route 'hide_topics.title', 'hide-topics'

Discourse::Application.routes.append do
  get '/admin/plugins/hide-topics' => 'admin/plugins#index', constraints: StaffConstraint.new
end

after_initialize do
  # Hide topics when created in specified categories
  DiscourseEvent.on(:topic_created) do |topic|
    if SiteSetting.hide_topics_enabled && SiteSetting.hide_topics_categories.include?(topic.category.slug)
      topic.update_status('hidden', true)
      Rails.logger.info("Topic #{topic.id} hidden by hide_topics plugin in category #{topic.category.slug}.")
    end
  end

  # Helper to scan and hide existing topics
  def self.hide_existing_topics
    Category.where(slug: SiteSetting.hide_topics_categories).each do |category|
      category.topics.each do |topic|
        next if topic.hidden?
        topic.update_status('hidden', true)
        Rails.logger.info("Existing topic #{topic.id} hidden in category #{category.slug}.")
      end
    end
  end

  # Ensure the scanning occurs on plugin activation
  hide_existing_topics if SiteSetting.hide_topics_enabled
end
