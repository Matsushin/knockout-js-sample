$ ->
  store =
    getTasks: ->
      $.ajax
        url: '/tasks'
        dataType: 'json'
    getTask: (taskId) ->
      $.ajax
        url: "/tasks/#{taskId}"
        dataType: 'json'
    addTask: (title, body) ->
      $.ajax
        url: '/tasks'
        type: 'POST'
        dataType: 'json'
        data: {task: {title: title, body: body}}
    updateTask: (taskId, taskBody) ->
      $.ajax
        url: "/tasks/#{taskId}"
        type: 'PATCH'
        dataType: 'json'
        data: {task: {body: taskBody}}
    deleteTask: (taskId) ->
      $.ajax
        url: "/tasks/#{taskId}"
        type: 'DELETE'
        dataType: 'json'

  class AppViewModel
    constructor: ->
      @tasks = ko.observableArray([])
      @title = ko.observable('')
      @body = ko.observable('')
      @updated = ko.observable('')
      @selectedTaskId = ko.observable()
      @editing = ko.observable(false)
      @loadTasks()

    title: null
    body: null
    updated: null
    selectedTaskId: null
    newTitle: null
    newBody: null
    editing: false

    loadTasks: ->
      store.getTasks().done (tasks) =>
        @tasks.removeAll()
        tasks.forEach (task) =>
          @tasks.push(new Task(task.id, task.title, task.body, task.updated_at, @))

    addTask: ->
      store.addTask(@newTitle, @newBody).done (task) =>
        @tasks.push(new Task(task.id, task.title, task.body, @))
    setSelectedTask: (taskId) ->
      store.getTask(taskId).done (task) =>
        @title(task.title)
        @body(task.body)
        @updated(task.updated_at)
        @selectedTaskId(task.id)
    updateTask: ->
      store.updateTask(@selectedTaskId(), @body()).done =>
        @toggleEditing()
        @loadTasks()
    deleteTask: ->
      store.deleteTask(@selectedTaskId()).done =>
        alert('削除しました')
        @loadTasks()
        @toggleEditing()
        @selectedTaskId(null)
    toggleEditing: ->
      @editing(!@editing())

  class Task
    constructor: (id, title, body, updated, app) ->
      @app = app
      @updated = updated
      @id = id
      @title = title
      @body = body

    selectTask: (task) ->
      @app.setSelectedTask(task.id)

  appViewModel = new AppViewModel()
  ko.applyBindings appViewModel