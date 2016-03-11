require 'redmine'
require_dependency 'subtask_list_columns_lib'
Rails.configuration.to_prepare do

  
     require_dependency 'subtask_list_columns_project_helper_patch'
 
end

Rails.configuration.to_prepare do
  unless IssuesHelper.included_modules.include?(SubtaskListColumnsLib)
      IssuesHelper.send(:include, SubtaskListColumnsLib)
  end
end


Redmine::Plugin.register :subtask_list_columns do
  name 'Subtask list columns plugin'
  author 'SMS-IT: S.Parfenov, E.Redkozubov'
  description 'Customize columns in list of subtasks on issue page'
  version '0.0.3'
  permission :create_save_config, :subtaskListColumns => :index
  permission :restore_config, :subtaskListColumns => :restoreDefaults
  menu :admin_menu, :subtask_list_columns, {:controller => 'subtask_list_columns', :action => 'index'}, :caption => :subtask_list_columns
  permission :manage_project_workflow, {}, :require => :member
end
