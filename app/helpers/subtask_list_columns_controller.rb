require_dependency 'constants.rb' 

class SubtaskListColumnsController < ApplicationController
  unloadable
  # before_filter :index 
 # before_filter :require_admin 
  def restoreDefaults()
    if (params['restoreRequest'].eql? '1')
       proj  = params['selectedProj'].blank? ? '' : params['selectedProj']
       #puts "OK"
       @canRestore = User.current.allowed_to?(:restore_config, Project.find_by(name: proj))
       SubtasksConfigList.where(userId: User.current.id).where(projectId: Project.find_by(name: proj)).destroy_all
    end
  end
  helper_method :restoreDefaults 
  def index   
    
    @projects ||= Project.pluck("name")
    @currentUser = User.current.id    
    puts (@canRestore)
    sql = "SELECT  name FROM custom_fields WHERE type = 'IssueCustomField'"
    customFields ||= ActiveRecord::Base.connection.select_all(sql)
    # @selectedColumns = .all 
    @allColumns = Constants::DEFAULT_FIELDS + customFields 
    sql = "SELECT userConfig from subtasks_config_list"
    defConfigs ||= SubtasksConfigList.where(userId: 0).where(projectId: 0).pluck("userConfig")
    @defaultConfig = defConfigs.join("").split("|")
    #  configs ||= SubtasksConfigList.where(userId: User.current.id).where(projectId: 0).pluck("userConfig")
   # @allConfigs = configs.join("").split("|")

   # sql = "SELECT userConfig  FROM subtasks_config_list where projectId=1" 
   # @allColumns ||= ActiveRecord::Base.connection.select_all(sql) 
    restoreDefaults()
    
    save = params['save'].blank? ? '' : params['save']
       
    #show_selected_project_config(proj)    
    if (save.eql? '1')
       config  = params['selectedColumns'].blank? ? '' : params['selectedColumns'] 
       proj  = params['selectedProj'].blank? ? '' : params['selectedProj']
     # if(json != '')
      #  updateSelectedColumns = JSON.parse(json)     
       #SubtasksConfigList.delete_all
       user = User.current.id 
       if (proj == "Global configuration")
          c  = SubtasksConfigList.find_by(id: 1)
          c.projectId = 0
          c.userId = 0
          c.userConfig = config
          c.save
          redirect_to :back
       else
          c = SubtasksConfigList.find_by(userId: User.current.id, projectId: Project.find_by(name: proj))
          if c == nil 
             c = SubtasksConfigList.new
          end
          temp  =  Project.find_by(name: proj)
          #projId = temp['id']
          c.projectId = temp['id'] 
          c.userId = User.current.id
          c.userConfig = config
          c.save
     
          #TODO: do lazy save
          redirect_to :back
      end
    end                                      
  end 
helper_method :index
end
