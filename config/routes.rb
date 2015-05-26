# Plugin's routes
# See: http://guides.rubyonrails.org/routing.html

match '/tests', :to => 'tests#index', :via => :get
match '/tests/executions', :to => 'tests#executions', :via => :get
match '/tests/logs', :to => 'tests#logs', :via => :get

match '/tests/executions/:id', :to => 'test_executions#show', :via => :get

match '/tests/suites/new', :to => 'test_suites#new', :via => :get
match '/tests/suites/create', :to => 'test_suites#create', :via => :post
match '/tests/suites/:id', :to => 'test_suites#show', :via => :get
match '/tests/suites/:id/edit', :to => 'test_suites#edit', :via => :get
match '/tests/suites/:id/update', :to => 'test_suites#update', :via => :post
match '/tests/suites/:id/destroy', :to => 'test_suites#destroy', :via => [:get, :post]
match '/tests/suites/:id/associate', :to => 'test_suites#associate', :via => [:get, :post]
match '/tests/suites/:id/dissociate', :to => 'test_suites#dissociate', :via => [:get, :post]
match '/tests/suites/:id/execute', :to => 'test_suites#execute', :via => [:get, :post]
match '/tests/suites/:id/next', :to => 'test_suites#next', :via => [:get, :post]

match '/tests/suites/:id/archive', :to => 'test_suites#archive', :via => :get
match '/tests/suites/:id/unarchive', :to => 'test_suites#unarchive', :via => :get
match '/tests/suites/:id/enable', :to => 'test_suites#enable', :via => :get
match '/tests/suites/:id/disable', :to => 'test_suites#disable', :via => :get

match '/tests/cases/auto_complete', :to => 'test_cases#auto_complete', :via => :get
match '/tests/cases/issue', :to => 'test_cases#issue', :via => :get

match '/tests/cases/new', :to => 'test_cases#new', :via => :get
match '/tests/cases/preview', :to => 'test_cases#preview', :via => :get
match '/tests/cases/create', :to => 'test_cases#create', :via => :get
match '/tests/cases/:id', :to => 'test_cases#show', :via => :get
match '/tests/cases/:id/edit', :to => 'test_cases#edit', :via => :get
match '/tests/cases/:id/update', :to => 'test_cases#update', :via => :get
match '/tests/cases/:id/destroy', :to => 'test_cases#destroy', :via => :get
match '/tests/cases/:id/execute', :to => 'test_cases#execute', :via => :get
match '/tests/cases/:id/log', :to => 'test_cases#log', :via => :get
