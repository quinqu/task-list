require "test_helper"

describe TasksController do
  let (:task) {
    Task.create name: "sample task", description: "this is an example for a test",
    completed_at: Time.now + 5.days
  }
  
  # Tests for Wave 1
  describe "index" do
    it "can get the index path" do
      # Act
      get tasks_path
      
      # Assert
      must_respond_with :success
    end
    
    it "can get the root path" do
      # Act
      get root_path
      
      # Assert
      must_respond_with :success
    end
  end
  
  # Unskip these tests for Wave 2
  describe "show" do
    it "can get a valid task" do
    
      # Act
      get task_path(task.id)
      
      # Assert
      must_respond_with :success
    end
    
    it "will redirect for an invalid task" do
      
      # Act
      get task_path(-1)
      
      # Assert
      must_respond_with :redirect
    end
  end
  
  describe "new" do
    it "can get the new task page" do
  
      get new_task_path
      
      must_respond_with :success
    end
  end
  
  describe "create" do
    it "can create a new task" do
      # Arrange
      task_hash = {
        task: {
          name: "new task",
          description: "new task description",
          completed_at: nil,
        },
      }
      
      expect {
        post tasks_path, params: task_hash
      }.must_change "Task.count", 1
      
      new_task = Task.find_by(name: task_hash[:task][:name])
      expect(new_task.description).must_equal task_hash[:task][:description]
      expect(new_task.completed_at).must_equal task_hash[:task][:completed_at]
      
      must_redirect_to task_path(new_task.id)
    end
  end
  

  describe "edit" do
    it "can get the edit page for an existing task" do

      get edit_task_path(0)
      must_respond_with :found

    end
    
    it "will respond with redirect when attempting to edit a nonexistent task" do
      get edit_task_path(-1)
      must_redirect_to tasks_path
    
    end
  end
  
  
  describe "update" do

    it "can update an existing task" do
      #always create for test database
      Task.create(name: "updated task", description: "update description")

      task_hash = {
        task: {
          name: "updated task test",
          description: "update task description test"
        }
      }
      
      task = Task.first

      expect{
        patch task_path(task.id), params: task_hash
      }.must_differ 'Task.count', 0
      
    
      expect(Task.first.name).must_equal task_hash[:task][:name]
          
    end
    
    it "will redirect to the root page if given an invalid id" do
      task_hash = {
        task: {
          name: "updated task test",
          description: "update task description test"
        }
      }

      expect{
        patch task_path(-1), params: task_hash
      }.must_differ 'Task.count', 0

      must_redirect_to tasks_path
    end
  end
  
 
  describe "destroy" do
    it "will destroy task" do
      Task.create(name: "task to delete", description: "DELETE ME")

      task = Task.first
  

      expect{delete task_path(Task.first.id)}.must_differ "Task.count", -1
    end
    
  end

  describe "toggle_complete" do
    it "will toggle complete" do
      Task.create(name: "task to complete", description: "COMPLETE ME")

      task_hash = {
        task: {
          name: "updated task test",
          description: "update task description test"
        }
      }
      
      patch mark_complete_path(Task.first.id)
      
      expect(task.completed_at).must_be_instance_of String 
    end
  end


end


