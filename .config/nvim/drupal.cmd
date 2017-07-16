dc| list                                    # Drupal console list
dc| shell                                   # Drupal console shell
dc| cron:execute --module*                  # Drupal console run hook_cron for module
dc| generate:module                         # Drupal console generate module
dc| _completion                        # BASH completion hook.
dc| about                              # Display basic information about Drupal Console project
dc| chain                              # Chain command execution
dc| check                              # System requirement checker
dc| complete                           # Shell completion command list
dc| exec                               # Execute an external command.
dc| help                               # Displays help for a command
dc| init                               # Copy configuration files.
dc| list                               # Lists all available commands
dc| server                             # Runs PHP built-in web server
dc| shell                              # Open a shell providing an interactive REPL (Read–Eval–Print-Loop).
dc| breakpoints:debug                  # Displays breakpoints available in application
dc| cache:context:debug                # Displays current cache context for the application.
dc| cache:rebuild                      # Rebuild and clear all site caches.
dc| chain:debug                        # List available chain files.
dc| config:debug                       # Show the current configuration.
dc| config:delete                      # Delete configuration
dc| config:diff                        # Output configuration items that are different in active configuration compared with a directory.
dc| config:edit                        # Edit the selected configuration.
dc| config:export                      # Export current application configuration.
dc| config:export:content:type         # Export a specific content type and their fields.
dc| config:export:single               # Export a single configuration or a list of configurations as yml file(s).
dc| config:export:view                 # Export a view in YAML format inside a provided module to reuse in other website.
dc| config:import                      # Import configuration to current application.
dc| config:import:single               # Import a single configurations or a list of configurations.
dc| config:override                    # Override config value in active configuration.
dc| config:settings:debug              # Displays current key:value on settings file.
dc| config:validate                    # Validate a drupal config against its schema
dc| config:validate:debug              # Validate a schema implementation before a module is installed.
dc| container:debug                    # Displays current services for an application.
dc| create:comments                    # Create dummy comments for your Drupal 8 application.
dc| create:nodes                       # Create dummy nodes for your Drupal 8 application.
dc| create:terms                       # Create dummy terms for your Drupal 8 application.
dc| create:users                       # Create dummy users for your Drupal 8 application.
dc| create:vocabularies                # Create dummy vocabularies for your Drupal 8 application.
dc| cron:debug                         # List of modules implementing a cron
dc| cron:execute                       # Execute cron implementations by module or execute all crons
dc| cron:release                       # Release cron system lock to run cron again
dc| database:add                       # Add a database to settings.php
dc| database:client                    # Launch a DB client if it's available
dc| database:connect                   # Shows DB connection
dc| database:drop                      # Drop all tables in a given database.
dc| database:dump                      # Dump structure and contents of a database
dc| database:log:clear                 # Remove events from DBLog table, filters are available
dc| database:log:debug                 # Display current log events for the application
dc| database:log:poll                  # Poll the watchdog and print new log entries every x seconds
dc| database:query                     # Executes a SQL statement directly as argument
dc| database:restore                   # Restore structure and contents of a database.
dc| database:table:debug               # Show all tables in a given database.
dc| devel:dumper                       # Change the devel dumper plugin
dc| dotenv:init                        # Drupal Console dotenv.
dc| entity:debug                       # Debug entities available in the system
dc| entity:delete                      # Delete an specific entity
dc| event:debug                        # Display current events 
dc| field:info                         # View information about fields.
dc| generate:authentication:provider   # Generate an Authentication Provider
dc| generate:breakpoint                # Generate breakpoint
dc| generate:cache:context             # Generate a cache context
dc| generate:command                   # Generate commands for the console.
dc| generate:controller                # Generate & Register a controller
dc| generate:doc:cheatsheet            # Generate a printable cheatsheet for Commands
dc| generate:doc:dash                  # Generate the DrupalConsole.docset package for Dash
dc| generate:doc:data                  # Generate documentations for Commands.
dc| generate:doc:gitbook               # Generate documentations for Commands
dc| generate:entity:bundle             # Generate a new content type (node / entity bundle)
dc| generate:entity:config             # Generate a new config entity
dc| generate:entity:content            # Generate a new content entity
dc| generate:event:subscriber          # Generate an event subscriber
dc| generate:form                      # Generate a new "%s"
dc| generate:form:alter                # Generate an implementation of hook_form_alter() or hook_form_FORM_ID_alter
dc| generate:form:config               # commands.generate.form.description
dc| generate:help                      # Generate an implementation of hook_help()
dc| generate:module                    # Generate a module.
dc| generate:module:file               # Generate a .module file
dc| generate:permissions               # commands.generate.permission.description
dc| generate:plugin:block              # Generate a plugin block
dc| generate:plugin:ckeditorbutton     # Generate CKEditor button plugin.
dc| generate:plugin:condition          # Generate a plugin condition.
dc| generate:plugin:field              # Generate field type, widget and formatter plugins.
dc| generate:plugin:fieldformatter     # Generate field formatter plugin.
dc| generate:plugin:fieldtype          # Generate field type plugin.
dc| generate:plugin:fieldwidget        # Generate field widget plugin.
dc| generate:plugin:imageeffect        # Generate image effect plugin.
dc| generate:plugin:imageformatter     # Generate image formatter plugin.
dc| generate:plugin:mail               # Generate a plugin mail
dc| generate:plugin:migrate:process    # Generate a migrate process plugin
dc| generate:plugin:migrate:source     # Generate a migrate source plugin
dc| generate:plugin:rest:resource      # Generate plugin rest resource
dc| generate:plugin:rulesaction        # Generate a plugin rule action
dc| generate:plugin:skeleton           # Generate an implementation of a skeleton plugin
dc| generate:plugin:type:annotation    # Generate a plugin type with annotation discovery
dc| generate:plugin:type:yaml          # Generate a plugin type with Yaml discovery
dc| generate:plugin:views:field        # Generate a custom plugin view field.
dc| generate:post:update               # commands.generate.post:update.description
dc| generate:profile                   # Generate a profile.
dc| generate:routesubscriber           # Generate a RouteSubscriber
dc| generate:service                   # Generate service
dc| generate:theme                     # Generate a theme.
dc| generate:twig:extension            # Generate a Twig extension.
dc| generate:update                    # Generate an implementation of hook_update_N()
dc| image:styles:debug                 # List image styles on the site
dc| image:styles:flush                 # Execute flush function by image style or execute all flush images styles
dc| libraries:debug                    # Displays libraries available in application
dc| module:debug                       # Display current modules available for application
dc| module:dependency:install          # commands.module.install.dependencies.description
dc| module:download                    # Download module or modules in application
dc| module:install                     # Install module or modules in the application
dc| module:path                        # Returns the relative path to the module (or absolute path)
dc| module:uninstall                   # Uninstall module or modules in the application
dc| module:update                      # Update core, module or modules in the application
dc| multisite:debug                    # List all multisites available in system
dc| multisite:new                      # Sets up the files for a new multisite install.
dc| node:access:rebuild                # Rebuild node access permissions.
dc| permission:debug                   # Display all user permissions.
dc| plugin:debug                       # Display all plugin types.
dc| queue:debug                        # Display the queues of your application
dc| queue:run                          # Process the selected queue.
dc| rest:debug                         # Display current rest resource for the application
dc| rest:disable                       # Disable a rest resource for the application
dc| rest:enable                        # Enable a rest resource for the application
dc| router:debug                       # Displays current routes for the application or information for a particular route
dc| router:rebuild                     # Rebuild routes for the application
dc| settings:debug                     # List user Drupal Console settings.
dc| settings:set                       # Change a specific setting value in DrupalConsole config file
dc| site:debug                         # List all known local and remote sites.
dc| site:import:local                  # Import/Configure an existing local Drupal project
dc| site:install                       # Install a Drupal project
dc| site:maintenance                   # Switch site into maintenance mode
dc| site:mode                          # Switch system performance configuration
dc| site:statistics                    # Show the current statistics of website.
dc| site:status                        # View current Drupal Installation status
dc| state:debug                        # Show the current State keys.
dc| state:delete                       # Delete State
dc| state:override                     # Override a State key.
dc| taxonomy:term:delete               # Delete taxonomy terms from a vocabulary
dc| theme:debug                        # Displays current themes for the application
dc| theme:download                     # Download theme in application
dc| theme:install                      # Install theme or themes in the application
dc| theme:path                         # Returns the relative path to the theme (or absolute path)
dc| theme:uninstall                    # Uninstall theme or themes in the application
dc| translation:cleanup                # Clean up translation files
dc| translation:pending                # Determine pending translation string in a language or a specific file in a language
dc| translation:stats                  # Generate translate stats
dc| translation:sync                   # Sync translation files
dc| update:debug                       # Display current updates available for the application
dc| update:entities                    # Applying Entity Updates
dc| update:execute                     # Execute a specific Update N function in a module, or execute all
dc| user:create                        # Create users for the application
dc| user:debug                         # Displays current users for the application
dc| user:delete                        # Delete users for the application
dc| user:login:clear:attempts          # Clear failed login attempts for an account.
dc| user:login:url                     # Returns a one-time user login url.
dc| user:password:hash                 # Generate a hash from a plaintext password.
dc| user:password:reset                # Reset password for a specific user.
dc| user:role                          # Adds/removes a role for a given user
dc| views:debug                        # Display current views resources for the application
dc| views:disable                      # Disable a View
dc| views:enable                       # Enable a View
dc| views:plugins:debug                # Display current views plugins for the application
