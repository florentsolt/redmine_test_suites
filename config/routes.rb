# Plugin's routes
# See: http://guides.rubyonrails.org/routing.html

match '/tests', :to => 'tests#index'
match '/tests/executions', :to => 'tests#executions'
match '/tests/logs', :to => 'tests#logs'

match '/tests/executions/:id', :to => 'test_executions#show'

match '/tests/suites/new', :to => 'test_suites#new'
match '/tests/suites/create', :to => 'test_suites#create'
match '/tests/suites/:id', :to => 'test_suites#show'
match '/tests/suites/:id/edit', :to => 'test_suites#edit'
match '/tests/suites/:id/update', :to => 'test_suites#update'
match '/tests/suites/:id/destroy', :to => 'test_suites#destroy'
match '/tests/suites/:id/associate', :to => 'test_suites#associate'
match '/tests/suites/:id/dissociate', :to => 'test_suites#dissociate'
match '/tests/suites/:id/execute', :to => 'test_suites#execute'
match '/tests/suites/:id/next', :to => 'test_suites#next'

match '/tests/suites/:id/archive', :to => 'test_suites#archive'
match '/tests/suites/:id/unarchive', :to => 'test_suites#unarchive'
match '/tests/suites/:id/enable', :to => 'test_suites#enable'
match '/tests/suites/:id/disable', :to => 'test_suites#disable'

match '/tests/cases/auto_complete', :to => 'test_cases#auto_complete'
match '/tests/cases/issue', :to => 'test_cases#issue'

match '/tests/cases/new', :to => 'test_cases#new'
match '/tests/cases/preview', :to => 'test_cases#preview'
match '/tests/cases/create', :to => 'test_cases#create'
match '/tests/cases/:id', :to => 'test_cases#show'
match '/tests/cases/:id/edit', :to => 'test_cases#edit'
match '/tests/cases/:id/update', :to => 'test_cases#update'
match '/tests/cases/:id/destroy', :to => 'test_cases#destroy'
match '/tests/cases/:id/execute', :to => 'test_cases#execute'
match '/tests/cases/:id/log', :to => 'test_cases#log'
